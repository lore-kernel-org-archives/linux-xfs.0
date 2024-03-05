Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313782595
	for <linux-xfs@vger.kernel.org>; Tue,  5 Mar 2024 06:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709620372; cv=none; b=opSNzEDb/g3Qz2bobQ3DrftaD8IaDK5bpNLZhkpZNlYnBPWbSEwLo5wTuQxU/XNLxSp992IOM3l/f8/CRE9n6lfUPmg6R5+2fzLjfUiNsO/hXQhsOS8hsc1dB3Pswvlg3KJXxg1NCX9RbENikLBW2y6AHg1UsvXfRBHw6LeuTIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709620372; c=relaxed/simple;
	bh=l6tWqBZf9dAOgJfvLQcPTWC0GYbHPyPAHObbiT9weQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlyzFtPtL2vWqS9gWptY7z08AkUwHUjI2JefmuefazP5swSoMMNe2FrNg53Tki+GNCMwm3Ao+vcNqotAKc9uNuBY7OQux6cm19CpAKAGB3NydY2WOxbwmxb9aP07rNUUfUVqLOX/K83BLCUjo4+izcmVXN9VbAKb/cu0nAiM4gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0ZXOsRwo; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0ZXOsRwo"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dca1efad59so4500843a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 22:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709620369; x=1710225169; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ulEP5imFArt8D9ulbIh3qQeX4ddZu2fU2ePzaN3i4GM=;
        b=0ZXOsRwopKRkrMgbHOY5Mu88MOIGM88FxSERoSTtSwt6OoRmNy2RId2f1me7njGZu6
         QCPmeBq7DaIukXZYwylMAI9tY0uWAYcZUOZ+QCWgg46L3oXafwULHiFeUJYiUK3n+8Ng
         /s2+lsxn47fLpraHkARsLdiVXzUztF/oa5r9374igk7O5PSHzltmhLmCOzexC2XGm4H1
         L5YqICqVa2Ye4RJSS6PvH2d86Ur9jHx/kRutfD0tAjwr+YxirJ56kyqVMuu9mqTWLYyx
         a4j06XuTX2FYnIQLhv8IqQvY7t4Ggrmz+57i8/3vSALOzwV+1rxdUBPqIZtJEIMh4ZAY
         X0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709620369; x=1710225169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ulEP5imFArt8D9ulbIh3qQeX4ddZu2fU2ePzaN3i4GM=;
        b=RmKofbW4wuNSV2Zb5pgq1nJPJTJeQmn0KDUjt++et3AQ6KY97c+PV6cxWNA3wNdRTU
         t6H8VCZObPknjoDaVPa9HNzOmcT4KT9jpN3RQwM5+XNIR6P/rdpiQQulQoAYNQZOlwJV
         wB9Vf1hVQuZtwrCzVEU0V9IGQmCB7nuZue82RmBjICcw2bat5hXiKwGAzBcZi/eyHuSn
         kU1eKcR0D4mm8uvaMSIyPinXjYUIGyBNoYL11FU+CPNtGQ7Rh4OgpEoC8TL43spQvwoy
         uMVr5qRXJzZeCxNDMgz9Fi7MY2Cx09sPcY84mt340+2zLNKcxnuIXfTU7OeLZItE1ezP
         hKFw==
X-Gm-Message-State: AOJu0Yx2hq9eh+w0T71Urdjg3XmgSp7tEi+ak5dri3vK5wynQtXqlRbL
	UQaI30y1eFZ23Hrz2W/20A/63NUMuDh1QDND4hbLTEFDSLcyoUWlZFZMICggvJ/8PpB3phOTmDj
	p
X-Google-Smtp-Source: AGHT+IHdl2nQnmKCobqCzaaHy5SecvTz5vLJeCBI+8NXVgyERAd3UpGrXuUiy+QaQKocv9GeCFRh5w==
X-Received: by 2002:a05:6a20:8b18:b0:1a1:4970:6e07 with SMTP id l24-20020a056a208b1800b001a149706e07mr711113pzh.58.1709620369228;
        Mon, 04 Mar 2024 22:32:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id z12-20020aa785cc000000b006e56e5c09absm8483977pfn.14.2024.03.04.22.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 22:32:48 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhOM1-00FF1x-2a;
	Tue, 05 Mar 2024 17:32:45 +1100
Date: Tue, 5 Mar 2024 17:32:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] Deadlock when executing xfs/168 on XFS' previous
 for-next
Message-ID: <Zea8ja0atOktTl5z@dread.disaster.area>
References: <87frx5mfqi.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frx5mfqi.fsf@debian-BULLSEYE-live-builder-AMD64>

On Tue, Mar 05, 2024 at 10:18:45AM +0530, Chandan Babu R wrote:
> Hi,
> 
> I noticed the following call trace when executing xfs/168 on XFS' for-next
> as on 3rd March. The top most commit was,
> 
>     commit 601f8bc2440a25a386b1283ce15330c9ea3aaa07
>     Merge: 8d4dd9d741c3 27c86d43bcdb
>     Author: Chandan Babu R <chandanbabu@kernel.org>
>     Date:   Thu Feb 29 10:01:16 2024 +0530
>     
>         Merge tag 'xfs-6.8-fixes-4' into xfs-for-next
>     
>         Changes for 6.8-rc7:
>     
>           * Drop experimental warning for FSDAX.
>     
>         Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> 
> The fstests configuration file used was,
> 
>     TEST_DEV=/dev/loop16
>     SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12"
>     MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -d su=128k,sw=4'
>     MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'
>     TEST_FS_MOUNT_OPTS="$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
>     USE_EXTERNAL=no
>     LOGWRITES_DEV=/dev/loop15
> 
> Three tasks (i.e. 230900, 230901 and 230919) are blocked on
> trying to lock AG 1's AGI and one task (i.e. 230902) is blocked on trying to
> lock AG 1's AGF.
> 
> I have not been able to recreate the problem though.

