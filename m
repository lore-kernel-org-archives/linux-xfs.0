Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A51B8C0B
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 03:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739937019; cv=none; b=frzceF0Ty5vD7qxGUi+uCd0+Jzg2AdiP/pmROTuzxMuKsPLRTBGKgH/a51lrEgpiBE0tPudpsc1rdAi1LC9A9BiorbSm3HNMoJFWhslAMKs7gEQcFRDjI6Rv+NTw0wnJ5Ri9bq4wb1Id5dfpO0A9eAYEBGsRYnaxRFdglT0GE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739937019; c=relaxed/simple;
	bh=lZ8DMLY9tyujUKKqaPOAcAPbIB95xR34kLdjUI+kiYw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AD053t/pisnqY+qnibo3qysBCxp/6J7tplTkCOTnH4gimwr0rLTerTtQB98hmBT2wC5r5Qg5xdw1AD+BqxSI5MP9NDcgx/YmGaWEvT2dO04sAIFbR3RqR6rTs34GbAAE5Hx4eai0xDEKTPOChW2PDD5EEDuJgzc6neUjCxpxOqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uGXWiJxB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uGXWiJxB"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2210d92292eso98396515ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 19:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739937017; x=1740541817; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GlGI1fVkm3fWgDOljww8mTi1QqSX9/+PKnaUqaMb2dQ=;
        b=uGXWiJxBKQHny5lKphZ/q6XYck6GgezPK5I+re6ETW+WEzbvYlOzysxZE9qpQ8FJDn
         xBJj3WOoE39xKQY0t8xqFS6orwmcgk77PmS6Vn022b5OhOZmMETPV/PROz1SQATwPU9g
         H0ZV5uiFS7oUcEpspCzHRYcJKp0g5ZD+jX+visgPEdrpi0e0uP8wTLfxv/TKrdaPnVY1
         4DFE8yfo0/3BPHheutv1vl1hrk7ol4LMHz30/Id8W2X/HXCj9LKlFB2FRCK5g1QRw/Jg
         70r67Hz2CJG3CgV+DnewufR5I9nzdqYLKaikxaK++jUhBs59mEKNI07piqr+eXJ7DEHl
         PxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739937017; x=1740541817;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlGI1fVkm3fWgDOljww8mTi1QqSX9/+PKnaUqaMb2dQ=;
        b=QK1C7IPS0f2FIxnCBugXcKlhDHkfAjTw65azoyFgSymS0zmNcR//9CLc6mzws2xp0/
         AMkv2dxiOtrjGmpdG2ZUTPvRXEJy5cGpTIjWdimw4Tmn4jzdqWjtkrtQJ065sIlNwptD
         3mJKHHr5GGcuCHw3sZs5hKZw8Bhzsn++x5sPUzehfGJXQbiKXTSA3ovn/gkb+yCmaGeB
         6ZEGP8pYYw88Um2TOUdtGLMxadrrv6a5T3LJd6rOIPeI4BL2y4oAVneshbmYTRjmnCXZ
         SfAPdVPRWNI0+e3VhOGjh/in3xy5su4tNuDjB3cexgBVxm4E7oL1aqTZ95z7tEjA/0oc
         Nu1Q==
X-Gm-Message-State: AOJu0YwGjp/GB1AzzUsrZ7JTWHNPSpH9aIK784/CzkLc6icFWDQy5RlX
	qt0Cr4F8jjfXtqmzetNyrJ0Ka7dzR/ZyoPu8lX882xVr/FC1jTyFcckcRxGfqMKTOTTaVXkUD5l
	Q
X-Gm-Gg: ASbGncuEpcHlJm4J5o9+JX+Vt1fg3T6D9tfdzDF0G52I0I+8NjdpKSFdXLveyMdZ/s2
	K9M/QDFV/CNAmG9Gio7dDrzBNay/nS7e6GSljG0ycdooMWhLHLnLJpOR3cwlt7UojkbDlSOFQEz
	pPPKJXtjdDYudb3O6uXQG15iQX6G5lCiclLtd56eZ8f84gBUPR2B7Z5g8TvFFiHdq0T5lWO1hlZ
	29lI6Kdg/Uu3MuLaZkrDmxgmsBCaK4iSWcbaiLaEZwx2F+pmVczA30s1FYlgUYkhBh0R9wMBXK4
	khtt9MSQg3oJqCKcbI1BK7gOT6PHk+pgVqVIV9etHuaMIheZvCkoRfGPRvHxXfeR3Pc=
X-Google-Smtp-Source: AGHT+IFq9wzGOK5yGAAqKAjilMRh8WTxi/DiWt25mKAbtFUsWsX005VRsSKcrSRNr1NWeClpIovVxw==
X-Received: by 2002:a05:6a21:6d85:b0:1ee:d17a:d63d with SMTP id adf61e73a8af0-1eed4e52f71mr3101266637.4.1739937017282;
        Tue, 18 Feb 2025 19:50:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adb586187a5sm9988771a12.38.2025.02.18.19.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 19:50:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tkb6D-0000000353r-38g1;
	Wed, 19 Feb 2025 14:50:13 +1100
Date: Wed, 19 Feb 2025 14:50:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, willy@infradead.org
Subject: [regression 6.14-rc2 + xfs-for-next] Bad page state at unmount
Message-ID: <Z7VU9QX8MrmZVSrU@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

I hit this running check-parallel a moment ago:

