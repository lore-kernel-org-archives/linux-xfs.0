Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BAA1DE4EC;
	Thu, 12 Jun 2025 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749751255; cv=none; b=ea2XmogbRg15HIog0o3xw2k2+k9X2Dj33CmLtuyoJlCobRnajxhN1atiPk2xaf8KQlp6QrZ0IZrtEbMpZkzgqxSx6SRjDGBsRHJJeimFbWVjDqkDlI2DrjCFXogqSBgxHx+L6JgkOnPxlyfjKwEVohgosY0rq6tryM/E3Bq/8HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749751255; c=relaxed/simple;
	bh=XZ67z4AvZTTlJfXqDGeb2LDeAoDVG3sdPTCXuPVaTTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrsLnPm0geJooR5WqI3v+aZ8Mm8GR+I/YTeZSBbuzEim+kFuAN2KD9cAeLXJacxamkKcTMRqSLWB8zn8B/xYKiNlr7YqS/rVdonJiaq6b6SgFzhoIeAJ3somvNeBn86Y6M9spOtIVxgnnyUb1wPV2X5pOciyYk6VoLXHdYSXMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FD681A1DBF;
	Thu, 12 Jun 2025 18:00:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 45DD919;
	Thu, 12 Jun 2025 18:00:28 +0000 (UTC)
Date: Thu, 12 Jun 2025 14:00:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: actually use the xfs_growfs_check_rtgeom
 tracepoint
Message-ID: <20250612140027.6655d6ed@batman.local.home>
In-Reply-To: <20250612175111.GP6156@frogsfrogsfrogs>
References: <20250612175111.GP6156@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45DD919
X-Stat-Signature: xg3u6bd3s1ucrari1wbneao8ww6d3jwa
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+VqFJ+19J63HXVgTJeciwPHq0DiHeAbk8=
X-HE-Tag: 1749751228-2520
X-HE-Meta: U2FsdGVkX19UW+4qC9Jss3E9WLJBwDY8btlovxTkB40PpK4TMVtqxWJMJDLO8XIfkzs/uaYivh0H9G9uUYqscz7GdCIjKaLIXpJjOht/+Cmpu92c2haJRlx5583BaThCNV/ucHoDOeOSv38d9fkw6baMmIRxw5g0RtzMJ7RXrQfikOWCr0zU8snHxeHPqO9LyydVCkoNct71DkH/akZW2LGxHQCz3iGTFK9xE3yfHPJeHha/ux6Rnc3bMpg1bR/WxDRx9BcqYZD5VGftzQjkqJOAXQO8AB8bRtCknN9dr2q/3yl9PoLJlI/mzObVk4EuF5q+DPIk69v5ISU1Y3dOqbQpmFogHwOXo0IbhPafQj3wkquCk37qhFvQs7pJPv6YxjCW2nfb2MiMs710dgWMZQ==

On Thu, 12 Jun 2025 10:51:12 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> From: Darrick J. Wong <djwong@kernel.org>
> 
> We created a new tracepoint but forgot to put it in.  Fix that.
> 
> Cc: rostedt@goodmis.org
> Cc: <stable@vger.kernel.org> # v6.14
> Fixes: 59a57acbce282d ("xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs")

May want to also add:

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250612131021.114e6ec8@batman.local.home/

Thanks,

-- Steve

> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6484c596eceaf2..736eb0924573d3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1259,6 +1259,8 @@ xfs_growfs_check_rtgeom(
>  
>  	kfree(nmp);
>  
> +	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
> +
>  	if (min_logfsbs > mp->m_sb.sb_logblocks)
>  		return -EINVAL;
>  

