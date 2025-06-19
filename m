Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517552472AE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Jun 2025 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750316334; cv=none; b=EM7Ndc6q94JThXOQaXhacQ+dmxnohmjfArVCyBBSMBVZuH3UjWeRd9mcWVGAwy3CGWGwOZljQsYqV87oSL7U+4U3KKzgwZBD5LHiDxnc/hLXpsljtOzTD4bHOkE6W0p6ykihKNg7Xo8awOoLsJ8qXYXvpFbcMVRn9uKMUjmqIK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750316334; c=relaxed/simple;
	bh=LEgZdtw4yy4wxW/YwPeGVtxh4mLgZu5S7bZ4Pnqi3zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1Lz4/cPk1PzuVX5YQPtHswixdFFADcZxqj3zxbujtYU9/rxLfbNTKYJ8NJ9wxxZL+SQA4uW97L37mjQu4ma0xhhgSYHviMEOotALNXfZSPSc4zJyS4WfAzzOQdsY+ICk28Ad/jmCMoS8zEq9u5xaqqevbvyaPuAhcli/LipCPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Gtg73a43; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Gtg73a43"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso334522b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 23:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750316331; x=1750921131; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FEOWds+bZgIKQAm0Gc3hmTHHUBV1bQQU4/mAuQcNS6k=;
        b=Gtg73a43QjqA/UGCCGr0ZeFpLaCuDl3MRORj6j4xASpdVeCkxy4AxFLtf9qiF7xKOe
         wInwTRIvJoxyQITzgkv30lj5+Z1idclnjyh1PDb2DTdQvSp/oXlSgVwifsC6nUWwvJvu
         HUVo9wGiSUhX8F7bqrEn1AThHYlhsTx2jr0Crmr/uMapr0fr5kHV0DGTip2IvAz7pgoD
         8AY9TCr4+gW83/gCT4oPc7WLNYwtaCxZSUN9WY+aWNpSiPSDB59hZ/G8axbERz7P6MEL
         l9h7T+v6S2yEB7S2pr8nPyo4HC0lHJweG+j+7qmE99Z3sTit2LfiioKw0u8nXROBag1f
         spmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750316331; x=1750921131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEOWds+bZgIKQAm0Gc3hmTHHUBV1bQQU4/mAuQcNS6k=;
        b=h/NkOKpyHPmdSnV1k9JZoMVM4QJygeEDmUAttlcAM6HeDM8/Jg6LldDKPX8oqG9cMc
         f8bSv/Kksi6rUS5tAxkoT5P5OLysOEZ5j2ND7uJ4spcwKFOFpKIP1wm78mT2/F8auMos
         4kPSkuqZj24UmK5pBH2/6Eki+ikFCFGKg93kS8TSdJiuQ1GTP/JEkNA5oR0ashN3a5NE
         QiaQRHyGrRYzwNRZ+6ORliAMZgdIhO52uEFhe86Q4fr3Hj6bFQxo0oss1cBIf2yyfFWL
         D0KBz55lVvS08irPhNDZW2/YfXLAB9trXQSQ8RV0rCOqJXjuAMb5VaaKn9buCJO/sC8Y
         ELXA==
X-Forwarded-Encrypted: i=1; AJvYcCXFOERAFG+mDG+A8+OW43I/h8F4N88B4WsFVcPbq9oPOxryoz1oA6fwab5AjAOeZQ+zSJoN5M+Rc6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQdTk8OTwz6VvxLx4TAyyUssuLXMIBpJcKcfktPuKy8muNikn6
	l+xSaI/7CC1vqWpaP2NSPLRAJO+pPQc1MdN/FoLGd1kekeyB3rYtdQlSMEGDsU4IsqQ=
X-Gm-Gg: ASbGncungzfV3rAX/ZtvIbr+pF9Rir675NKKu+Cx1Q0lvfjNRgpseW5cc6Qz6fqHvuY
	wB7Pb/iPFP8rcRHC3277DEJE4VWELiBKGo3Mb7MIDf9WV6qA2M/rAmK+4DtfQ+g7HOPkHNrtbZK
	DFUU3erwvaH5ebVR7L1di47x9oYuSk0qOAsCxIBxiFdUiX3AttNtSTJ0v0TpQsycV64hrJ+YjZD
	3GfbjnA3Wry4aMdnR9+PtejcafqklzgLsk27RalzFgyYv3+W7LYBsuhqeu5qY+0LkHpJKYtErUL
	phmDyAaTwqFBId02CLqIM6gxGz7hArOtW2TpDqe4ntEYc4pLy3hoZH19QURcyJoIL76i/dnVZqs
	IaLXkqrdTlly89TRhnDmFCuNhleqgsjoTBGr9KQ==
X-Google-Smtp-Source: AGHT+IG/t6AgewTKKFlu+zlGfeXTFh1ou5tRTtU465CwJD7ztn4RWuG2pzS3wWFsCC7qbrg0yXA0dQ==
X-Received: by 2002:a05:6a20:7289:b0:218:17c4:248c with SMTP id adf61e73a8af0-21fbd559921mr33585411637.22.1750316331337;
        Wed, 18 Jun 2025 23:58:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748ecb5468dsm2779741b3a.96.2025.06.18.23.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 23:58:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uS9EV-00000000Vzq-2X9s;
	Thu, 19 Jun 2025 16:58:47 +1000
