Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F401F1114
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 02:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721873131; cv=none; b=SPkBuhUn7iebTZZ3llwRJh6U/s/Xf1BVfGmzRZenzfmQlJLaOi7c+/CUgoR/hVJE6HchoLBvWK++3J+ePZcIchdVs9OCV43nSSM51HNqwQ/qAXZ8uRUQ+Zv3TWA0DE5MNs9SUhU5wGYxqzMRTo7lBIqxnl52yn+8MToeB1HbFC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721873131; c=relaxed/simple;
	bh=LmSifnkCjuZ5FeVnvQE8M2HT1zy4fRbN5Qt7u9LFFOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScO+BA6ZvROpYuNp3yfex9IbGBWbacLkQyRTam2C051ncwY/tk3kEU/aan8WQuBq0wuUIoVyMDVKpdauBsRAtW5TLtwFaQ71c2U6au8lKU+mqYxoEBBPMUjYs9clo1kbkFnBrUpHmHyF5JQpQkbVK5HThk4t2UBDh1ceyxxsoFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Jw1y/T9P; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Jw1y/T9P"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fd69e44596so3341125ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 19:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721873129; x=1722477929; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JcnbCJTcYrguhpGhITB3qLd+XcBmCzKxwCjDbU5MJGo=;
        b=Jw1y/T9P8N54XIpqFYXjCHZ1oY6PEILoTNYhGkxmz0+6iiYPoHPHdkMd+H9vALhDUr
         IcXdkYhFTNVOLfazRYWBWsRET/XXgUZ94GncgJkqHGicNnZ2q0AtmhN2m7+iVgMjfOj3
         1hFC1gmqBVBPLVtGsYYbWB7AUgipeQaQFzpVc+FWZp6Ehz2ZzwQP0YV5CT1FO3W9jDZd
         uQPh9qskJnBG5ctH6o86x0NXRE8Ut+igG/3pKZQ2cUTV6jL4iwshmfuu7vGTt0z3QOcl
         5JYg5T4UwfSAUgXhsiKrr0gYVRsKxOs1CXXbyEcp0iXP7NMLaNOmswXpq/qZcjlT4XE6
         PmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721873129; x=1722477929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcnbCJTcYrguhpGhITB3qLd+XcBmCzKxwCjDbU5MJGo=;
        b=LyJGnu7BTcbDqOx33PdRVciRbwTbFDyeyTuSDN8QZ1heXxSbbD/Te0Gp2hhWQlEohS
         +Xg9FbfCOkRTsR+4lgPDAy/WI/xsm1qcXb++obvfW9y1cOawFGzK6MqKsz4AYfFfmLDB
         Ge0wvkLYSTqv5iHDhdwU2Do5H1ayGQV4LUMCNA9l+wNTCbxeidZjNpalmpDwFG9Tmz2y
         yEXa8Zn4oPDTOV7qNDW5cyuv+aSP5KxLuVgpJEjhQROCHSClC94xoC39Q1ViYa1s2InG
         zyn6ZM2Wckw01do0JS64CGn6uB0ixwHxsZ6CdHiVnFLAZ1uVgqiwX+UijJBvEnxh03Ve
         /yeg==
X-Gm-Message-State: AOJu0YwU8bBWnakPrZV9Tn45BArZZJ/up5XEocDjcH6Wrnmu63khWkIy
	XZO9AUouTQdzEMN/25aeZy/aMaa6gYYwxMlPBmJUgdSxRhW9+f2Kuel5tPMW/QpnFzoDqlcootB
	0
X-Google-Smtp-Source: AGHT+IHxLhO0MjwiwLG2LdIfobsmobeaNNMpGrW4sQsAwdoYNN1+6VMnfMEQhwLnNU/E5pMAfB7xKA==
X-Received: by 2002:a17:902:d490:b0:1fd:8f4d:2392 with SMTP id d9443c01a7336-1fdd6d73dccmr49367715ad.1.1721873129145;
        Wed, 24 Jul 2024 19:05:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7c8d1f6sm2571505ad.8.2024.07.24.19.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 19:05:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWnrC-00AL1e-1T;
	Thu, 25 Jul 2024 12:05:26 +1000
Date: Thu, 25 Jul 2024 12:05:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <ZqGy5qcZAbHtY61r@dread.disaster.area>
References: <20240724213852.GA612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724213852.GA612460@frogsfrogsfrogs>

