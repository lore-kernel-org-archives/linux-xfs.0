Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232991EB56
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729549862; cv=none; b=haLuyZnmdJq6hyhvKiFgfY8xBf/Cp7dKjpQgAQAL/SNXzVjZcUsBtfOArzZGx/ONmQ0cteM38jqryhVrbQSwhh8aGbmkaI4UQ0NM8YUTGWBtGIo/BhtdO6Ry4ZBrTi1gRG3sFj5D4Fm2EbnvIQILyLsDnv/Tsd40QNnVnma3PpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729549862; c=relaxed/simple;
	bh=02WBLYn5hm46RGjKT09iky3RgWRBw1dRwnKC0MwXA8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izWxOtq04r27ef7pWb4QUop0Emx8yqaBgHzQlwPGRDisgd/bNXuIWpKTY02hKrdByZv49ZHcIPtktdkR2y+NCQ+4fx04xZJHfqGFwE1QUZ1ZDVlW9BjbAz+YtmCG2C4om8ZU/JVDoszybmX4NoGqlAtU6LbctVeGFUIRWUqwj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mgaibbP0; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mgaibbP0"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cb47387ceso44174545ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 15:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729549860; x=1730154660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gpov8qknWLMdPqHJDFq36iRXP4pxjN7UjssnKFRCVMo=;
        b=mgaibbP0ao5eSiG3E8f/qHnKdePZqWKL0c8oPigvqb6qatxlTlO0UWJUQD5OQ2bmh8
         37IDy2A09CIDOZfogr47ftMGJQ51w5k0d59J6e6rl53+gjITrMYRvIIqiQxCRbnq+6UH
         HjDUt0K6Uw15ge/DV3mI5pEMlseghjxTO1Mlc2SCJyZplClsWdTWixIGvDI/Cm//Rck3
         FzN+wDuIbwEfiF6S3c+xZuN+WFJU0sWY7g6un/pR+M/Jc5IzDTdNwEoWE4DAhl+wjJs/
         j7pAc+DcAyTzmSNmCT50SCvDoe2vHaodunVkBSvyyxjAKt+1aS3nBpyc/8nvT9X4Lvj9
         GKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729549860; x=1730154660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gpov8qknWLMdPqHJDFq36iRXP4pxjN7UjssnKFRCVMo=;
        b=azDRh4m26mAF8CSSOTZGJPvh9ox51F8ZXhmbHY9x9i5EzlbNLfdz08bepeCDrduoSP
         GpAyP8Fcmd8EO9byNvlk0wEssAKv/sY4k5dIMmEBWfEhkab2Jlhf/BPVkq5q+xmK3UN/
         Prp4FLRrP25Ut1dRpNsNi+q1/pajzpoSnpvCDeVqyukXQhRjF49ROnaSnRYPnl0sPDIX
         gf4/Lqfcgj068YHkfq7+SdYHwDwwP/EwPmQW61Zu8WEY7Lk4EAuEyTiDE7vudhVzZcJw
         OXNekT3LazwutQ2TdRnLEAqjfX1d2VK6t2bzLO/SB0lD+YJNTvshpq/BPgQT2Iag1yE0
         IgFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQQ7XSa2iTtVUxZzVz/afDFOH2XQt1G8BLiXQVaoA9BRTRBMRDdI5rxHIKqKNvIydQsOOxtzHcYnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz50PfivQODIy9KZ/LvC/P0SFKwC/bpbuJ8nBm9O1vcX0uPGbcp
	u4zdIo6Mwr2AvH/hxCHcYwTfYUhCDvNyzkhrlLX6CTqdmtI0WZ9o7+zuVbo7cSw=
X-Google-Smtp-Source: AGHT+IGnZvSN/JgkvgxC51U5ZIowUxltQuOXg6wu1T2t8vfivVOuEl4426pU73OYYuA8tQqUXZlpGA==
X-Received: by 2002:a17:902:ce85:b0:20c:c1bc:2253 with SMTP id d9443c01a7336-20e5a8a101dmr167189345ad.32.1729549860470;
        Mon, 21 Oct 2024 15:31:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0f3ca3sm31011095ad.274.2024.10.21.15.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 15:30:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t30vQ-003zWR-2L;
	Tue, 22 Oct 2024 09:30:56 +1100
Date: Tue, 22 Oct 2024 09:30:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH] iomap: writeback_control pointer part of
 iomap_writepage_ctx
Message-ID: <ZxbWINZwAEJEdX7S@dread.disaster.area>
References: <326b2b66114c97b892dbcf83f3d41b86c64e93d6.1729266269.git.rgoldwyn@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <326b2b66114c97b892dbcf83f3d41b86c64e93d6.1729266269.git.rgoldwyn@suse.com>

On Fri, Oct 18, 2024 at 11:55:50AM -0400, Goldwyn Rodrigues wrote:
> Reduces the number of arguments to functions iomap_writepages() and
> all functions in the writeback path which require both wpc and wbc.
> The filesystems need to initialize wpc with wbc before calling
> iomap_writepages().
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks reasonable to me - there's only one path this comes in since
we got rid of iomap_writepage()...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
