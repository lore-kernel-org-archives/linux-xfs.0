Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F801C287;
	Mon,  8 Jul 2024 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720427775; cv=none; b=kbuHNoeG7L1wWFPmsfDvg8ac9+PrjpahNVeb94wHpt5ZiN+ycw0I7paA+qOeh/wv90CkdilLeg0IdByLx4BTHNKKVu4p1U9U1W96XSoKvJdSLXW5c39ZUO7kzuZQkNpxMpKGRz91s+7Cw4wXNBmjiLiZc2Cz+AT+oU7L18XdgYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720427775; c=relaxed/simple;
	bh=ntYJhtVGR9f3QM15zn4sdZag4CwS/D+IcM32w/CzGeI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=p29e9PhpkqIpyBXjJj/X0xGH2Alqt9g4zQF1+KyKKVe7grq722Y6FCYDW+4Yh2wsRnykuGTeR8v89div6Sb2uzh6ZW+kxvqjar43n9LnImvekTpDIsswNmfa/5tpFyyYcIJrZUlLtQseUvCDbUK3+nXqm2Re5qUJ4s9lsmpqB40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeFSG4pe; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeFSG4pe"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d9272287easo996005b6e.2;
        Mon, 08 Jul 2024 01:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720427772; x=1721032572; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckwzYGTIT0iYPZg14psVy0rINcMO6y55PA7hbNu4YYs=;
        b=VeFSG4peJQ4ygHMJIdVwYXCl7TQVcmq9HNR/WjInP6PmMttyCvMQNnH9WjPizZ6mYw
         TvtsvCnJNSeRBBkDTZsXqXUAQwC2dQ6i/ZOpUleFgnKXXiI5oSkuFTAdqZceTHYfbqNq
         iZOcWCN2xy2U8IePlpdT80wQaIPfokb5U/68kuh4Z/4P0LaVbfEgTJknoXNOMNbnXY4w
         gsI/fXRmOFIEu5oFm5o/DkAcuzIMy46Oabl32+ZEwPc+aMAh+AhnWTYDLHJwkA7y4otE
         tAp8FyezntVU6VtXSwnsjXxLXmcoLel9C3WRR5cXilbZt2ILG8HfyYLpm700mfiojR+T
         S3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720427772; x=1721032572;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ckwzYGTIT0iYPZg14psVy0rINcMO6y55PA7hbNu4YYs=;
        b=s//uHUZR75z3GGdohDthSsFBwNw87sexb7nS95b5nXk9vOY91L9+wyv33ndms0yd8d
         2LFlJo+F1D94sjKYQW7EStVyden2lFqVgu2CamTiZLAKbrNrSLuJd/p+1/Py/OjuysNb
         A4PQlJQ3Z5tY8uUka3+Yl8URvLH/E/WJvHbxW0eV48udetNrdQZsNmQrywdnLAH2Gt+Z
         tl9mp7345sgHFY+mRDv7CqEdz4kT3nF43fZ9imMh2PxgVnzPv1VJMkuZ/m3e2bC02oEa
         yOyOWFaNZVjAWlJ/vcrcCk+pB+03s5pBEiMUJo0HPnJdtTRl0R614zzIinWqjXDzEDUE
         cE5w==
X-Forwarded-Encrypted: i=1; AJvYcCW/GjCDh6MdeDrHiiUUUzGGSzscZ8dx5yyt43661E7+0l8cHeEawbxmw9LObdOaibQYRwaFmaPIfsSAIXHNe7UerEngdtIDD9OjxvL0
X-Gm-Message-State: AOJu0Yy7B7kZhivN2lFmWyCHyTJxbMql+nSOod1yTCrPCSugkXulalRI
	OWT6t8HXwQXiIckq/QiukUxIg/L1tH9c1i99bx3GiQKHXCMWwkN0enyI5A==
X-Google-Smtp-Source: AGHT+IHBmHy95kFyeSWDc3WO+DwA6O7MK+D44iVN0slGlPHCHKjyGLSdAbwfyeC9fFpJ4iqy9RttMA==
X-Received: by 2002:a05:6808:f87:b0:3d6:30af:54cb with SMTP id 5614622812f47-3d914eba84bmr14098027b6e.50.1720427771675;
        Mon, 08 Jul 2024 01:36:11 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a8dbff3sm14783597a12.32.2024.07.08.01.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 01:36:10 -0700 (PDT)
