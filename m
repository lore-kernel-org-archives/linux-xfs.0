Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B898D1C8FCE
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 21:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737583114; cv=none; b=u0Kn7GSbmKv4STxGMvPXi/4PVcMzl2YCbWyP2mTLfj3rY62N240nAl5tYzqOM4c04O7Hn14Y0VrWSjGpVxbTJX4IUKz1avzKGC/BDsyTXyBZt5TJrmgT+rIFmWkM1KM1fwvNhDA09dIyqnQfir4jakY3Ia+KD4SnH5swsU1pOps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737583114; c=relaxed/simple;
	bh=3SYl4+g1NDV+Zn9PgqRX7HmhqCL6eecegckdXkGBGQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AE5xgqHTgT0BUrNqsAy1+kZN9mIYNBqlH0vNRC56SrCtbqWIriZvBc0j1F7hAT7/wYFDRdY8lBRol5nf7P4PxM3W/aRJh5vGW6uLSG+TvmtR3JSRUW/gE4X3AVCMQSsTi6rIs65glttDVijeu+6ZmXpCA1LtZR/Ur84WpePbp7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gOUa9sVf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gOUa9sVf"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21619108a6bso2647145ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 13:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737583111; x=1738187911; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXvn1GAZum62eGt9FVKhSYNWM9rpkSfE7ZuGmpHTELc=;
        b=gOUa9sVf5VRMOjtstH4vTAcj5r0I91w7O1Ywz/O8Hu/hiWAy4xsv0Nr8rMIAZsd1+R
         uCd9Xx/ywuT5Bh5Gp3l8qTEXsv4iGCtN+HSoYU8mWfk+zwu4E/3hyijmnSi2YvA0fAs2
         UvM/9xBgE+1idJ48qwqrnOKL0GkruArS3w6GyQfTBNUJouU2qhsodKX9CBpgEPkScgEl
         Rv5Y0A4yRHJcV99fu4jG8XtO6SlHrQs3/zVpiCoo1abZyyjNKIGyuZulV5/T+PFxQ5mg
         PUpPHeh0yGQdXQLxplgmIZ+cGy4JTIXqzComc2/aAuMKOl1woOxt2S1patGtZaEQllTl
         jmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737583111; x=1738187911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXvn1GAZum62eGt9FVKhSYNWM9rpkSfE7ZuGmpHTELc=;
        b=QR9n/Cr1CEXbnWYSa/elf2/17D1VfymxEA075VZgZIrgqn0AqTii+luXsoleg/zMbd
         banIjJhdVpLMMc5CP29uiIwwFm5HCaFo4mCOeWXL9BQWx3BIGr3UijAaoXzEYCev/aHS
         /B67Gh06ho5IgWmr7zR+9dce5o5dhOXJ8XjaMl9qt302UFWUMy9G0Ok5NpOyjU3LG7dt
         IejykHLgXjDjbkMV85uaAwhpR7t2lLbh1ymgI5ze5ET0X50jQceRKYXZBYJzJhxAxOnV
         YJt8BCHQkom3kf6h2Z3NQSCJqUyGd50IfZ1+SrC5m27UARigJ9HhvZ9NwUp2GzSs7CnD
         9A9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1JY2wRTfco6NEstPRt8gHula0U8vuXDNYFFSsXH5RuPNqKmegVQUvsu6kpkBrzvyQjiqPmygR0WQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBiEFGbtgyLYavasho7CIKFqa5x2KonVEcB7ISVutMgDoZWBmQ
	TBlCZjZGwORIViuFP42PZPdB3QcQ0uDLkcO/hI1/KUHbSNvmUwBIxlhaWM5H+agseI/1+zd++tl
	w
X-Gm-Gg: ASbGnctlvKBdEc47XAQzpzRmlghXCm/+ZsH8Y41tQHaqy0GVWTLb7ahXLwHuVKbQ/88
	z+1v+tsugyXeTYhefHpJJHMU2ZIEblstqcbst4PU4QpuebjgWP2EmDD7t0RcIku15sNkJbgxIrn
	qsj0Ne80Q8RrvQc89X/Dk+8dK7K2gnjCodbbqE1nhYTZC4A7q+P3ciKPvM7swGw8C9IzE/DLzxf
	lIRZI2mMBOnsyrtHuKi3tsmzOhJQ0deP/uDGiJf/Bp5FCvJWlkggTyFgbVvqVCMHLti1WTBJD/1
	Vaj9jZUrPZNJrjz5/9bzTlXLl/928MRWwSiiFHATuQVlag==
