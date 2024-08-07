Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABCA2F5A
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 00:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988851; cv=none; b=kzN/8DCoIKflhfAnXH5JkCbXXSfziGXnlqduEnaT11RJkIqQjs0VI3M9saiMU1P0Dq/btFPmI8inulzdiL8evDExsEqyxIzL7KbTrraoxISuQLzNDil594SfYbZorzzC6CDiFHdS0q5BqeZUYXBl2GNFoxJlfKYrh8bwQs5/JXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988851; c=relaxed/simple;
	bh=2aSqKoeIL7H1XnqTVZYnhSa9Sxg7fRAqjT3icKRimgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=triUyjxzpNYG+uGzULTzBPb3cR2Qjo3R9CjLfTVo6zgQefG5tRLA/wxyrjmpv4dJrPJ3jL1ptl1+ldvNtSGO7JBroNKwLK/PDIvZqlpWYErUuiRXjWsegHZHea8SkWAi9PqEb4TAV6Jsw6HqRuEtRZTJsnQA2e13nnottdlnQ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2ih/FZYd; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2ih/FZYd"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70d199fb3dfso975663b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 17:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722988849; x=1723593649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkbg7RhfRFm56OQaj9VVBTsqBGFrSx4GH7fUN2VwLaI=;
        b=2ih/FZYduh6OtbjRXFmnVTT6gz1TB6WTlsbuyQFdRP51vzzaFYLEFlYVn2D4Ds85Nl
         BOFR7UOWqF/aCpGtg9ABr1H4MZpK3P405gjcSPg1TA5OQUhplcT9l6d5KYHV2T9rn2Hz
         aMpWVy75TJnl1BXP6jrp8CvIoIUkYPJBqhW5ZKwCp2+lETGLuW5J1ROTbG9woa/+Lujx
         uTueIBAcxJ1sxURBo3UFkmoYJ1FSnqUL6NJXFn1GuPjodBSBWlwsNIpVF457zfZcZsY+
         APE0ZtwALC7SAH/OMemCuh8OutajnZIIVtvq7sl7glJV62WX1nCQaot60xlTAnzdJ80+
         ZukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722988849; x=1723593649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkbg7RhfRFm56OQaj9VVBTsqBGFrSx4GH7fUN2VwLaI=;
        b=p3Lmyg311gTGcNYbkmxKqtCvelpkkApwC/S1PQnUvEShUCcTUQrjcYjLKVA1zjAzPp
         P5CNpXbMTCJYVJIeqWz4otv0SbeKevxaC/IE134sbJaiI2Sr/95s0ZD6backU3w+S8KM
         HPjCJUM3cPhAUuuLgccnoJzuijkj9UKyl0WmkKP+DcDdY9Iyb/fxhNgLNzPf6W0vPUzR
         5lWPbgOF3Ntbg/Tk9IdsPZojE8grj3g5zX6XQjOQREarCflUllfsgWrx/bXpdErJXb+E
         XYsKCEgXRthst9NJHdmyhmEEIdPL7Ypu7QAeynt1p1ugFDGYwMLH0o9coqyS7bAIYkJ8
         mVXA==
X-Forwarded-Encrypted: i=1; AJvYcCUVf5/iS9Uy0IiELxLieW/ST6YO+Fb4/zpoeAmR6zbPMFBYYsp30H/f9Jt1xGxUtmxBBcEjVuflt2RHYsG9QpMPio6SQ6zzWeqd
X-Gm-Message-State: AOJu0Yy+ZsfjdOhUqUEgt9g0rD4zqSxbaLh4z1rg82I4FoM2znd3/t3n
	kbHrbTqhriCCILAJfM5/qpKDckcgnp2zyPc6NpitZY+wfqd2V1TVq+2ayMgcHWM=
X-Google-Smtp-Source: AGHT+IGjuYHFxiGqFhb6phLGMfE0TvNxItmu2KVYzOt2XbeUv5QmT4Am5+FxycPh4+8CFBdU8ZnNvg==
X-Received: by 2002:a05:6a00:194f:b0:70d:3104:425a with SMTP id d2e1a72fcca58-7106d02ba22mr21668337b3a.23.1722988849335;
        Tue, 06 Aug 2024 17:00:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ecfccd3sm7673423b3a.144.2024.08.06.17.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 17:00:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbU6g-007vzC-2Y;
	Wed, 07 Aug 2024 10:00:46 +1000
Date: Wed, 7 Aug 2024 10:00:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 04/14] xfs: make EOF allocation simpler
Message-ID: <ZrK5Lu1+oqqyG3ke@dread.disaster.area>
References: <20240801163057.3981192-1-john.g.garry@oracle.com>
 <20240801163057.3981192-5-john.g.garry@oracle.com>
 <20240806185853.GI623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806185853.GI623936@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 11:58:53AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 01, 2024 at 04:30:47PM +0000, John Garry wrote:
> > @@ -3688,12 +3649,19 @@ xfs_bmap_btalloc_filestreams(
> >  	}
> >  
> >  	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
> > -	if (ap->aeof)
> > -		error = xfs_bmap_btalloc_at_eof(ap, args, blen, true);
> > +	if (ap->aeof && ap->offset)
> > +		error = xfs_bmap_btalloc_at_eof(ap, args);
> >  
> > +	/* This may be an aligned allocation attempt. */
> >  	if (!error && args->fsbno == NULLFSBLOCK)
> >  		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> >  
> > +	/* Attempt non-aligned allocation if we haven't already. */
> > +	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
> > +		args->alignment = 1;
> > +		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> 
> Oops, I just replied to the v2 thread instead of this.
> 
> From
> https://lore.kernel.org/linux-xfs/20240621203556.GU3058325@frogsfrogsfrogs/
> 
> Do we have to zero args->alignslop here?

No. It should always be zero here to begin with. It is the
responsibility of the allocation attempt that modifies
args->alignment and args->alignslop to reset them to original values
on allocation failure.

The only places we use alignslop are xfs_bmap_btalloc_at_eof() and
xfs_ialloc_ag_alloc(). They both zero it and reset args->alignment
on allocation failure before falling through to the next allocation
attempt.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