[80180.074658] BUG: Bad page cache in process umount  pfn:7655f4
[80180.077259] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x0 pfn:0x7655f4
[80180.080573] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
[80180.083615] memcg:ffff888104f36000
[80180.084977] aops:xfs_address_space_operations ino:84
[80180.087175] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
[80180.091380] raw: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
[80180.094469] raw: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
[80180.097740] head: 0017ffffc000016d ffffea001745c648 ffffea0012b1da08 ffff8891726dae98
[80180.100988] head: 0000000000000000 0000000000000000 0000000900000000 ffff888104f36000
[80180.104129] head: 0017ffffc0000202 ffffea001d957d01 ffffffff00000003 0000000000000004
[80180.107232] head: 0000000000000004 0000000000000000 0000000000000000 0000000000000000
[80180.110338] page dumped because: still mapped when deleted
[80180.112755] CPU: 32 UID: 0 PID: 832271 Comm: umount Not tainted 6.14.0-rc2-dgc+ #302
[80180.112757] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[80180.112760] Call Trace:
[80180.112763]  <TASK>
[80180.112766]  dump_stack_lvl+0x3d/0xa0
[80180.112773]  dump_stack+0x10/0x17
[80180.112775]  filemap_unaccount_folio+0x151/0x1e0
[80180.112779]  delete_from_page_cache_batch+0x61/0x2f0
[80180.112787]  truncate_inode_pages_range+0x122/0x3e0
[80180.112807]  truncate_inode_pages_final+0x40/0x50
[80180.112809]  evict+0x1af/0x310
[80180.112817]  evict_inodes+0x66/0xc0
[80180.112818]  generic_shutdown_super+0x3c/0x160
[80180.112821]  kill_block_super+0x1b/0x40
[80180.112823]  xfs_kill_sb+0x12/0x30
[80180.112824]  deactivate_locked_super+0x38/0x100
[80180.112826]  deactivate_super+0x41/0x50
[80180.112828]  cleanup_mnt+0x9f/0x160
[80180.112830]  __cleanup_mnt+0x12/0x20
[80180.112831]  task_work_run+0x89/0xb0
[80180.112833]  resume_user_mode_work+0x4f/0x60
[80180.112836]  syscall_exit_to_user_mode+0x76/0xb0
[80180.112838]  do_syscall_64+0x74/0x130
[80180.112840]  ? exc_page_fault+0x62/0xc0
[80180.112841]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
....
[80180.131293] BUG: Bad page cache in process umount  pfn:4ac768
[80180.131296] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x4 pfn:0x4ac768
[80180.131299] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
[80180.131301] memcg:ffff888104f36000
[80180.131302] aops:xfs_address_space_operations ino:84
[80180.218440] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
[80180.222779] raw: 0017ffffc000016d ffffea001d957d08 ffffea000d980b08 ffff8891726dae98
[80180.226376] raw: 0000000000000004 0000000000000000 0000000900000000 ffff888104f36000
[80180.229546] head: 0017ffffc000016d ffffea001d957d08 ffffea000d980b08 ffff8891726dae98
[80180.232954] head: 0000000000000004 0000000000000000 0000000900000000 ffff888104f36000
[80180.232956] head: 0017ffffc0000202 ffffea0012b1da01 ffffffff00000003 0000000000000004
[80180.232958] head: 0000000500000004 0000000000000000 0000000000000000 0000000000000000
[80180.232958] page dumped because: still mapped when deleted
[80180.232961] CPU: 32 UID: 0 PID: 832271 Comm: umount Tainted: G    B              6.14.0-rc2-dgc+ #302
[80180.232965] Tainted: [B]=BAD_PAGE
.....
[80180.233052] BUG: Bad page cache in process umount  pfn:36602c
[80180.241951] page: refcount:9 mapcount:1 mapping:00000000ecd1b54a index:0x8 pfn:0x36602c
[80180.241955] head: order:2 mapcount:4 entire_mapcount:0 nr_pages_mapped:4 pincount:0
[80180.241957] memcg:ffff888104f36000
[80180.241958] aops:xfs_address_space_operations ino:84
[80180.241961] flags: 0x17ffffc000016d(locked|referenced|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
[80180.241965] raw: 0017ffffc000016d ffffea0012b1da08 ffffea000d585508 ffff8891726dae98
[80180.241966] raw: 0000000000000008 0000000000000000 0000000900000000 ffff888104f36000
[80180.241967] head: 0017ffffc000016d ffffea0012b1da08 ffffea000d585508 ffff8891726dae98
[80180.241969] head: 0000000000000008 0000000000000000 0000000900000000 ffff888104f36000
[80180.241970] head: 0017ffffc0000202 ffffea000d980b01 ffffffff00000003 0000000000000004
[80180.241971] head: 0000000500000004 0000000000000000 0000000000000000 0000000000000000
[80180.241972] page dumped because: still mapped when deleted
[80180.241974] CPU: 32 UID: 0 PID: 832271 Comm: umount Tainted: G    B              6.14.0-rc2-dgc+ #302
[80180.241976] Tainted: [B]=BAD_PAGE

I don't know which fstest triggered it, but this is a new failure
that I haven't seen before. It looks like 3 consecutive order-2
folios on the same mapping all have the same problem....

The kernel was a post 6.14-rc2 kernel with linux-xfs/for-next merged
into it. I'm going to update the kernel to TOT to see if this
reproduces again, but I've only seen this once in dozens of tests
runs on this kernel, so....

Has anyone seen something similar or have any ideas where to look?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
