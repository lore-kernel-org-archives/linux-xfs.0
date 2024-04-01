Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C7311187
	for <linux-xfs@vger.kernel.org>; Mon,  1 Apr 2024 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711968599; cv=none; b=COl1zyRL/Y8dywk/X8Dy/CZhkmiDqcXB0zq0wO+Yd+eoNBZrpcctGJ2gDTGSA2TBmJlOHtxazAezRPiu7NvgbS5Hx2xf9eb8KBJOCSWjXpz4mVvXzSDFxdjFZVNWWtkIP6Lb/nrqR3UuPdnDLZ+zTushaNNCxLEsPLd/SyYDcmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711968599; c=relaxed/simple;
	bh=eDqKse3tDAscplvDKdr/MvUa2laKqSY3EO0rmvi6aMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUk0zrkWUwewEiCFEQv3xOY/Tm5bJiW02TjQPU8T8SlBqIjNGPzGkaTbm27sncQD/VUvVuY+015JR+D8JWDGhyu5SexixJgQNMJ3QwheO7Ub2EOXoQqCBgMTF/lFfghDfJI4p3eflHOnQIEg8I+wT0icU4HKK2+W3r7O7YRDJVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wmtMUhlm; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wmtMUhlm"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e00d1e13acso24770305ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2024 03:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711968597; x=1712573397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hE0bLuBmKWjs0TKjlDgCWR3GBLmqtE3VpFOLiFlvHNk=;
        b=wmtMUhlmLK2L9pzG5L4HsdhnT7ifTIeYD5xV9X9QZugcWqGYHF5Jo3sficO+6rfRaD
         44R1MLOk1W4fqwFJNPXlX8KQAZ4eF9UUmmyyb/7RmtMpQRox1lYczx34v5K7flmhHmr+
         4WPx5r89dsaVWSI+dzEr+CCtRWY3TOHFMRGlpaPPAZQI/SB01DWBwBgvUQ8IRN0xH+RE
         cAmX+VDIsaKndbwVuZWoLhRpJ93UYSHr7fk0HGKQMyLrMI/zRgFKlE0NI1ITqr42Su4b
         A1hVvFw7ggBHcVhjR/IlMeGr2ZavBD+bIpizKYF44nuFtJGv7SbM/NLsiejxkoCfV6bo
         6TBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711968597; x=1712573397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hE0bLuBmKWjs0TKjlDgCWR3GBLmqtE3VpFOLiFlvHNk=;
        b=jRFi6B8roF8sxMboGu4Ify0HBxhKtQo5XKEWuw9jzB/3CoHGdFc5jfcVqfUT1RAJ69
         Dw0zAA2QAaoqwTFJL+EILD1JtHb3obfQy5Kjdl3zkOlwo8FoaZw8N0vmnViMY+7MqlNv
         A0YtLVqRQ2wskz23FYEEXblIbZQqKiTsgaEzlt6M/Y5kVQFNDDKwceMwBFLJIhm33CSX
         B0T0hpAND3vW528mvH9O0m05Wp3qmSouLO/FPOb4aHlbSqwQARVo2Fyh/88oKrfaepBN
         QvGOare3H2v8tj9NMLZW0OKK8olYUK/I0j5/5UOQtXskO0c0l0rPeOQgsXP52ZyVaXnS
         joWg==
X-Gm-Message-State: AOJu0Yw25afp/V8b6NGZ8O/mLb5w1nxSZLMHsWt6KKrktvPfFrq/7upe
	FldBSjHbN784KJJx5Fp3QVXBIIYjz1kIW2VlktKjGzvCL9UeJkDZLaT7s6+ZfE2gW3MXNN5nmqw
	w
X-Google-Smtp-Source: AGHT+IElAMbx3RDrpjom7cpP5jdO4AV0n+KMtmow66p1k9VC+EPPVf8zhLsuUw3J0cNdqBTH7N1LOw==
X-Received: by 2002:a17:902:b710:b0:1e2:3078:c00e with SMTP id d16-20020a170902b71000b001e23078c00emr7880627pls.20.1711968597019;
        Mon, 01 Apr 2024 03:49:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902cecc00b001e0f277174dsm8567493plg.27.2024.04.01.03.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 03:49:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrFEf-0005Vf-29;
	Mon, 01 Apr 2024 21:49:53 +1100
Date: Mon, 1 Apr 2024 21:49:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Potential issue with a directory block
Message-ID: <ZgqRUeuKnLDGxS+i@dread.disaster.area>
References: <CANubcdXY-otymMxDpzbdy1q5osnruNeU7L-b_+eeNo682U4p+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdXY-otymMxDpzbdy1q5osnruNeU7L-b_+eeNo682U4p+Q@mail.gmail.com>

On Fri, Mar 29, 2024 at 10:55:29AM +0800, Stephen Zhang wrote:
> Hi all,
> 
> It's all about the commit 09654ed8a18c ("xfs: check sb_meta_uuid for
> dabuf buffer recovery").
> 
> IIUC, any XFS buffer will be in an internally consistent state
> regardless of whether any other buffer is replaying to it.
> 
> Specifically, for a buffer like:
> 
> ...
> bleaf[0].hashval = 0x2e
> bleaf[0].address = 0x8
> bleaf[1].hashval = 0x172e
> bleaf[1].address = 0xa
> bleaf[2].hashval = 0x4eccc517
> bleaf[2].address = 0x36
> bleaf[3].hashval = 0x4eccc519
> bleaf[3].address = 0x2a
> bleaf[4].hashval = 0x4eccc51a
> bleaf[4].address = 0x24
> bleaf[5].hashval = 0x4eccc51b
> bleaf[5].address = 0x1e
> bleaf[6].hashval = 0x4eccc51e
> bleaf[6].address = 0xc
> bleaf[7].hashval = 0x9133c702
> bleaf[7].address = 0x68
> bleaf[8].hashval = 0x9133c704
> bleaf[8].address = 0x52
> bleaf[9].hashval = 0x9133c705
> bleaf[9].address = 0
> bleaf[10].hashval = 0x9133c706
> bleaf[10].address = 0x3c
> bleaf[11].hashval = 0x9133c707
> bleaf[11].address = 0
> btail.count = 12
> btail.stale = 2
> 
> and then If we skip a buffer replay during log recovery, the buffer
> will still be in an internally consistent state. This implies that the
> 'stale' or 'count' will be consistent with the real count in the
> block, meaning it won't trigger the check in xfs_dir3_leaf_check_int.
> 
> but the commit 09654ed8a18c ("xfs: check sb_meta_uuid for dabuf buffer
> recovery") states that in some scenarios, IIUC, if we skip a buffer
> replay during log recovery, the buffer will not be in an internally
> consistent state.
> 
> What could cause this inconsistency? Are there any potential issues
> with the directory block?

Original state:		count = 12, stale = 2
Change A:		adds entry @ 12
			count = 13, stale = 2
Change B:		removes entry 4
			count = 13, stale = 3
Change C;		adds entry @ 9
			count = 13, stale = 2

So at the end of recovering these individual changes, we have stale
entries at 4 and 11.

Now let's fail to replay Change B. What's the final state when we
replay only A + C over the original buffer? Is it internally
consistent?

However, log recovery should never allow this "silently fail to
recover intermediate change" situation to occur - if it can't
recover change B, it must abort recovery immediately and never
attempt to recover change C....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
