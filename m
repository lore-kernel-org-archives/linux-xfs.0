Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2554A1C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 00:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723421064; cv=none; b=FM4AGGYFUFF/a7xNFlNEdrMptt7mGlS5YKRUugeW1we3f27KaHBUA1DPryW8Xu+WX2FWNK/UaXLXD/i9XnBwAd8DNJy+xqdqJSNsBlSc1vhGr9Ti+kNuEebpiT3Ri1kaTUHpuqKHe7lYMPyvycU4zw29jeXhpz8g+f/q6hedP/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723421064; c=relaxed/simple;
	bh=xkh6wJHVf6uVke9ptkJtT2GAdv+0ZBuNUx7jFO6MAGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CL3xU9dHb4BxMQL9u4P93unAvOVYsXXBBpIR02kOaHAr+Fjp4K5XAgmTNhzqLwe7ezY2fIyZFjNUi+4zWhdkBP2lK2Q/lTVdKRo+e8uv+VQGf1ULrxxEYtTBbj3RWLZ3R6A0WeU3BSOSeiNPU5B9sVRVSJfNtBH2a5kcffCECQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mA6HQzR3; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mA6HQzR3"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-261e543ef35so2660712fac.3
        for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723421061; x=1724025861; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FwHHMTfR0m72/F0FKClBhUnG7fJbSLh/yvNQxx41+us=;
        b=mA6HQzR3S1Gx+jVpF/LL9s6yVD49b0wSkM2jyqIwbqQg8s5KgPDPcm1sN7HNu5EF86
         jaQdya+iaPt0AgKUeN1wVBU+XwL6Uw9IK75KU1A5XF+8ejUu2AJd1Jfs1qbIulQNBzAL
         82qVQ90H6jDALcmcVWgMZdrMBXG3eUs1y/tLaGbnJZYHopv08C0dWX24hI6IwQSavV0e
         fK3llqerNO44OpLS3XdNgJ7stAqeLjorqkqR2vx3ll/5SLLCLCpK3JasY/UIAGC4BOP8
         IA/KKv/W1O8FOTZTbdqdCoSUL38s1YuyMhQJ23nX0WDz0pHcMt8WlY7pKmxgywLwolJd
         mlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723421061; x=1724025861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwHHMTfR0m72/F0FKClBhUnG7fJbSLh/yvNQxx41+us=;
        b=bx0ZKycY+zmEFxO8m9umcBNvN7wW76b37rMn9818sCbjKvcYD54uZp+66KYhLuIa/B
         QlvIMGC7f0eyxbyZiFkfAHUUS+1iRfK+cQy3nwG+gNXTtjuzbhXEjUVByXX0C4HuhgPc
         RGQJXcYurdWRw6sqzeFd+XW1yyz8ELXWLDlqC6i+uOcxGHVqrAeutCSnJ3FHzvW4xgs+
         hxw4MS/KVJouq233K/CCJtiXBjcCrJjuI+r5Rv+zqJhhuc2CwME2/uweXID0bVIPDeu5
         CjFL6KWd2NMPXTCNxPmMcmW04jRMk8CSL809ch6h5MaFmqdaPGHFNvmeHpupzqCm8ST0
         EnHA==
X-Gm-Message-State: AOJu0YxNLwFrShOKVJ+VW7XPPTNAJRmOCXVytrVRiEKmBxXhBN/ZFlAb
	iwhuPf8UfiR6HkbO384xi18ZrepkbZ0xqPC0Nyvz2IeK5Rgz/xj4BwRAt05U8Cc=
X-Google-Smtp-Source: AGHT+IGb7eCyKYvq+Vqr8OsUoaQJY2rmfDVWWR4wHJ7zWsOfWyPSQU6zpm+MuO6FZOFN+8ecM6Purw==
X-Received: by 2002:a05:6870:7246:b0:260:e36f:ef50 with SMTP id 586e51a60fabf-26c62c0df24mr10492409fac.2.1723421061598;
        Sun, 11 Aug 2024 17:04:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a89ab3sm2857371b3a.153.2024.08.11.17.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 17:04:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sdIXq-00DpB6-2p;
	Mon, 12 Aug 2024 10:04:18 +1000
Date: Mon, 12 Aug 2024 10:04:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anders Blomdell <anders.blomdell@gmail.com>
Cc: linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <ZrlRggozUT6dJRh+@dread.disaster.area>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>

On Sun, Aug 11, 2024 at 10:17:50AM +0200, Anders Blomdell wrote:
> On 2024-08-11 01:11, Dave Chinner wrote:
> > On Sat, Aug 10, 2024 at 10:29:38AM +0200, Anders Blomdell wrote:
> > > On 2024-08-10 00:55, Dave Chinner wrote:
> > > > On Fri, Aug 09, 2024 at 07:08:41PM +0200, Anders Blomdell wrote:
> > > echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
> > > mount /dev/vg1/test /test
> > > echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
> > > umount /test
> > > echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
> > > mount /dev/vg1/test /test
> > > echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
> > > 
> > > [55581.470484] 6.8.0-rc4-00129-g14dd46cf31f4 09:17:20
> > > [55581.492733] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [56048.292804] XFS (dm-7): Ending clean mount
> > > [56516.433008] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:55
> > 
> > So it took ~450s to determine that the mount was clean, then another
> > 450s to return to userspace?
> Yeah, that aligns with my userspace view that the mount takes 15 minutes.
> > 
> > > [56516.434695] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [56516.925145] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:56
> > > [56517.039873] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [56986.017144] XFS (dm-7): Ending clean mount
> > > [57454.876371] 6.8.0-rc4-00129-g14dd46cf31f4 09:48:34
> > 
> > Same again.
> > 
> > Can you post the 'xfs_info /mnt/pt' for that filesystem?
> # uname -r ; xfs_info /test
> 6.8.0-rc4-00128-g8541a7d9da2d
> meta-data=/dev/mapper/vg1-test isize=512    agcount=8, agsize=268435455 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
>          =                       reflink=1    bigtime=0 inobtcount=0 nrext64=0
> data     =                       bsize=4096   blocks=2147483640, imaxpct=20
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, nothing I'd consider strange there.

> > > And rebooting to the kernel before the offending commit:
> > > 
> > > [   60.177951] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:00
> > > [   61.009283] SGI XFS with ACLs, security attributes, realtime, scrub, quota, no debug enabled
> > > [   61.017422] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [   61.351100] XFS (dm-7): Ending clean mount
> > > [   61.366359] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
> > > [   61.367673] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [   61.444552] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
> > > [   61.459358] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
> > > [   61.513938] XFS (dm-7): Ending clean mount
> > > [   61.524056] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
> > 
> > Yeah, that's what I'd expect to see.

Ok, can you run the same series of commands but this time in another
shell run this command and leave it running for the entire
mount/unmount/mount/unmount sequence:

# trace-cmd record -e xfs\* -e printk

Then ctrl-c out of it, and run:

# trace-cmd report > xfs-mount-report.<kernel>.txt

on both kernels and send me the output (or a link that I can
download because it will probably be quite large even when
compressed) that is generated?

That will tell me what XFS is doing different at mount time on the
different kernels.

[snip stuff about git bisect]

I'll come back to the bisect if it's relevant once I know what XFS
is doing differently across the unmount/mount cycles on the two
different kernels.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
