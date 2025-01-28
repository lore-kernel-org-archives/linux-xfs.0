Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046C18BC3F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 06:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738046645; cv=none; b=pdVMWYIQj7MyqHB6gRMzAoIezn5pEo3uR0Z0y/kTRsdGXxA0ClE5giRhEKKMXlyXXkshhrG+nRczNplCxbcgZYUe+Nh+z1WKtOT7ElEJ7LF/lAzi2VM4cinqeoXHae5Oc1i+rvY4cpzJmlfUmVI4dmb7cAGJDbctd1L2ijZoK50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738046645; c=relaxed/simple;
	bh=eFPg/mpxLFtfrAGnuVnPbc+k8sXCnhUZNyvxju+tVTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XHNy2AVl+dVl+PsJYTBpyi42JAxpEs8Stmvgv0kcGRD3r+5UYtA+w2MTETlFWrJJKo879ltmAeP3KdnwWEV1SAN+RS2kzR713TdBMD2zISTpKADHiXWx3AjCvqtwBWlW8XkDvqotdrS2n5HSAYfxHPPlYuH0VKmEfI5WuHWZFbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OabfFJgw; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OabfFJgw"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21661be2c2dso89557105ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 22:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738046643; x=1738651443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukz2gQSSnzbjXzqDlsR3AW5c1pfnNPgMkqcXT8m+jOY=;
        b=OabfFJgwY8gT+NZTJJlxubEgdhL1YY+mOpnajlDbqEX2dAJHFtlOjraySDwwGb0tTC
         SMXlZApvZjXl97K/cQufmExz55YDIkqiNvLLcw1SfQ9EMpM4O/Udx05yMuqrumRe3cpS
         so0pCzdMgevYDXcsxHbWjCaBEyNK6V1YeIx0X+GtoTySG2ecg2zHzoDlNZNp7UVNLyxu
         E+hpmQ9eoC8VOuGX0bxFfJlghK/OC447c6pIoelHu71RgSBKqZWsvav/NKYZzpJ/mtzK
         QI15m1iYnlPQfgGDLVFzZ4zwnc4J2nCt6LsucBpzhyG+N4WAqJ1oBCA9rvdBjuQcE/He
         I6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738046643; x=1738651443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukz2gQSSnzbjXzqDlsR3AW5c1pfnNPgMkqcXT8m+jOY=;
        b=HikirvEIp1uK4ZEhn2mK7ieZdTfU52AopxKzqkIpMFhB7t9ERl+qmvIQ6QkmcYr1AH
         a6OsQypXgj99bAKxroKEXeiYxEOe/bnFNcvtLOe/YQV1LYmwcHTE2hHRDBLdYvsZpqNA
         c89EyzsHB3I3AICZGBf61LPpVursotC4CqHRMbFSH6BNCDaWWcEDlhe0V/asCVdfOPuO
         Jjh1gpYtXUa6vcCSGhCdtSxHgZuEREHoUjafe1kl67td1sRTR4QCgkRy+lvQerElqyQZ
         RkPMbLaMQxB9xts/6wB6Cz/tWrC35anymxaa2i7MsD2/iA7cJXN548nuK7dNYFAEcvQ5
         288w==
X-Forwarded-Encrypted: i=1; AJvYcCVE6XNuZoJnaCrzUu037S1po1rWPZCw/b0qCDPz/nNQgQn/KjHk/25bvCZCvqMUVAB9Sp2QIBBH+7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTeVeGdzQACbBbn/w0Ty6K2kr3WEmWUPaG2RTMKaAooCe5UsbA
	Q6klXIchFfmEDXIQCeencUW8K2ri6kQR/n2cHyMN+EtF07nYvGGsV8M/IXuCoaE=
X-Gm-Gg: ASbGnctjwFcMIo+tSDmkElDy/PrVIwZrLBz9nC+nIP0miv5pm9L4lE/E2Ewa5AnvdFQ
	eLgztU8KvhzC7+cudZUMRHTbGjTZrysb9S72TaGXtIHtg8ai/dRrPiHmRAzwz9Mif8y8mRFhLWF
	IaLJgK60SEK1+xYWvpj8i6efq6HjS6m7e6QcVlTOu/WWdeuXQ8OkDfrw+Q9kTkqd8dn6OIZj+KD
	KObQQEiyLd2sl0oEtwxpLIECwImDTFq152yoJLQPGJqkr6fIcIkKzi0/eRXagzJHdTs0iXOdzQQ
	GA0Fx3p1b63AXSHD2V233cpT/UESYWwaVUZJ38+/Vvr9tCnUFfjwlW1y
X-Google-Smtp-Source: AGHT+IFIULr5DOo+IpqDEY0tscaTY7rlZBmDgosaw+lahDpJcaIFvcIHQoRR2CnA3eM5Pmqg6EvQTQ==
X-Received: by 2002:a17:902:e5ca:b0:215:b473:1dc9 with SMTP id d9443c01a7336-21c355fa313mr597717805ad.46.1738046643498;
        Mon, 27 Jan 2025 22:44:03 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac490acd735sm6305715a12.44.2025.01.27.22.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 22:44:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcfKK-0000000BTwW-0fdY;
	Tue, 28 Jan 2025 17:44:00 +1100
Date: Tue, 28 Jan 2025 17:44:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, "Lai, Yi" <yi1.lai@linux.intel.com>
Subject: Re: [PATCH] xfs: remove xfs_buf_cache.bc_lock
Message-ID: <Z5h8sOZmA-1WHybn@dread.disaster.area>
References: <20250127150539.601009-1-hch@lst.de>
 <Z5fqPyqU4KTSMGyh@dread.disaster.area>
 <20250128050613.GA18688@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128050613.GA18688@lst.de>

On Tue, Jan 28, 2025 at 06:06:14AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 28, 2025 at 07:19:11AM +1100, Dave Chinner wrote:
> > Ok, so now we can get racing inserts, which means this can find
> > the buffer that has just been inserted by another thread in this
> > same function. Or, indeed, and xfs_buf_lookup() call.
> 
> Yes.
> 
> > What prevents
> > those racing tasks from using this buffer before the task that
> > inserted it can use it?
> > 
> > I think that the the buffer lock being initialised to "held" and
> > b_hold being initialised to 1 make this all work correctly,
> 
> Exactly, the buffer is inserted with the b_sema held and b_hold
> initializes 1, aka locked and held.
> 
> > but
> > comments that explicitly spell out why RCU inserts are safe
> > (both in xfs_buf_alloc() for the init values and here) would be
> > appreciated.
> 
> Sure.

Thanks.

> > >  struct xfs_buf_cache {
> > > -	spinlock_t		bc_lock;
> > >  	struct rhashtable	bc_hash;
> > >  };
> > 
> > At this point, the struct xfs_buf_cache structure can go away,
> > right?  (separate patch and all that...)
> 
> Yes.  And in fact I think the per-pag hash should also go away, as with
> the per-bucket locking there is no point in it.  I've had this patch in
> my testing runs for a while, which I think is where we should be
> going:
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=890cd2cd255710ee5d3408bc60792b9cdad3adfb

*nod*

Code seems reasonable, but it'll need some benchmarking and
scalability analysis before merging...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
