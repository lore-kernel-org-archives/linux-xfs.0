Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168845025E;
	Mon, 22 Apr 2024 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798620; cv=none; b=qCwnLYU6a88on0wcwX8vBo4HdeTy+bfaC3/3VgcDwXBg/UgvFtpKzPR739tJZxtl0aK9MqAcs0WrV78wsBKGXyqkxFw7BTHY5xIIsjxw+v6FCCn9JDsWtxYBnlOfUdWZldxTcUMC9x0cSQC+R/w0vfE0lF2k6CRjPbI5QWKE80o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798620; c=relaxed/simple;
	bh=Yt8xkX0N3nbNBABJMLTLHbcx2YsWeUS8NaA+r9e8Kt0=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=fgdrfHH4dk9m5Hcn396XxAvx2IjbvAhe9nPMnvMME425nvBGPP72SpdgAYKzFDYeNnCrGNc7Z5eFCBw3KDVqIlXGg3hlkijIom1z0QufCVwySVwBED2flNr2+VzuwC1CrA6TDj1PYnZ69wp5/2LeUZUbFZ+Jkd2HHqnHuRsd02I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QfI0QTu0; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfI0QTu0"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ed20fb620fso3757260b3a.2;
        Mon, 22 Apr 2024 08:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713798618; x=1714403418; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNrs7+bJ32cKaNctOjioC+KE9Cj3gAa7cu0czlLxGY4=;
        b=QfI0QTu0/jyfXVUSfU7UWeC7fdNHy+FG2geP4YVjNPOIIkFCH9L2K38yhnpxvYtsda
         k7NJNZacGlwEgX20KJv3uYqWHqV2tG9RgiXVqxi6LHOxwbzemZs4d2ZjHUXDYLPBwUZg
         3lHlTgo1VocIcgGCIElcZch/RcuDhTSqIkqgOFgxBSmc02v9nkhw3ucSmtZrP39lNyv3
         Fbot7u09uf3znE48B0YLdRSx4xZI1K+WZQ4WVv/6vZ/2x/UW1LdR36SN7A4G1AmxSKy0
         fRZuzphWGp9gFw27lRE3BjLTT25GgvXJAWxAnRyx4MSW6jeOKuykhdfztko7LusOyhun
         0y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713798618; x=1714403418;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNrs7+bJ32cKaNctOjioC+KE9Cj3gAa7cu0czlLxGY4=;
        b=AxFPfhZWcLHWOP4wtR1g63sZdWSsr8vm1XYjZXJz70cs4nYEtQdZtQd7/uPJ0wqpJn
         oOfF7Fky645RKwg9OkejPPeNgbOyX46z6CLhgC0fa7nvrHwOXtrODGeIAdhPXh9KwF2k
         pfhKOgTbeTgGY9FdTLmksA1QyzVyR/XPcJSW6+Aey/e7KMKtqrNtPg6xAci8DN/mFDnV
         kCmtRbGN4wjXKvsNkl2g7Ngu/H5V34blgmHyDOTUW6kRlugUj/cRJVrvc9i9Z7fcqE4j
         EB4ZMyQIZbwiY/lAToUW60epH32Us2Sln04RHC+g/8pyyt7LXU3ZBTdINbLtBy7AnSHN
         P/hA==
X-Forwarded-Encrypted: i=1; AJvYcCXu6tDpDiLd1jlVpMzAxJ8F8617E13c/FoCq2FpIbBQIfA8+dxaj3ICdMIEzZs2meVflJ8ly3O5nAXNkEYIGkz90napuN0J
X-Gm-Message-State: AOJu0Yygdcl+QrS3Y9dXLzt4W4okJo7eBoQtlfyWtyFeQuWawe1wivo6
	N51AMi8zmKasueO+ic2yMA4eFWW3A3utkJxASdtp1+XOo2ksfsbY0bkQLlbM
X-Google-Smtp-Source: AGHT+IHDNzsY4d3Q0b4UVY5LCW618G1RRmCZh82VLR8jRuC6damal3HdfFvzYkRd8KE0X3rEFcK+hw==
X-Received: by 2002:a05:6a20:101a:b0:1a7:bb6d:6589 with SMTP id gs26-20020a056a20101a00b001a7bb6d6589mr8925877pzc.29.1713798617717;
        Mon, 22 Apr 2024 08:10:17 -0700 (PDT)