X-Google-Smtp-Source: AGHT+IHpNXzEDizxXUaP+qhVhDGM/6CzcfsTvz8bGC6/q51aZ4HDAeIaKSo3aEqGYpR6Eyp0UlrLWg==
X-Received: by 2002:a05:6a20:a10c:b0:1d9:6c9c:75ea with SMTP id adf61e73a8af0-1eb21470203mr34616403637.5.1737583109417;
        Wed, 22 Jan 2025 13:58:29 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72daba48cd0sm11735376b3a.131.2025.01.22.13.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 13:58:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1taijy-00000009FSe-1SgK;
	Thu, 23 Jan 2025 08:58:26 +1100
Date: Thu, 23 Jan 2025 08:58:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: xfs_repair after data corruption (not caused by xfs, but by
 failing nvme drive)
Message-ID: <Z5FqAgxiLbqI6gmz@dread.disaster.area>
References: <20250120-hackbeil-matetee-905d32a04215@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120-hackbeil-matetee-905d32a04215@brauner>

On Mon, Jan 20, 2025 at 04:15:00PM +0100, Christian Brauner wrote:
> Hey,
> 
> so last week I got a nice surprise when my (relatively new) nvme drive
> decided to tell me to gf myself. I managed to recover by now and get
> pull requests out and am back in a working state.
> 
> I had to reboot and it turned out that my LUKS encrypted xfs filesystem
> got corrupted. I booted a live image and did a ddrescue to an external
> drive in the hopes of recovering the things that hadn't been backed up
> and also I didn't want to have to go and setup my laptop again.
> 
> The xfs filesystem was mountable with:
> 
> mount -t xfs -o norecovery,ro /dev/mapper/dm4 /mnt
> 
> and I was able to copy out everything without a problem.
> 
> However, I was curious whether xfs_repair would get me anything and so I
> tried it (with and without the -L option and with and without the -o
> force_geometry option).
> 
> What was surprising to me is that xfs_repair failed at the first step
> finding a usable superblock:
> 
> > sudo xfs_repair /dev/mapper/dm-sdd4
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks with matching geometry !!!
> 
> attempting to find secondary superblock...
> ..found candidate secondary superblock...
> unable to verify superblock, continuing...
> ....found candidate secondary superblock...
> unable to verify superblock, continuing...

Yeah, so it's a 4 AG filesystem so it has 1 primary superblock and 2
secondary superblocks. Two of the 3 secondary superblocks are trash,
and repair needs 2 of the secondary superblocks to match the primary
for it to validate the primary as a good superblock.

xfs_repair considers this situation as "too far gone to reliably
repair" and so aborts.

I did notice a pattern to the corruption, though. while sb 1 is
trashed, the adjacent sector (agf 1) is perfectly fine. So is agi 1.
But then agfl 1 is trash. But then the first filesystem block after
these (a free space btree block) is intact. In the case of sb 3,
it's just a single sector that is gone.

To find if there were any other metadata corruptions, I copied the
primary superblock over the corrupted one in AG 1:

xfs_db> sb 1
Superblock has bad magic number 0xa604f4c6. Not an XFS filesystem?
xfs_db> daddr
datadev daddr is 246871552
xfs_db> q
$ dd if=t.img of=t.img oseek=246871552 bs=512 count=1 conv=notrunc
...

and then ran repair on it again. This time repair ran (after zeroing
the log) and there were no corruptions other than what I'd expect
from zeroing the log (e.g. unlinked inode lists were populated,
some free space mismatches, etc).

Hence there doesn't appear to be any other metadata corruptions
outside of the 3 bad sectors already identified. Two of those
sectors were considered critical by repair, hence it's failure.

What I suspect happened is that the drive lost the first page that
data was ever written to - mkfs lays down the AG headers first, so
there is every chance that the FTL has put them in the same physical
page. the primary superblock, all the AGI, AGF and AGFL headers get
rewritten all the time, so the current versions of them will be
immediately moved to some other page. hence if the original page is
lost, the contents of those sectors will still be valid. However,
the superblocks never get rewritten, so only they get lost.

Journal recovery failed on the AGFL sector in AG 1 that was also
corrupted - that had been rewritten many times, so it's possible
that the drive lost multiple flash pages. It is also possible that
garbage collection had recently relocated the secondary superblocks
and that AGFL into the same page and that was lost. This is only
speculation, though.

That said, Christian, I wouldn't trust any of the recovered data to
be perfectly intact - there's every chance random files have random
data corruption in them. Even though the filesystem was recovered,
it is worth checking the validity of the data as much as you can...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
