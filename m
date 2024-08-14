Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFD14D8AF
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611568; cv=none; b=OHScsLU9PqLRnI8gLypAFxaS41RMVklfvNSxvFNZxCE0M3/fw7s1v1yED4YrGjiPhr8e6s6dYVqKSB1oeXD80lSsQnc1KtahsXmS67qruNktwqsvhE4eyPkX/nyuknkW7NU1Eff/spW4/3RayB8KNIzkSjlt8TWqdTV4APZZkfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611568; c=relaxed/simple;
	bh=N0sUmJT0wjmV/m+WHFZMycnAPET6uKJCQrUyePt9ayY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JA4ObhYHt7YFbqeC6GQxLhkCTvHZi+eruJuXXUnSmNg3YTWgudl53zZ501uNsgYQjccTjjgOe6HsuFmcMiPDz0Bbn9dk+twrE6wdjs9uHgg0UrUkuwfgdkUNvNX/mp9/nrzF797Nd9u67SBhH7fc7qwNGw9zLlCkN785ukKDO3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oMiWrhK3; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oMiWrhK3"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2d1ecfe88d7so3491235a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 21:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723611566; x=1724216366; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q9hs9yPPIjAFKNvPKQSLvy6Q7Cm9t0oU+bjgW2/ohow=;
        b=oMiWrhK3D/eiaMcT9CdZKFxRdCxGstjQQLDGII1fBnwx+Be3R1NsdqfGqX3DpTqALV
         LhkGsspSa86/eIQ7t8/DUlE988rS3LlIMZZl/dfn6sakXLFfOZBFmEMx/5zcdp6ITYpc
         5TcFYjl+N0NjiRjkc6prIx4w0Pe3h1oPi61QT6g7lEtbPYRJhwwZ461NtwepwQ3y+T2y
         e9ose6GlNtsdNelhJh46ANBHjQMOorq+v4VS4/fJGghjz2sQX/OJ+7/ui4cnXAbJZGx+
         5G5PpVNgMSCEZwDgwtRIkPGOw2+u7vpuNXR8i+fcPLwINr7E6cSSTym0iDJqkF+zdniU
         u7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723611566; x=1724216366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9hs9yPPIjAFKNvPKQSLvy6Q7Cm9t0oU+bjgW2/ohow=;
        b=Zco5y7K+qsdz6zLK9aZ0xJ5WFmdSS61xB9EOlVvcDLWxzn6XzfcF9FZ4XuDNvDghNA
         aGNJNHOxwMGaHiqD62UdWOGHqGD0QQhx2eynicwxA0WP5Mio9iCkuRsAYMv6CX0ml+2Z
         zH6iWAh9souiSXj/l34VR/RMfHILqEk257yt42M7EVvMPBbkWlB1Vb8qGvu0cAI3SJL6
         D+ylroFxi0AchLW1CFKyR1hVLPzMagZx7rl+xBXL0O2QXOECwSpHKxkKSSKLlTdS8aD7
         bcX/D0zp923dr+oDQqjz5Xsdo27gGk2yJLXfPMvMo+9+zBVlhRyJ6o+KNTF6JQ4oVlTg
         /K0A==
X-Forwarded-Encrypted: i=1; AJvYcCVNlvp5sTFvQLoe6RGrrg/e5yoswb2MWpcOnsFFHPWAX8nOgIFN0QZFyCFzG2DNzrEGjyw3NhspUm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeoYQEKwWcEVPYTxNWfGaUgdyaIledf5slSRE2xj/k+0xHEMZB
	335IMLStJ9sb7LGqesRC+u+wNi61VrDGtYclr3mfWovu2PHY94+LD8gJriIOLSc=
X-Google-Smtp-Source: AGHT+IERVX43gOXYdcf3KbRYaCL9u9fdteGqPIVuHakd/aJAOk7ZsngokahozzcvU6RwEvf5ewwQoA==
X-Received: by 2002:a17:90a:c909:b0:2ca:a625:f9e9 with SMTP id 98e67ed59e1d1-2d3aabad914mr1819772a91.42.1723611566502;
        Tue, 13 Aug 2024 21:59:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3ac856c64sm539189a91.55.2024.08.13.21.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 21:59:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1se66V-00GQUx-2q;
	Wed, 14 Aug 2024 14:59:23 +1000
Date: Wed, 14 Aug 2024 14:59:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: convert perag lookup to xarray
Message-ID: <Zrw5q0qTi9m8AT6+@dread.disaster.area>
References: <20240812063143.3806677-1-hch@lst.de>
 <20240812063143.3806677-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812063143.3806677-3-hch@lst.de>

