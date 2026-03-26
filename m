Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91E3B8D40
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774528315; cv=none; b=et0w6AXXfqyq5r1Fa+8VbW++P7pVCjMVCI4vW+EKhdRUUvXKzl7+VZVOKmCX/y68f9IKasKdg7xdCcdqOKj9Zumk3ERdwZl5tLVzTX5745PRd9CqK8Ix+K8hho/mD8gSZQjrsBW57y7yOZbXWNqhH/dph1dK32sU9h2AAUKaa+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774528315; c=relaxed/simple;
	bh=FQP+lDRdzhGO5Czm/Aiyn8NuE1XKGcPbDuEU7qvu5fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heKR3GfPyS2Ldl1w30J+N9E0q+3mTfmW2MGI1VlmrlDsB0nQAIeU3gLQ3R/WSC1MJ7otmpzOvlQMKSmsIZKwO/DBLq1ZS1O1kp5H2EQZMZC6Yw004J50lGmcyA/epG4s9C6tFTkmP2L6Dtn6ib/cHH53MCl7OMZdqNofD5zOdKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+rexeLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+rexeLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D498FC116C6;
	Thu, 26 Mar 2026 12:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528315;
	bh=FQP+lDRdzhGO5Czm/Aiyn8NuE1XKGcPbDuEU7qvu5fQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+rexeLJLk0l1q5nsAaDxWSDrmXmmjV9D5lG22Qc3tiyaAydK1W96/ByY0bU0JYFx
	 uyeCP65JuTFmlD/1hFsTwL5oP4Ivepg52ppowJWCQH7wyAWtQ3fJV5BvQlF41oYG/x
	 gYDpxGPlIP3O+yzH2r+PGD77YYL50mgWlDpFXpPDw9Akn07WRHpuHmgeGJFNvySCpM
	 j5+Z0vpr+3sFQpbxuXEUE66425+IA20L23P3W1HYwJUkfIQzigqXBluT+e/XBNvsEt
	 p5q7ocEic/e3eQD8g2fP/oTXYkyUNSLdKAUK3CtUkFn0qkCoyBLFZQBWLkJsCGbfI5
	 5GEiWXLkfi9gA==
Date: Thu, 26 Mar 2026 13:31:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david.laight.linux@gmail.com, 
	rostedt@goodmis.org
Subject: Re: [PATCH 3/3] xfs: remove file_path tracepoint data
Message-ID: <acUnLT6dg3oupPPt@nidhogg.toxiclabs.cc>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210433.GO6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210433.GO6223@frogsfrogsfrogs>

On Mon, Mar 23, 2026 at 02:04:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfile/xmbuf shmem file descriptions are no longer as detailed as
> they were when online fsck was first merged, because moving to static
> strings in commit 60382993a2e180 ("xfs: get rid of the
> xchk_xfile_*_descr calls") removed a memory allocation and hence a
> source of failure.
> 
> However this makes encoding the description in the tracepoints sort of a
> waste of memory.  David Laight also points out that file_path doesn't
> zero the whole buffer which causes exposure of stale trace bytes, and
> Steven Rostedt wonders why we're not using a dynamic array for the file
> path.
> 
> I don't think this is worth fixing, so let's just rip it out.
> 
> Cc: rostedt@goodmis.org
> Cc: david.laight.linux@gmail.com
> Link: https://lore.kernel.org/linux-xfs/20260323172204.work.979-kees@kernel.org/
> Cc: <stable@vger.kernel.org> # v6.11
> Fixes: 19ebc8f84ea12e ("xfs: fix file_path handling in tracepoints")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/trace.h |   12 ++----------
>  fs/xfs/xfs_trace.h   |   11 ++---------
>  2 files changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 39ea651cbb7510..286c5f5e054449 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -972,20 +972,12 @@ TRACE_EVENT(xfile_create,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(unsigned long, ino)
> -		__array(char, pathname, MAXNAMELEN)
>  	),
>  	TP_fast_assign(
> -		char		*path;
> -
>  		__entry->ino = file_inode(xf->file)->i_ino;
> -		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
> -		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
>  	),
> -	TP_printk("xfino 0x%lx path '%s'",
> -		  __entry->ino,
> -		  __entry->pathname)
> +	TP_printk("xfino 0x%lx",
> +		  __entry->ino)
>  );
>  
>  TRACE_EVENT(xfile_destroy,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb7a..91c4c9422c8739 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5091,23 +5091,16 @@ TRACE_EVENT(xmbuf_create,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(unsigned long, ino)
> -		__array(char, pathname, MAXNAMELEN)
>  	),
>  	TP_fast_assign(
> -		char		*path;
>  		struct file	*file = btp->bt_file;
>  
>  		__entry->dev = btp->bt_mount->m_super->s_dev;
>  		__entry->ino = file_inode(file)->i_ino;
> -		path = file_path(file, __entry->pathname, MAXNAMELEN);
> -		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
>  	),
> -	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
> +	TP_printk("dev %d:%d xmino 0x%lx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->ino,
> -		  __entry->pathname)
> +		  __entry->ino)
>  );
>  
>  TRACE_EVENT(xmbuf_free,
> 
