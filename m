Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803DF155382
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 09:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720519047; cv=none; b=I5SuZAuTEujUPUXDcj+Z9kIavSEFiuIk98j4VddtffsYsJbf2xiaMAnOGlBAcAQxSLD/E374S1gK3NeqOmeDYeaknDTU4CQUmKFdkuscyTAz/Nlas6cRznqEbVbQ7K2Xjhm+CBazkmOewyM/I+5Gmw8hlKNr+AB85smnJBN2jy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720519047; c=relaxed/simple;
	bh=aEPWqt4EkE+1dZwNyihdiQTNmdiVdPEo/G9muf2rBrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXv2rWk1oY2jlDZ3at0bOkIQgJ3hD29Gbe6q9N4g487TKqXTccKZ/u71KAXXhmaRZAmN1LYvtbtdFLRByeCW2qe02vdovNxmVd0iVDhO8kt4GTvCbpn7rKQCutM/1WJPuMk7VzDH45D5v5E32EJ2L6A+omiIpS/dVTRpDR+Jm6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=X+yZjLrZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="X+yZjLrZ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso3389013b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 02:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720519046; x=1721123846; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oOyqcxyb5IwP9Eq+BrWEYtwo3uCUMmyhSGduwVBkBvQ=;
        b=X+yZjLrZuZAeWg27u4qroP5kWgGzhHjBF8gBIFzVldSEc2Kxae/Z8wQAK2xr9GKY31
         6CHC0VinoYGpSJ8NGCWrtRBRh1XXS3Uzy3i6UgI+7kjD7oWZiSbbmy35cjnhvupGyE4T
         sp0mp1yirmxg3T1IgK5QI5Gx38zUkbRZP+HXFmX+JP38XFJb/T/7DCuY1Ck7hrPUBF1R
         fVnghyHdOfEQhi5exZFVgx0Xd9zsVWTk6Fm29jeepqCsvnPoEvsaeEk+rN3FU4Tnm9ND
         6txOO7/rRJOGyTYoWsgasGhGq1h3af1A2txDkgXnCxsj0eq+kDdj/uEAElXduqOMVozP
         V8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720519046; x=1721123846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOyqcxyb5IwP9Eq+BrWEYtwo3uCUMmyhSGduwVBkBvQ=;
        b=BQs+e3mQd95Xjbamqa8jWHhcjtlR3nOgzGNw1s5pK2Os/1Q44SPKC7WAotQ2zrDvJU
         eEUzP4sqfhX0nrulGh7nde66/IVd33l1a8czNvqk9wvEVUrvlYGA+bVYnWRAUYVXX37S
         1Rncc26LYc4gXpj8yU8WVnnql00hXXcyoIXcIMQZWKOCG1QSH3HRLg2yEEYRMysJfFof
         vjs3S2+FPQRu17wLA4kQgVBtkI44Vm1vgXKKrabilbFwaDsLLYT8pfMGPXyYth8DSUzy
         LUAzDEai15KmMWoGrJum2ee1ecaIX48Sx86t0U15wVZj2BgBXnEA127SgOEnhurxETN0
         kkZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIxO/4TY2OtiNuG50jZqS5aOmhy5eZIBOrk57S08ycLYm4JWqxdJWG0lEFBr6j7TNGPVyx3mr9qNwSHjhZ6vnitjnwOu9H8k5a
X-Gm-Message-State: AOJu0Yy0Oh/t0GHVih7SvxG15VDj73WHSQ+oFCimld/nG9cg5BVJ7WzF
	ssXoBDDLl/BJL5D8gP/Pn13evN15zcRh7wEx1lb8jln64iHQD3Xu5xEKZyKxTuw=
X-Google-Smtp-Source: AGHT+IFMGvAPzINU+Gs4ZFgsoFRoQvo0clRLF0utSQEN97hfaP88j88mC5MzvN9RYzCJoVB3MRsbWg==
X-Received: by 2002:a05:6a20:734c:b0:1c0:f6b7:a897 with SMTP id adf61e73a8af0-1c2982285f2mr2354821637.32.1720519045687;
        Tue, 09 Jul 2024 02:57:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-77d5f0aaf55sm1096674a12.11.2024.07.09.02.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 02:57:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sR7b8-009ZB3-2w;
	Tue, 09 Jul 2024 19:57:22 +1000
Date: Tue, 9 Jul 2024 19:57:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	djwong@kernel.org, dchinner@redhat.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2 10/13] xfs: Unmap blocks according to forcealign
Message-ID: <Zo0JghFEaqxBs41l@dread.disaster.area>
References: <20240705162450.3481169-1-john.g.garry@oracle.com>
 <20240705162450.3481169-11-john.g.garry@oracle.com>
 <20240706075858.GC15212@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706075858.GC15212@lst.de>

On Sat, Jul 06, 2024 at 09:58:58AM +0200, Christoph Hellwig wrote:
> 
> > +			if (isforcealign) {
> > +				off = ip->i_extsize - mod;
> > +			} else {
> > +				ASSERT(isrt);
> > +				off = mp->m_sb.sb_rextsize - mod;
> > +			}
> 
> And we'll really need proper helpers so that we don't have to
> open code the i_extsize vs sb_rextsize logic all over.

We already have that: xfs_inode_alloc_unitsize().

Have the code get that value, then do all the alignment based on
whether it is allocation unit size > mp->m_sb.sb_blocksize. Then all
the calculations are generic and not dependent on forcealign or rt,
but on whether the inode requires multi-block contiguous extent
alignment....

i.e.
	alloc_size = xfs_inode_alloc_unitsize(ip);
	if (alloc_size > mp->m_sb.sb_blocksize) {
		/* do aligned allocation setup stuff */
		.....
	}
	....

No code should be doing "if (forcealign) ... else if (realtime) ..."
branching for alignment purposes. All the code should all be
generic based on the value xfs_inode_alloc_unitsize() returns.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
