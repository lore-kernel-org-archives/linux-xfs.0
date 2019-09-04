Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9032BC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A2192087E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfIDXgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfIDXgm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 19:36:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7ADF130860C0;
        Wed,  4 Sep 2019 23:36:42 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA7D600F8;
        Wed,  4 Sep 2019 23:36:40 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, darrick.wong@oracle.com,
        "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH v2] xfsprogs: copy_range don't truncate dstfile
Date:   Thu,  5 Sep 2019 07:36:34 +0800
Message-Id: <20190904233634.12261-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 04 Sep 2019 23:36:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

now if we do copy_range from srcfile to dstfile without any option
will truncate the dstfile, and not any document indicate this default
action. that's unexpected and confuse people.

'''
$ ./xfs_io -f -c 'copy_range copy_file_range.c'  testfile
$ ll testfile
-rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:15 testfile
$ ./xfs_io -c 'copy_range testfile'  testfile
$ ll testfile
-rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:16 testfile
$ ./xfs_io -c 'copy_range testfile -l 3534 -d 3534' testfile
$ ll testfile
-rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:17 testfile
$ ./xfs_io -c 'copy_range copy_file_range.c'  testfile
$ ll testfile
-rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:18 testfile
$ cmp -n 3534 copy_file_range.c testfile
$ cmp -i 0:3534 copy_file_range.c testfile
'''

Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
---
 io/copy_file_range.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index b7b9fd88..283f5094 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -66,15 +66,6 @@ copy_src_filesize(int fd)
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
@@ -146,12 +137,6 @@ copy_range_f(int argc, char **argv)
 			goto out;
 		}
 		len = sz;
-
-		ret = copy_dst_truncate();
-		if (ret < 0) {
-			ret = 1;
-			goto out;
-		}
 	}
 
 	ret = copy_file_range_cmd(fd, &src, &dst, len);
-- 
2.21.0

