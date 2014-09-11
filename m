Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0472D7F67
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 22:25:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9796304043
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 20:25:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oBQWN1TT1mUVIiI1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 20:24:59 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8B3OxHf020735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 23:24:59 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8B3OvQE008598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 23:24:58 -0400
Message-ID: <54111610.4080604@redhat.com>
Date: Wed, 10 Sep 2014 22:25:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: add mremap command
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This adds a simple mremap command to xfs_io.

It does not take a start address; it uses the existing
start address, so the sized passed will be the new total
size of the mapping.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/mmap.c b/io/mmap.c
index ea7498f..565a541 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -29,6 +29,7 @@ static cmdinfo_t mread_cmd;
  static cmdinfo_t msync_cmd;
  static cmdinfo_t munmap_cmd;
  static cmdinfo_t mwrite_cmd;
+static cmdinfo_t mremap_cmd;
  
  mmap_region_t	*maptable;
  int		mapcount;
@@ -574,6 +575,66 @@ mwrite_f(
  	return 0;
  }
  
+static void
+mremap_help(void)
+{
+	printf(_(
+"\n"
+" resizes the current memory mapping\n"
+"\n"
+" Examples:\n"
+" 'mremap 8192' - resizes the current mapping to 8192 bytes.\n"
+"\n"
+" Resizes the mappping, growing or shrinking from the current size.\n"
+" The default stored value is 'X', repeated to fill the range specified.\n"
+" -f -- use the MREMAP_FIXED flag\n"
+" -m -- use the MREMAP_MAYMOVE flag\n"
+"\n"));
+}
+
+int
+mremap_f(
+	int		argc,
+	char		**argv)
+{
+	ssize_t		new_length;
+	void		*new_addr;
+	int		flags = 0;
+	int		c;
+	size_t		blocksize, sectsize;
+
+	while ((c = getopt(argc, argv, "fm")) != EOF) {
+		switch (c) {
+		case 'f':
+			flags = MREMAP_FIXED|MREMAP_MAYMOVE;
+			break;
+		case 'm':
+			flags = MREMAP_MAYMOVE;
+			break;
+		default:
+			return command_usage(&mremap_cmd);
+		}
+	}
+
+	init_cvtnum(&blocksize, &sectsize);
+	new_length = cvtnum(blocksize, sectsize, argv[optind]);
+	if (new_length < 0) {
+		printf(_("non-numeric offset argument -- %s\n"),
+			argv[optind]);
+		return 0;
+	}
+
+	new_addr = mremap(mapping->addr, mapping->length, new_length, flags);
+	if (new_addr == MAP_FAILED)
+		perror("mremap");
+	else {
+		mapping->addr = new_addr;
+		mapping->length = new_length;
+	}
+
+	return 0;
+}
+
  void
  mmap_init(void)
  {
@@ -628,9 +689,21 @@ mmap_init(void)
  		_("writes data into a region in the current memory mapping");
  	mwrite_cmd.help = mwrite_help;
  
+	mremap_cmd.name = "mremap";
+	mremap_cmd.altname = "mrm";
+	mremap_cmd.cfunc = mremap_f;
+	mremap_cmd.argmin = 1;
+	mremap_cmd.argmax = 2;
+	mremap_cmd.flags = CMD_NOFILE_OK | CMD_FOREIGN_OK;
+	mremap_cmd.args = _("[-f|-m] newsize");
+	mremap_cmd.oneline =
+		_("alters the size of the current memory mapping");
+	mremap_cmd.help = mremap_help;
+
  	add_command(&mmap_cmd);
  	add_command(&mread_cmd);
  	add_command(&msync_cmd);
  	add_command(&munmap_cmd);
  	add_command(&mwrite_cmd);
+	add_command(&mremap_cmd);
  }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e1a3e1a..e40fbf9 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -501,6 +501,20 @@ See the
  .B mmap
  command.
  .TP
+.BI "mremap [ \-f ] [ \-m ] " new_length
+Changes the current mapping size to
+.IR new_length .
+Whether the mapping may be moved is controlled by the flags passed;
+MREMAP_FIXED
+.RB ( \-f ),
+or MREMAP_MAYMOVE
+.RB ( \-m ).
+.TP
+.B mrm
+See the
+.B mremap
+command.
+.TP
  .B munmap
  Unmaps the current memory mapping.
  .TP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