On Wed, Jul 24, 2024 at 02:38:52PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Over in this thread:
> https://lore.kernel.org/linux-xfs/20240724131825.GA12250@lst.de/
> 
> I originally proposed turning on background xfs_scrub by default in
> Debian.  Christoph wondered if it was such a good idea to unleash this
> upon hoards of debian sid users, considering that the introduction of
> e2scrub by default didn't go entirely smoothly.  Debian policy is to
> enable packaged services at installation time, which is reasonable for
> httpd but perhaps not so much for experimental services.
> 
> I proposed modifying xfsprogs so that for Debian builds, it would spit
> out a separate "xfsprogs-self-healing" package containing only the files
> needed to activate the background scrub services by default.  People
> would have to opt-in to installing it... insofar as one can configure
> apt to pull in Suggests: and Recommends: packages.
> 
> Christoph suggested adding a compat flag to the superblock so that
> sysadmins can mark filesystems for (or against) background online
> repair.  Therefore, I'm proposing adding such a flag.  Before I start
> any work on that, I thought I'd sketch out what I'd add to make that
> happen:
> 
> On Disk Format Changes
> ======================
> 
> Add a new COMPAT flag XFS_SB_FEAT_COMPAT_SELF_HEALING.  If set,
> the background xfs_scrub_all service can periodically scan the
> filesystem and initiate repairs.  If not set, then background repairs
> are not allowed.

Maybe I'm missing something important - this doesn't feel like
on-disk format stuff. Why would having online repair enabled make
the fileystem unmountable on older kernels?

Hmmm. Could this be implemented with an xattr on the root inode
that says "self healing allowed"?

That way installing the xfsprogs-self-healing package can turn
itself on at install/upgrade time when we decide that online reapir
is no longer experimental without on-disk format implications. In
the mean time we could add an xfs_admin command to set/clear the
xattr on the mounted filesystem for the admin to chose to enable it.

> Note that administrator-initated scans (e.g. invoking xfs_scrub from the
> CLI) would not be blocked by this flag.
> 
> Question: Should this compat flag control background scrubs as well?

Probably. scrub is less intrusive, but I can see people wanting to
avoid it because it can have a perf impact. Could this be done with
a different xattr on the root inode?

> Userspace ABI Changes
> =====================

Answers from here are purely about mkfs based compat bit, though I'd
think this is unnecesary if we use an xattr.

> The first thing is adding a new CLI option to mkfs.xfs to set the value
> of the flag:
> 
> # mkfs.xfs -m self_healing=1
> 
> Question: If rmap and parent pointers are turned on, should we turn on
> self healing by default?

No.

> Question: If self healing is turned on, should we turn on rmap and
> parent pointers as well?

Yes.

> For xfs_scrub_all, we'd need a way to query the status of the self
> healing bit; this could be snuck into the xfs geometry ioctl as a new
> feature bit XFS_FSOP_GEOM_FLAGS_SELF_HEALING.
> 
> # xfs_info /dev/sdf
> meta-data=/dev/sdf     isize=512    agcount=1, agsize=268435455 blks
>          =             sectsz=512   attr=2, projid32bit=1
>          =             crc=1        finobt=1, sparse=1, rmapbt=1
>          =             reflink=1    bigtime=1 inobtcount=1 nrext64=1
>          =             exchange=0   metadir=0 self_healing=1
> data     =             bsize=4096   blocks=5192704, imaxpct=25
>          =             sunit=0      swidth=0 blks
> naming   =version 2    bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log bsize=4096   blocks=16384, version=2
>          =             sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none         extsz=4096   blocks=0, rtextents=0
>          =             rgcount=0    rgsize=0 extents

OK.

> I think we also want to enable sysadmins to change this on the fly.
> For mounted filesystems, this could be done through an administrative
> ioctl or mount options.  Offline, this would become another xfs_admin
> command.
> 
> # xfs_spaceman -c 'self_healing on' /usr
> # xfs_spaceman -c 'self_healing off' /tmp/extraspace
> 
> # xfs_admin --self-healing=on /dev/sda1
> # xfs_admin --self-healing=off /dev/sda2

I'd prefer the primary admin to be done through an xfs_admin
command.

> # mount /dev/sda2 /mnt -o self_healing
> 
> Thoughts?  Flames?

This really seems like information that userspace can maintain on
the filesystem itself, not something that belongs in the on-disk
format for the filesystem. Implementing it as an xattr the
xfsprogs-self-healing package maintains means no
kernel, mkfs, spaceman, db or repair changes are needed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
