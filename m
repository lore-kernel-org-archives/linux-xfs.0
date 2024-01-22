Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676A5482ED
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 22:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705961357; cv=none; b=o0KxYimyxwpZScXZe1M3Icgy+78wiC0ZIpsJz7KqmPir7v7wpLQHZ+QbRllW+TvN/pfyg7npBROUKHloU59QjdZZFfU12XzMWL7BnBtQJjVMfU4tKd7Zl7rKwjiYpZL6ZNCiRAIEx7oZXbhOTuU78kLQft2zDSLWppywGkCjS6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705961357; c=relaxed/simple;
	bh=jC+sjI6NX7RLadtr/Cl7oKFb2Ife7x5+8U/64bCmGkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DN8IqiWNKGp5I0IkK7YY9k0Ez+x+LtRR4uid+AWxM44MnymTFbSxGm8WCevx5p+KLGcZwaHG4RKCLCogYWgD2e3F6+6VjFvoFb2Jj8cEG/PGMAmBlX2F2iTyLAzpaW7VraT9qKf06BBIp7epT24LS4XFML4rHeHuOC/9idhPPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aBIiCtOc; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aBIiCtOc"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d76671e5a4so5239505ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 14:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705961355; x=1706566155; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k0vFbwEyh3GR18Rvrc/KZl0hv5JkTW80198C76dD82M=;
        b=aBIiCtOcF2FrZ5LDjFIXP1zseh/L9vQv4C9AAlOo3ZZ+s9UsGpYA4TOpiajWKvserF
         GsqMjr4YymXdkEuA3DZQr5iyAH5V1cETAsqO1Le6kD+rVH6I09BXWJqLdnXiRy8Oc1Xh
         Dx96aq3SXKcUF5zvdd80LGekoQm0RXNzOIvnwHSRl/uPhIC1Dfj5bAwByScZ+9cdPf0J
         m8oHODVV3eHAB3fcuuorx3QHiomfg5UT+cNwm9AQesMTx9qu3VHuK/HhS4wp8qOw2NbP
         qS0ZPZn7b3wWdw1/qF6XTd+PLYr0e+akk4robyLxGkY8JMTyJ6/7QptkGQ9WVDYQFRy8
         Ozyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705961355; x=1706566155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0vFbwEyh3GR18Rvrc/KZl0hv5JkTW80198C76dD82M=;
        b=MhITUMNdSkF3T5o6Vo6wjr8NY5TJjuOD4ymK5YeFyqVOpLxvCj68fYaV3tuAE5KyJY
         L+ETlKSdqyMUPAUAvN0qDNFgSh8HHVlYsPSuhq4qGXHBJn2dqzd66pqfTQOV9xCFtDWx
         YPtaz/oQ7iUbHCQo/aPQt80uNuUkpD/w/TbLRt9BIJprd7FznFggs15jj2QVVrzoDTZ5
         UBy995cGumlu/YHMS65iQCEk7p1+uOZsxfOsptgBuOMwEBrZBeQs1S3oJzY8tHB3MeIo
         qe6qGv5T+dJWBgy2xtHetznXNW11zVbYXd/gKHFFmpYT8x17ofDZWb76Hp/foyukZTGT
         RT6A==
X-Gm-Message-State: AOJu0Yx+bie4BYP6Yvg2t5Oe1k2wKHO1X+yP92soC6cEPMy9TAVg8xEx
	Zn+3wdDdgThQdxOHc4nnXtK9H001w0zYnGhollyb8u5937foMWcwx1pbB78mLGI=
X-Google-Smtp-Source: AGHT+IFgpPdMPXlqRZW533MDddacDsDHsODnQiYxIBGd+jMPzOIX5TViGSOo20P64sDScR1XgLyYqQ==
X-Received: by 2002:a17:902:eb45:b0:1d3:2a94:cb54 with SMTP id i5-20020a170902eb4500b001d32a94cb54mr5265604pli.53.1705961354736;
        Mon, 22 Jan 2024 14:09:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f7d100b001d71ae81cbbsm6154563plw.190.2024.01.22.14.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 14:09:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rS2Tf-00DwxE-34;
	Tue, 23 Jan 2024 09:09:11 +1100
