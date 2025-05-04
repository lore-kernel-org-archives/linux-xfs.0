Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE3A4438B
	for <linux-xfs@vger.kernel.org>; Sun,  4 May 2025 23:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746400850; cv=none; b=cRMKGEOXZVAOf+PxVJFVOirbLEL5GarkamSmp5yXAnRUiZmYXDeFIV9OsHdu2RKReZRSpST3u6mbOzs7ucsBT5QkNMaLi4TANd7EnCD9ntkEdzaT/TDPbsJbzazsLShog4Xb7Ua+ItiqhThkFNcMd+pqwetPP/AQGdgEjX1UilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746400850; c=relaxed/simple;
	bh=OoLLbuCi1nwJYIopl/I5q6sYONCn7G5rdO1K+psOwnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbI6Z5Li48ula3HjuGetCk4k92SmT0MmVR8ihABd/3tHLZ4H5W3UhWbP0P8M6ts2mIvIFauQ6e4+cNdmi14sAo6e6jgSHVouNNTKeysOe7YwqR9ivsQXRXnNcWDptQ5UhB62Mc23z/lt7Wja2qvHc0OWK4qG3zpI/6rIfYL+68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=g5efLGsK; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="g5efLGsK"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so765051b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 04 May 2025 16:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746400848; x=1747005648; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kfeBgs4UborAOcvG4HnMDQYljLnZG29GLGTw9gpzQk8=;
        b=g5efLGsKhY0cBexytwHPWiqW+7gmArX0qVNIIwRuwMlOGRdhQEDc32cQ2JliCB2X5c
         7q2P89w07WWRFiP5YMU6Jk7hrOWucSCNFApALUqV+D2dwryojgeRbzA56Q7R+q+elB4S
         yvSnCoQDnxPL515IT08AHMU/HCtd38SSgdv4moXYTe3HLl0FN+02/6Ib8g+DfTwpVq/8
         rqJauwSrwTBLxcAn5t/8sHv9l4ISNHmORSmAjL64KEEAcxeI1CCBM67dN2j2skuDI3jG
         OxT79feH4M82mLDs9D20qWDsjYY2f/sMz15Clfekwf0FsJmiEBvFt+LrKtwaDrJW9KRz
         NJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746400848; x=1747005648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfeBgs4UborAOcvG4HnMDQYljLnZG29GLGTw9gpzQk8=;
        b=WNSlo3XOnJBjosPToqD0q7JG91bK3NmZzZDDua4kaG6G7oui5+EnUJQrfvldEsiTFU
         rqoT0cxn+DCWyhLIcRFjiUr/NpQkLqxvuH3xc+m4VL6Mxr4DiBH1ealn5xx+oBwaQSKX
         Dgqew1WczBbOAwyHr0BU/Ehp0ogwfpgQ9S9Pl6/VE+PXXJUt1NT5bcohZZLjHgBqk0af
         hRCNOFzegWVXy2pDFgl1xcUuPBy3qeLqdI59oPza1RdQh//n8Hu6dSWM3g3+Wh1LOq8w
         h0iSX3xF4nG3UF4M+kxjdBqqo+YRZXg9oxZQjNmkHJQqpXZZTW/EADpQcXCyUoQLgZHm
         d0LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe85GIYRZ/lLsjMw6zAAZDsO9+GhGLZyTzW4hlIrqXx77+wp2eUR5vKGBJelMC2YGBnTyhZ7jScKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8/c7X6OfGj3RrQOKPDmGDPcpg5gJRa9u0BuZ9zOPaE30AUEma
	uV8+BX2yzJiHFL3bYvy72i6uQ57V9Cr3wUmW/jrkvD75Ufi278PowugMrQZEmWU=
