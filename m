Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DA2C00307
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 07:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254A221D82
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 07:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfIIH3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfIIH3O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Sep 2019 03:29:14 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 498D910CC200;
        Mon,  9 Sep 2019 07:29:14 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEF6C60923;
        Mon,  9 Sep 2019 07:29:09 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, darrick.wong@oracle.com, sandeen@redhat.com,
        "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH v3] xfs_io: copy_range don't truncate dst_file, and add smart length
Date:   Mon,  9 Sep 2019 15:29:03 +0800
Message-Id: <20190909072903.2749-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 09 Sep 2019 07:29:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

1. copy_range should be a simple wrapper for copy_file_range(2)
and nothing else. and there's already -t option for truncate.
so here we remove the truncate action in copy_range.
see: https://patchwork.kernel.org/comment/22863587/#1

2. improve the default length value generation:
if -l option is omitted use the length that from src_offset to end
(src_file's size - src_offset) instead.
if src_offset is greater than file size, length is 0.

3. update manpage

4. rename var name from 'src, dst' to 'src_off, dst_off'

and have confirmed that this change will not affect xfstests.

Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
---
 io/copy_file_range.c | 40 ++++++++++++++--------------------------
 man/man8/xfs_io.8    | 12 ++++++------
 2 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index b7b9fd88..c2105115 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -36,12 +36,12 @@ copy_range_help(void)
  * glibc buffered copy fallback.
  */
 static loff_t
-copy_file_range_cmd(int fd, long long *src, long long *dst, size_t len)
+copy_file_range_cmd(int fd, long long *src_off, long long *dst_off, size_t len)
 {
 	loff_t ret;
 
 	do {
-		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst,
+		ret = syscall(__NR_copy_file_range, fd, src_off, file->fd, dst_off,
 				len, 0);
 		if (ret == -1) {
 			perror("copy_range");
@@ -66,21 +66,13 @@ copy_src_filesize(int fd)
 	return st.st_size;
 }
 
-static int
-copy_dst_truncate(void)
-{
-	int ret = ftruncate(file->fd, 0);
-	if (ret < 0)
-		perror("ftruncate");
-	return ret;
-}
-
 static int
 copy_range_f(int argc, char **argv)
 {
-	long long src = 0;
-	long long dst = 0;
+	long long src_off = 0;
+	long long dst_off = 0;
 	size_t len = 0;
+	bool len_specified = false;
 	int opt;
 	int ret;
 	int fd;
@@ -93,15 +85,15 @@ copy_range_f(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "s:d:l:f:")) != -1) {
 		switch (opt) {
 		case 's':
-			src = cvtnum(fsblocksize, fssectsize, optarg);
-			if (src < 0) {
+			src_off = cvtnum(fsblocksize, fssectsize, optarg);
+			if (src_off < 0) {
 				printf(_("invalid source offset -- %s\n"), optarg);
 				return 0;
 			}
 			break;
 		case 'd':
-			dst = cvtnum(fsblocksize, fssectsize, optarg);
-			if (dst < 0) {
+			dst_off = cvtnum(fsblocksize, fssectsize, optarg);
+			if (dst_off < 0) {
 				printf(_("invalid destination offset -- %s\n"), optarg);
 				return 0;
 			}
@@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
 				printf(_("invalid length -- %s\n"), optarg);
 				return 0;
 			}
+			len_specified = true;
 			break;
 		case 'f':
 			src_file_nr = atoi(argv[1]);
@@ -137,7 +130,7 @@ copy_range_f(int argc, char **argv)
 		fd = filetable[src_file_nr].fd;
 	}
 
-	if (src == 0 && dst == 0 && len == 0) {
+	if (!len_specified) {
 		off64_t	sz;
 
 		sz = copy_src_filesize(fd);
@@ -145,16 +138,11 @@ copy_range_f(int argc, char **argv)
 			ret = 1;
 			goto out;
 		}
-		len = sz;
-
-		ret = copy_dst_truncate();
-		if (ret < 0) {
-			ret = 1;
-			goto out;
-		}
+		if (sz > src_off)
+			len = sz - src_off;
 	}
 
-	ret = copy_file_range_cmd(fd, &src, &dst, len);
+	ret = copy_file_range_cmd(fd, &src_off, &dst_off, len);
 out:
 	close(fd);
 	return ret;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6e064bdd..61c35c8e 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -669,13 +669,13 @@ The source must be specified either by path
 or as another open file
 .RB ( \-f ).
 If
-.I src_file
-.IR src_offset ,
-.IR dst_offset ,
-and
 .I length
-are omitted the contents of src_file will be copied to the beginning of the
-open file, overwriting any data already there.
+is not specified, this command copies data from
+.I src_offset
+to the end of
+.BI src_file
+into the dst_file at
+.IR dst_offset .
 .RS 1.0i
 .PD 0
 .TP 0.4i
-- 
2.21.0