Date: Thu, 19 Jun 2025 16:58:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: cleanup log item formatting
Message-ID: <aFO1J-1SO2Sn6GgV@dread.disaster.area>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>

On Tue, Jun 10, 2025 at 07:14:57AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> I dug into a rabit hole about the log item formatting recently,
> and noticed that the handling of the opheaders is still pretty
> ugly because it leaks pre-delayed logging implementation
> details into the log item implementations.
> 
> The core of this series is to remove the to reserve space in the
> CIL buffers/shadow buffers for the opheaders that already were
> generated more or less on the fly by the lowlevel log write
> code anyway, but there's lots of other cleanups around it.

Another journal header corruption failure - I've hit the original
one I reported and this one a few times today:

[ 2217.226513] XFS (loop220): bad number of regions (33206) in inode log format  
[ 2217.231292] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2220
[ 2217.236193] ------------[ cut here ]------------                              
[ 2217.239216] kernel BUG at fs/xfs/xfs_message.c:102!                           
[ 2217.253064] Oops: invalid opcode: 0000 [#1] SMP NOPTI                         
[ 2217.253224] XFS (loop390): Unmounting Filesystem d3058266-1835-4b17-a51a-7276edbea3e9
[ 2217.267570] CPU: 31 UID: 0 PID: 1291175 Comm: mount Not tainted 6.15.0-dgc+ #339 PREEMPT(full) 
[ 2217.267574] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2217.267577] RIP: 0010:assfail+0x3a/0x40                                       
[ 2217.267588] Code: 89 f1 48 89 fe 48 c7 c7 8a f7 ed 82 48 c7 c2 f2 85 e8 82 e8 c8 fc ff ff 80 3d 19 b6 50 03 01 74 09 0f 0b 5d c3 cc cc cc cc cc <0f> 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
[ 2217.285594] RSP: 0018:ffffc90028293980 EFLAGS: 00010246                       
[ 2217.285598] RAX: ad5e2cca7393a700 RBX: 0000000000000000 RCX: ad5e2cca7393a700 
[ 2217.285600] RDX: ffffc90028293848 RSI: 000000000000000a RDI: ffffffff82edf78a 
[ 2217.285602] RBP: ffffc90028293980 R08: 0000000000000000 R09: 000000000000000a 
[ 2217.285603] R10: 0000000000000000 R11: 0000000000000021 R12: ffff8888e4108c80 
[ 2217.285605] R13: 00000000000000b0 R14: ffff8889008165c0 R15: ffff8889008165f0 
[ 2217.285609] FS:  00007fc3143ce840(0000) GS:ffff88909a83e000(0000) knlGS:0000000000000000
[ 2217.285612] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                 
[ 2217.285614] CR2: 00007ff4b56f0000 CR3: 000000013aaab000 CR4: 0000000000350ef0 
[ 2217.285619] Call Trace:                                                       
[ 2217.285622]  <TASK>                                                           
[ 2217.285625]  xlog_recover_add_to_trans+0x24e/0x2a0                            
[ 2217.294934]  xlog_recovery_process_trans+0x67/0x100                           
[ 2217.294937]  xlog_recover_process_ophdr+0xdd/0x140                            
[ 2217.294939]  xlog_recover_process_data+0x9b/0x160                             
[ 2217.294942]  xlog_recover_process+0xb2/0x110                                  
[ 2217.294943]  xlog_do_recovery_pass+0x685/0x900                                
[ 2217.294946]  xlog_do_log_recovery+0x43/0xb0                                   
[ 2217.306831]  xlog_do_recover+0x2c/0x190                                       
[ 2217.306834]  xlog_recover+0x165/0x180                                         
[ 2217.306835]  xfs_log_mount+0x14d/0x270                                        
[ 2217.306843]  xfs_mountfs+0x3aa/0x990                                          
[ 2217.306846]  xfs_fs_fill_super+0x701/0x870                                    
[ 2217.306850]  ? __pfx_xfs_fs_fill_super+0x10/0x10                              
[ 2217.321294]  get_tree_bdev_flags+0x120/0x1a0                                  
[ 2217.321314]  get_tree_bdev+0x10/0x20                                          
[ 2217.321316]  xfs_fs_get_tree+0x15/0x20                                        
[ 2217.321319]  vfs_get_tree+0x28/0xe0                                           
[ 2217.321321]  vfs_cmd_create+0x5f/0xd0                                         
[ 2217.321326]  vfs_fsconfig_locked+0x50/0x130                                   
[ 2217.321329]  __se_sys_fsconfig+0x349/0x3d0                                    
[ 2217.321332]  __x64_sys_fsconfig+0x25/0x30                                     
[ 2217.321336]  x64_sys_call+0x3be/0x2f60 

I'm going to stop testing this branch now and leave it until the
next version is posted for review.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
