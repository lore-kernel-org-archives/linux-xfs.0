Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26512C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 14:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346107AbiF1OqF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbiF1OqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 10:46:05 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B2AF2C101
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 07:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=floop
        MHyPc5b/HVchmwHR6E8y/dzqJo4FKeYJ0fkwU0=; b=mQ2iW692ibvNnFKFKsuty
        5Hb+Fu3cNdy+tZUpeapgACFUYR8TFZiA8E6Y1D2i7tbuHOWNfPqmjMHpw65XMjJM
        +P7MnDySAAt4Pel7zAxRp6ceT6yBJYgbSu70m5SL9c/khZNvxiEVpcRXPwg5phk1
        1xilU0+8ziS2dKhaoo4Mh0=
Received: from localhost.localdomain (unknown [111.32.104.14])
        by smtp1 (Coremail) with SMTP id C8mowAB3VN0oFLtiALI1Fg--.63814S2;
        Tue, 28 Jun 2022 22:46:00 +0800 (CST)
From:   hexiaole <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     hexiaole <hexiaole@kylinos.cn>
Subject: [PATCH v1] xfs: correct nlink printf specifier from hd to PRIu32
Date:   Tue, 28 Jun 2022 22:45:42 +0800
Message-Id: <20220628144542.33704-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowAB3VN0oFLtiALI1Fg--.63814S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF18Gr4rXrW8Ar4fJF1fJFb_yoW8Ar1Dpa
        1fJa45Gan5Zay3uFsrtrWqvw1agay5Jr43ZFnI9w15ArZxJr1qqrn2kw1Svw4UCw48XF1Y
        vFyqy3WfGr48u3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYdgAUUUUU=
X-Originating-IP: [111.32.104.14]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbimwkuBlx5hJZeXgAAsN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

1. Description
libxfs/xfs_log_format.h declare 'di_nlink' as unsigned 32-bit integer:

typedef struct xfs_icdinode {
        ...
        __uint32_t      di_nlink;       /* number of links to file */
        ...
} xfs_icdinode_t;

But logprint/log_misc.c use '%hd' to print 'di_nlink':

void
xlog_print_trans_inode_core(xfs_icdinode_t *ip)
{
    ...
    printf(_("nlink %hd uid %d gid %d\n"),
           ip->di_nlink, ip->di_uid, ip->di_gid);
    ...
}

'%hd' can be 16-bit on many architectures, on these architectures, the 'printf' only print the low 16-bit of 'di_nlink'.

2. Reproducer
2.1. Commands
[root@localhost ~]# cd
[root@localhost ~]# xfs_mkfile 128m 128m.xfs
[root@localhost ~]# mkfs.xfs 128m.xfs
[root@localhost ~]# mount 128m.xfs /mnt/
[root@localhost ~]# cd /mnt/
[root@localhost mnt]# seq 1 65534|xargs mkdir -p
[root@localhost mnt]# cd
[root@localhost ~]# umount /mnt/
[root@localhost ~]# xfs_logprint 128m.xfs|grep nlink|tail -1

2.2. Expect result
nlink 65536

2.3. Actual result
nlink 0
---
 logprint/log_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a3..6add28ed 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -444,7 +444,7 @@ xlog_print_trans_inode_core(
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
 	   (int)ip->di_format);
-    printf(_("nlink %hd uid %d gid %d\n"),
+    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
 	   ip->di_nlink, ip->di_uid, ip->di_gid);
     printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
 		xlog_extract_dinode_ts(ip->di_atime),
-- 
2.27.0

