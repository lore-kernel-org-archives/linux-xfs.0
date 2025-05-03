Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5774315F
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746310584; cv=none; b=n7dFe4ixWul37lJqwg3dSEv8oDXzTFBnkabm1HxJ8TinIFSMuEFthC4+eiQRYdecAJY1TvULvinAcSxN4KM6ScZ/8wP/O0IVHnqpXIM6EoT+uUul4YxTZfn8CE3eSbndTiWQMM089xllRcrX7DcWPUCklq4pXkbVRE5kav4z/lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746310584; c=relaxed/simple;
	bh=Da7kcjAkTRHqVA06s8ztDuc8EzeV9QMe/dWPbIss+mE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGn8zlD4WzihZy3rUvGp4/N95OP73h28MURvymrkxMyG1FsYPob7QZ8LWKYOhMxkZilH6voXTZRQ3p8v9CaI4up4Kz9epyBps9HxWTPaCHZaemeuZ7jwYk9cwV5X1+og4QvGSlOFk/HE0P7ZcaVD/X9ultEdSOPOYV17eG8mYEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VwE32Tvk; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VwE32Tvk"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736b98acaadso3137262b3a.1
        for <linux-xfs@vger.kernel.org>; Sat, 03 May 2025 15:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746310582; x=1746915382; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3/BOZ1oqrbclwCS/0w9JT7451hLp7XldrjPCpknUI0=;
        b=VwE32TvkNU619qaoeQKh9nKoWLvznfFV41/iTXWLeLcOmJtQTlTi3uMoruRFdiYkgv
         h9KWrjbFZ6cDLoG51IIvSjy0TKlsg2KDCW2tDGlvZwDIz2rMlOw/RA+GZGPQYmzmKthT
         aCm2cf959mSevQHdiJhkK5xH2Md6ZkflN0ePx8ehZKDd4uY5hcEojc7nPWBgU8VYAKdG
         dm5/OequgucFjoAYb6du+7WaLCARtmxxo3OMWmflliPG0G4RItMhsEkwFr1fHfocb2pH
         3ZhekoMQQq12EpXwtfzNyop6vHW9vipty82yJepwJ+eKa17ypZqs0YoS1mMSnKFnilmF
         VvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746310582; x=1746915382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3/BOZ1oqrbclwCS/0w9JT7451hLp7XldrjPCpknUI0=;
        b=jzZ8x1yrMhvaXuAi+OJBJw0B3t9Sn7+pPGJLmJeH5TcwRX9pvS2TGLcyFuogeVrNs7
         LTmyCowPzlvw2KaStQrIi+l2asqLnR0Lez8UM9b/NE5gUffEUsqBnpppJky+UZF2kUNh
         6SCdk2YQPMAJWGYPTZMHssY7bZwyHl/QTIXJRzjjLXgb7BSa5UD6ClJ2fygdlQzfoIr/
         /qa3MkLk/4C3gSfBdxPZL+bbuokAKpK1Tl8BOmZCacUJFf+P/HPX12U7maUCmLlbdxoS
         E5O0ZjTd6O4qCO9/oIXO4RP/9LyEAqwMexQ/591gWWNE9ND3bUMCk+ZtQGff4qT5tbB6
         0xsw==
X-Forwarded-Encrypted: i=1; AJvYcCXJwxaunteb/hpcAr5VbqciJJav5pjKUPHaExKGTRGr5MMeceYMAyuWu5yjvYBnVPFzxCIYI8usUeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjkdE4zAOCaPsy4KMp5ubyvSL+fMY3UvOgT+Qfa/S7c/FpZniJ
	pxJykqHKEzw28RPIgawfproI1ryKoLzi4v+Tn/d995drDqbD4QVRDCxiYQKDL1axnC05bfE2kqk
	H
