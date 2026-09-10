Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC643AEB2C
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031827; cv=none; b=uLO6lEnOSI+HY/gad9yP++6hjzplMDTZQAWTTgjQjA5KkymqY2UbBDM0/+fEURgTI9xbiJ8mj/Z7qsX/EQcv4i2TVPNinEuQqaQGHxtMg/GuaPhJEhrTyrr10wD30TLwGGKraRcVz0GhkXErJ1r9Gq0+VdUU5CbxpjkAB6HRUwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031827; c=relaxed/simple;
	bh=SwDMGVW+mbxyymv5c8YDSl3DG1Cd+PvsqGFtIrW7ph4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLDzk0rpabCwqcU5IQLETsFqWtiBjcEoMzGVzhQ/RQBrNAhZkb7DX0KAwPlZvPGflTLxxqfYn2KHKkgy8s0eiyCVQ26ID8NkfiDPVyj4gCwUIKayzDlCvbaNTvdu3sDV9DC+L0bJcfEnBrjOsVriDThGZzx5yhorm5SPad/yFNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSG3eCBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSG3eCBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A44E1F000FF;
	Thu, 10 Sep 2026 09:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031825;
	bh=IL7sWm5m5Lp66R+RQAma0Arq+O5F2W/irhAKeF+V+FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cSG3eCBUMAcLmNs2xHHoSKh5nHAe7NPjLeom9quClc7MSUlOnSIqw4dEZ2ppR78+y
	 2UDe5+8zA1S2jaJLu1ohOJMFxYiDvW5+KU5OasGpdOSLndKMEBfxYmXOv3qU3U+n5G
	 sTSW4oidPB6UdAocngjCXeG6oZHhbZWyCNxdNDsP7177g6K9Mpo9RSGpPG+SxQje/X
	 sdrUE+ArGPJcWaFLHok14frHPyCnjwtvp3wUj7K6npZPrjlloVDDyAOQl0nxoO/OK6
	 /ckytNQovVPTAjfbnTRjFatvlFExhJbgUBYOSFNXgzJg+TjFVHFEdkQ30Trt0SIQGZ
	 5vmEwKrkBQpag==
Date: Thu, 10 Sep 2026 11:17:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: enable xfs_trans_cancel() to report and error
 code
Message-ID: <aqJ1Zl-Z4u3el0RJ@andromeda.toxiclabs.cc>
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-3-cem@kernel.org>
 <20260908152754.GF2619314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908152754.GF2619314@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 08:27:54AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 08, 2026 at 04:54:15PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Once in a while it's useful to know exactly what kind of error caused a
> > transaction to be cancelled.
> > Enable xfs_trans_cancel() to receive an error code to be reported.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_trans.c | 8 +++++---
> >  fs/xfs/xfs_trans.h | 6 +++++-
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 792a67a7ec28..5bbbb9226864 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -971,8 +971,9 @@ xfs_trans_commit(
> >   * xfs_trans_commit().
> >   */
> >  void
> > -xfs_trans_cancel(
> > -	struct xfs_trans	*tp)
> > +__xfs_trans_cancel(
> > +	struct xfs_trans	*tp,
> > +	int			error)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xlog		*log = mp->m_log;
> > @@ -999,7 +1000,8 @@ xfs_trans_cancel(
> >  	 * here.
> >  	 */
> >  	if (dirty && !xfs_is_shutdown(mp)) {
> > -		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
> > +		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
> > +				 error, mp);
> >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  	}
> >  #ifdef DEBUG
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 2b366851e9a4..30135152d043 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -213,6 +213,11 @@ xfs_trans_read_buf(
> >  				      flags, bpp, ops);
> >  }
> >  
> > +void __xfs_trans_cancel(xfs_trans_t *, int);
> > +
> > +#define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
> > +#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel(tp, error)
> 
> Nitpicking: the arguments should be wrapped in parentheses so you can't
> do evil things to the preprocessor.  SOrry about being sloppy about
> that.

You were not sloppy.... That's preprocessor 101 and I shouldn't have
overlooked that. Thanks for catching it.

> 
> #define xfs_trans_cancel_error(tp, error) \
> 	__xfs_trans_cancel((tp), (error))
> 
> --D
> 
> > +
> >  struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
> >  struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
> >  
> > @@ -237,7 +242,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> >  int		xfs_trans_commit(struct xfs_trans *);
> >  int		xfs_trans_roll(struct xfs_trans **);
> >  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> > -void		xfs_trans_cancel(xfs_trans_t *);
> >  int		xfs_trans_ail_init(struct xfs_mount *);
> >  void		xfs_trans_ail_destroy(struct xfs_mount *);
> >  
> > -- 
> > 2.55.0
> > 
> > 
> 
