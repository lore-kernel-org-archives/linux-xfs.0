Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D0C2575F
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600375; cv=none; b=oTvURNldrEb9m1d4xuyMG7w1pjcLvrclSR48XAcwE6/gE92V7PJYpHiPlW8AQhWEfLWU1IG2LWUUzpFY+kVqZgY5IUuterzlKtJgj444vtMfbFC6Kg0jh9awaorVy2Pc1hjLvgQFIdnAkukuN62TRHW811cdUcOxNt5Kabc0UWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600375; c=relaxed/simple;
	bh=qJoZ+x+n8tMxuOW27E2rWDcrJTJP9ieeHNFmkm23MyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSLoi+uKZn6oXxAuIr/BiUai01Nwxn4DWv35HJ+n8L5eL/izYLahh5H5sJP1ddCAMOQR5dK9+7huH+WFzLcFioGBcqZxXfY+p3fhKwY6yQrt0kj+WUPLIg0nPI1MWS63y0Gh3ehVb6P1uHQXFrjlhMUo49BQU5APfi+A3NZlpCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kJuyhFbE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kJuyhFbE"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dee27acf7aso3929195ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711600373; x=1712205173; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fhtANJB0mofMqIbp4fOgbSdiG6Cra/s6b/sB+/jKdDU=;
        b=kJuyhFbEdCQa6swUoqKSFLKXUnnd/+/EAojurHRsOvdsDYo3h3HDznRG+xNCfuuQBQ
         us645oJ46tu10/PM2szjwBSHTo/DkuW3/h5IqutcGei7Tk5rsa61s7GPUZPwQFNsq1ha
         xy+1rt+vVN6AdVdTfCkNDct11HO0l6aMqwtmLYVQlH3dwsBJIQlVUhbdZGE3928AD9zb
         H1dsKhRqih2aCO3FU1AfbRzv3GwyuHZJih2uMgFq/0XsqOSN6cRfu12YvfIQ6Jb3IUmV
         ayN4uVMYYJb+uA2p+a5XiugKiFLjgJIzE15XeeCa560G4mJ5v/7bR/07fxlxynn4IjIN
         SAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600373; x=1712205173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhtANJB0mofMqIbp4fOgbSdiG6Cra/s6b/sB+/jKdDU=;
        b=s+5YhXX1Ksn51L1kS8ZKLajg2Sd9RXuYOjfLLiPHdrDLNyiklS840lobR2/w8D4A9n
         CsZOlCvBnGJIBu5rFGvM1UL5ib0nhndEHOs0gZVZI22gy3bSaFkqCL72M908GHw+PEva
         whHHu4wlVjcscPomFIfUOxyhZqZw/AUgcTpkWItBJiln/VYDgBnjOiA/Gp6DR34uHH00
         2cblHqWaveoEMA2OKQMTkXcCBj2Qp4fHEgljQWJoH0zVY/lfDq0Brp7G+ApXdehCcRy3
         +N1QQDWa61KWWLe2Ne4W8s5OGRj/+h5VSnCqEtE6y4L048GsfZJTEBWBrgoQN9y0+PWN
         BIdA==
X-Forwarded-Encrypted: i=1; AJvYcCVoEtcbeI/0DyluCpJmQ2Rvi9WQLXHVlmwxA6hwo0E1xEQCkRsciyWTmM7FAITVfxMgXiHSjjNFdq1WjW5UiA04dZuyllmtMw0t
X-Gm-Message-State: AOJu0Yzr0c31hBWUWzpEU4aNnoEdowehKsjDCB3FNGq7FaAbtT4P5LqS
	CsHxGHd5XfFIVYDtVzB1WBrXQt8JXDd+b4AbECxLYTgRq3D8rD2SKUybnkY8Z9I=
X-Google-Smtp-Source: AGHT+IGigpudoy4SHSAPyoJojWWLmuvGI0aVQpoH8nyLpf7yqOFFlL7Flo7MRVIsjtG5AYU6MDelzQ==
X-Received: by 2002:a17:903:110d:b0:1e0:b287:cff9 with SMTP id n13-20020a170903110d00b001e0b287cff9mr1808289plh.46.1711600373347;
        Wed, 27 Mar 2024 21:32:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b001dd02f4c2casm409688pla.164.2024.03.27.21.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:32:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphRa-00Ch6X-27;
	Thu, 28 Mar 2024 15:32:50 +1100
Date: Thu, 28 Mar 2024 15:32:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: look at m_frextents in
 xfs_iomap_prealloc_size for RT allocations
Message-ID: <ZgTy8iQgXeCK841G@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-11-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:15PM +0100, Christoph Hellwig wrote:
> Add a check for files on the RT subvolume and use m_frextents instead
> of m_fdblocks to adjust the preallocation size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

One minor nit:

> +	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
> +		freesp = xfs_rtx_to_rtb(mp, xfs_iomap_freesp(&mp->m_frextents,
> +				mp->m_low_rtexts, &shift));

It took me extra brain cells to realise that this had nested
function calls because of the way the long line is split. Can we
change it to look like this:

		freesp = xfs_rtx_to_rtb(mp,
				xfs_iomap_freesp(&mp->m_frextents,
						mp->m_low_rtexts, &shift));

Just to make it a little easier to spot the nested function and
which parameters belong to which function?

Regardless, the code looks correct, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
