Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F350E14006
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 20:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709758468; cv=none; b=gRLBWX9GKGQZnhBHLJMo+Dk4p0un8CjTebuvTUn48l+kMLjXHetBoT3MAGWq0NWMxnsOClakUFK8NyNgvjJ4zD99Cz/bfD0Ug7nIjFxFQOeDhN4lY+Lja1qnmQI7+T06kB3H43uaYueJ1vW8+XDm5enXAJuwkCl0vqoXYZIp0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709758468; c=relaxed/simple;
	bh=vDoyC2vhdlxrH71gLPj4oJ9gjwBAUxQmq4klIWJsVLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpXKv++h9su49XvQ9HLZ3CjR9Bs8YP+8x45PnSdtd413t8ENgvegARv+PX/8OkPbOFigLETpeQUyDmJtgUVavQ/Q3IboEpZ9x8OQz/8G3g8IriH3InPDf1GH7pLVP51pAQ/5arUwMh2l95sAWU2FdGMlzp2S4seKZ5JLspDThZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=L3vK2nAo; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="L3vK2nAo"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dcafff3c50so1225935ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 06 Mar 2024 12:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709758466; x=1710363266; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+N0eecURrl+qvmZT/Ue/35NHmLRkoDP9zxRnp5vt+Q=;
        b=L3vK2nAoLWfazj4y0kpgtPxs2+c0zTa88uaifnvlwjhXn2JVjB58ocsYTQRjQ6Ew8i
         flBIKI6Lwz+Q8jnQ7Z1WakmLgoLkG7m4umssgNpqnSf60FwJKd7maS5tnZ+RQMHDgWu6
         Knl5QL8gjzB4i26Oe62EI7xf3tldcyVvuxihAJnk0pAEiBPPEbfzmEJUzDwyIq/AIitC
         OKqjEQ5gEK5JCm5QaneMSIythQDWOm6C+jHn5Ju7U53NEfvtlnh4jeiBvBWkE33sqHfK
         +BsyX60SViyVR3AODxljVPHgok9UaFC1XHCMPZk7brK/fjpKx1w9NOQtQ68lal9IcpX0
         2ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709758466; x=1710363266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+N0eecURrl+qvmZT/Ue/35NHmLRkoDP9zxRnp5vt+Q=;
        b=Z3lP+PyULIdWKG+lRmuWPrGKYwo3gTCScw3lelX2hbSQ0/ZDD60+yIIzif8x1iU4bw
         hmFStor5NeBrTzLWMdaobiD+7XB0NwaXtKVIx0CuTJwGbicikSHo8oyUhc2Uj/xPsT4v
         sDGMT2SxWDtmf0hBTQCOUbRndH221Wa3IDVBkE0G6JYdLU2ozl9K67p5WewIn1gxn0sq
         pdBwI8IpvIowDVI+Jj3f6z4Bk2e3w8Uv+caCZ2kWPe0oP/UQVBZerh2xPRQRM49e9fcF
         DYfnMxVXFvqg97P+Vc8PlAuVvkrI6jeZWULDz35f6SEsUXJNnKXhGssRPQUKEPgoicfK
         LEeQ==
X-Gm-Message-State: AOJu0Yw9zp8exsj4+sOAWdT4GHS6dZs8J4p9aNr9tsQIeSAkjMXD1A00
	0knjCBKDD0B5f1K18gR1g1oHDGxPCGB84EGrNdHkn9vhaaxk4AaEMWqoXKEgUxk=
X-Google-Smtp-Source: AGHT+IEB4VooX+xqGfyaGv/fHQTS9tOS3vTZuML3IW5SzWfFkGyy0QSD9dEGfDG/4qalFdSmwhIamg==
X-Received: by 2002:a17:903:1248:b0:1dc:3517:1486 with SMTP id u8-20020a170903124800b001dc35171486mr7354247plh.49.1709758466141;
        Wed, 06 Mar 2024 12:54:26 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id kv14-20020a17090328ce00b001dcad9cbf8bsm13054592plb.239.2024.03.06.12.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 12:54:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhyHP-00Fxef-1i;
	Thu, 07 Mar 2024 07:54:23 +1100
Date: Thu, 7 Mar 2024 07:54:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [RFC PATCH 0/3] xfs: forced extent alignment
Message-ID: <ZejX/7Eqef7nZ6C7@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <53f4519a-6798-4925-ad5a-5d2d17b6a00f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f4519a-6798-4925-ad5a-5d2d17b6a00f@oracle.com>

On Wed, Mar 06, 2024 at 11:46:38AM +0000, John Garry wrote:
> On 06/03/2024 05:20, Dave Chinner wrote:
> > Hi Garry,
> > 
> > I figured that it was simpler just to write the forced extent
> > alignment allocator patches that to make you struggle through them
> > and require lots of round trips to understand all the weird corner
> > cases.
> 
> I appreciate that.
> 
> > 
> > The following 3 patches:
> > 
> > - rework the setup and extent allocation logic a bit to make force
> >    aligned allocation much easier to implement and understand
> > - move all the alignment adjustments into the setup logic
> > - rework the alignment slop calculations and greatly simplify the
> >    the exact EOF block allocation case
> > - add a XFS_ALLOC_FORCEALIGN flag so that the inode config only
> >    needs to be checked once at setup. This also allows other
> >    allocation types (e.g. inode clusters) use forced alignment
> >    allocation semantics in future.
> > - clearly document when we are turning off allocation alignment and
> >    abort FORCEALIGN allocation at that point rather than doing
> >    unaligned allocation.
> > 
> > I've run this through fstests once so it doesn't let the smoke out,
> > but I haven't actually tested it against a stripe aligned filesystem
> > config yet, nor tested the forcealign functionality so it may not be
> > exactly right yet.
> > 
> > Is this sufficiently complete for you to take from here into the
> > forcealign series?
> > 
> 
> I'll try it out.
> 
> What baseline are these against? Mine were against v6.8-rc5, but I guess
> that you develop against an XFS integration tree. Maybe they apply and build
> cleanly against v6.8-rc5 ...

6.8-rc7 + linux-xfs/for-next + some other local patches to other
parts of XFS that shouldn't overlap with this patch set. I don't
think there's anything in for-next overlapping this code, so it
might just apply cleanly to your tree....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