Received: from dw-tp ([171.76.85.139])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006ed64f4767asm7935370pff.112.2024.04.22.08.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 08:10:17 -0700 (PDT)
Date: Mon, 22 Apr 2024 20:40:03 +0530
Message-Id: <87ttjto2lw.fsf@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: Add cond_resched to xfs_defer_finish_noroll
In-Reply-To: <ZiWjbWrD60W/0s/F@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> On Sun, Apr 21, 2024 at 01:19:44PM +0530, Ritesh Harjani (IBM) wrote:
>> An async dio write to a sparse file can generate a lot of extents
>> and when we unlink this file (using rm), the kernel can be busy in umapping
>> and freeing those extents as part of transaction processing.
>> Add cond_resched() in xfs_defer_finish_noroll() to avoid soft lockups
>> messages. Here is a call trace of such soft lockup.
>> 
>> watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [rm:81335]
>> CPU: 1 PID: 81335 Comm: rm Kdump: loaded Tainted: G             L X    5.14.21-150500.53-default
>
> Can you reproduce this on a current TOT kernel? 5.14 is pretty old,
> and this stack trace:
>

Yes, I was able to reproduce this on upstream kernel too -

    watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
    CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
    Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
    NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
    LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
    Call Trace:
      xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
      xfs_alloc_compute_aligned+0x5c/0x144
      xfs_alloc_ag_vextent_size+0x238/0x8d4
      xfs_alloc_fix_freelist+0x540/0x694
      xfs_free_extent_fix_freelist+0x84/0xe0
      __xfs_free_extent+0x74/0x1ec
      xfs_extent_free_finish_item+0xcc/0x214
      xfs_defer_finish_one+0x194/0x388
      xfs_defer_finish_noroll+0x1b4/0x5c8
      xfs_defer_finish+0x2c/0xc4
      xfs_bunmapi_range+0xa4/0x100
      xfs_itruncate_extents_flags+0x1b8/0x2f4
      xfs_inactive_truncate+0xe0/0x124
      xfs_inactive+0x30c/0x3e0
      xfs_inodegc_worker+0x140/0x234
      process_scheduled_works+0x240/0x57c
      worker_thread+0x198/0x468
      kthread+0x138/0x140
      start_kernel_thread+0x14/0x18


>> NIP [c00800001b174768] xfs_extent_busy_trim+0xc0/0x2a0 [xfs]
>> LR [c00800001b1746f4] xfs_extent_busy_trim+0x4c/0x2a0 [xfs]
>> Call Trace:
>>  0xc0000000a8268340 (unreliable)
>>  xfs_alloc_compute_aligned+0x5c/0x150 [xfs]
>>  xfs_alloc_ag_vextent_size+0x1dc/0x8c0 [xfs]
>>  xfs_alloc_ag_vextent+0x17c/0x1c0 [xfs]
>>  xfs_alloc_fix_freelist+0x274/0x4b0 [xfs]
>>  xfs_free_extent_fix_freelist+0x84/0xe0 [xfs]
>>  __xfs_free_extent+0xa0/0x240 [xfs]
>>  xfs_trans_free_extent+0x6c/0x140 [xfs]
>>  xfs_defer_finish_noroll+0x2b0/0x650 [xfs]
>>  xfs_inactive_truncate+0xe8/0x140 [xfs]
>>  xfs_fs_destroy_inode+0xdc/0x320 [xfs]
>>  destroy_inode+0x6c/0xc0
>
> .... doesn't exist anymore.
>
> xfs_inactive_truncate() is now done from a
> background inodegc thread, not directly in destroy_inode().
>
> I also suspect that any sort of cond_resched() should be in the top
> layer loop in xfs_bunmapi_range(), not hidden deep in the defer
> code. The problem is the number of extents being processed without
> yielding, not the time spent processing each individual deferred
> work chain to free the extent. Hence the explicit rescheduling
> should be at the top level loop where it can be easily explained and
> understand, not hidden deep inside the defer chain mechanism....

Yes, sure. I will submit a v2 with this diff then (after I verify the
fix once on the setup, just for my sanity)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e..44d5381bc66f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
                error = xfs_defer_finish(tpp);
                if (error)
                        goto out;
+               cond_resched();
        }
 out:
        return error;


-ritesh
