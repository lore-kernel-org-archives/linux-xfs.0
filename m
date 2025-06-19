Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43147184F
	for <linux-xfs@vger.kernel.org>; Thu, 19 Jun 2025 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750300965; cv=none; b=ST1rMTLBLRrZZtS2l8uxEkUTd3cC4J3pJIunMQAoEGfxZsiy2tYO/xz6alCYLYjXozHid5WChTLR+FDsYhbl8r3V8bEu0EzuBk8zPJTlqNrpT8OLStLa11Kgzyl4IPXxyOfrgQpCF2Xigpg/PGwmrgkonj2krR51lr9N+kuwpWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750300965; c=relaxed/simple;
	bh=7wovHLABMUxOjzouPiBdM3z4rI+e4/Y5WEzhhi73ljA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxxnKQQLNgcVo3IfpKAsOTgTrdH495BQPOWqO4SiLJPt8B1iObj2nBET8rbr0FEQdgICNsk5ehdgNa9eDPfUGUYDXmGtbzhoD4/VZMn+YCPDALU4j227JGEogebMb465AbYbkAVkHoEifIfbxfsg+bZvbB6xrsHicZylcdgL/Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xfiJ5D8B; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xfiJ5D8B"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3138d31e40aso202569a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750300963; x=1750905763; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+zqE2bUQla7RpyZpXqrV1wADVIc70PVNgtx5FzauDk=;
        b=xfiJ5D8BYduoB+F7n5uhUbGQI9Ui5DE9LF4hioSafWkemyZlMhCM3jtLg7PDx+Q/NC
         quGzFBhczBEGzVCr8fU3UkMB450zffVh4qLqxkElqVk4nPKURrhrWQhpQfHk5KU/zKhX
         7ByEnjnQnxT/relmYR5vhkLrAl/XEV1RSEVpbF8JTrSTkz48P9bN90Okje0dJl1Te9lB
         OMrX2Xf72TIKKMcYIwcx1x+GlNvSrOnPDEYEctQI47q92ajXbFgQhNPjVTrDVQuiTVX2
         R0kK+UYoNORWVpymAQ9KpjynCHxRZlQEG0xxgsNbRaV2Xtl3SFQcN1aX+HwZiIX8au2V
         Y8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750300963; x=1750905763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+zqE2bUQla7RpyZpXqrV1wADVIc70PVNgtx5FzauDk=;
        b=UbKeoBIan1WvNXJKksWm7gA44gADxWCiq+q9U+qaWxzGTVNFJ3qhfdQ4guu0B6EA6e
         uWh3YvB8aSdWgf4Ht4D70OaHQSAxw1OXLkTNAgPQIk6/ArUH42RjJvDYCIO1gx5ikFRM
         V3K4D9CJ8AsIq/cPJiSlHluuJwJ5pZQ4G73WEodcoDpJceZtz9sbMwX/qiPgetlCadj6
         4U6Bjkc0xOk+k3FWMLe4vXke4MNvqgwiWB5+HGMGr48gUZ7K0fzy5HkTQpM/exYo8LJC
         xAL5zMJcnHItjf/fktqzC7DSmN7ma2Nyq8jsWErTT/9bqDftdb0tEP1wnumj9NCaj12h
         hfWA==
X-Forwarded-Encrypted: i=1; AJvYcCWvXvYYeExzTcpuklyCzBrdkk51yRRIUOyjZ4p3NOeKZm+6PIjahgpCCOFWGMxalsbLiGLy+1qwWPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIsP/jUcKnQY3j9NyFSaUP03aCWhpR5RkfqIihdHAjzzsaB0Xt
	MuR4bH6dBQLR6p33H9xqYs7ZDB1V0MJubqp57XpFr0DLZsGAxO5K2BjHGiVPPsLHx9o=
X-Gm-Gg: ASbGnctbY7pOol61hpUsAXPdOIb5ehVW5/r4QnNuZZF1hrFrDB8vmH/xrb+7fQ6Ei9I
	Za5TCF4kHy624qwnBQMbFroeC2bH37hCqayLRgnfUF/aswjAY3vr19z2CRPVCsvz4sQdJMuGkDc
	i1We6PuhqjtlAM2/3wgtq+3YhDIjapUfQ1i1q7VeiMgq7ttkNRKR7QsFhsgnP1AJE5rYhAWEDf8
	t3Pyx4zaKrV8M0PUlg7recCqwQtePPr0Fkx+/Q7O2C+AilHUZ9J5ouve5/eFfPkLD8hzcObKauc
	w0dc1VyGGPOsiJBWS099HkKWKLe04ntXcy28MI+rf+m8joQrqTl/loRH7bvVfFnCzPphgCwhgOV
	pvNph+G6Qmq5D+b15SDCqxsKa4dX8maJdHeQHyg==
X-Google-Smtp-Source: AGHT+IFC40tQbHF0XXT8ujRd0AXJBm1jxSMNVxz8L3VY4RURUurXUuPKkMgLoiEhSaopETS4JPCuhg==
X-Received: by 2002:a17:90b:3d01:b0:311:c1ec:7d11 with SMTP id 98e67ed59e1d1-313f1db807amr33156046a91.18.1750300963422;
        Wed, 18 Jun 2025 19:42:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a331426sm849823a91.44.2025.06.18.19.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 19:42:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uS5Ed-00000000RRj-28Hk;
	Thu, 19 Jun 2025 12:42:39 +1000
Date: Thu, 19 Jun 2025 12:42:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <aFN5H-uDW5vxQmZJ@dread.disaster.area>
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-8-hch@lst.de>
 <aFH_bpJrowjwTeV_@dread.disaster.area>
 <20250618051509.GF28260@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618051509.GF28260@lst.de>

On Wed, Jun 18, 2025 at 07:15:09AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 18, 2025 at 09:51:10AM +1000, Dave Chinner wrote:
> > On Tue, Jun 17, 2025 at 12:52:05PM +0200, Christoph Hellwig wrote:
> > > The file system only has a single file system sector size.
> > 
> > The external log device can have a different sector size to
> > the rest of the filesystem. This series looks like it removes the
> > ability to validate that the log device sector size in teh
> > superblock is valid for the backing device....
> 
> I don't follow.  Do you mean it remove the future possibility to do this?

No, I mean that this:

# mkfs.xfs -l sectsize=512,logdev=/dev/nvme1n1 -d sectsize=4k ....  /dev/nvme0n1

is an valid filesystem configuration and has been for a long, long
time. i.e. the logdev does not have to have the same physical sector
size support as the data device.

If the above filesystem was moved to new devices where the external
log device also had a minimum LBA sector size of 4kB, that
filesystem must not mount. The 512 byte sector size for the journal
means journal IO is aligned and rounded to 512 byte boundaries, not
4kB boundaries like the new underlying device requires. IOWs, that
fs config is unusable on that new device config.

This sort of sector size mismatch is currently caught by the
xfs_setup_devices() -> xfs_configure_buftarg() ->
bdev_validate_blocksize() path. That validation path is what you are
removing in this series, so you are introducing regressions in device
sector size validation during mount....

> Even then it would be better to do this directly based off the superblock
> and not use a field in the buftarg currently only used for cached buffers
> (which aren't used on anything but the main device).

IDGI. The sector size passed to xfs_configure_buftarg() by
xfs_setup_devices() for the bdev LBA size check comes directly from
the superblock. You're advocating that we do exactly what the code
you are removing already does....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
