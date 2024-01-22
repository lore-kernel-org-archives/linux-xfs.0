Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34DBDF54
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908203; cv=none; b=AqfDLHCRq87li9+E4vH3ey23CW6TDPmG6TtTrKtUWntFnWhJvHSJ2QV8djUvb14xho+UIG90oY+XlK/ab6dK1Y0W6775uvGey4xu1Lt/2Kpil6HFfIEncgjqIJLU8WIBQLlNhtUyQWDmxtAHbIT0F3hvujgdkDpg/u1fkWBu43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908203; c=relaxed/simple;
	bh=JbQthke1faRHr4TfIpnVdBvH/vybjVXmgcfqpppf9Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAE//rY7c1i74DK1EsUg23bjKnq+4OPTwS7T9tTBtPTtQy46sDEyODqF6TNiShnCZMYehAiJAN8OwlEmdopwOcEjZsasRByKuM4BHMqywIpZdIbAGevIDHievLmJ7MbDzRtaEZrClEuFyfYDrQ4JtCo+B9C/olgVLmE562qLYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ls0kgX3e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ls0kgX3e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705908200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZYJ03vaGgoY5OJnElF7KSbuxgKkYoSBa8QbVHBRj93I=;
	b=Ls0kgX3eWXya9ppCkcnikkc3sZXDTiTLjJvg60klNxsYotU5I5T6XvHSGBdlpi9H+SnjsJ
	OwpvlPLf9NDvwMOobORJL9vNn9YiU6S3oEIkLoMd3tA1NtQ2yiDO/5IP+4PtSg8ibZutVQ
	iaVIAuk+p4hpc0SIJh9x3ghBxK0YLdQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-kIGRlvCOM1WJNjdPN6Nm3A-1; Mon, 22 Jan 2024 02:23:18 -0500
X-MC-Unique: kIGRlvCOM1WJNjdPN6Nm3A-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5cd61dccd77so1257563a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2024 23:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705908197; x=1706512997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYJ03vaGgoY5OJnElF7KSbuxgKkYoSBa8QbVHBRj93I=;
        b=A4czbps9wAIpNWQosnEPSPjl+NMQysqh8wqEIG4NlpRgtyQpmwniQNdnqJ8GJ/Eiy4
         uZjnQaACxJoPKuIAivq5Eg8ozmeRZq0UnFvhvigCBtluFKQpsjUhGxm0Gy0YiYGa6hyg
         t2cpTbDvlWV2bgyDR4lYp+6s4A7Gk5byr3yB3mIW0+N2Tg+lx7kf7R/BQIQC43OBvBSN
         l1j20M7vYMaKiFpeGGKm7LhO2JyYfPWyoZwiXe4w4bHik2X5N7xrzIOQ5opAchd73xYQ
         vUNk5neleFKtYmaeVy5WtVYkRjJdeA0g5/VnCFEiluzRC/fh4xaDbhS1R52ADexMxL5S
         fbJQ==
X-Gm-Message-State: AOJu0Ywt9t3hkHsrovgy0b5Dc0+0JcHT9SJgvpNblvb2MQ9uXs46kfkm
	bV0dFGlv41vIwjW6MXsAW8OUFQgFWsda6ko61nVaaSlL3/hlGKnpDJeuLTxH5ZLJcnDiRWvEc0O
	y4gxazkEMEfFJTdN9XexjPV8/oJySqr0zn3vrmXWbgcm83wxdz83KsrSILBckCykAAK1F
X-Received: by 2002:a05:6a20:4326:b0:19c:4af8:f608 with SMTP id h38-20020a056a20432600b0019c4af8f608mr304209pzk.82.1705908196951;
        Sun, 21 Jan 2024 23:23:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxtqU3xwYGGDDuI2ojnRVLZvy2v8opBDZRNyQn8GFsxLBKnQggd86gtWCPEFhwJwnaFOsUWQ==
X-Received: by 2002:a05:6a20:4326:b0:19c:4af8:f608 with SMTP id h38-20020a056a20432600b0019c4af8f608mr304199pzk.82.1705908196475;
        Sun, 21 Jan 2024 23:23:16 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gx13-20020a056a001e0d00b006db6fc4c292sm8984251pfb.49.2024.01.21.23.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 23:23:16 -0800 (PST)
Date: Mon, 22 Jan 2024 15:23:12 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaxeOXSb0+jPYCe1@dread.disaster.area>

On Sun, Jan 21, 2024 at 10:58:49AM +1100, Dave Chinner wrote:
> On Sat, Jan 20, 2024 at 07:26:00PM +0800, Zorro Lang wrote:
> > On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> > > Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> > > fixed it? Nothing in the for-next branch really looks relevant to
> > > the problem to me....
> > 
> > Hi Dave,
> > 
> > Finally, I got a chance to reproduce this issue on latest upstream mainline
> > linux (HEAD=9d64bf433c53) (and linux-xfs) again.
> > 
> > Looks like some userspace updates hide the issue, but I haven't found out what
> > change does that, due to it's a big change about a whole system version. I
> > reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
> > (I'll try to find out what changes cause that later if it's necessary)
> > 
> > Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
> > you suggested. And got the xfs metadump file after it crashed [1] and rebooted.
> > 
> > Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
> > but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:
> > 
> > https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing
> 
> Ok, I forgot the log on s390 is in big endian format. I don't have a
> bigendian machine here, so I can't replay the log to trace it or
> find out what disk address the buffer belongs. I can't even use
> xfs_logprint to dump the log.
> 
> Can you take that metadump, restore it on the s390 machine, and
> trace a mount attempt? i.e in one shell run 'trace-cmd record -e
> xfs\*' and then in another shell run 'mount testfs.img /mnt/test'

The 'mount testfs.img /mnt/test' will crash the kernel and reboot
the system directly ...

> and then after the assert fail terminate the tracing and run
> 'trace-cmd report > testfs.trace.txt'?

... Can I still get the trace report after rebooting?

Thanks,
Zorro

> 
> The trace will tell me what buffer was being replayed when the
> failure occurred, and from there I can look at the raw dump of the
> log and the buffer on disk and go from there...
> 
> >  [ 1707.044730] XFS (loop3): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
> >  [ 1707.061925] XFS (loop3): Starting recovery (logdev: internal)
> >  [ 1707.079549] XFS (loop3): Bad dir block magic!
> 
> At minimum, this error message will need to be improved to tell us
> what buffer failed this check....
> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

