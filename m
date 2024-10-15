Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B9C8F0
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 02:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728960186; cv=none; b=Q/DRGWUCodX75zAZuRXrlXCDo/8+bFpq/EyRXPBszYn/QKvzgyoSAsyjwXZhNXhQLKZyUcSxNSP+bZ9tIYudcqLeTmhpVOFGU4Y1vQdHPKkYLUu9C2AH1IQfDrWUx3kq9692FjAyQqBAuh3t0xysDGSRL0o2M2Ub0GSp3zpOkLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728960186; c=relaxed/simple;
	bh=YcpTAyuG7yQ7QViCWcY0g9WYmY/XHBAuD/vN36/8Cs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkFkHU0PkAcq5OWXGQ/e7TLOCvu26kgTdOix1O40Wb0gDmdW+CIEI3YotdAYR4Z7pJ69fADe4RmZk1Elpqasdoek2kBOccth/ZqJi5arMi5GwhfRMJ4wexVDLoPttOh/G+KlMYug897ja6nqf3TyUwF+dD54YTF1IomPcTNBHUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=aeB/cfwk; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="aeB/cfwk"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ea9739647bso629908a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 19:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728960184; x=1729564984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/TurvcGk6KDqJj4Oz0aUKZL033e5dsribCFkovIuMg=;
        b=aeB/cfwklWLezkjoc+oOFYa7d8wnCzTjYdYoC92OYzEf0GcOv+u+VAfN0UuC8EY7d0
         cyfQXfnjkFxfW+XC9qi5R0ajHw0U/uujAJ9Y32MsEmNtYl1ol81i2qHTjqt/i7jenelP
         dZ4oRPB+kYjgDfdO3ISxJOCPyxL+BHZr14e//77RwC1SdgdDtOtzApH0hZOOLZR71ZmZ
         YroJaIdqrQY4JHJS9aSII1ahP1G8Ayevatm70ToX9sD9RYdZkD/bIK+vdP8Mz6aHsIuo
         yMlVbKOAC94bLKqmWBQ6+HGmC7is34j6z8fiPPBEO25SlDN5Z3pD6PMtTLy14PcU4QPF
         eD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728960184; x=1729564984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/TurvcGk6KDqJj4Oz0aUKZL033e5dsribCFkovIuMg=;
        b=Bx8uiolTiKwIJAp6QeQZ3IsSLSeG8eJQeUTLjWmTJsis2ge6TTsBpSdcqfUSPIOL8z
         6NvykhEYtWfp7D1zZAYPI9y6hz89flFOzDBsYt0sSJEyY5cl9dSDWSpqHPgOtBJ67k8M
         AdDzu0ikergM5vqep9q3wkqq4jCvwy30iWheVT2zALy3d6ImqHz56c6EBoaKoTAhCg2G
         1mRetCtZJXFGPuZrAQkl5zKiloJDJuu47ARiGfrh3uuydwLMJAt8Mu6de+1EYrFJlHcQ
         bKMDPBArMaygvpaGSSRgnJBwp7ul/72G+Ha615ePz62F1SVyy9iEUq2zireP5lI2qQcj
         OVhw==
X-Gm-Message-State: AOJu0YxGWIxUW5wVUS4j6n7fnC5dyvnkKMDvmcH6KNrK0CQZ85s9NsMh
	7r6KBfBfHpFfWb7pevLJqmKyyhQ4ZzZOC0T0kD8hEC5tkeOa4ed1N1ieEzX36Qs=
X-Google-Smtp-Source: AGHT+IFwEKjfssuApr4k0yL9D9nYUyzcnuFaH3jErkdmQriGfeqYzFZHi9VikS0wu5qDgJSdBJrmMA==
X-Received: by 2002:a05:6a21:6f01:b0:1d8:f679:ee03 with SMTP id adf61e73a8af0-1d8f679f18cmr968406637.27.1728960184566;
        Mon, 14 Oct 2024 19:43:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774cf306sm248348b3a.153.2024.10.14.19.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 19:43:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0XWX-000x2o-1i;
	Tue, 15 Oct 2024 13:43:01 +1100
Date: Tue, 15 Oct 2024 13:43:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/16] xfs: convert extent busy tracking to the generic
 group structure
Message-ID: <Zw3WtXJIpXTUdVhr@dread.disaster.area>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641435.4176300.8386911960329501440.stgit@frogsfrogsfrogs>
 <Zw3AqAuiDKKKowCa@dread.disaster.area>
 <20241015012121.GR21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015012121.GR21853@frogsfrogsfrogs>

On Mon, Oct 14, 2024 at 06:21:21PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 15, 2024 at 12:08:56PM +1100, Dave Chinner wrote:
> > On Thu, Oct 10, 2024 at 05:46:48PM -0700, Darrick J. Wong wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > Prepare for tracking busy RT extents by passing the generic group
> > > structure to the xfs_extent_busy_class tracepoints.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_extent_busy.c |   12 +++++++-----
> > >  fs/xfs/xfs_trace.h       |   34 +++++++++++++++++++++-------------
> > >  2 files changed, 28 insertions(+), 18 deletions(-)
> > 
> > Subject is basically the same as the next patch - swap "busy"
> > and "extent" and they are the same. Perhaps this should be
> > called "Convert extent busy trace points to generic groups".
> 
> Done.
> 
> > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > index 2806fc6ab4800d..ff10307702f011 100644
> > > --- a/fs/xfs/xfs_extent_busy.c
> > > +++ b/fs/xfs/xfs_extent_busy.c
> > > @@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
> > >  	new->flags = flags;
> > >  
> > >  	/* trace before insert to be able to see failed inserts */
> > > -	trace_xfs_extent_busy(pag, bno, len);
> > > +	trace_xfs_extent_busy(&pag->pag_group, bno, len);
> > >  
> > >  	spin_lock(&pag->pagb_lock);
> > >  	rbp = &pag->pagb_tree.rb_node;
> > > @@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
> > >  		ASSERT(0);
> > >  	}
> > >  
> > > -	trace_xfs_extent_busy_reuse(pag, fbno, flen);
> > > +	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
> > >  	return true;
> > >  
> > >  out_force_log:
> > >  	spin_unlock(&pag->pagb_lock);
> > >  	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
> > > -	trace_xfs_extent_busy_force(pag, fbno, flen);
> > > +	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
> > >  	spin_lock(&pag->pagb_lock);
> > >  	return false;
> > >  }
> > > @@ -496,7 +496,8 @@ xfs_extent_busy_trim(
> > >  out:
> > >  
> > >  	if (fbno != *bno || flen != *len) {
> > > -		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
> > > +		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
> > > +				fbno, flen);
> > 
> > Also, the more I see this sort of convert, the more I want to see a
> > pag_group(args->pag) helper to match with stuff like pag_mount() and
> > pag_agno()....
> 
> Me too.  I'll schedule /that/ transition for tomorrow, along with the
> patch folding that hch asked for.
> 
> I'm gonna assume you also want an rtg_group() that does the same for
> rtgroups?

I hadn't got that far yet, but I think that's probably a good idea.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
