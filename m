Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FA74B1B3F
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443558; cv=none; b=uQ2G0julGsPPzotM9W/ITj07z96mCAradUdvnlLtVGdTNUfzL+is1QKbyIZRz9H4pnk+oeCjHxhm8zOAFVWzXQTmbQtbKMvbPv6FJSMtPSPO11VVurCuThOoMaFdbNPL1oMqPOME7vhaa60HQ3HMqgNphI0gVM6lpeu9UR06LF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443558; c=relaxed/simple;
	bh=Iji4D2buWPRLhZoxA1uH9NERFPm7OneKA3HE03sRbkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UK5ThLYI1XhJRZEOKRcvHJ/VTetjPPtB9vodOp3kM+yMlG1u+DWb38iVhJnc8rP+hAo5tuoYQgakYxx6as9Pxl/FkOinGKo56aCnOjWzOyOvhLXoTkYUGMWj/yVX3y9Q1ATb+zg5SppVVGQji5HVk6ieWGMRxpksSRK3SydWTeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OWEIGGmQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWEIGGmQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788443537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYValkT1RfLf8KNyXAg43KyIUolG/6q8D740NY7N3y0=;
	b=OWEIGGmQKYVHSOLO41Jor1RzhFe2pcLYt2cihwxGesQQNMJXIQitgf97DjxWtIeHfeA1TX
	Opls2oJwpbTdBfhyN2uwEThkCDpyOynTIeQ/lDZU6PYdTES+Q7FMZdpVAc1kjpWoI+cEmO
	H7oay6tt+WB+aOphPMSRHhLZACo/Wig=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27--MjhSEGMNGGbQ1VSHW1TjA-1; Thu,
 03 Sep 2026 09:52:14 -0400
X-MC-Unique: -MjhSEGMNGGbQ1VSHW1TjA-1
X-Mimecast-MFC-AGG-ID: -MjhSEGMNGGbQ1VSHW1TjA_1788443530
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1174190FF8E;
	Thu,  3 Sep 2026 13:52:09 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 830C73000239;
	Thu,  3 Sep 2026 13:52:06 +0000 (UTC)
Date: Thu, 3 Sep 2026 09:52:04 -0400
From: Brian Foster <bfoster@redhat.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <apl7hNnt0lR5HFXA@bfoster>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> Use memalloc_nofs_save/restore with a local variable instead so
> tp->t_pflags is never touched.
> 
> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

I agree that the Sashiko analysis looks correct. The only thing I wonder
is whether it might be a bit cleaner to have the set_context() helper
return the context instead of hardcode the assignment to ->t_pflags so
it can be used in both places. The reasoning is just that the current
arrangement kind of makes it easy to repeat this mistake in the future.

Then again, it's a single line helper so maybe another option could be
to just remove and open code it. I suppose the pro of keeping the helper
is that it's a decent spot to document the concern and why it returns a
value, etc. *shrug* Thoughts?

(Please don't change this patch just on my comments alone. Let's see if
others have input first..).

Brian

>  fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 6738d9d1511b..8ae4b94e6995 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
>  {
>  	struct xfs_btree_split_args	*args = container_of(work,
>  						struct xfs_btree_split_args, work);
> -	xfs_trans_set_context(args->cur->bc_tp);
> +	unsigned int			nofs_flags;
> +
> +	/*
> +	 * Don't use xfs_trans_set_context() here: it would overwrite the
> +	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
> +	 */
> +	nofs_flags = memalloc_nofs_save();
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
>  
> -	xfs_trans_clear_context(args->cur->bc_tp);
> +	memalloc_nofs_restore(nofs_flags);
>  
>  	/*
>  	 * Do not access args after complete() has run here. We don't own args
> -- 
> 2.55.0
> 
> 

