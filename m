Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0E01E877
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712785828; cv=none; b=bCiDziiKc2MHOgL7Qf5lEL0jkXcQJTz7dJOupQpk/iYbEDAg9W44c3YseYmFfaTobyvHrpb0OCLa//D4EUOvzgm1qDbXZBN2U3KYyih2PtAgKRaevFb5HTTRknT2ojeIBYb7SixeiOfd1Pwxkj9eCZTbUXy6+0neJgFXrPbGDhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712785828; c=relaxed/simple;
	bh=FhdViyOg2yfKokYNkeMCtNTab6khXM6u3ktG5APR6Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivk7WUs6QjkDH9z55Xis9GSwuxP/An3hdePIZvSmOtOQl0+lUWsYHs7kH6N9i9LxMTkP0pzPC5/Yn9i135G8nY9gs1wgQpEly7nSax+mtHd+wJTCROrCd9cI+iEE1u25VBMPAx8wYuVPnJamJi1QacENXZb/ggefYLWoAexHJbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEnGvFCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEnGvFCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E88DC433F1;
	Wed, 10 Apr 2024 21:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712785827;
	bh=FhdViyOg2yfKokYNkeMCtNTab6khXM6u3ktG5APR6Gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JEnGvFCENCUA3DFh3qP4v7CTvmgm9bv6OlClb1M0pzuqqQ8r1cuEfuSs2hNuU8cKm
	 7rgTekHik3Lmpt7nSVR7dN9Dw2vCdY+RxInT3g75GWSDVgAhJ2sQkCi4R9zQxBfxpD
	 GjXoH59KQieTX4Uss8Z5UtzSOcZC2+itDrG7gWOdt9hnXCBHc4CudY2P284xomkOIL
	 ZSuHayK/rT4rvQFJJSIJdrew4gz+i3uhVsToRfpk82MD0qUS2W4jKzlVrO5g90gpWc
	 rME+SibXbSXaU7zG8HhY+7Z/+itdiEkMMz2Iy4+lwiA68x/chYNu90G+HO5X02YfiQ
	 Wx4zIfjkWPAzg==
Date: Wed, 10 Apr 2024 14:50:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/32] xfs: parent pointer attribute creation
Message-ID: <20240410215026.GG6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969840.3631889.8747832684298773440.stgit@frogsfrogsfrogs>
 <ZhYnWEiQuxzONreJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYnWEiQuxzONreJ@infradead.org>

On Tue, Apr 09, 2024 at 10:44:56PM -0700, Christoph Hellwig wrote:
> 
> One thing that might be worth documenting in a comment or at least
> the commit log is why we have this three phase split between
> allocating the daargs, doing all the work and freeing it.
> 
> As far as I can tell that is because the da_args need to be around
> until transaction commit because xfs_attr_intent has a pointer to
> the da_args and not a full copy.

Correct.  I think the xfs_attr_intent could make its own full copy and
iterate on that, but that would break the existing behavior that the
xfs_attr_set caller can look at the end state of the xfs_attr_set
operation.

AFAICT the only xfs_attr_* callers that care about the end state at all
are xfs_attr_lookup functions (because they might want to get the
value).  I don't *think* any of the xfs_attr_set callers actually care.
The log intent creation function will snapshot the
name/value/oldname/newvalue buffers, so we're already doing large(ish)
allocations deep in transaction context.

On the other hand, the current code has fewer copies to make because we
"know" that the da_args has to persist until transaction commit
because...

>                                   So unless the attrs are on stack
> they need to be free after transaction commit, and as the normal
> dir operation args are not on the stack we don't want to add the
> attr one to the stack here.  We could probably allocate the da_args
> in the main parent pointer helpers, but that would require a NOFAIL
> allocation and maybe lead to odd calling conventions, but maybe
> someone directly involved can further refine that reasoning.

...the da_args (for the parent pointer op) is already allocated as part
of xfs_parent_args in xfs_parent_start.  If the kernel supported alloca
(HAHAAHA) then we wouldn't need the xfs_parent_args_cache.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
