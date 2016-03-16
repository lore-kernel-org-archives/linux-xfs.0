Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EAEE57CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 09:22:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66C04AC001
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:22:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dzn1Fn8dpOzLR1Fi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:22:04 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 264BD80508
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 14:22:04 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] io/mremap: modify argument errors of mremap command
Date: Wed, 16 Mar 2016 22:21:58 +0800
Message-Id: <1458138118-5272-1-git-send-email-zlang@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bfoster@redhat.com, Zorro Lang <zlang@redhat.com>

There're 2 argument errors in mremap command:
1. If run "mremap 1024 8192", it won't return error and try to
do "mremap 1024" silently.

2. The "-f" option can't be used, due to it need a new address
argument as the fifth argument of mremap() syscall(man mremap).

This patch try to fix above two problems.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 io/mmap.c         | 25 ++++++++++++++++++-------
 man/man8/xfs_io.8 |  5 ++++-
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/io/mmap.c b/io/mmap.c
index 5970069..568102e 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -589,7 +589,7 @@ mremap_help(void)
 "\n"
 " Resizes the mappping, growing or shrinking from the current size.\n"
 " The default stored value is 'X', repeated to fill the range specified.\n"
-" -f -- use the MREMAP_FIXED flag\n"
+" -f <new_address> -- use MREMAP_FIXED flag to mremap on new_address\n"
 " -m -- use the MREMAP_MAYMOVE flag\n"
 "\n"));
 }
@@ -600,15 +600,19 @@ mremap_f(
 	char		**argv)
 {
 	ssize_t		new_length;
-	void		*new_addr;
+	void		*new_addr = NULL;
 	int		flags = 0;
 	int		c;
 	size_t		blocksize, sectsize;
 
-	while ((c = getopt(argc, argv, "fm")) != EOF) {
+	init_cvtnum(&blocksize, &sectsize);
+
+	while ((c = getopt(argc, argv, "f:m")) != EOF) {
 		switch (c) {
 		case 'f':
 			flags = MREMAP_FIXED|MREMAP_MAYMOVE;
+			new_addr = (void *)cvtnum(blocksize, sectsize,
+			                          optarg);
 			break;
 		case 'm':
 			flags = MREMAP_MAYMOVE;
@@ -618,7 +622,9 @@ mremap_f(
 		}
 	}
 
-	init_cvtnum(&blocksize, &sectsize);
+	if (optind != argc - 1)
+		return command_usage(&mremap_cmd);
+
 	new_length = cvtnum(blocksize, sectsize, argv[optind]);
 	if (new_length < 0) {
 		printf(_("non-numeric offset argument -- %s\n"),
@@ -626,7 +632,12 @@ mremap_f(
 		return 0;
 	}
 
-	new_addr = mremap(mapping->addr, mapping->length, new_length, flags);
+	if (!new_addr)
+		new_addr = mremap(mapping->addr, mapping->length,
+		                  new_length, flags);
+	else
+		new_addr = mremap(mapping->addr, mapping->length,
+		                  new_length, flags, new_addr);
 	if (new_addr == MAP_FAILED)
 		perror("mremap");
 	else {
@@ -697,9 +708,9 @@ mmap_init(void)
 	mremap_cmd.altname = "mrm";
 	mremap_cmd.cfunc = mremap_f;
 	mremap_cmd.argmin = 1;
-	mremap_cmd.argmax = 2;
+	mremap_cmd.argmax = 3;
 	mremap_cmd.flags = CMD_NOFILE_OK | CMD_FOREIGN_OK;
-	mremap_cmd.args = _("[-m|-f] newsize");
+	mremap_cmd.args = _("[-m|-f <new_address>] newsize");
 	mremap_cmd.oneline =
 		_("alters the size of the current memory mapping");
 	mremap_cmd.help = mremap_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 33fbe6a..984b551 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -581,7 +581,7 @@ See the
 .B mmap
 command.
 .TP
-.BI "mremap [ \-f ] [ \-m ] " new_length
+.BI "mremap [ \-f <new_address> ] [ \-m ] " new_length
 Changes the current mapping size to
 .IR new_length .
 Whether the mapping may be moved is controlled by the flags passed;
@@ -589,6 +589,9 @@ MREMAP_FIXED
 .RB ( \-f ),
 or MREMAP_MAYMOVE
 .RB ( \-m ).
+.IR new_length
+specifies a page-aligned address to which the mapping must be moved. It
+can be setted to 139946004389888, 4096k or 1g etc.
 .TP
 .B mrm
 See the
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
