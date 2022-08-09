Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE4AC3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 11:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiHILRX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbiHILRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 07:17:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A371CB13;
        Tue,  9 Aug 2022 04:17:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z16so13876362wrh.12;
        Tue, 09 Aug 2022 04:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=FSin4nxPSri0c4vse/wXNNtixSzUTmHBfg6r5jr3f84=;
        b=PK4GfSJ8p5Gkb79fhLizv5HSIf2CA47E+qVBBsrEyVaLlmoMa6oP0szt1Z92u8miBD
         g0kKiDisS8MwPatyb9Udy54rkbgY53Jd8QOulTtXNhc5p0HZCT/ZvP14WmAvKFD736X/
         mJvVbO9tELYsmRnd4ksII7R5Qae9ImGGeAAhgB/AHULGqdVlZhwfwsCuOF3IQpoLxkkp
         W0IeBCdQ4VLoI6F9A08M0vaJyPwmfs+0UbyC0yhP+HodcDcWOoLl9xOb8oTcNcR9EyMB
         rkc0J6agtgn3vbVtaamkE8+Ok4U/xbADWo1y1wNrrNdi7qB2hrX1tVEaFxyy03EZpPPu
         w86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=FSin4nxPSri0c4vse/wXNNtixSzUTmHBfg6r5jr3f84=;
        b=1brNlRWKB9Cq00CZw15vRXFt27hPv+H+X6uteaTNcSN+w6WCfnNjzOnrXlYFbGvc1c
         gfDDssI4dcl3cqjOAm7IreYNieLMCy4jsnYJLSRJd3JcIlyaQuEjOqAua6yensTuLmUQ
         e40wJ5/s5AMXQm4DHBTYAkuhvWodKQUCnYNwZLjk/2hdIiLC5CnJCMVLsc9HNrqMrW55
         up5PPTUjrsNmW9lxcjpGsstW7vcTdlIOQ8ZyetHNN1GHIQBkV2GzzbNzlOTc5NnfyJyh
         6Jezs9GebIE/phGUIxNtlIupTdpQEfNz0AbHRKlSu2o1KG3dkXIHpMIG0arZN5AXVFCF
         HzXA==
X-Gm-Message-State: ACgBeo1DOZRlNAkxVppLkQHOoSWJroFbIiyPTgHPVU0gS84/rkJ4/xG7
        EbdITM0zHiG6N1ZxXTQwGdM=
X-Google-Smtp-Source: AA6agR45EwuNJ72Yb99xHk9y3CXyddmGgTOD1i5lJANycdVyt04nI02GYqNJTJnLC5sIOPLbuh+mEg==
X-Received: by 2002:adf:dc87:0:b0:21e:ecad:a6bc with SMTP id r7-20020adfdc87000000b0021eecada6bcmr13689675wrj.218.1660043839775;
        Tue, 09 Aug 2022 04:17:19 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id l2-20020a1ced02000000b003a3170a7af9sm15906169wmh.4.2022.08.09.04.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 04:17:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 5.10 CANDIDATE 2/4] mm: Add kvrealloc()
Date:   Tue,  9 Aug 2022 13:17:06 +0200
Message-Id: <20220809111708.92768-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809111708.92768-1-amir73il@gmail.com>
References: <20220809111708.92768-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit de2860f4636256836450c6543be744a50118fc66 upstream.

During log recovery of an XFS filesystem with 64kB directory
buffers, rebuilding a buffer split across two log records results
in a memory allocation warning from krealloc like this:

xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
XFS (dm-0): Unmounting Filesystem
XFS (dm-0): Mounting V5 Filesystem
XFS (dm-0): Starting recovery (logdev: internal)
------------[ cut here ]------------
WARNING: CPU: 5 PID: 3435170 at mm/page_alloc.c:3539 get_page_from_freelist+0xdee/0xe40
.....
RIP: 0010:get_page_from_freelist+0xdee/0xe40
Call Trace:
 ? complete+0x3f/0x50
 __alloc_pages+0x16f/0x300
 alloc_pages+0x87/0x110
 kmalloc_order+0x2c/0x90
 kmalloc_order_trace+0x1d/0x90
 __kmalloc_track_caller+0x215/0x270
 ? xlog_recover_add_to_cont_trans+0x63/0x1f0
 krealloc+0x54/0xb0
 xlog_recover_add_to_cont_trans+0x63/0x1f0
 xlog_recovery_process_trans+0xc1/0xd0
 xlog_recover_process_ophdr+0x86/0x130
 xlog_recover_process_data+0x9f/0x160
 xlog_recover_process+0xa2/0x120
 xlog_do_recovery_pass+0x40b/0x7d0
 ? __irq_work_queue_local+0x4f/0x60
 ? irq_work_queue+0x3a/0x50
 xlog_do_log_recovery+0x70/0x150
 xlog_do_recover+0x38/0x1d0
 xlog_recover+0xd8/0x170
 xfs_log_mount+0x181/0x300
 xfs_mountfs+0x4a1/0x9b0
 xfs_fs_fill_super+0x3c0/0x7b0
 get_tree_bdev+0x171/0x270
 ? suffix_kstrtoint.constprop.0+0xf0/0xf0
 xfs_fs_get_tree+0x15/0x20
 vfs_get_tree+0x24/0xc0
 path_mount+0x2f5/0xaf0
 __x64_sys_mount+0x108/0x140
 do_syscall_64+0x3a/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Essentially, we are taking a multi-order allocation from kmem_alloc()
(which has an open coded no fail, no warn loop) and then
reallocating it out to 64kB using krealloc(__GFP_NOFAIL) and that is
then triggering the above warning.

This is a regression caused by converting this code from an open
coded no fail/no warn reallocation loop to using __GFP_NOFAIL.

What we actually need here is kvrealloc(), so that if contiguous
page allocation fails we fall back to vmalloc() and we don't
get nasty warnings happening in XFS.

Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_log_recover.c |  4 +++-
 include/linux/mm.h       |  2 ++
 mm/util.c                | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 69408782019e..e61f28ce3e44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2061,7 +2061,9 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = kvrealloc(old_ptr, old_len, len + old_len, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5b4d88faf114..b8b677f47a8d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -788,6 +788,8 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 	return kvmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
+extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
+		gfp_t flags);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
diff --git a/mm/util.c b/mm/util.c
index ba9643de689e..25bfda774f6f 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -661,6 +661,21 @@ void kvfree_sensitive(const void *addr, size_t len)
 }
 EXPORT_SYMBOL(kvfree_sensitive);
 
+void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
+{
+	void *newp;
+
+	if (oldsize >= newsize)
+		return (void *)p;
+	newp = kvmalloc(newsize, flags);
+	if (!newp)
+		return NULL;
+	memcpy(newp, p, oldsize);
+	kvfree(p);
+	return newp;
+}
+EXPORT_SYMBOL(kvrealloc);
+
 static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
-- 
2.25.1

