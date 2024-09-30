Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1256074BF8
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 03:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727667890; cv=none; b=W4rbtAnHehE1ib93G/aLmyxXo2wIu90x0AgQd/HBZEe80nQ62eCY57eV/e3yufxIIMq1sA7J9OOc+9hDjqZ183Cc84kd62f5C6b7vO6ojrf+RUOD+11oeJqQSpswSbmc2pqBezZiz2gO/UDjEJ7BU2YX5vvVVeX1FsXN2v8fIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727667890; c=relaxed/simple;
	bh=ne/kOSOxtiI2HoTDyTW1s7G/NHHPfTdon3GXICVrDjc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l2deNUHcktwFOIQKvjgUzfiwUP+OCHV6VuAm064uAQevnJkaKtVqQJI2vEulyq/sxg7liDK++SltUZiH9bDYV2HOC2DXBxuQucQBUZSG65mEjUObXPMxV30eSmL4V1c8ZlvtyNg5Dbrrs6FMV6j/PHmfEVANzadDq9vk3/TWG88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZarihzHl; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZarihzHl"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-656d8b346d2so2332491a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Sep 2024 20:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727667888; x=1728272688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z4pnZB8shasEH25pvpHG/bmviIMTnBbWK6MWKS8jfiQ=;
        b=ZarihzHlOv18vkvDCMczqDmLXYUmi2/4eVmgB3jUoVN44gYYx62+Q4HPGNGqIU2jeP
         VMrzH2xGyR7BYUG1n7jV2D5GS7Hux4g7C9JmWKurFrmKQIHdMGPDMGHql1LXrd/Kvd4s
         EjVl4DoTAv8uCjcUqxL/VfVKUErICRWChavz4rQi1yrjGh2t9WDJGcYWyY9JXzbvHubN
         FIXN5hucq5gJFb283UZ7iRZnWH2m1HxpTUhWbAURtsvzVdcgEnm6D9gypeCdjjJScZi6
         gwHJR0GVaW7ezupH90Y6bOYEgszoj5I5fGlKNAqySrvLY9Z2L1itXOzm3LztJ0txZ4Cz
         ck7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727667888; x=1728272688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4pnZB8shasEH25pvpHG/bmviIMTnBbWK6MWKS8jfiQ=;
        b=SEUCZZ0vNaTAC+p/0j1xuw/P8W24s6AmqSvfdozDDv5ryOATxu4qNmdnq+4Bh8j78B
         +SbbfFMmEI/DX2XlyfvVNjl5k8yVJXB05iW5uMs+qeFw7WIao6i1KnUpljvw2RFY61zi
         VVoIQpsdiuNIG8c3blXr/oydD6m1GYF4ZyCRDBPFTvgdQa20XhmBL3DzOI9GUTmxDsgr
         s/hYkjedq16bpHrx47mNOs0mBCndG+guKuouzRkIhYbbZ1d8izc+2wwU/LVBCdGB5UOm
         XIa8NRDEhrKtu3wUoFU7kY/hdfd2V0S09wT1RZM9dJdvJFzVvnivdL/c9nq+cDZow1km
         B+mg==
X-Gm-Message-State: AOJu0Yx99IAB/4BzYnypylBG2RAry1y11K62c/ZssW8gBj5hGuVzUiRE
	Mg7BK0uo/3t+tL/mT2zbgiOuaJTTZgMg/ZhyzgtIDCsaXUYB6Uhd
X-Google-Smtp-Source: AGHT+IE6oODRebcTeW3XDMGhBhpAsjglXHIAXGvZkH4XBQZDh9tyM/vybrd1PK7i5KiPdk/60o3Pig==
X-Received: by 2002:a05:6a21:8cc7:b0:1d4:e54b:6048 with SMTP id adf61e73a8af0-1d4fa63cabfmr16940000637.1.1727667888323;
        Sun, 29 Sep 2024 20:44:48 -0700 (PDT)
Received: from localhost.localdomain ([39.144.244.124])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2649ca38sm5274120b3a.23.2024.09.29.20.44.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2024 20:44:47 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: chandan.babu@oracle.com,
	djwong@kernel.org,
	david@fromorbit.com
Cc: linux-xfs@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] xfs: Fix circular locking during xfs inode reclamation
Date: Mon, 30 Sep 2024 11:44:06 +0800
Message-Id: <20240930034406.7600-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I encountered the following error messages on our test servers:

[ 2553.303035] ======================================================
[ 2553.303692] WARNING: possible circular locking dependency detected
[ 2553.304363] 6.11.0+ #27 Not tainted
[ 2553.304732] ------------------------------------------------------
[ 2553.305398] python/129251 is trying to acquire lock:
[ 2553.305940] ffff89b18582e318 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0x70/0x190 [xfs]
[ 2553.307066]
but task is already holding lock:
[ 2553.307682] ffffffffb4324de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x368/0xb10
[ 2553.308670]
which lock already depends on the new lock.

