Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C964F1BFDF7
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568906; cv=none; b=Xg7BZuYMG100kjFJz72ezFnFD25tCAb1amWRQTCfXvTR6goIlsu4UDEpUes/FBauU9XllrAUDbZ/7KD8QMFnq2cNe59X/lcNU6OD3SRvbiRhApyXt0dmTFr1aA50xtbpDKyamQXIIAhx4FWzvf3qexOFCOnWKzuAMUuaFa5J9ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568906; c=relaxed/simple;
	bh=/8NBAinZ8EgkzvQXzoDbQ3tLu4qThe0woTws9+sEhHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0muwdBWN5jlm+I/1SZ/Lp9PCBVCb57XemT7MmeK/vmxuWd8/D4c4hEy8qAEcjq31FYt1HTfx4+NBkN57E05/Q6CMCEruX2hK/aCNWdDys5a7OTNAk4odsu9MjuTAYh+GrLVp9rLYZlHRRFyHDt1cWRLJDa6i8egon6kfnGzze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UAIWC8ty; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UAIWC8ty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728568902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z1lT0aWNqnHum+Bslu5Ayu5fpgktm7Iker7z7HQieFA=;
	b=UAIWC8tysAcy87DVR0R1v9KD5/XRl94lAae/tDzPCk/4eMOiFxVf5NJjbL+sXnHFmcUV+E
	LMNHjHAcaH7EIfsJZNxTF58C6S8RV4iNHJYWQu+J/r5am2O3Nom/rQ4ZMt7UgjeStf50rr
	kXgBEMrfMzr95wdbhCQyasq1fbpncl8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-l8wb3KyNMdCHU70RIjAriQ-1; Thu,
 10 Oct 2024 10:01:36 -0400
X-MC-Unique: l8wb3KyNMdCHU70RIjAriQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C82071955F57;
	Thu, 10 Oct 2024 14:01:34 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA5F719560A3;
	Thu, 10 Oct 2024 14:01:33 +0000 (UTC)
Date: Thu, 10 Oct 2024 10:02:49 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <ZwfeiYzopK-iD24Y@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Sep 30, 2024 at 06:41:42PM +0200, Christoph Hellwig wrote:
> Currently only the new agcount is passed to xfs_initialize_perag, which
> requires lookups of existing AGs to skip them and complicates error
> handling.  Also pass the previous agcount so that the range that
> xfs_initialize_perag operates on is exactly defined.  That way the
> extra lookups can be avoided, and error handling can clean up the
> exact range from the old count to the last added perag structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c   | 29 ++++++++---------------------
>  fs/xfs/libxfs/xfs_ag.h   |  5 +++--
>  fs/xfs/xfs_fsops.c       | 18 ++++++++----------
>  fs/xfs/xfs_log_recover.c |  5 +++--
>  fs/xfs/xfs_mount.c       |  4 ++--
>  5 files changed, 24 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec766b4bc8537b..6a165ca55da1a8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3346,6 +3346,7 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3393,8 +3394,8 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
> +			sbp->sb_dblocks, &mp->m_maxagi);

I assume this is because the superblock can change across recovery, but
code wise this seems kind of easy to misread into thinking the variable
is the same. I think the whole old/new terminology is kind of clunky for
an interface that is not just for growfs. Maybe it would be more clear
to use start/end terminology for xfs_initialize_perag(), then it's more
straightforward that mount would init the full range whereas growfs
inits a subrange.

A oneliner comment or s/old_agcount/orig_agcount/ wouldn't hurt here
either. Actually if that's the only purpose for this call and if you
already have to sample sb_agcount, maybe just lifting/copying the if
(old_agcount >= new_agcount) check into the caller would make the logic
more self-explanatory. Hm?

Otherwise the logic changes look Ok to me functionally.

Brian

>  	if (error) {
>  		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
>  		return error;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1fdd79c5bfa04e..6fa7239a4a01b6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -810,8 +810,8 @@ xfs_mountfs(
>  	/*
>  	 * Allocate and initialize the per-ag data.
>  	 */
> -	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
> -			&mp->m_maxagi);
> +	error = xfs_initialize_perag(mp, 0, sbp->sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed per-ag init: %d", error);
>  		goto out_free_dir;
> -- 
> 2.45.2
> 
> 

