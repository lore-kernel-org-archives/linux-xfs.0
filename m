Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7161110F2
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729126408; cv=none; b=G7zkkyoumfRNSq5kdKky3AV2YH/H0l0xUovS6M9/GirEbAU6Ei09p/U2iNVdlknqdFGsf4LJWYkHcDYlNy72/FtnKpCyW4AZ3XUGDDC3fOssYDvNAk1A0UAoALgyzRoKuIUdWvThyLzlN4wUyP4tsev4u0bsV0a9AewS/ZTQlmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729126408; c=relaxed/simple;
	bh=itmRBCyOHouzo9A+F3qhScrbBHXCrNzpvwkew3uPQ5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFrE7dSbDPj83JyYOTUpq7pltxY1II9OfTEvr/uccK0i1Btn7kFXmQdOClLnONO1phhYpkaP5zRWZ9l9m5PVuLNX1FmPLBi4IaH66jal0ojLHjzmsG7/mzQDYiU4Wq4X7ekxOdg1PVx4UScpRwxZCYZj6ZhDF8jeiec5/E81Qzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EX0QmdN7; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EX0QmdN7"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e49ef3b2bso273365b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 17:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729126405; x=1729731205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IK5h5w5Ghva2vbT6gutysnV4jCZSHbLo7fe8Cq+2V+I=;
        b=EX0QmdN7CqCXKAujtObtBzN+8yWwr9nkWkatqEOZ8R9mJzO2m3kBxttZQA0Q6yLEfC
         WLLD8Ob6s+nWrsB9jK2EAKFJLY1uad1mdFqdSQxD+9mmmqcNiTgATm3eIUDvsQMDrzoZ
         1QoXGcIx+FHtvu61mSI/JZbgUPdqVSxlRPhYG5tT/L4yn78y1kEcdpYsQ6WDeZQ3BKRq
         VCh3sxLvBKODcwFO19QbUzrQJMvenkN4o+vTp8jOyAZ1p2CA3lj1xyD45wm3l5zBgo6x
         /Eqd9g+huFpHM8jdPzUqs415IwiTP2y+3oEhIGayHAixchbDbTl7WKeNmCMNFgNjzEnT
         9HDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729126405; x=1729731205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IK5h5w5Ghva2vbT6gutysnV4jCZSHbLo7fe8Cq+2V+I=;
        b=C7kABUec6ONNTnDVpwhnkT8ssqcfStAGnyXpOpHvTC9+U07ejS9UtnHhkxHPyj4Rs9
         nm7bPGksLsidfNW30AncRC+gdlrvi5L5kqdfBgjKwHxdn1t5ctQIycZYYr+kZnT+yrDY
         UrssgYP06Cbp8mdFjWyPPJqOaf6rOP0xtbUUiT4RsRDfp5sK7AMDjdgglDTQFmRAe+dz
         RYNFgVC7+7l3SUfnAeOp2YDljKcevUHWOCQs9Ps1xkY0FEZLx96/jofTdFiQ1RBEx7WB
         kzcNxKiwr7R4nLQQbEE7py+Jlq3i7KbwmQxsL5DRsjtFfEoZefUVAQbZVpsD7K0nejna
         +LfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfTi9+IkAYhoghuT+mlxbNMVe0OrR9CoDT/s8xC3lEWN3l+d4mGLE+g6apzagoG3oaIV25XLl3ki0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Um0ZN5gyAVwqQWRrYZnfUZCLWpzLNYuC1TcqME14+AduJB8T
	lv3t64GQ326xM4r0SsePU7TM0hoivts4L3ZkfM7JZKIzgdZT3FC6FPgsufM8bdo=
X-Google-Smtp-Source: AGHT+IESEFIczjMTnRS7nuNJYsAKWZtPSOEJF8D08vVUNv2Ii/9kat5KgkzI53i7+OFX/13ck3qaCw==
X-Received: by 2002:a05:6a00:320b:b0:71e:41b3:a56b with SMTP id d2e1a72fcca58-71e41b3a6eemr19937994b3a.24.1729126404786;
        Wed, 16 Oct 2024 17:53:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774c315fsm3785824b3a.141.2024.10.16.17.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 17:53:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t1ElV-001nw3-2D;
	Thu, 17 Oct 2024 11:53:21 +1100
Date: Thu, 17 Oct 2024 11:53:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+611be8174be36ca5dbc9@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync (2)
Message-ID: <ZxBgAU7aasIzcBfj@dread.disaster.area>
References: <67104ab3.050a0220.d9b66.0175.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67104ab3.050a0220.d9b66.0175.GAE@google.com>

On Wed, Oct 16, 2024 at 04:22:27PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    09f6b0c8904b Merge tag 'linux_kselftest-fixes-6.12-rc3' of..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14af3fd0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd9e7e4a8a0a15b
> dashboard link: https://syzkaller.appspot.com/bug?extid=611be8174be36ca5dbc9
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c7705f980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d2fb27980000

I explained this last time syzbot triggered this: this is a syzbot
configuration problem, not a filesystem bug.

[   96.418071][ T5112] XFS (loop0): Mounting V5 Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
[   96.593743][ T5112] XFS (loop0): Ending clean mount
[   96.791357][ T5112] loop0: detected capacity change from 32768 to 0
[   96.814808][ T5127] xfsaild/loop0: attempt to access beyond end of device
[   96.814808][ T5127] loop0: rw=4097, sector=2, nr_sectors = 1 limit=0
[   96.851235][ T5127] xfsaild/loop0: attempt to access beyond end of device
[   96.851235][ T5127] loop0: rw=4097, sector=24, nr_sectors = 8 limit=0
[   96.860284][    T9] XFS (loop0): metadata I/O error in "xfs_buf_ioerror_alert_ratelimited+0x7b/0x1e0" at daddr 0x2 len 1 error 5
[   96.886045][    T9] kworker/0:1: attempt to access beyond end of device
[   96.886045][    T9] loop0: rw=4097, sector=2, nr_sectors = 1 limit=0
[   96.900489][ T5127] xfsaild/loop0: attempt to access beyond end of device
[   96.900489][ T5127] loop0: rw=4097, sector=32, nr_sectors = 8 limit=0
[   96.932892][    T9] kworker/0:1: attempt to access beyond end of device
[   96.932892][    T9] loop0: rw=4097, sector=24, nr_sectors = 8 limit=0
[   96.940364][ T5127] xfsaild/loop0: attempt to access beyond end of device
[   96.940364][ T5127] loop0: rw=4097, sector=8832, nr_sectors = 64 limit=0
.....

And so it goes until something tries to freeze the filesystem and
gets stuck waiting for writeback of metadata that is not making
progress because XFS defaults to -retry metadata write errors
forever- until the filesystem is shut down.

If the user expects an XFS filesystem to fail fast when they
accidentally shrink the block device under a mounted filesytem, then
they need to configure XFS to fail metadata IO fast. Otherwise
metadata will remain dirty and be retried until the filesystem is
shut down or the error behaviour is reconfigured.

Please fix your syzbot configurations and/or tests that screw with
the block device under filesystems to configure XFS filesystems to
fail fast so that these tests no longer generate unwanted noise.

#syz invalid

-Dave.
-- 
Dave Chinner
david@fromorbit.com