X-Gm-Gg: ASbGncsjdi/iACwjDN/EAm129fSmamHJ2PKPwRtvzh/RpsP+nMRqMvUdhVweFeBvaoG
	hAvAdfk4s7v/f+h5tEZMPNLVwm7K79hgatk2KhhvPXcNhuHtJrAdeeK6f+Mr+x08ZWbMp5rhPgI
	x6hGAXvTTNk2EueYxFqzdd2W9lKRLi4rFzwnD29bpY0xkopDBKAlALbafTjA1mOCQixWZfDUliM
	+dF5GbU4Z/Hplyv+I7VoItUMLD7bt0nBjWZQN9k6c3JKTy537XOPyke+0IR1ZHdHHYO2eKSKK/s
	INUYrOW5zzB1ISMRtx6TgQTu+gXkV3YEBkK1hD5aVnxPQ9blNVLKSWmQqI3iYam8J+wOJ2ZQiVn
	u3ogvOZWD/Nhpgg==
X-Google-Smtp-Source: AGHT+IGCM1oKSvy7l0H2B/hDL6kgsXjWiZgAvEkfu7nnKuE8VkwYZd2FK8GVtUX6+MWy4Rlsv/R+Rg==
X-Received: by 2002:a05:6a21:3416:b0:1ee:450a:8259 with SMTP id adf61e73a8af0-20bd8d4b1cdmr21085599637.18.1746400848366;
        Sun, 04 May 2025 16:20:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590218bdsm5548747b3a.99.2025.05.04.16.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 16:20:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uBhDp-0000000H1tf-2dG5;
	Mon, 05 May 2025 07:50:05 +1000
Date: Mon, 5 May 2025 07:50:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
Message-ID: <aBfhDQ6lAPmn81j0@dread.disaster.area>
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
 <aBaVsli2AKbIa4We@dread.disaster.area>
 <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAiJnjor+=Zn62n09f-aJw2amX2wxQOb-2TB3rea9wDCU7ONoA@mail.gmail.com>

[cc linux-block]

[original bug report: https://lore.kernel.org/linux-xfs/CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com/ ]

On Sun, May 04, 2025 at 10:22:58AM +0300, Anton Gavriliuk wrote:
> > What's the comparitive performance of an identical read profile
> > directly on the raw MD raid0 device?
> 
> Rocky 9.5 (5.14.0-503.40.1.el9_5.x86_64)
> 
> [root@localhost ~]# df -mh /mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md127       35T  1.3T   34T   4% /mnt
> 
> [root@localhost ~]# fio --name=test --rw=read --bs=256k
> --filename=/dev/md127 --direct=1 --numjobs=1 --iodepth=64 --exitall
> --group_reporting --ioengine=libaio --runtime=30 --time_based
> test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
> 256KiB-256KiB, ioengine=libaio, iodepth=64
> fio-3.39-44-g19d9
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=81.4GiB/s][r=334k IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=43189: Sun May  4 08:22:12 2025
>   read: IOPS=363k, BW=88.5GiB/s (95.1GB/s)(2656GiB/30001msec)
>     slat (nsec): min=971, max=312380, avg=1817.92, stdev=1367.75
>     clat (usec): min=78, max=1351, avg=174.46, stdev=28.86
>      lat (usec): min=80, max=1352, avg=176.27, stdev=28.81
> 
> Fedora 42 (6.14.5-300.fc42.x86_64)
> 
> [root@localhost anton]# df -mh /mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md127       35T  1.3T   34T   4% /mnt
> 
> [root@localhost ~]# fio --name=test --rw=read --bs=256k
> --filename=/dev/md127 --direct=1 --numjobs=1 --iodepth=64 --exitall
> --group_reporting --ioengine=libaio --runtime=30 --time_based
> test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
> 256KiB-256KiB, ioengine=libaio, iodepth=64
> fio-3.39-44-g19d9
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=41.0GiB/s][r=168k IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=5685: Sun May  4 10:14:00 2025
>   read: IOPS=168k, BW=41.0GiB/s (44.1GB/s)(1231GiB/30001msec)
>     slat (usec): min=3, max=273, avg= 5.63, stdev= 1.48
>     clat (usec): min=67, max=2800, avg=374.99, stdev=29.90
>      lat (usec): min=72, max=2914, avg=380.62, stdev=30.22

So the MD block device shows the same read performance as the
filesystem on top of it. That means this is a regression at the MD
device layer or in the block/driver layers below it. i.e. it is not
an XFS of filesystem issue at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
