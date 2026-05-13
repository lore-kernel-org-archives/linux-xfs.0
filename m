Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C94D3A9611
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778702141; cv=none; b=dbvNA6hm3HI7X7t4T7WUKpIIH7kxkkxvZqN9wCRpQSGsfky2cNH/TzJAAChHR/p/8mFWHHslolXQQp0fvnT1kZmemlRb1dtaR2K0NcGLisD4Ab6iDXQggJG+kdG24f8h/6tZX9meGrj0icVZJAsuJQytkb8LwHVP7cvzU5bZNt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778702141; c=relaxed/simple;
	bh=6q+Jlew0Fwj+Ewp6UZdrRl4SO/A/6VSjk4celCdXvTU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pAz3uhfJHkhNLE/5lYRa/KT2EM0N+44daX7Ks7FfmURTHtGGO9Zdv3wE9Plzeaark4Xj2u/0Bu+IYti4ScWM6ucrStHyrxY/8ECuvzTy78KG6zcptcc22aT5tv8V35bv3RYkGck1LyYTAMyK9drhF8ml3oXzI8uMrAHKxWGOABA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Huic3uXR; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Huic3uXR"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7dea1272943so3794016a34.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 12:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778702138; x=1779306938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63STWXd9Wzpt4PhrJ/B9urLFnYXotN9z6wtEWKI/5Zc=;
        b=Huic3uXRAqUq/jmsHa2NBsfRiXjoa/vPexojOpjASE6BgTsG807o2YheMpXGIUXneP
         Z/t2sWQS3wgDk4th5MIBHDd067Y1kMlVWCEjV4FO296ftCeE7RJTRHYNwpjubvg9sL/y
         eQsPuYpW1kV1+d/FTPihD7q4dApBVKwbwJcsFWrxshG5R0Xayu5Hwaw1jE/Es2NZkMQw
         FwBjiASSdWnVgovI4rGAhJ18S6KcfbOdTdVapvkk3Kq/4IPJ9nAkEo66Bwxs4rSF3CAM
         xJ7UUsc+ZBHMC7eR0L17Re+wDZw+wcOo1p6/jkj0/iS8dD/A2XRBZ2Mk6kPrE+9Sl1xM
         YuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778702138; x=1779306938;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=63STWXd9Wzpt4PhrJ/B9urLFnYXotN9z6wtEWKI/5Zc=;
        b=CsT6lhofqwg+Sd9vF7p0HzCyvft97W6KXAIzdtYfLDjqhyl+kN46l6N0y9Td/vtZJC
         4aARtcq4V0jw5ChWg7v7qIT30dyc8mYgooktY/5f386sxLZBqvYenA/s6at9CXsRTLso
         qTFqTCG66y8EVI7AWBIxPyaW9+7T07e07HcSVNUHijpIuwrFEgceh7Go29WQb+UfXdt0
         QdL4JOUMdwj/Q9/gceX82qjhh9ZxbE7vWbyWuOzArkTfQstn2QO70wrgbCrh1HckmRa1
         AlAaOSXSGF/PjA3xPxnoz0CDTvYcA+RjtipJXCUBuk6vJgmIc2ELysPgZmdU5laUlIbj
         jptA==
X-Forwarded-Encrypted: i=1; AFNElJ/dQcAWOH75nuUzXt1trUNRNk2aGxZUL373/+fCV6dHJ8atkcyYAUxP4Xbc/L2lqTb0jFH7gYq0Qbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCD6u6+x+pzpjVESHy0xpzfUZjfy3m9a2QI+Kljdu5tgh901m0
	Up9ovB3Hov3RglAQLxYqkYowUQHn2Iwoavj1Dpm6uWXr9hWwIdCxlRUOVlMIFBXnOxY=
X-Gm-Gg: Acq92OHd4n7lQayMybjPuVUps7Revva94ykiDEZ6/gbyLfRvm0LGNK7SbF7tqh68juO
	AKhnmu0IkeMrln+Txh6Qff6PDm4OoyvLiepC2x9cGzBRku+dzO2Sfm1BfziIj3UFK3noGudMZgw
	VqJ5KEtja5j0mxaxDq8yiFxdw6gX9uAqcpSOJ7FdvA5GZMPE9YQHst7a//QzlMcZYcPPlJKbrZg
	myhJsSoGZGHQT8LI7IN9WNAjiqJOuwfoaWAP1tsqz2+eXrphUBUSggP0s3POLfuVIaeMoNEUa4k
	FW1t/OVPQYT88d6AdqNuhxdhdQMMC/Wd9ZerCIAdzNPIJuhc53UvrsFFAQ69jsrbRnAA0PV08K/
	3gWBfOvH+O+PBcmEk+SbfJruGou4WKsAbQee0tihYyRH1gTKbsA4ZzOulH6AXJ+xnN7uUzU1xTD
	/26x5bHqcMcfvLkhRrjYqb+7OPZ3z303JzQ+OYw05GXptC7y1hHJcOWxXRkZVSz3RJ5Xl/qP6cJ
	6CmcF34udCDUg==
X-Received: by 2002:a05:6830:6ac2:b0:7de:b878:3106 with SMTP id 46e09a7af769-7e3da08eecemr2719920a34.7.1778702138210;
        Wed, 13 May 2026 12:55:38 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e3f3edbff9sm260584a34.21.2026.05.13.12.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 12:55:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, 
 Pankaj Raghav <pankaj.raghav@linux.dev>, linux-block@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260507050153.1298375-1-hch@lst.de>
References: <20260507050153.1298375-1-hch@lst.de>
Subject: Re: fix block layer bounce buffering for block size > PAGE_SIZE v2
Message-Id: <177870213725.543218.16808866598223942501.b4-ty@b4>
Date: Wed, 13 May 2026 13:55:37 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 07 May 2026 07:01:46 +0200, Christoph Hellwig wrote:
> this series has two fixes that make the new block layer bounce
> buffering code work for the block size > PAGE_SIZE case.
> 
> Changes since v1:
>  - update a commit log to better describe the applicability
> 
> Diffstat:
>  block/bio.c          |   27 +++++++++++++++------------
>  fs/iomap/direct-io.c |    2 +-
>  include/linux/bio.h  |    3 ++-
>  3 files changed, 18 insertions(+), 14 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] block: pass a minsize argument to bio_iov_iter_bounce
      commit: 32d5019ed3b6ff4439cb075fb275f655c8a2059c
[2/2] block: align down bounces bios
      commit: e7b8b3c5b2a65595d506ffedafac66f0a11fbdc2

Best regards,
-- 
Jens Axboe



