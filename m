Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66B227FA5
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 11:54:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 556978F8037
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 09:54:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MNvuR7lnZVOAsteI for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 09:54:34 -0700 (PDT)
Message-ID: <54132553.9090202@sandeen.net>
Date: Fri, 12 Sep 2014 11:54:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfs_io: add mremap command
References: <54111610.4080604@redhat.com>
In-Reply-To: <54111610.4080604@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This adds a simple mremap command to xfs_io.

It does not take a start address; it uses the existing
start address, so the sized passed will be the new total
size of the mapping.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: fix stray line in help.
	- Why was it only visible after I sent V1... :/ 
V3: Unmangle whitespace, yay me!

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
+	mremap_cmd.args = _("[-m|-f] newsize");
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
