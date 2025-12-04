Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A21917FB
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764840727; cv=none; b=i2D32l354oggZ6kZ3ZKApnvBlKNzP9UP0EzuUOeuPl9YRGmZOBwxn/fHWaTazIqaQHP/q5Bw0LgZzd9np1UIv62A0GY8Lvul3MKHNFGVtKE+uHhZTu50Y0eLYIK1vwxHShzLMCAFgoZBw6DkVAivADhYW0ITW1uRvCOotFgfEdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764840727; c=relaxed/simple;
	bh=o1/gA76yom3wVfWKzDlbn9UWMFjoMslATToxh4Qid3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihFqHY0M3FjCD2BKmY0cILenVABYLNX7r110uWUUP7Yar66FXJimW2APxZebiOqJ6yOstkDsyk0dCeo9soKs60QRycwIn1pN4qRtcv1wh+O1FP1jPxhTLC7SVFVJc7z0/fjkslJJbmFh6cXLoXDDbKWcTj55SC/JoSexL3FnYbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BCCEA227AAF; Thu,  4 Dec 2025 10:32:02 +0100 (CET)
Date: Thu, 4 Dec 2025 10:32:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, hch@lst.de, preichl@redhat.com
Subject: Re: [PATCH 23/33] xfs: convert xfs_buf_log_format_t typedef to
 struct
Message-ID: <20251204093202.GC19971@lst.de>
References: <cover.1764788517.patch-series@thinky> <qptxxayqxie4vwryddds36sofs44zufqo3wes6j4dfehl2jxoq@3ioxr4fnyynb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qptxxayqxie4vwryddds36sofs44zufqo3wes6j4dfehl2jxoq@3ioxr4fnyynb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 03, 2025 at 08:09:48PM +0100, Andrey Albershteyn wrote:
> Convert xfs_buf_log_format_t to struct and retab arguments for new
> longer type.

I think all these patches should go before the removal?

> 
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  include/xfs_trans.h      | 10 +++++-----
>  logprint/log_print_all.c | 18 +++++++++---------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index d7d3904119..a3e8a000c9 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -46,11 +46,11 @@
>  };
>  
>  typedef struct xfs_buf_log_item {
> -	xfs_log_item_t		bli_item;	/* common item structure */
> -	struct xfs_buf		*bli_buf;	/* real buffer pointer */
> -	unsigned int		bli_flags;	/* misc flags */
> -	unsigned int		bli_recur;	/* recursion count */
> -	xfs_buf_log_format_t	__bli_format;	/* in-log header */
> +	xfs_log_item_t			bli_item;	/* common item structure */

This should be struct xfs_log_item.

> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index 39946f32d4..bbea6a8f07 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c

And this clashed with the series I had, which also splits things up.
But I guess we should just do the quick conversion given that you've
done all the work and I was too slow.

