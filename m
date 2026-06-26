Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEC6279329
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 05:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450270; cv=none; b=u18gmSLai60sYtJiNAG6TynM5cUuofDtgvYSFahu9U8SEgmmK5Z4a1krlbP4kPAeL3+lX/ZLuNU/MrJnKrQvrS4gHQxkOKOM6EECjp9gqZETGkqJplh04D+MrvUEQweDLygb17E3vcYsqmXEiqhFLe0WJVuY2ESvKfPkY/dlbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450270; c=relaxed/simple;
	bh=csmsAbYlceNk/U3SNHDUuHmJGTptzs9pCWHURoic9YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdVNIacvU9Tt5YMlJapP0yLTldcU6qRO7kvyptR5BquX7oC8Sb+CDDX+2GH2F6uxQd9hXwiB54kRqdSeVxd1zkCKBXLr8+RfqHOPdpJEaCMg06qFU5EauFgZpPjkLTFaEUUI71rcbvxw2qmVFlUiMDewo5AA4NbUKDZW152RWuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9106C68B05; Fri, 26 Jun 2026 07:04:26 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:04:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/8] xfs_scrub: fix estimate of work items for phase 4
Message-ID: <20260626050426.GE8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801396.1981574.2199805727145890150.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178242801396.1981574.2199805727145890150.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:55:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complains that the number of work items computed when estimating
> the amount of work for phase 4 doesn't include the FSCOUNTERS and
> QUOTACHECK items.  Add them back in.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  scrub/phase4.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/scrub/phase4.c b/scrub/phase4.c
> index 6bd16c23939eb4..744fd92ab195f4 100644
> --- a/scrub/phase4.c
> +++ b/scrub/phase4.c
> @@ -297,6 +297,10 @@ phase4_estimate(
>  	need_fixing = action_list_length(ctx->fs_repair_list) +
>  		      action_list_length(ctx->file_repair_list);
>  
> +	/* fscounters and quotacheck */
> +	if (need_fixing)
> +		need_fixing += 2;
> +

This matches the commit message, but there does this come from?
Why are fscountれrs and quotachck special?

