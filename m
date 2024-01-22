Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C543BB51
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 11:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705922473; cv=none; b=B5uwm/CpEbz3B1OSNQVKeGOrHHQWNR+lbxCRAbB9CztBecf9M4oo2uUdCrhLCMLrxoRBzsIIvsk8WTxLlPICNRv3KPgd9h0+QnJIKJBxfUg4Io9dgER+dal1gZ0OeesWVblrI+UukFRhnXMMcUM9rwD5sD9vMeO1DuzolVWojKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705922473; c=relaxed/simple;
	bh=SyzTg9VJs+XiKuTZui8QFn45g732+4X0RI9/qMtM9NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOZQqe4iTcblSUhiVIukdvSA5ZKLvx5wtgTCDMVavS8JBW6YrkKeA1XYfLUNmMQEYoIWmIxStf1aw/H/DVHI7mmm2eIEMjLfxrey0C8FRaffLA9eK8C7sjgw00m3UqAZAyuLqRyD6yjG84yMpuX9ZOabg4ZeAMqmUegnyFIA6no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QPWQAF9E; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QPWQAF9E"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6dbd65d3db6so578206b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 03:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705922471; x=1706527271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ydBUbEMreIqbIMihUS/Kgz/H9vCi4TtibpqalZLZnuA=;
        b=QPWQAF9EJPBM3LaVh0W7BGZMmBQKgWsB/fAX9Pduel/oH0wda7IWEMh6juOVfV/k/p
         NPeKgZSWzRk7CvK3p1poXVTrJa4gTNCUqbTc6uFl2NOy5NTLTWUFQDwzaqtHeNSTx6VT
         B+TS8m22koyC7wg+mcFEHXAdNXqrxAi/vWas0tzJIaC0Lpv/Olg9uVsD5RW/q3V7ElBP
         8RWyKUz5Qjepae7ELyV9fewpSZXCtjEFoAh7SrcqXc3Vc3lLMuRp9EPDsgyipao2y1hH
         De1LUTpjRklVqTYitga++DLq+7usukLgMQqRtLiOHjcJgIh3QgPIlT3kaLGe4wJxx2jl
         Araw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705922471; x=1706527271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydBUbEMreIqbIMihUS/Kgz/H9vCi4TtibpqalZLZnuA=;
        b=JzCQfLfh3wjOElwm9ID5Pnq3CCVB2EnRvZ3ljI5DOSZVNRNKvUJWdi535Y7lPz6mMz
         cTfOOudaakLUcfT1KMEuHxl6Nk55ClhL/8vcLbFCCe/6rKbHxTkKZNAZc7+y6GbkraOF
         JVD1Y0BueWeiFcN+TNTjNHdCkfSkdvg+s7lyBu26Zu9sI8mTw0YZQiXEhywLeyKA/9Or
         00E5NXV9cG7wunjPeTh0fY51gwPyqtKJPvg+NSEXpIs3Oxo5G1jNP1WU8PnSrOWzLRDE
         SWaxT1WStgKtt53w+sJyHLDTfcRoacv1Srz9NlAbCKGYM4QSdaEL1Ya4eOsEjp7LZciY
         dIkA==
X-Gm-Message-State: AOJu0YzX3cJZ9p6v6DvJ38uNASEqAYR9a8umgjepw+d+s0EmLFxjJXDJ
	LSYU2hC7HXLgbWVBazu3oAf6bW8fgmc2AwvQOFZm+W4JJjz1Byy/EZIxH4yxIho=
X-Google-Smtp-Source: AGHT+IGvacqwVOJtQKNnfdm8+2pkpHhhiKGz2N8iW9S4Sqyhgpem1AM3j9e3tO0i9SnpGJ5FC+97vQ==
X-Received: by 2002:a05:6a21:9184:b0:19a:328a:3a with SMTP id tp4-20020a056a21918400b0019a328a003amr1655885pzb.60.1705922470799;
        Mon, 22 Jan 2024 03:21:10 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id z6-20020aa78886000000b006da24688178sm9383985pfe.39.2024.01.22.03.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 03:21:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRsMV-00DkNH-2o;
	Mon, 22 Jan 2024 22:21:07 +1100
Date: Mon, 22 Jan 2024 22:21:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <Za5PoyT0WZdqgphT@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
 <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Jan 22, 2024 at 03:23:12PM +0800, Zorro Lang wrote:
> On Sun, Jan 21, 2024 at 10:58:49AM +1100, Dave Chinner wrote:
> > On Sat, Jan 20, 2024 at 07:26:00PM +0800, Zorro Lang wrote:
> > > On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> > > > Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> > > > fixed it? Nothing in the for-next branch really looks relevant to
> > > > the problem to me....
> > > 
> > > Hi Dave,
> > > 
> > > Finally, I got a chance to reproduce this issue on latest upstream mainline
> > > linux (HEAD=9d64bf433c53) (and linux-xfs) again.
> > > 
> > > Looks like some userspace updates hide the issue, but I haven't found out what
> > > change does that, due to it's a big change about a whole system version. I
> > > reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
> > > (I'll try to find out what changes cause that later if it's necessary)
> > > 
> > > Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
> > > you suggested. And got the xfs metadump file after it crashed [1] and rebooted.
> > > 
> > > Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
> > > but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:
> > > 
> > > https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing
> > 
> > Ok, I forgot the log on s390 is in big endian format. I don't have a
> > bigendian machine here, so I can't replay the log to trace it or
> > find out what disk address the buffer belongs. I can't even use
> > xfs_logprint to dump the log.
> > 
> > Can you take that metadump, restore it on the s390 machine, and
> > trace a mount attempt? i.e in one shell run 'trace-cmd record -e
> > xfs\*' and then in another shell run 'mount testfs.img /mnt/test'
> 
> The 'mount testfs.img /mnt/test' will crash the kernel and reboot
> the system directly ...

Turn off panic-on-oops. Some thing like 'echo 0 >
/proc/sys/kernel/panic_on_oops' will do that, I think.


> > and then after the assert fail terminate the tracing and run
> > 'trace-cmd report > testfs.trace.txt'?
> 
> ... Can I still get the trace report after rebooting?

Not that I know of. But, then again, I don't reboot test machines
when an oops or assert fail occurs - I like to have a warm corpse
left behind that I can poke around in with various blunt instruments
to see what went wrong....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
