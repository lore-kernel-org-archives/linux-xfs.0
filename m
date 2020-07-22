Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBE2C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 05:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E655F2176B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 05:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgGVFW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 01:22:27 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8494 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726147AbgGVFW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 01:22:27 -0400
X-IronPort-AV: E=Sophos;i="5.75,381,1589212800"; 
   d="scan'208";a="96728511"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 22 Jul 2020 13:22:24 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id B60F44CE5059;
        Wed, 22 Jul 2020 13:22:23 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 22 Jul 2020 13:22:23 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 13:22:23 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <sandeen@sandeen.net>, <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] xfs_io: Document '-q' option for sendfile command
Date:   Wed, 22 Jul 2020 13:15:07 +0800
Message-ID: <20200722051507.13322-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: B60F44CE5059.A9641
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 io/sendfile.c     | 3 ++-
 man/man8/xfs_io.8 | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io/sendfile.c b/io/sendfile.c
index ff012c81..a003bb55 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -25,6 +25,7 @@ sendfile_help(void)
 " Copies data between one file descriptor and another.  Because this copying\n"
 " is done within the kernel, sendfile does not need to transfer data to and\n"
 " from user space.\n"
+" -q -- quiet mode, do not write anything to standard output.\n"
 " -f -- specifies an input file from which to source data to write\n"
 " -i -- specifies an input file name from which to source data to write.\n"
 " An offset and length in the source file can be optionally specified.\n"
@@ -168,7 +169,7 @@ sendfile_init(void)
 	sendfile_cmd.argmax = -1;
 	sendfile_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	sendfile_cmd.args =
-		_("-i infile | -f N [off len]");
+		_("[-q] -i infile | -f N [off len]");
 	sendfile_cmd.oneline =
 		_("Transfer data directly between file descriptors");
 	sendfile_cmd.help = sendfile_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index d3eb3e7e..caf3f15c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -541,13 +541,17 @@ manual page to allocate and zero blocks within the range.
 Truncates the current file at the given offset using
 .BR ftruncate (2).
 .TP
-.BI "sendfile \-i " srcfile " | \-f " N " [ " "offset length " ]
+.BI "sendfile [ \-q ] \-i " srcfile " | \-f " N " [ " "offset length " ]
 On platforms which support it, allows a direct in-kernel copy between
 two file descriptors. The current open file is the target, the source
 must be specified as another open file
 .RB ( \-f )
 or by path
 .RB ( \-i ).
+.RS 1.0i
+.B \-q
+quiet mode, do not write anything to standard output.
+.RE
 .TP
 .BI "readdir [ -v ] [ -o " offset " ] [ -l " length " ] "
 Read a range of directory entries from a given offset of a directory.
-- 
2.21.0



