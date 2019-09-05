Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A948C3A5A5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E1A208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbfIEFcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 01:32:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbfIEFb7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 01:31:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96CAB317528C;
        Thu,  5 Sep 2019 05:31:59 +0000 (UTC)
Received: from dhcp-12-115.nay.redhat.com (dhcp-12-115.nay.redhat.com [10.66.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52355194B2;
        Thu,  5 Sep 2019 05:31:58 +0000 (UTC)
From:   "Jianhong.Yin" <yin-jianhong@163.com>
To:     linux-xfs@vger.kernel.org
Cc:     jiyin@redhat.com, "Jianhong.Yin" <yin-jianhong@163.com>
Subject: [PATCH 1/2] xfsprogs: copy_range don't truncate dstfile
Date:   Thu,  5 Sep 2019 13:31:51 +0800
Message-Id: <20190905053152.15701-1-yin-jianhong@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 05 Sep 2019 05:31:59 +0000 (UTC)
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

