Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997851FBB
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 15:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306700; cv=none; b=YAxb/v3Ni5nF7cV0AX2V1jmL8N2HDtZS6N4z4YeygIySYmX/SVbgD5xfvot0dYEDRWN0IVdmAtXGUJI40phla4N5MOknvaLm7iaulBhTyJ6/+nYgFdmdZYvojSfeOFwja1fFD4GjrktB5VHyUea2D8YRx5PMJzvSHAN6/LnheG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306700; c=relaxed/simple;
	bh=JjTWCkduH+OpFsJTw7eVqwr7P0eSjsOR86MmcSGo2/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dui4iMsYmFiQSk5yyiGyLMOnc2NTLzO7vbUrFNzulqtXtUL4mf0S49gHDUipYm+IPG5gS2OGJluPxi5KDUUL6a3hfu6J5fYWF2Rznk1K9FXoPyDOL1oqLoA0hiXq8iawWfwdqBLOhh+oC5YkUamEMgk5kp2MCgDimbwH0CcQquQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4wvqpcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4wvqpcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEAEC2BD11;
	Tue, 21 May 2024 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716306700;
	bh=JjTWCkduH+OpFsJTw7eVqwr7P0eSjsOR86MmcSGo2/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E4wvqpcSSUzFaxEJNFeAL77140QktYJpM4UQpYbI1pqhzdyLY6lD9Wgf3RRmYZD8d
	 0yOmwiYpTczI9IvBiJVr427TdCuoAc3671tp1jIyFPr6VptYCd/6Ig70KyzBVwqc/7
	 Kvel3URvjPcJzbbPWYLsYpShcdVzTekau/lF4qzwwaVHVfuK8D7Gv97rAsB57lFWxe
	 bGCN4H7w3tSupp+8bRHePhQuA92lGAPlHLpENcyZAYEywVADUC6XOMBmERHYowbdo/
	 Wc3RzipvrTvp07aOnUmIg1c9K+ENw2/T1w8mnb8tJYaF0/39XZQUn0LKpejBk5JrXM
	 45RcVgVppBdEw==
Date: Tue, 21 May 2024 08:51:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
Message-ID: <20240521155139.GQ25518@frogsfrogsfrogs>
References: <20240521010338.GL25518@frogsfrogsfrogs>
 <Zkymy4s5LtabyMRm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zkymy4s5LtabyMRm@infradead.org>

On Tue, May 21, 2024 at 06:51:07AM -0700, Christoph Hellwig wrote:
> On Mon, May 20, 2024 at 06:03:38PM -0700, Darrick J. Wong wrote:
> > +	tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
> >  		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
> > +	return args->total;
> 
> Seems like indentation is off for the XFS_TRANS_PERM_LOG_RES
> assignment?

Oops.  I think I could shorten this to:

/* Initialize transaction reservation for an xattr set/replace/upsert */
inline struct xfs_trans_res
xfs_attr_set_resv(
	const struct xfs_da_args	*args)
{
	struct xfs_mount		*mp = args->dp->i_mount;
	struct xfs_trans_res		ret = {
		.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
			    M_RES(mp)->tr_attrsetrt.tr_logres * args->total,
		.tr_logcount		= XFS_ATTRSET_LOG_COUNT,
		.tr_logflags		= XFS_TRANS_PERM_LOG_RES,
	};

	return ret;
}

> Also wju does this need to return args->total vs just handling it
> in the caller? 

I'm not sure, @total for the remove action used to be in xfs_attr_set
prior to the creation of xfs_attr_recover_work.

> > +/* Initialize transaction reservation for an xattr remove */
> > +unsigned int
> > +xfs_attr_init_remove_trans(
> > +	struct xfs_da_args	*args,
> > +	struct xfs_trans_res	*tres)
> > +{
> > +	struct xfs_mount	*mp = args->dp->i_mount;
> > +
> > +	*tres = M_RES(mp)->tr_attrrm;
> > +	return XFS_ATTRRM_SPACE_RES(mp);
> 
> And do we even need this helper vs open coding it like we do in
> most transaction allocations?

Not really.

--D
