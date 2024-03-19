Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E65EE67
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 23:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710890088; cv=none; b=rIFvNvNSL1Y5d0lbyyeGdMqOwtMvP+UNOqc5WOv2+MamqlJRGm+ZKT4FhSAB/TGVsIzC2Wm+HG88RJULNQpszAcwDlQ7pf3pc9DG64YSDEUIkotRqVfMLFG7WRMQAjyanGiooV2rozWpK+jkoGY/Fb0lTbV/ZNrAA1gNKg17D2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710890088; c=relaxed/simple;
	bh=hx7tFt287CXQ4efiChS4xhZ9mEX2q6u4Cy8TimAim/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqwUwkwCL/r7NtvJWyM06Y8xiSme2ySoLkMSgqcdwWnESfpGHORGNV464Weo3O+BYbpak+uFK5GxAV0/AAEUo/NhH2qZeClB8J2rkVb7XlGt54l0FmN2MfzeKfJG67ZZ4nBLQzEGXrRObkuiVX+RguAIQXbbI8CYiSGyZCU9zZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbDW4ntA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbDW4ntA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CFAC433C7;
	Tue, 19 Mar 2024 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710890087;
	bh=hx7tFt287CXQ4efiChS4xhZ9mEX2q6u4Cy8TimAim/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fbDW4ntA/KIoDYswVQBx57MKbqHoMNE32CvasgNnLdZr7h4oBXRh5IFxc6jhy/DA4
	 H2R+ht3iKHYtrigUQKHdd7bzOsed+YCDtxa13k7LgLkN9z+huS6s0xExfY1GVgkByI
	 eTvF59kwEq7J60HRRjyXXPrOk9MtbQeSHai6rrtM5C2vVlP22bVN0ZkTtqnhM+rI9m
	 6buFRDufZOTYF4qYeuJwKjrNQKQW31xNmKSzZxse3iTVu5yi2Orouj0OiRB6ZRsDqY
	 eic3kTfJl7nduHDeQHGJP88SmekXzO+y3iuNYbg9cGwRQJGUIT16sLm+/fSwLw+Tz0
	 OUSwA+9CdzKJA==
Date: Tue, 19 Mar 2024 16:14:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: detect partial buffer recovery operations
Message-ID: <20240319231447.GS1927156@frogsfrogsfrogs>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-5-david@fromorbit.com>
 <ZfoXihIirJ1PZrs5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoXihIirJ1PZrs5@infradead.org>

On Tue, Mar 19, 2024 at 03:54:02PM -0700, Christoph Hellwig wrote:
> > +static bool
> > +xlog_recovery_is_dir_buf(
> > +	struct xfs_buf_log_format	*buf_f)
> > +{
> > +	switch (xfs_blft_from_flags(buf_f)) {
> > +	case XFS_BLFT_DIR_BLOCK_BUF:
> > +	case XFS_BLFT_DIR_DATA_BUF:
> > +	case XFS_BLFT_DIR_FREE_BUF:
> > +	case XFS_BLFT_DIR_LEAF1_BUF:
> > +	case XFS_BLFT_DIR_LEAFN_BUF:
> > +	case XFS_BLFT_DA_NODE_BUF:
> 
> XFS_BLFT_DA_NODE_BUF can also be a non-directory buffer.  Maybe this
> should be named something like xlog_recover_maybe_is_partial_dabuf?
> 
> > +		error = bp->b_error;
> >  		goto out_release;
> >  	}
> >  
> > +
> 
> This adds a spurious new line.
> 
> Otherwise this looks good to me, but the lack over verifiation for these
> multi-buffer recoveries really scares me..

I wondered if there was a good way to reconstruct the discontiguous
buffer, but the only things I could think of relied on guessing from the
subsequent buffer log items.  Does anyone have a better idea?

--D
