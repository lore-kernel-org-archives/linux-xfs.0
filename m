Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B118BC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F83423402
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfIDGcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfIDGcb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 02:32:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD6C63082E20;
        Wed,  4 Sep 2019 06:32:31 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 041125D9E1;
        Wed,  4 Sep 2019 06:32:28 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH] xfsprogs: copy_range don't truncate dstfile if same with srcfile
Date:   Wed,  4 Sep 2019 14:32:22 +0800
Message-Id: <20190904063222.21253-1-yin-jianhong@163.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 04 Sep 2019 06:32:31 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

now if we do copy_range in same file without any extra option
will truncate the file, and not any document indicate this default
action. that's risky to users.

'''
$ LANG=C ll testfile
-rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:22 testfile
$ ./xfs_io -c 'copy_range testfile' testfile
$ LANG=C ll testfile
-rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:23 testfile
'''

Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
---
 io/copy_file_range.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index b7b9fd88..487041c0 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -75,6 +75,19 @@ copy_dst_truncate(void)
 	return ret;
 }
 
+int is_same_file(int fd1, int fd2) {
+	struct stat stat1, stat2;
+	if (fstat(fd1, &stat1) < 0) {
+		perror("fstat");
+		return -1;
+	}
+	if (fstat(fd2, &stat2) < 0) {
+		perror("fstat");
+		return -1;
+	}
+	return (stat1.st_dev == stat2.st_dev) && (stat1.st_ino == stat2.st_ino);
+}
+
 static int
 copy_range_f(int argc, char **argv)
 {
@@ -147,10 +160,12 @@ copy_range_f(int argc, char **argv)
 		}
 		len = sz;
 
-		ret = copy_dst_truncate();
-		if (ret < 0) {
-			ret = 1;
-			goto out;
+		if (!is_same_file(fd, file->fd)) {
+			ret = copy_dst_truncate();
+			if (ret < 0) {
+				ret = 1;
+				goto out;
+			}
 		}
 	}
 
-- 
2.17.2