Message-ID: <e5814465-b39a-44d8-aa3d-427773c9ae16@gmail.com>
Date: Mon, 8 Jul 2024 16:36:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Alex Shi <seakeel@gmail.com>
Subject: xfs deadlock on mm-unstable kernel?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

  372.297234][ T3001] ============================================
[  372.297530][ T3001] WARNING: possible recursive locking detected
[  372.297827][ T3001] 6.10.0-rc6-00453-g2be3de2b70e6 #64 Not tainted
[  372.298137][ T3001] --------------------------------------------
[  372.298436][ T3001] cc1/3001 is trying to acquire lock:
[  372.298701][ T3001] ffff88802cb910d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_reclaim_inode+0x59e/0x710
[  372.299242][ T3001] 
[  372.299242][ T3001] but task is already holding lock:
[  372.299679][ T3001] ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
[  372.300258][ T3001] 
[  372.300258][ T3001] other info that might help us debug this:
[  372.300650][ T3001]  Possible unsafe locking scenario:
[  372.300650][ T3001] 
[  372.301031][ T3001]        CPU0
[  372.301231][ T3001]        ----
[  372.301386][ T3001]   lock(&xfs_dir_ilock_class);
[  372.301623][ T3001]   lock(&xfs_dir_ilock_class);
[  372.301860][ T3001] 
[  372.301860][ T3001]  *** DEADLOCK ***
[  372.301860][ T3001] 
[  372.302325][ T3001]  May be due to missing lock nesting notation
[  372.302325][ T3001] 
[  372.302723][ T3001] 3 locks held by cc1/3001:
[  372.302944][ T3001]  #0: ffff88800e146078 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: walk_component+0x2a5/0x500
[  372.303554][ T3001]  #1: ffff88800e145e58 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4d/0x60
[  372.304183][ T3001]  #2: ffff8880040190e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x82/0x4e0
[  372.304740][ T3001] 
[  372.304740][ T3001] stack backtrace:
[  372.305031][ T3001] CPU: 6 PID: 3001 Comm: cc1 Not tainted 6.10.0-rc6-00453-g2be3de2b70e6 #64
[  372.305453][ T3001] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  372.305934][ T3001] Call Trace:
[  372.306109][ T3001]  <TASK>
[  372.306253][ T3001]  dump_stack_lvl+0x78/0xe0
[  372.306483][ T3001]  validate_chain+0x519/0x9d0
[  372.306715][ T3001]  ? __pfx_validate_chain+0x10/0x10
[  372.306971][ T3001]  ? hlock_class+0x4e/0x130
[  372.307195][ T3001]  ? mark_lock+0x36/0x3b0
[  372.307409][ T3001]  __lock_acquire+0xacf/0x1540
[  372.307659][ T3001]  lock_acquire+0x165/0x3b0
[  372.307936][ T3001]  ? xfs_reclaim_inode+0x59e/0x710
[  372.308254][ T3001]  ? __pfx_lock_acquire+0x10/0x10
[  372.308507][ T3001]  ? __pfx___might_resched+0x10/0x10
[  372.308770][ T3001]  ? __pfx___lock_release.isra.0+0x10/0x10
[  372.309061][ T3001]  down_write_nested+0x9c/0x200
[  372.309303][ T3001]  ? xfs_reclaim_inode+0x59e/0x710
[  372.309552][ T3001]  ? __pfx_down_write_nested+0x10/0x10
[  372.309822][ T3001]  ? trace_xfs_ilock+0x119/0x190
[  372.310072][ T3001]  xfs_reclaim_inode+0x59e/0x710
[  372.310320][ T3001]  xfs_icwalk_ag+0x833/0xe50
[  372.310549][ T3001]  ? __pfx_xfs_icwalk_ag+0x10/0x10
[  372.310803][ T3001]  ? find_held_lock+0x2d/0x110
[  372.311037][ T3001]  ? xfs_perag_grab_tag+0x143/0x2d0
[  372.311297][ T3001]  ? xfs_perag_grab_tag+0x14d/0x2d0
[  372.311554][ T3001]  ? __pfx_xfs_perag_grab_tag+0x10/0x10
[  372.311828][ T3001]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  372.312096][ T3001]  xfs_icwalk+0x4c/0xd0
[  372.312306][ T3001]  xfs_reclaim_inodes_nr+0x148/0x1f0
[  372.312571][ T3001]  ? __pfx_xfs_reclaim_inodes_nr+0x10/0x10
[  372.312964][ T3001]  super_cache_scan+0x393/0x4e0
[  372.313267][ T3001]  do_shrink_slab+0x33e/0xc90
[  372.313552][ T3001]  shrink_slab_memcg+0x479/0x9c0
[  372.313852][ T3001]  ? shrink_slab_memcg+0x2df/0x9c0
[  372.314074][ T3001]  ? __pfx_shrink_slab_memcg+0x10/0x10
[  372.314328][ T3001]  ? find_held_lock+0x2d/0x110
[  372.314560][ T3001]  ? __pfx_shrink_lruvec+0x10/0x10
[  372.314811][ T3001]  ? __lock_release.isra.0+0x103/0x440
[  372.315078][ T3001]  shrink_slab+0x426/0x520
[  372.315306][ T3001]  ? __pfx_shrink_slab+0x10/0x10
[  372.315675][ T3001]  ? __pfx___might_resched+0x10/0x10
[  372.315999][ T3001]  ? page_counter_calculate_protection+0x2b3/0x5f0
[  372.316317][ T3001]  shrink_node_memcgs+0x4bc/0x8b0
[  372.316624][ T3001]  ? sum_zone_node_page_state+0x75/0xe0
[  372.316953][ T3001]  ? __pfx_shrink_node_memcgs+0x10/0x10
[  372.317226][ T3001]  ? node_page_state+0x2a/0x70
[  372.317462][ T3001]  ? prepare_scan_control+0x64e/0xb30
[  372.317729][ T3001]  shrink_node+0x1c4/0xeb0
[  372.317988][ T3001]  ? zone_reclaimable_pages+0x4ab/0x8b0
[  372.318266][ T3001]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  372.318620][ T3001]  do_try_to_free_pages+0x27b/0x1670
[  372.318969][ T3001]  ? __pfx_throttle_direct_reclaim+0x10/0x10
[  372.319266][ T3001]  try_to_free_pages+0x198/0x280
[  372.319509][ T3001]  ? __pfx_try_to_free_pages+0x10/0x10
[  372.319777][ T3001]  ? __pfx___might_resched+0x10/0x10
[  372.320039][ T3001]  __alloc_pages_slowpath.constprop.0+0x749/0x1460
[  372.320356][ T3001]  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10
[  372.320697][ T3001]  __alloc_pages_noprof+0x497/0x540
[  372.321004][ T3001]  ? __pfx___alloc_pages_noprof+0x10/0x10
[  372.321293][ T3001]  ? __pfx___lock_release.isra.0+0x10/0x10
[  372.321623][ T3001]  ? mark_held_locks+0x96/0xe0
[  372.321858][ T3001]  alloc_pages_bulk_noprof+0x6b7/0x1000
[  372.322134][ T3001]  ? lockdep_init_map_type+0x16d/0x7c0
[  372.322399][ T3001]  ? lockdep_init_map_type+0x16d/0x7c0
[  372.322665][ T3001]  xfs_buf_alloc_pages+0x1b9/0x8d0
[  372.322917][ T3001]  ? __pfx___lock_release.isra.0+0x10/0x10
[  372.323209][ T3001]  xfs_buf_find_insert.isra.0+0xd4/0x390
[  372.323480][ T3001]  ? __pfx_xfs_buf_find_insert.isra.0+0x10/0x10
[  372.323784][ T3001]  xfs_buf_get_map+0x8c2/0xe20
[  372.324017][ T3001]  ? __pfx_xfs_buf_get_map+0x10/0x10
[  372.324275][ T3001]  xfs_buf_read_map+0xbd/0xa40
[  372.324508][ T3001]  ? xfs_da_read_buf+0x1f5/0x300
[  372.324752][ T3001]  ? __pfx_xfs_buf_read_map+0x10/0x10
[  372.325015][ T3001]  xfs_trans_read_buf_map+0x289/0x4d0
[  372.325281][ T3001]  ? xfs_da_read_buf+0x1f5/0x300
[  372.325523][ T3001]  ? __lock_release.isra.0+0x103/0x440
[  372.325791][ T3001]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10
[  372.326082][ T3001]  ? unwind_next_frame+0x501/0x1d80
[  372.326344][ T3001]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  372.326646][ T3001]  xfs_da_read_buf+0x1f5/0x300
[  372.326881][ T3001]  ? __pfx_xfs_da_read_buf+0x10/0x10
[  372.327143][ T3001]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[  372.327445][ T3001]  ? kernel_text_address+0xbc/0x150
[  372.327698][ T3001]  ? unwind_get_return_address+0x5e/0xa0
[  372.327985][ T3001]  ? xfs_dir2_leaf_search_hash+0xfc/0x2b0
[  372.328262][ T3001]  ? __pfx_xfs_dir2_leaf_search_hash+0x10/0x10
[  372.328564][ T3001]  ? __pfx_xfs_iread_extents+0x10/0x10
[  372.328834][ T3001]  xfs_dir3_data_read+0x38/0x2a0
[  372.329192][ T3001]  xfs_dir2_leaf_lookup_int+0x464/0xae0
[  372.329529][ T3001]  ? __pfx_xfs_dir2_leaf_lookup_int+0x10/0x10
[  372.329829][ T3001]  ? xfs_bmap_last_offset+0x14c/0x2f0
[  372.330093][ T3001]  ? __pfx_xfs_bmap_last_offset+0x10/0x10
[  372.330371][ T3001]  xfs_dir2_leaf_lookup+0xf0/0x410
[  372.330621][ T3001]  ? __pfx_xfs_dir2_leaf_lookup+0x10/0x10
[  372.330901][ T3001]  ? down_read_nested+0xc0/0x340
[  372.331146][ T3001]  xfs_dir_lookup_args+0xcc/0xe0
[  372.331391][ T3001]  ? __pfx_xfs_dir_lookup_args+0x10/0x10
[  372.331669][ T3001]  xfs_dir_lookup+0x596/0x870
[  372.331901][ T3001]  xfs_lookup+0x185/0x2e0
[  372.332117][ T3001]  ? __pfx_xfs_lookup+0x10/0x10
[  372.332357][ T3001]  xfs_vn_lookup+0x14e/0x1a0
[  372.332586][ T3001]  ? __pfx_xfs_vn_lookup+0x10/0x10
[  372.332839][ T3001]  ? lockdep_init_map_type+0x16d/0x7c0
[  372.333109][ T3001]  __lookup_slow+0x20e/0x3c0
[  372.333340][ T3001]  ? __pfx___lookup_slow+0x10/0x10
[  372.333594][ T3001]  ? __startup_64+0x190/0x550
[  372.333827][ T3001]  ? __startup_64+0x190/0x550
[  372.334069][ T3001]  walk_component+0x2b3/0x500
[  372.334301][ T3001]  path_lookupat+0x117/0x680
[  372.334530][ T3001]  filename_lookup+0x1b0/0x520
[  372.334765][ T3001]  ? __pfx_filename_lookup+0x10/0x10
[  372.335024][ T3001]  ? __lock_acquire+0xacf/0x1540
[  372.335272][ T3001]  ? __pfx___lock_release.isra.0+0x10/0x10
[  372.335560][ T3001]  ? __pfx___might_resched+0x10/0x10
[  372.335834][ T3001]  vfs_statx+0xc9/0x4e0
[  372.336046][ T3001]  ? __pfx_vfs_statx+0x10/0x10
[  372.336283][ T3001]  ? getname_flags.part.0+0xb7/0x440
[  372.336544][ T3001]  vfs_fstatat+0x96/0xc0
[  372.336755][ T3001]  __do_sys_newlstat+0x99/0x100
[  372.336994][ T3001]  ? __pfx___do_sys_newlstat+0x10/0x10
[  372.337264][ T3001]  ? __pfx___lock_release.isra.0+0x10/0x10
[  372.337552][ T3001]  ? syscall_trace_enter+0x152/0x250
[  372.340527][ T3001]  ? syscall_trace_enter+0x152/0x250
[  372.340822][ T3001]  do_syscall_64+0xc1/0x1d0
[  372.341041][ T3001]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  372.341327][ T3001] RIP: 0033:0x7fdb7b6ecb29
[  372.341554][ T3001] Code: 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 48 89 f0 83 ff 01 77 34 48 89 c7 48 89 d6 b8 06 00 00 00 0f 05 <48> 3d 00 f0 ff f0
[  372.342495][ T3001] RSP: 002b:00007fff978b5ec8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[  372.342903][ T3001] RAX: ffffffffffffffda RBX: 00007fff978b6ff0 RCX: 00007fdb7b6ecb29
[  372.343284][ T3001] RDX: 00007fff978b5f10 RSI: 00007fff978b5f10 RDI: 00007fff978b5ff0
[  372.343681][ T3001] RBP: 00007fff978b5fe0 R08: 0000558afac57acb R09: 0000558ae4d344e0
[  372.344046][ T3001] R10: 00000000a053c1a1 R11: 0000000000000246 R12: 00007fff978b5ff0
[  372.344414][ T3001] R13: 0000558afac57acc R14: 0000558afac57ac2 R15: 00007fff978b600c
[  372.344816][ T3001]  </TASK>
