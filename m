Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7EB3A8743;
	Fri, 13 Mar 2026 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413857; cv=none; b=Rd7UD57/kKWAbyjc3cYdFterV0BLglM3gZR3BqTbzO5bx4tntqyHIam/kkRXj0de9o+ulYNUD/qxbU6lA2t6TBaBxqQXmqbCYZN54MSKuAnMehU1QJvXK1fKy1173fsBS1OaZB57B/A+GlPsRnDoEu5icB1PGk6TL7a2EhzqZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413857; c=relaxed/simple;
	bh=08TPvKwyl36FzMlvSX3X3YJCr2tM4c/qd6WY/yURdR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8nZuYbgfWzKhk6xNVxWThA/XUxKaGGD+6yt3Yk5Ek62ysr8gDlOx2od3mYgH6PlfTr2u4vIMoDBlZL9Qh9bKTNMNqij7Dxs09EzbNK1CDgO9IjHQHuovwTb2WT0HI7WtNTPRsR8WkkFPogfEFiUBezHFVFixa13MXYoEzXuWxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWctC+Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWctC+Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F274AC19421;
	Fri, 13 Mar 2026 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773413857;
	bh=08TPvKwyl36FzMlvSX3X3YJCr2tM4c/qd6WY/yURdR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWctC+OdSrUWbw+1mYqRtt1b2znyxAJ962tc57KUJyX/xROXgg6r0U0jstQq7DoYK
	 WHg5C0TGaJIGfG2uzDN+ownBY+/nT+tpBERAUa7dAAgQQFrHq7BqggHJ1ZAnftwQhT
	 eJTkbQxy+PKysot7RQnrE3jHlY8nWZH5dO93eoZ0EYyknW5i0msaLn2dYcYuAusrdv
	 Bgxx+6u63+5MGsMRiXq/gogmmRL24jZyDtQmoNZjhYng2oX4axSz/94eAe53gwZtak
	 jwErQwyp0glrzyLqpVixtJs+bnHOkaIfULqYOMYGuS8FXC6lmAUygeq7rRu8szM/0t
	 kM7mNJZeAXDFw==
Date: Fri, 13 Mar 2026 07:57:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	brauner@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
	yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] iomap: fix incorrect did_zero setting in
 iomap_zero_iter()
Message-ID: <20260313145736.GO1770774@frogsfrogsfrogs>
References: <20260310082250.3535486-1-yi.zhang@huaweicloud.com>
 <20260310221303.GA1770774@frogsfrogsfrogs>
 <1dce8b3b-29ee-4c45-98cb-8882a79c41c2@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dce8b3b-29ee-4c45-98cb-8882a79c41c2@huaweicloud.com>

On Wed, Mar 11, 2026 at 10:17:25AM +0800, Zhang Yi wrote:
> On 3/11/2026 6:13 AM, Darrick J. Wong wrote:
> > On Tue, Mar 10, 2026 at 04:22:50PM +0800, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> The did_zero output parameter was unconditionally set after the loop,
> >> which is incorrect. It should only be set when the zeroing operation
> >> actually happens, not when IOMAP_F_STALE is set or when
> >> IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
> >> or when iomap_iter_advance() returns an error.
> >>
> >> This causes did_zero to be incorrectly set when zeroing a clean
> >> unwritten extent because the loop exits early without actually zeroing
> >> any data.
> >>
> >> Fix it by using a local variable to track whether any folio was actually
> >> zeroed, and only set did_zero after the loop if zeroing happened.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> ---
> >>  fs/iomap/buffered-io.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> >> index 5297491d5e3e..7a3780242cde 100644
> >> --- a/fs/iomap/buffered-io.c
> >> +++ b/fs/iomap/buffered-io.c
> >> @@ -1537,6 +1537,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
> >>  		const struct iomap_write_ops *write_ops)
> >>  {
> >>  	u64 bytes = iomap_length(iter);
> >> +	bool zeroed = false;
> >>  	int status;
> >>  
> >>  	do {
> >> @@ -1555,6 +1556,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
> >>  		/* a NULL folio means we're done with a folio batch */
> >>  		if (!folio) {
> >>  			status = iomap_iter_advance_full(iter);
> >> +			if (status)
> >> +				return status;
> >>  			break;
> >>  		}
> >>  
> >> @@ -1565,6 +1568,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
> >>  				bytes);
> >>  
> >>  		folio_zero_range(folio, offset, bytes);
> >> +		zeroed = true;
> >>  		folio_mark_accessed(folio);
> >>  
> >>  		ret = iomap_write_end(iter, bytes, bytes, folio);
> >> @@ -1574,10 +1578,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
> >>  
> >>  		status = iomap_iter_advance(iter, bytes);
> >>  		if (status)
> >> -			break;
> >> +			return status;
> > 
> > I think this seems like an unrelated change?  Do any of the callers
> > behave differently if iomap_zero_range() returns an error but also sets
> > did_zero to true?
> > 
> 
> In the event of an error return, no caller will be concerned with the
> did_zero state. It is only relevant when the operation is successful.
> So I think we can just return if some error happens, consistent with
> other error-handling practices in this loop.
> 
> >>  	} while ((bytes = iomap_length(iter)) > 0);
> >>  
> >> -	if (did_zero)
> >> +	if (did_zero && zeroed)
> >>  		*did_zero = true;
> > 
> > Why not just do:
> > 
> > 	if (did_zero)
> > 		*did_zero = zeroed;
> > 
> > ?
> > 
> 
> If we proceed with this approach, when there are mixed extents and the
> final iteration of the iomap_zero_range() loop does not zero out any
> data, it will clear the flags that were set in previous loop when the
> data was zeroed.

Ah, got it.  This makes sense enough to me to warrant wider testing so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Thanks,
> Yi.
> 
> > --D
> > 
> >>  	return status;
> >>  }
> >> -- 
> >> 2.52.0
> >>
> >>
> 
> 