Date: Tue, 23 Jan 2024 09:09:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <Za7nhz08dMrJ/I8X@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
 <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Za5PoyT0WZdqgphT@dread.disaster.area>
 <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Jan 22, 2024 at 09:18:56PM +0800, Zorro Lang wrote:
> On Mon, Jan 22, 2024 at 10:21:07PM +1100, Dave Chinner wrote:
> > On Mon, Jan 22, 2024 at 03:23:12PM +0800, Zorro Lang wrote:
> > > On Sun, Jan 21, 2024 at 10:58:49AM +1100, Dave Chinner wrote:
> > > > On Sat, Jan 20, 2024 at 07:26:00PM +0800, Zorro Lang wrote:
> > > > > On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> > > > > > Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> > > > > > fixed it? Nothing in the for-next branch really looks relevant to
> > > > > > the problem to me....
> > > > > 
> > > > > Hi Dave,
> > > > > 
> > > > > Finally, I got a chance to reproduce this issue on latest upstream mainline
> > > > > linux (HEAD=9d64bf433c53) (and linux-xfs) again.
> > > > > 
> > > > > Looks like some userspace updates hide the issue, but I haven't found out what
> > > > > change does that, due to it's a big change about a whole system version. I
> > > > > reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
> > > > > (I'll try to find out what changes cause that later if it's necessary)
> > > > > 
> > > > > Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
> > > > > you suggested. And got the xfs metadump file after it crashed [1] and rebooted.
> > > > > 
> > > > > Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
> > > > > but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:
> > > > > 
> > > > > https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing
> > > > 
> > > > Ok, I forgot the log on s390 is in big endian format. I don't have a
> > > > bigendian machine here, so I can't replay the log to trace it or
> > > > find out what disk address the buffer belongs. I can't even use
> > > > xfs_logprint to dump the log.
> > > > 
> > > > Can you take that metadump, restore it on the s390 machine, and
> > > > trace a mount attempt? i.e in one shell run 'trace-cmd record -e
> > > > xfs\*' and then in another shell run 'mount testfs.img /mnt/test'
> > > 
> > > The 'mount testfs.img /mnt/test' will crash the kernel and reboot
> > > the system directly ...
> > 
> > Turn off panic-on-oops. Some thing like 'echo 0 >
> > /proc/sys/kernel/panic_on_oops' will do that, I think.
> 
> Thanks, it helps. I did below steps:

Thanks!

> 
> # trace-cmd record -e xfs\*

One modification to this:

# trace-cmd record -e xfs\* -e printk

So it captures the console output, too.


> Hit Ctrl^C to stop recording
> ^CCPU0 data recorded at offset=0x5b7000
>     90112 bytes in size
> CPU1 data recorded at offset=0x5cd000
>     57344 bytes in size
> CPU2 data recorded at offset=0x5db000
>     9945088 bytes in size
> CPU3 data recorded at offset=0xf57000
>     786432 bytes in size
> # mount testfs.img /mnt/tmp
> Segmentation fault
> # (Ctrl^C the trace-cmd record process)
....
> 
> # trace-cmd report > testfs.trace.txt
> # bzip2 testfs.trace.txt
> 
> Please download it from:
> https://drive.google.com/file/d/1FgpPidbMZHSjZinyc_WbVGfvwp2btA86/view?usp=sharing

Excellent, but I also need the metadump to go with the trace. My
fault, I should have made that clear.

My initial scan of the trace indicates that there is something
whacky about the buffer that failed:

mount-6449  [002] 180724.335208: xfs_log_recover_buf_reg_buf: dev 7:0 daddr 0x331fb0, bbcount 0x58, flags 0x5000, size 2, map_size 11

It's got a size of 0x58 BBs, or 44kB. That's not a complete
directory buffer, the directory buffer should be 0x80 BBs (64kB) in
size.

I see that buf log format item in the journal over and over again at
that same size and that is how the buffer is initialised and read
from disk during recovery.  So it look slike the buf log item
written to the journal for this directory block is bad in a way I've
never seen before.

At this point I suspect that something has gone wrong at runtime,
maybe to do with logging a compound buffer, but my initial thought
is that this isn't a recovery bug at all. However, I'll need a
matching trace and metadump to confirm that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