Before I even look at it, I very much doubt this is a recent
regression.

> [18460.730782] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
> [18460.742765] XFS (loop5): Ending clean mount
> [18461.786504] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
> [18679.145200] INFO: task fsstress:230900 blocked for more than 122 seconds.
> [18679.147164]       Tainted: G        W          6.8.0-rc6+ #1
> [18679.148710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [18679.150423] task:fsstress        state:D stack:0     pid:230900 tgid:230900 ppid:230899 flags:0x00000002
> [18679.152186] Call Trace:
> [18679.153257]  <TASK>

Ugh - those stack traces are unreadable because of all the unwinder
false positives (all the ? entries) in them. Can you either change
the unwinder config in your builds to get rid of them or
post-process the stack dumps so they are human readable?

/me selects everything and runs `:'<,'>!grep -v "?"` make it
somewhat more readable and then trims manually:

> [18679.174407]  down+0x71/0xa0
> [18679.175442]  xfs_buf_lock+0xa4/0x290 [xfs]
> [18679.176816]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> [18679.179246]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> [18679.183248]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> [18679.198661]  xfs_buf_read_map+0xbb/0x900 [xfs]
> [18679.212987]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> [18679.219754]  xfs_read_agi+0x1cd/0x500 [xfs]
> [18679.224471]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
> [18679.227863]  xfs_dialloc+0x60e/0xbc0 [xfs]
> [18679.232961]  xfs_symlink+0x855/0xdc0 [xfs]
> [18679.238776]  xfs_vn_symlink+0x15d/0x3d0 [xfs]
> [18679.242688]  vfs_symlink+0x35a/0x5a0

Ok, symlink creation reading the AGI for inode allocation. Normal.

> [18679.282122]  down+0x71/0xa0
> [18679.282962]  xfs_buf_lock+0xa4/0x290 [xfs]
> [18679.284134]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> [18679.285249]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> [18679.287895]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> [18679.301750]  xfs_buf_read_map+0xbb/0x900 [xfs]
> [18679.315706]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> [18679.321739]  xfs_read_agi+0x1cd/0x500 [xfs]
> [18679.326984]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
> [18679.330566]  xfs_dialloc+0x60e/0xbc0 [xfs]
> [18679.335605]  xfs_create+0x5d9/0xf60 [xfs]
> [18679.343710]  xfs_generic_create+0x46f/0x600 [xfs]
> [18679.348897]  vfs_mknod+0x45a/0x740
> [18679.349783]  do_mknodat+0x27b/0x4d0

special file creation reading the AGI for inode allocation. Normal.

> [18679.390879]  down+0x71/0xa0
> [18679.391730]  xfs_buf_lock+0xa4/0x290 [xfs]
> [18679.392845]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> [18679.394012]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> [18679.398640]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> [18679.414394]  xfs_buf_read_map+0xbb/0x900 [xfs]
> [18679.421339]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> [18679.426929]  xfs_read_agf+0x1be/0x4d0 [xfs]
> [18679.431980]  xfs_alloc_read_agf+0xdf/0xf90 [xfs]
> [18679.441008]  xfs_alloc_fix_freelist+0x7f2/0x970 [xfs]
> [18679.456394]  xfs_alloc_vextent_prepare_ag+0x75/0x410 [xfs]
> [18679.457598]  xfs_alloc_vextent_exact_bno+0x2b8/0x440 [xfs]
> [18679.462437]  xfs_ialloc_ag_alloc+0x513/0x18d0 [xfs]
> [18679.469776]  xfs_dialloc+0x683/0xbc0 [xfs]
> [18679.473892]  xfs_create+0x5d9/0xf60 [xfs]
> [18679.481977]  xfs_generic_create+0x46f/0x600 [xfs]
> [18679.487565]  vfs_mknod+0x45a/0x740

Special file creation holding the AGI lock doing inode chunk
allocation needing to trying to get the AGF. Normal.

> [18679.536829]  down+0x71/0xa0
> [18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
> [18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> [18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> [18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> [18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
> [18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> [18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
> [18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
> [18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
> [18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
> [18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
> [18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
> [18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
> [18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]

Growfs - that was not what I expected -  trying to run a
shrink operation and needing to read the AGI to calculate how
much space it needs to reserve. Huh, it does <read agi>, <read agf>
before anything so it shouldn't have a lock inversion.

Oh, there's a second call to xfs_ag_resv_init in an error handling
path. Yup, there's the bug.

	<read AGI>
	<read AGF>
	<do checks>
	<free ag resv>

	/* internal log shouldn't also show up in the free space btrees */
        error = xfs_alloc_vextent_exact_bno(&args,
                        XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta));
        if (!error && args.agbno == NULLAGBLOCK)
                error = -ENOSPC;

        if (error) {
                /*
                 * if extent allocation fails, need to roll the transaction to
                 * ensure that the AGFL fixup has been committed anyway.
                 */
>>>>>>          xfs_trans_bhold(*tpp, agfbp);
>>>>>>          err2 = xfs_trans_roll(tpp);
                if (err2)
                        return err2;
>>>>>>          xfs_trans_bjoin(*tpp, agfbp);
>>>>>>          goto resv_init_out;
        }
....
resv_init_out:
>>>>>>  err2 = xfs_ag_resv_init(pag, *tpp);	

Ok, so on error, it holds the AGF, commits the transaction, rejoins
the locked AGF to the new transaction, and then attempts to read
the AGI to restore the AG reservations.

Yup, that's a lock order inversion - it needs to hold both the AGF
and AGI across the transaction roll to avoid needing to re-read the
AGI in the error handling path.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