On Mon, Aug 12, 2024 at 08:31:01AM +0200, Christoph Hellwig wrote:
> Convert the perag lookup from the legacy radix tree to the xarray,
> which allows for much nicer iteration and bulk lookup semantics.
> 
> Note that this removes the helpers for tagged get and grab and the
> for_each* wrappers built around them and instead uses the xa_for_each*
> iteration helpers directly in xfs_icache.c, which simplifies the code
> nicely.

Can we split the implementation change and the API change into two
separate patches, please?

I have no problems with the xarray conversion, I have reservations
about the API changes.

I hav eno idea what the new iteration method that is needed looks
like, but I'd prefer not to be exposing all the perag locking and
reference counting semantics all over the code - the current
iterators were introduced to remove all that stuff from existing
iterators.

This patch makes iteration go back to this model:


	rcu_read_lock()
	xa_for_each....() {
		/* get active or passive ref count */
		....
		rcu_read_unlock();

		/* do work on AG */

		/* put/rele perag */

		/* take RCU lock for next perag lookup */
		rcu_read_lock();
	}
	rcu_read_unlock();


And that feels like a step backward from an API perspective, not
an improvement....

So what's the overall plan for avoiding this sort of mess
everywhere? Can we re-implement the existing iterators more
efficiently with xarray iterators, or does xarray-based iteration
require going back to the old way of open coding all iterations?

> @@ -1493,21 +1497,32 @@ xfs_blockgc_flush_all(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> +	unsigned long		index = 0;
>  
>  	trace_xfs_blockgc_flush_all(mp, __return_address);
>  
>  	/*
> -	 * For each blockgc worker, move its queue time up to now.  If it
> -	 * wasn't queued, it will not be requeued.  Then flush whatever's
> -	 * left.
> +	 * For each blockgc worker, move its queue time up to now.  If it wasn't
> +	 * queued, it will not be requeued.  Then flush whatever is left.
>  	 */
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> -		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
> -				&pag->pag_blockgc_work, 0);
> +	rcu_read_lock();
> +	xa_for_each_marked(&mp->m_perags, index, pag, XFS_ICI_BLOCKGC_TAG)
> +		mod_delayed_work(mp->m_blockgc_wq, &pag->pag_blockgc_work, 0);
> +	rcu_read_unlock();
>
> +	index = 0;
> +	rcu_read_lock();
> +	xa_for_each_marked(&mp->m_perags, index, pag, XFS_ICI_BLOCKGC_TAG) {
> +		if (!atomic_inc_not_zero(&pag->pag_active_ref))
> +			continue;
> +		rcu_read_unlock();
>  
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
>  		flush_delayed_work(&pag->pag_blockgc_work);
> +		xfs_perag_rele(pag);
> +
> +		rcu_read_lock();
> +	}
> +	rcu_read_unlock();

And this is the whole problem with open coding iterators. The first
iterator accesses perag structures and potentially queues them for
work without holding a valid reference to the perag. The second
iteration takes reference counts, so can access the perag safely.

Why are these two iterations different? What makes the first,
non-reference counted iteration safe?

>  
>  	return xfs_inodegc_flush(mp);
>  }
> @@ -1755,18 +1770,26 @@ xfs_icwalk(
>  	struct xfs_perag	*pag;
>  	int			error = 0;
>  	int			last_error = 0;
> -	xfs_agnumber_t		agno;
> +	unsigned long		index = 0;
> +
> +	rcu_read_lock();
> +	xa_for_each_marked(&mp->m_perags, index, pag, goal) {
> +		if (!atomic_inc_not_zero(&pag->pag_active_ref))
> +			continue;
> +		rcu_read_unlock();
>  
> -	for_each_perag_tag(mp, agno, pag, goal) {
>  		error = xfs_icwalk_ag(pag, goal, icw);
> +		xfs_perag_rele(pag);
> +
> +		rcu_read_lock();
>  		if (error) {
>  			last_error = error;
> -			if (error == -EFSCORRUPTED) {
> -				xfs_perag_rele(pag);
> +			if (error == -EFSCORRUPTED)
>  				break;
> -			}
>  		}
>  	}
> +	rcu_read_unlock();
> +

And there's the open coded pattern I talked about earlier that we
introduced the for_each_perag iterators to avoid.

Like I said, converting to xarray - no problems with that. Changing
the iterator API - doesn't seem like a step forwards right now.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