X-Gm-Gg: ASbGnctPa4yYoXs/BoFaMdmZB2vry/ap4D0ukvCsjuwexPkgA8y0oQ0QoY2nSNfjEAP
	IVftTnrA0uCxmR5Uee1gUh7DmLazzb7lwDjB9V3cYOr1bnlUctQIuXJwhtnOTnVJ5SC7XXiCAP8
	AcaAiZHa4R/7jmvcSnjJGZs6tcmZx1GkIDRWpzhZ3S7DVkYiIgBbxTVa//EKzH3JdIqYF9ZZixK
	0GYj1Htj2/X3j83g1GUY73m0mEGNabJpCwlBGyh3zXAXQyUG4CVXXQkHNh1GmJM+tAF2+JB4cCd
	rmP+CGWVpW4Iti+6TpI1BkmyGi+nRL5vBNamtFQorEsGVui7y82JO7Peush+f/rbj8TX3PBWe9f
	ReTmWz9+7orQvuOgT5okIUpAN
X-Google-Smtp-Source: AGHT+IGmuZRFjkJBnVjd0PafVKe4ogAwiZZ61mf+m/Kp5oR9p7LQ3yubCIm58SmnIqpQGdkDdBVuKw==
X-Received: by 2002:a05:6a21:100f:b0:1f5:75a9:5257 with SMTP id adf61e73a8af0-20e068196e5mr6049852637.13.1746310582249;
        Sat, 03 May 2025 15:16:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405909ca4csm3839134b3a.161.2025.05.03.15.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 15:16:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uBL9e-0000000GcsB-3gNd;
	Sun, 04 May 2025 08:16:18 +1000
Date: Sun, 4 May 2025 08:16:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: Sequential read from NVMe/XFS twice slower on Fedora 42 than on
 Rocky 9.5
Message-ID: <aBaVsli2AKbIa4We@dread.disaster.area>
References: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAiJnjoo0--yp47UKZhbu8sNSZN6DZ-QzmZBMmtr1oC=fOOgAQ@mail.gmail.com>

On Sun, May 04, 2025 at 12:04:16AM +0300, Anton Gavriliuk wrote:
> There are 12 Kioxia CM-7 NVMe SSDs configured in mdadm/raid0 and
> mounted to /mnt.
> 
> Exactly the same fio command running under Fedora 42
> (6.14.5-300.fc42.x86_64) and then under Rocky 9.5
> (5.14.0-503.40.1.el9_5.x86_64) shows twice the performance difference.
> 
> /mnt/testfile size 1TB
> server's total dram 192GB
> 
> Fedora 42
> 
> [root@localhost ~]# fio --name=test --rw=read --bs=256k
> --filename=/mnt/testfile --direct=1 --numjobs=1 --iodepth=64 --exitall
> --group_reporting --ioengine=libaio --runtime=30 --time_based
> test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
> 256KiB-256KiB, ioengine=libaio, iodepth=64
> fio-3.39-44-g19d9
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=49.6GiB/s][r=203k IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=2465: Sat May  3 17:51:24 2025
>   read: IOPS=203k, BW=49.6GiB/s (53.2GB/s)(1487GiB/30001msec)
>     slat (usec): min=3, max=1053, avg= 4.60, stdev= 1.76
>     clat (usec): min=104, max=4776, avg=310.53, stdev=29.49
>      lat (usec): min=110, max=4850, avg=315.13, stdev=29.82

> Rocky 9.5
> 
> [root@localhost ~]# fio --name=test --rw=read --bs=256k
> --filename=/mnt/testfile --direct=1 --numjobs=1 --iodepth=64 --exitall
> --group_reporting --ioengine=libaio --runtime=30 --time_based
> test: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
> 256KiB-256KiB, ioengine=libaio, iodepth=64
> fio-3.39-44-g19d9
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=96.0GiB/s][r=393k IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=15467: Sun May  4 00:00:39 2025
>   read: IOPS=390k, BW=95.3GiB/s (102GB/s)(2860GiB/30001msec)
>     slat (nsec): min=1111, max=183816, avg=2117.94, stdev=1412.34
>     clat (usec): min=81, max=1086, avg=161.60, stdev=19.67
>      lat (usec): min=82, max=1240, avg=163.72, stdev=19.73
> 

Completely latency has doubled on the fc42 kernel. For a read, there
isn't much in terms of filesystem work to be done on direct IO
completion, so I'm not sure this is a filesystem issue...

What's the comparitive performance of an identical read profile
directly on the raw MD raid0 device?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
