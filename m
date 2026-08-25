Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067CA3BAD88;
	Tue, 25 Aug 2026 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640297; cv=none; b=A4XRJM9iOjhWW4MIzLp6FYxUKrh5IbMJRbnKhL2IYHVisOO1utZl2PB/esfgdDU3eJGsqpx7aWyRpeifs4A3BOPT5xHqBcNZr3+BMDsrSMx01yMmkscKrNcoCg5QRNYX0zG0sGjMif94dAP1ruBb2RWYQC8X1KUYdz8w+T49ySk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640297; c=relaxed/simple;
	bh=gcLGT30jo02+QcsxQZoTkWWtffp90Fntidtsqo56iTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmmnhIKXDJGVKNWZjfAMUluNM76BrNQqD3tCdldB3dP3sVVAFMFT/InJHCt2o15432XXoKwLmkaBVbcYl5bgtoe/BV5zREM0IhHuT05YW55VWX7C1tvslFrrqLjdzFmcW98KhGCUs5qazorBHwYyZ530Ww6Tb9QEZvH8J1/c0vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0EF5968BFE; Tue, 25 Aug 2026 08:44:52 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:44:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: check healthmon outbuffer space correctly
Message-ID: <20260825064451.GB24532@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941123.944364.14413050986149192404.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760941123.944364.14413050986149192404.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:36:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that the outbuf space check in xfs_healthmon_format_pop
> isn't quite correct -- it checks that there's enough space to write a
> xfs_healthmon_event object, but the outbuffer is supposed to contain
> xfs_health_monitor_event objects.  Fix this by adding a helper, and
> refactoring all three outbuf size checks to use it.
> 
> Cc: <stable@vger.kernel.org> # v7.0
> Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/xfs_healthmon.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 166ef0d5864486..a2ae15a262a510 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -739,6 +739,12 @@ static const unsigned int type_map[] = {
>  	[XFS_HEALTHMON_DATALOST]	= XFS_HEALTH_MONITOR_TYPE_DATALOST,
>  };
>  
> +static inline bool
> +xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
> +{
> +	return hm->bufhead + sizeof(struct xfs_health_monitor_event) <= hm->bufsize;

Overly long line.

>  		memcpy(hm->buffer + hm->bufhead, &hme, sizeof(hme));
>  		hm->bufhead += sizeof(hme);
>  	}
> @@ -891,7 +897,11 @@ xfs_healthmon_format_pop(
>  {
>  	struct xfs_healthmon_event *event;
>  
> -	if (hm->bufhead + sizeof(*event) > hm->bufsize)
> +	/*
> +	 * Don't bother if there's not enough space to format even one event in
> +	 * the outbuffer.
> +	 */
> +	if (!xfs_healthmon_check_outbuffer_space(hm))
>  		return NULL;
>  
>  	mutex_lock(&hm->lock);

This is a bit annoying as we now require the type name instead of an
object, and the v0 implies there could be other formats.  But I guess
for now it is fine..