[ 2553.309487]
the existing dependency chain (in reverse order) is:
[ 2553.310276]
-> #1 (fs_reclaim){+.+.}-{0:0}:
[ 2553.310853]        __lock_acquire+0x508/0xba0
[ 2553.311315]        lock_acquire+0xb4/0x2c0
[ 2553.311764]        fs_reclaim_acquire+0xa7/0x100
[ 2553.312231]        __kmalloc_noprof+0xa7/0x430
[ 2553.312668]        xfs_attr_shortform_list+0x8f/0x560 [xfs]
[ 2553.313402]        xfs_attr_list_ilocked+0x82/0x90 [xfs]
[ 2553.314087]        xfs_attr_list+0x78/0xa0 [xfs]
[ 2553.314701]        xfs_vn_listxattr+0x80/0xd0 [xfs]
[ 2553.315354]        vfs_listxattr+0x42/0x80
[ 2553.315782]        listxattr+0x5f/0x100
[ 2553.316181]        __x64_sys_flistxattr+0x5c/0xb0
[ 2553.316660]        x64_sys_call+0x1946/0x20d0
[ 2553.317118]        do_syscall_64+0x6c/0x180
[ 2553.317540]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2553.318116]
-> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
[ 2553.318802]        check_prev_add+0xed/0xcc0
[ 2553.319251]        validate_chain+0x535/0x840
[ 2553.319693]        __lock_acquire+0x508/0xba0
[ 2553.320155]        lock_acquire+0xb4/0x2c0
[ 2553.320560]        down_read_nested+0x36/0x170
[ 2553.321028]        xfs_ilock+0x70/0x190 [xfs]
[ 2553.321625]        xfs_can_free_eofblocks+0xd1/0x170 [xfs]
[ 2553.322327]        xfs_inode_needs_inactive+0x97/0xd0 [xfs]
[ 2553.323010]        xfs_inode_mark_reclaimable+0x81/0xd0 [xfs]
[ 2553.323694]        xfs_fs_destroy_inode+0xb7/0x150 [xfs]
[ 2553.324356]        destroy_inode+0x3e/0x80
[ 2553.325064]        evict+0x1e5/0x2f0
[ 2553.325607]        dispose_list+0x4d/0x70
[ 2553.326261]        prune_icache_sb+0x5c/0x90
[ 2553.326870]        super_cache_scan+0x15b/0x1d0
[ 2553.327476]        do_shrink_slab+0x157/0x6a0
[ 2553.328098]        shrink_slab_memcg+0x260/0x5d0
[ 2553.328747]        shrink_slab+0x2a3/0x360
[ 2553.329352]        shrink_node_memcgs+0x1eb/0x260
[ 2553.329995]        shrink_node+0x108/0x430
[ 2553.330551]        shrink_zones.constprop.0+0x89/0x2a0
[ 2553.331230]        do_try_to_free_pages+0x4c/0x2f0
[ 2553.331850]        try_to_free_pages+0xfc/0x2c0
[ 2553.332416]        __alloc_pages_slowpath.constprop.0+0x39c/0xb10
[ 2553.333172]        __alloc_pages_noprof+0x3a1/0x3d0
[ 2553.333847]        alloc_pages_mpol_noprof+0xd9/0x1e0
[ 2553.334499]        vma_alloc_folio_noprof+0x64/0xd0
[ 2553.335159]        alloc_anon_folio+0x1b3/0x390
[ 2553.335757]        do_anonymous_page+0x71/0x5b0
[ 2553.336355]        handle_pte_fault+0x225/0x230
[ 2553.337019]        __handle_mm_fault+0x31b/0x760
[ 2553.337760]        handle_mm_fault+0x12a/0x330
[ 2553.339313]        do_user_addr_fault+0x219/0x7b0
[ 2553.340149]        exc_page_fault+0x6d/0x210
[ 2553.340780]        asm_exc_page_fault+0x27/0x30
[ 2553.341358]
other info that might help us debug this:

[ 2553.342664]  Possible unsafe locking scenario:

[ 2553.343621]        CPU0                    CPU1
[ 2553.344300]        ----                    ----
[ 2553.344957]   lock(fs_reclaim);
[ 2553.345510]                                lock(&xfs_nondir_ilock_class);
[ 2553.346326]                                lock(fs_reclaim);
[ 2553.347015]   rlock(&xfs_nondir_ilock_class);
[ 2553.347639]
 *** DEADLOCK ***

The deadlock is as follows,

    CPU0                                  CPU1
   ------                                ------

  alloc_anon_folio()
    vma_alloc_folio(__GFP_FS)
     fs_reclaim_acquire(__GFP_FS);
       __fs_reclaim_acquire();

                                    xfs_attr_list()
                                      xfs_ilock()
                                      kmalloc(__GFP_FS);
                                        __fs_reclaim_acquire();

       xfs_ilock

To prevent circular locking, we should use GFP_NOFS instead of GFP_KERNEL
in xfs_attr_shortform_list().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 fs/xfs/xfs_attr_list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 7db386304875..0dc4600010b8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -114,7 +114,7 @@ xfs_attr_shortform_list(
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->count * sizeof(*sbuf);
-	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
+	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
-- 
2.43.5

