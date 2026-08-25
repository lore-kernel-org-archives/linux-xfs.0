Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CCA3B14D6;
	Tue, 25 Aug 2026 06:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640023; cv=none; b=tCRvstavqLMGVyF5/skWPMKkDKHN/z4pAGkMga0wZbGmVG+fURthOhCxvdRMWKe53iK9l861MT77FNX3vXdMf4eQieSQQNabyYSSyZXind7YQ6cufXtccSV2vhbwBCfNXOVo55fpbt50Ell8MC4SQQbSlWeHK/puTj1VzM3GHAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640023; c=relaxed/simple;
	bh=rpJfdotnG56wr0gfaDItxSymmdriLdT1l07a85QKbbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYUIlH1J8xhZzWPNfjCrTaJg1Dhd/yN4ktY59Hie21q4P8V28EVy5sDKLKQIkZ0t0RQChRlYEiky1snItdaVGu3LIztz/dssH0cAb/nO4qTuywHpXGLvHyxqwE7jxHXGViSAKcPf1lEij10OIvw7VuxHYExN5mlP9fmRLYBUE5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDCF368BFE; Tue, 25 Aug 2026 08:40:17 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:40:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260825064017.GA24532@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760941102.944364.11828316232110118627.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:36:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that __xfs_healthmon_insert purports to insert a
> xfs_healthmon_event event at the start of the event list, but neglects
> to update first_event to point to the unmount event if there were
> already events in the queue.  That results in list corruption, so let's
> fix this problem.

I can't really follow this..

> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index d8b95af33a3e9f..166ef0d5864486 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -276,8 +276,7 @@ __xfs_healthmon_insert(
>  	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
>  
>  	event->next = hm->first_event;
> -	if (!hm->first_event)
> -		hm->first_event = event;
> +	hm->first_event = event;
>  	if (!hm->last_event)
>  		hm->last_event = event;

event is the newly inserted event.  We want to queue it at the
head of the list (why, btw?).  The next point in event points to
first_event (which can be NULL).  And first should always point
to event, otherwise we potentially never queue anything up?  I.e.
we never ever actually set first?  Not sure how that is related
to umount.

Maybe this should just use standard list_head-based lists even
if they waste an extra pointer in the event structure?

