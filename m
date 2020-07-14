Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691FFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 06:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B08B21D93
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 06:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgGNGAt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 02:00:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22626 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725306AbgGNGAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 02:00:48 -0400
X-IronPort-AV: E=Sophos;i="5.75,350,1589212800"; 
   d="scan'208";a="96298591"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Jul 2020 14:00:44 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 802C04CE4BD9
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 14:00:38 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 14 Jul 2020 14:00:38 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 14 Jul 2020 14:00:35 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] xfs_io: Document '-q' option for pread/pwrite command
Date:   Tue, 14 Jul 2020 13:53:26 +0800
Message-ID: <20200714055327.1396-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 802C04CE4BD9.A9C1A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 io/pread.c        |  3 ++-
 io/pwrite.c       |  3 ++-
 man/man8/xfs_io.8 | 10 ++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/io/pread.c b/io/pread.c
index 971dbbc9..458a78b8 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -30,6 +30,7 @@ pread_help(void)
 " The reads are performed in sequential blocks starting at offset, with the\n"
 " blocksize tunable using the -b option (default blocksize is 4096 bytes),\n"
 " unless a different pattern is requested.\n"
+" -q   -- quiet mode, do not write anything to standard output.\n"
 " -B   -- read backwards through the range from offset (backwards N bytes)\n"
 " -F   -- read forwards through the range of bytes from offset (default)\n"
 " -v   -- be verbose, dump out buffers (used when reading forwards)\n"
@@ -506,7 +507,7 @@ pread_init(void)
 	pread_cmd.argmin = 2;
 	pread_cmd.argmax = -1;
 	pread_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	pread_cmd.args = _("[-b bs] [-v] [-i N] [-FBR [-Z N]] off len");
+	pread_cmd.args = _("[-b bs] [-qv] [-i N] [-FBR [-Z N]] off len");
 	pread_cmd.oneline = _("reads a number of bytes at a specified offset");
 	pread_cmd.help = pread_help;
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 995f6ece..467bfa9f 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -27,6 +27,7 @@ pwrite_help(void)
 " The writes are performed in sequential blocks starting at offset, with the\n"
 " blocksize tunable using the -b option (default blocksize is 4096 bytes),\n"
 " unless a different write pattern is requested.\n"
+" -q   -- quiet mode, do not write anything to standard output.\n"
 " -S   -- use an alternate seed number for filling the write buffer\n"
 " -i   -- input file, source of data to write (used when writing forward)\n"
 " -d   -- open the input file for direct IO\n"
@@ -483,7 +484,7 @@ pwrite_init(void)
 	pwrite_cmd.argmax = -1;
 	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	pwrite_cmd.args =
-_("[-i infile [-dDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
+_("[-i infile [-qdDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
 	pwrite_cmd.oneline =
 		_("writes a number of bytes at a specified offset");
 	pwrite_cmd.help = pwrite_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index b9dcc312..d3eb3e7e 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -200,7 +200,7 @@ option will set the file permissions to read-write (0644). This allows xfs_io to
 set up mismatches between the file permissions and the open file descriptor
 read/write mode to exercise permission checks inside various syscalls.
 .TP
-.BI "pread [ \-b " bsize " ] [ \-v ] [ \-FBR [ \-Z " seed " ] ] [ \-V " vectors " ] " "offset length"
+.BI "pread [ \-b " bsize " ] [ \-qv ] [ \-FBR [ \-Z " seed " ] ] [ \-V " vectors " ] " "offset length"
 Reads a range of bytes in a specified blocksize from the given
 .IR offset .
 .RS 1.0i
@@ -211,6 +211,9 @@ can be used to set the blocksize into which the
 .BR read (2)
 requests will be split. The default blocksize is 4096 bytes.
 .TP
+.B \-q
+quiet mode, do not write anything to standard output.
+.TP
 .B \-v
 dump the contents of the buffer after reading,
 by default only the count of bytes actually read is dumped.
@@ -241,7 +244,7 @@ See the
 .B pread
 command.
 .TP
-.BI "pwrite [ \-i " file " ] [ \-dDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
+.BI "pwrite [ \-i " file " ] [ \-qdDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
 Writes a range of bytes in a specified blocksize from the given
 .IR offset .
 The bytes written can be either a set pattern or read in from another
@@ -254,6 +257,9 @@ allows an input
 .I file
 to be specified as the source of the data to be written.
 .TP
+.B \-q
+quiet mode, do not write anything to standard output.
+.TP
 .B \-d
 causes direct I/O, rather than the usual buffered
 I/O, to be used when reading the input file.
-- 
2.21.0



