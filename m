Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2B1CEABF
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728576176; cv=none; b=Ppt5CSqhuqs6U3sMKkPL+3GMLfIm6CD4hRl/zeg78wEhdzTwzyiGcA7BTkp7KkXCK01xIz5xoEdSaIGrdpbNPP6xr5afnwWQTmdb4tB2O6A/fGMK4Q5KvZaw7QhuKXS+t9rFf+hXMklEh2BURs9WfaA7d2278IAxh+Grci1HTPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728576176; c=relaxed/simple;
	bh=/5XTJSvG3zIDUubzim+M6MxmguMQcBEndnIegXPA+AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlQi8dVmximJ0nEITZ3XfUrckz3GP5vG7VHcY5YgM/M4Q+YeRC09JdywjxGncDRheHweAJaEFggzLV8O57WaePP2UvfFnalv7RGE9+n64q1Chwn5Cwt8jKhQiJ+messnPs8sTZ4kB18HRwszAr7qrstyyCq7boJg8c9nEnUNAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHdgJAoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHdgJAoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF0C4CECE;
	Thu, 10 Oct 2024 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728576176;
	bh=/5XTJSvG3zIDUubzim+M6MxmguMQcBEndnIegXPA+AY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cHdgJAoXe0WU5Sl7O5X5S2bTH/HdYWqDL/bjgmUuQWKSz0WE6CyqOUeiOPiXW0yl0
	 Z3GsXuArOM2yUsvjJczD/GXH7HKGmNh6/mRbYN2IlDDeau2iIL1494o3leDIU2YXfs
	 SQtr3I75PJuj2udD0R/VfzEB92Z/Z34pc3l36fT1nqRzr2DpFGvfZXLcVsFxDLbB+H
	 BFHYDWy+wFV/kk2qpAoArNbV17tcMmooj9eg3wIXogGee7RMUk3SCRNROs8FjUVH65
	 sWgmhT/Q7aRFYolIdrvNdq2cYH9zhv4Y44rS4Xr0Jvis9E90/gf6Icb1IVXp8qrSXd
	 jsBYZw83doOgg==
Date: Thu, 10 Oct 2024 09:02:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <20241010160255.GT21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-4-hch@lst.de>
 <20240930165019.GS21853@frogsfrogsfrogs>
 <20241001084918.GB21122@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001084918.GB21122@lst.de>

On Tue, Oct 01, 2024 at 10:49:18AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 30, 2024 at 09:50:19AM -0700, Darrick J. Wong wrote:
> > > +int
> > > +xlog_recover_update_agcount(
> > > +	struct xfs_mount		*mp,
> > > +	struct xfs_dsb			*dsb)
> > > +{
> > > +	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
> > > +	int				error;
> > > +
> > > +	xfs_sb_from_disk(&mp->m_sb, dsb);
> > 
> > If I'm understanding this correctly, the incore superblock gets updated
> > every time recovery finds a logged primary superblock buffer now,
> > instead of once at the end of log recovery, right?
> 
> Yes.
> 
> > Shouldn't this conversion be done in the caller?  Some day we're going
> > to want to do the same with xfs_initialize_rtgroups(), right?
> 
> Yeah.  But the right "fix" for that is probably to just rename
> this function :)  Probably even for the next repost instead of
> waiting for more features.

Forgot to reply to this, but yes, how about
xlog_recover_update_group_count?

--D
