Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647E74C7E
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706043175; cv=none; b=ub/My1Ip7Oc6sd8bJqLbl7OpfCJtGsaTdhYRK9Z7AzFJJ4sKsS5TUEOQCi1pvG4Ibtw68LqjJHOUSIPtZ4gpmMs7WwC1B9eRJVAcw5D1aAJ40TI8dMOGR2ftK2FmBdr9MECFNQAjb6w7Oj/mS7LiqzTFvOPpMTK7QJi952/zUl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706043175; c=relaxed/simple;
	bh=O09BT57VdD4bz/kbe5fPfUpR+8h0iKee8ccSFrD66+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fskkyLkFN8zQ5WM0NZfxLobFTEo7Eo+gulLpGBKxcpQsDIx2I3K5JCI6oGf/axMRMAC7/NCH09muyhr1bbOO+qQt6JzFoHFx8geiWau2WBsVX05hcovsKJgZuVniGtadDSKRGtqqM8vqLVt9zcVolsdtfgcKxpGTpctEqXPqxKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HXDjR2EB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HXDjR2EB"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3608aa647bfso20918485ab.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 12:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706043172; x=1706647972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNMBOTMO3A4AGmXjXbwASyKTiJiSRA2OYoW9tG2AvRc=;
        b=HXDjR2EBvka94rAPkM+WznPlh4cCvya+wSASzww4BA5OYvTXZZ9r5/l9tm2tFzM2Qu
         LWNM/5yjW+nwjF/I5aqD8fI6mIX7R25HqKgqKVfrUo3DyxBGMP/Q0XPl3nWJCIIGB+yp
         gi+rVwMRI8jJziq++vKpXPmFV7GXmZ4cKZj2DkwZmpsqb5907hZ0oHL+sj4Gnm45yeoI
         N8LHccqBn/uiFguMLUteJKiz01a2b+psno1w5+IB7YMULMzwjcHxnQDP9+hFkAs9pa/s
         tpbKjctX9yg3ijlmx+MfQTlWlGkK44T71/MHom+zc9cWq5L0dV1lIzNWIPUIArgEEgUI
         DOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706043172; x=1706647972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNMBOTMO3A4AGmXjXbwASyKTiJiSRA2OYoW9tG2AvRc=;
        b=jMh1mItxD4Rv18qzwl5upxB2frMwKY8MU3g0t5G28DRoKUOGOcPPAZjM2hzc1Nxt3M
         7ipQY0Fl/wdnIj26TwDFHcYpxkH9Kjpy+XhlNjo8Et7Smt335ayKq0vLErVnyx7sCJGm
         uJJH+5LI3aiOEzqYx5KKILgg0UCARRZwcgb7muSCyivEAIiBheTFGAjzgRpQMCN6sy3J
         HJWCwWa53gZcBV+O/ZjyKxLOs582ltVPO6d5BRbGcBBOLFfoC7cFbjZKPSb2Zl9GJ4kc
         yqt1n+PzE1Rm/HoqUAQ9bZ7ZauGWNE2+MdlOJtUEWh+AOhG/zugkmkym9gEA78L0rEm2
         UF+A==
X-Gm-Message-State: AOJu0YwSSirEn4lFjjMpx2q0MK3RuyvczHheQRC/Wvu007ztoatg+Oqp
	zrsAV7000T/y5uzvzk2t8HOJ8u+zjz7mDedhKKsTWeziE6hXQqm6XyoyRoq5Bqc=
X-Google-Smtp-Source: AGHT+IGbbA0xWB/HjZdO6za3buG7S49yQJOoQ7uLRMfcbzNpNv6kHQCrqsU5Ede8jEMGz68JGhabyw==
X-Received: by 2002:a92:c851:0:b0:361:9667:39f0 with SMTP id b17-20020a92c851000000b00361966739f0mr501544ilq.35.1706043172279;
        Tue, 23 Jan 2024 12:52:52 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id j38-20020a635526000000b005cf7c4bb938sm10504703pgb.94.2024.01.23.12.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 12:52:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rSNlI-00EMob-2R;
	Wed, 24 Jan 2024 07:52:48 +1100
Date: Wed, 24 Jan 2024 07:52:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <ZbAnIIUFXJC74CcQ@dread.disaster.area>
References: <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
 <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Za5PoyT0WZdqgphT@dread.disaster.area>
 <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Za7xAQUZa1PtnAHn@dread.disaster.area>
 <20240123070203.6ybj224cwt2v6zf3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123070203.6ybj224cwt2v6zf3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Jan 23, 2024 at 03:02:03PM +0800, Zorro Lang wrote:
> On Tue, Jan 23, 2024 at 09:49:37AM +1100, Dave Chinner wrote:
> > On Mon, Jan 22, 2024 at 09:18:56PM +0800, Zorro Lang wrote:
> > Zorro, in the mean time, can you write up an xfstest that creates a
> > small XFS filesystem with "-n size=64k" and a large log, sets it up
> > with single block fragmentation (falloc, punch alternate), then
> > creates a bunch of files (a few thousand) to create a set of
> > fragmented directory blocks, then runs 'shutdown -f' to force the
> > log and prevent metadata writeback, then unmounts and mounts the
> > filesystem. The mount of the filesystem should then trigger this
> > directory fragment recovery issue on any platform, not just s390.
> 
> Sure Dave, do you mean something likes this:

Almost. Free space needs to be fragmented before creating the
directory structure so that the directory blocks are fragmented.

> # mkfs.xfs -f -d size=1g -n size=64k -l size=200M /dev/loop0
> # mount /dev/loop0 /mnt/test

# fallocate 1g /mnt/test/file
# punch_alternate /mnt/test/file

> # for ((i=0; i<10000; i++));do echo > /mnt/tmp/dir/loooooooooooooooooooooooogfile$i;done && xfs_io -xc 'shutdown -f' /mnt/test
> # umount /mnt/test
> # mount /mnt/test

Otherwise this should trigger recover of the directory blocks and
hopefully trip over it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
