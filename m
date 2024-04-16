Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57401E4BF
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713292872; cv=none; b=pdwFTMbdRvl3WBYNS/EpeDWk74hRkhOQ6x3+AEPzWcqiBtwbOYZHdSG4qYRheKi5nv4WUapcT7o0s1REMqA/0rwiD3iBfNpdBfb8Z0kPbAGyPINKpAua6wdILEjlnE7M1PKd52jl/C3UZgCHUgX+TdXpwAOUdAz8xXvZIXjg5pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713292872; c=relaxed/simple;
	bh=/GGQRbCKCn76mTfHWv2bkQN9A7Ty0I+m56xO3ZJEtI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z6V0jw7K4CbQ4//Ud1Nigjt8BUkpWhWNmTy61uxRpAuA7ILm4eRMfbqGO/3naM8js6lG5JLxXMD9sRVJG5qEofPrEzNUg8BveWZbuUuyCYoQlMQPSIbwLcc76X1mLRQTLAUt9mWAiBAhseBcdgZErw8r0Tq7jpoY85r6djt6ohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0JrWpej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0JrWpej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70917C113CE;
	Tue, 16 Apr 2024 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713292871;
	bh=/GGQRbCKCn76mTfHWv2bkQN9A7Ty0I+m56xO3ZJEtI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0JrWpejr315QvE4u5l5WpLWyIuE87mraAqnETEA7tcTlr1ucUhWpcTHHV6ohVcub
	 ntUjh737cDz7tTiteTK3SF/0B31P8eQVy8B6etozeZTnsyBDvziMttDFAEhyeMPBxf
	 NaqVn0sGjA+7ui3MmevbhK7bk4u2PI08MGtl8DN9h5qZGPXv1mL79kC9g1tykeau00
	 zHkUYMEQex0+usZsL2U660gJR8ufZV0oYh5mdKAnTYwIa2g5IsCgia2B0LZFxZnhf+
	 AfzSkEVyYWr2F6RuwR1xwNS7vAtg/LGvmGn6yPPyATGdS41bpahVGTMVOnnzM5S6QW
	 BoNqyz/KK/cXQ==
Date: Tue, 16 Apr 2024 11:41:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <20240416184110.GX11948@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
 <20240416160555.GI11948@frogsfrogsfrogs>
 <Zh6nGaPvk3tKf3gg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6nGaPvk3tKf3gg@infradead.org>

On Tue, Apr 16, 2024 at 09:28:09AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 09:05:55AM -0700, Darrick J. Wong wrote:
> > I prefer to keep the pptr version separate so that we can assert that
> > the args contents for parent pointers is really correct.
> 
> We could do that with a merged version just as easily.

Eh, ok.

> > Looking at
> > xfs_attr_defer_parent again, it also ought to be checking that
> > args->valuelen == sizeof(xfs_getparents_rec);
> 
> Yes.

The patch "xfs: create attr log item opcodes and formats for parent
pointers" now contains:

void
xfs_attr_defer_add(
	struct xfs_da_args	*args,
	enum xfs_attr_defer_op	op)
{
	struct xfs_attr_intent	*new;
	unsigned int		log_op = 0;
	bool			is_pptr = args->attr_filter & XFS_ATTR_PARENT;

	if (is_pptr) {
		ASSERT(xfs_has_parent(args->dp->i_mount));
		ASSERT((args->attr_filter & ~XFS_ATTR_PARENT) != 0);
		ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
		ASSERT(args->valuelen == sizeof(struct xfs_parent_rec));
	}

	new = kmem_cache_zalloc(xfs_attr_intent_cache,
			GFP_NOFS | __GFP_NOFAIL);
	new->xattri_da_args = args;

	/* Compute log operation from the higher level op and namespace. */
	switch (op) {
	case XFS_ATTR_DEFER_SET:
		if (is_pptr)
			log_op = XFS_ATTRI_OP_FLAGS_PPTR_SET;
		else
			log_op = XFS_ATTRI_OP_FLAGS_SET;
		break;
	case XFS_ATTR_DEFER_REPLACE:
		if (is_pptr)
			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
		else
			log_op = XFS_ATTRI_OP_FLAGS_REPLACE;
		break;
	case XFS_ATTR_DEFER_REMOVE:
		if (is_pptr)
			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
		else
			log_op = XFS_ATTRI_OP_FLAGS_REMOVE;
		break;
	default:
		ASSERT(0);
		break;
	}
	new->xattri_op_flags = log_op;

	/* Set up initial attr operation state. */
	switch (log_op) {
	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
	case XFS_ATTRI_OP_FLAGS_SET:
		new->xattri_dela_state = xfs_attr_init_add_state(args);
		break;
	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
		ASSERT(args->new_valuelen == args->valuelen);
		new->xattri_dela_state = xfs_attr_init_replace_state(args);
		break;
	case XFS_ATTRI_OP_FLAGS_REPLACE:
		new->xattri_dela_state = xfs_attr_init_replace_state(args);
		break;
	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
	case XFS_ATTRI_OP_FLAGS_REMOVE:
		new->xattri_dela_state = xfs_attr_init_remove_state(args);
		break;
	}

	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
}

and then we can drop this patch.

--D
