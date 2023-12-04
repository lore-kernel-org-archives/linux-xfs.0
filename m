Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3782530CFB
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8aNzyWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E89FC433C8;
	Mon,  4 Dec 2023 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701715891;
	bh=s9Xo4fcU4/TfuTUd+pK7nyD0mRrN4ycqiYBhdPEHvIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8aNzyWvCgQOx7LXp3LbxcBj0HWbanHtgFN4YDtJgHc9eaKwwZEqHiJx8KEBNWhDT
	 O72/IgdlE9ocmFCEEO/W3oxXEmOfd6SIsBeydlRynfVf+X1GRt3TTtaFkVerzVnpvv
	 IfTDw/1E8WMNQvVuUafBmCinFvQJG63NHM0kxOrMeJCklU3sx2vl5JAAd+zoroaoiN
	 P0cRGbZ7Em/tComqoKyjgQkmL0ZLyovegOG7Njr6zFAFmWZGLMmZUCQZgnR/ARjtNf
	 p+1FHf1Bav7jX+1KivDD1x/5/Y988mgvs3OrXOJKP9APjkWmzfDlpseBMLVOPd3R4D
	 uGSSZsKxq1jIw==
Date: Mon, 4 Dec 2023 10:51:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: collapse the ->create_done functions
Message-ID: <20231204185131.GZ361584@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
 <170162990294.3037772.8654512217801085122.stgit@frogsfrogsfrogs>
 <20231204052403.GD26448@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204052403.GD26448@lst.de>

On Mon, Dec 04, 2023 at 06:24:03AM +0100, Christoph Hellwig wrote:
> > +static struct xfs_log_item *
> > +xfs_attr_create_done(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_log_item		*intent,
> > +	unsigned int			count)
> >  {
> > -	struct xfs_attrd_log_item		*attrdp;
> > +	struct xfs_attri_log_item	*attrip;
> > +	struct xfs_attrd_log_item	*attrdp;
> >  
> > -	ASSERT(tp != NULL);
> > +	if (!intent)
> > +		return NULL;
> > +
> > +	attrip = ATTRI_ITEM(intent);
> 
> How can we end up with a NULL intent here?

static struct xfs_log_item *
xfs_attr_create_intent(
	struct xfs_trans		*tp,
	struct list_head		*items,
	unsigned int			count,
	bool				sort)
{
	struct xfs_mount		*mp = tp->t_mountp;
	struct xfs_attri_log_item	*attrip;
	struct xfs_attr_intent		*attr;
	struct xfs_da_args		*args;

	ASSERT(count == 1);

	/*
	 * Each attr item only performs one attribute operation at a time, so
	 * this is a list of one
	 */
	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
			xattri_list);
	args = attr->xattri_da_args;

>>>	if (!(args->op_flags & XFS_DA_OP_LOGGED))
		return NULL;

If the caller doesn't set XFS_DA_OP_LOGGED, then this function returns
NULL for "no log intent item".  The LOGGED flag gets set sometimes:

int
xfs_attr_change(
	struct xfs_da_args	*args)
{
	struct xfs_mount	*mp = args->dp->i_mount;
	bool			use_logging = false;
	int			error;

	ASSERT(!(args->op_flags & XFS_DA_OP_LOGGED));

	if (xfs_attr_want_log_assist(mp)) {
		error = xfs_attr_grab_log_assist(mp);
		if (error)
			return error;

>>>		args->op_flags |= XFS_DA_OP_LOGGED;
		use_logging = true;
	}

But only on a V5 filesystem with a debug kernel and only if
xfs_globals.larp is set.

static inline bool
xfs_attr_want_log_assist(
	struct xfs_mount	*mp)
{
#ifdef DEBUG
	/* Logged xattrs require a V5 super for log_incompat */
	return xfs_has_crc(mp) && xfs_globals.larp;
#else
	return false;
#endif
}

> The intent passed in is
> always ->dfp_intent and I don't think that can be NULL.  No other
> implementation of ->create_done checks for it either.

If xfs_attr_create_intent returns NULL, then xfs_attr_create_done won't
create a done item either.  xfs_defer_finish_one will walk through the
state machine as always, but the operation won't be restarted by
recovery since the higher level operation state was not recorded in the
log.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
