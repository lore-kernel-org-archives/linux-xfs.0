Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A287434E21;
	Tue, 15 Sep 2026 04:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446684; cv=none; b=LYmnvO5WSj1M9s6hWyQRWwQVdho7Ww86RO918k86k0Z4WCv7JtPmQvBJKEBVXUHgBWhKHA7rKB3bBE+QYek0d3ejSn+oJ0YxkTWP5QX2DPrqjRhg2g5TR8U6FhuQ6WCOj8pAizqucJIP+DPUD7ZnlnH0TzHZXLinwmqBZ8cNfnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446684; c=relaxed/simple;
	bh=mLTNFuKW9fsHo1e2o7AXzHKBwIZje5RsD9hRbi+i/YY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Og4H85CQw+4gEFvZ+rLNKCv1ihpT6HRhUby5Vv/6Pt/APXBTAMtcaDIRzrSPosjtkGJwB2WoZnBJlwiDnro6XMzEz4dtO4Zd94WyxgHFiaeJD4hnXcR95J1/PceibgDmYkYfA89wX3E4cFVqBkc81/rcC4eUSHXPhGe3cpt8NrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1iP19UE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1iP19UE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 175711F000FF;
	Tue, 15 Sep 2026 04:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789446666;
	bh=SvOrkac5XCpY8FwPLhGfa51jU5G2Yh36zDzvPoh/hNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a1iP19UE8+gH0RaoGxZKxDGjQazLf6mYbG2THq9kYmJhNcWlIPa/tQcOBqb8MJSq3
	 4WHQyQZxrycmeVrt6gCt14j6xNa+5N89X4bcDE14r+k7iLDDzEHEfEp5EExhl70g8F
	 UjQyT6VjkqrPJzwhRh7fZVE1XitT3Qa0XHbjD8Wu9xVl6H261GyGu6CqUBoqMdzCxB
	 WAnY1PQng9FBKnqdPV9ws+VE4HSqESdvakKj3o+NszDAVwb70KjL/R8aVHvVrYumRQ
	 a1HcNg4DGQFDgHDPtZkQAig0Ut/bO5OLiEteYRz5Jevg8Ed7IimuPx2N6khiVyTyAQ
	 8LkeE2lBSzSiQ==
Date: Mon, 14 Sep 2026 21:31:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <20260915043105.GB2705364@frogsfrogsfrogs>
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
 <20260911174247.GK6265@frogsfrogsfrogs>
 <4ff8e91e-a5b2-4754-ac9a-20f64f169af0@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ff8e91e-a5b2-4754-ac9a-20f64f169af0@windriver.com>

[add xfsprogs maintainer to cc]

On Tue, Sep 15, 2026 at 11:18:47AM +0800, Zhou, Yun wrote:
> 
> 
> On 9/12/26 01:42, Darrick J. Wong wrote:
> > CAUTION: This email comes from a non Wind River email account!
> > Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > On Fri, Jul 31, 2026 at 11:10:10AM +0800, Yun Zhou wrote:
> > > xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> > > xfs_trans_commit(), which flushes the CIL push workqueue internally.
> > > If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> > > lock these buffers to fail them, causing a deadlock:
> > > 
> > >    setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
> > >    CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> > > 
> > > Remove the xfs_trans_bhold() calls so that commit releases the buffer
> > > locks normally.  After the sync commit, re-acquire the buffers via
> > > mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> > > 
> > > Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> > > Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > > v3:
> > >   - Drop xfs_buf_hold/xfs_buf_relse, use lock/unlock directly (Christoph).
> > > 
> > > v2:
> > >   - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
> > >     xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
> > >   - Convert xfs_log_rtsb() stub from macro to inline function to avoid
> > >     the need for (void) casting (Christoph).
> > > ---
> > >   fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
> > >   fs/xfs/libxfs/xfs_sb.c      | 37 +++++++++++++++++--------------------
> > >   2 files changed, 22 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> > > index c0b9f9f2c413..fca2eb74908c 100644
> > > --- a/fs/xfs/libxfs/xfs_rtgroup.h
> > > +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> > > @@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
> > >   # define xfs_rtgroup_unlock(rtg, gf)         ((void)0)
> > >   # define xfs_rtgroup_trans_join(tp, rtg, gf) ((void)0)
> > >   # define xfs_update_rtsb(bp, sb_bp)  ((void)0)
> > > -# define xfs_log_rtsb(tp, sb_bp)     (NULL)
> > > +static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
> > > +             const struct xfs_buf *sb_bp)
> > > +{
> > > +     return NULL;
> > > +}
> > >   # define xfs_rtgroup_get_geometry(rtg, rgeo) (-EOPNOTSUPP)
> > >   #endif /* CONFIG_XFS_RT */
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 47322adb7690..2664728f2d8f 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -1470,36 +1470,33 @@ xfs_sync_sb_buf(
> > >        bool                    update_rtsb)
> > >   {
> > >        struct xfs_trans        *tp;
> > > -     struct xfs_buf          *bp;
> > > -     struct xfs_buf          *rtsb_bp = NULL;
> > >        int                     error;
> > > 
> > >        error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
> > >        if (error)
> > >                return error;
> > > 
> > > -     bp = xfs_trans_getsb(tp);
> > >        xfs_log_sb(tp);
> > > -     xfs_trans_bhold(tp, bp);
> > > -     if (update_rtsb) {
> > > -             rtsb_bp = xfs_log_rtsb(tp, bp);
> > > -             if (rtsb_bp)
> > > -                     xfs_trans_bhold(tp, rtsb_bp);
> > > -     }
> > > +     if (update_rtsb)
> > > +             xfs_log_rtsb(tp, xfs_trans_getsb(tp));
> > >        xfs_trans_set_sync(tp);
> > >        error = xfs_trans_commit(tp);
> > >        if (error)
> > > -             goto out;
> > > -     /*
> > > -      * write out the sb buffer to get the changes to disk
> > > -      */
> > > -     error = xfs_bwrite(bp);
> > > -     if (!error && rtsb_bp)
> > > -             error = xfs_bwrite(rtsb_bp);
> > > -out:
> > > -     if (rtsb_bp)
> > > -             xfs_buf_relse(rtsb_bp);
> > > -     xfs_buf_relse(bp);
> > > +             return error;
> > > +
> > > +     /* Re-acquire and write the sb and rtsb to disk. */
> > > +     xfs_buf_lock(mp->m_sb_bp);
> > 
> > FYI, this causes porting problems to xfsprogs' libxfs because userspace
> > doesn't have m_sb_bp or m_rtsb_bp pointers in struct xfs_mount.  It's
> > not a big deal to add them, but if anyone ever wants to call
> > xfs_sync_sb_buf then we're going to have to figure out when to populate
> > those pointers.
> > 
> 
> You're right — the problem is referencing mp->m_sb_bp / mp->m_rtsb_bp
> directly in libxfs. I can avoid that by going back to acquiring the
> buffer early via xfs_trans_getsb() / xfs_log_rtsb() (as the original
> code did), instead of touching the mount pointers.
> 
> To keep this safe for a userspace caller that may not hold a
> mount-level reference to the sb buffer, we can take an explicit
> xfs_buf_hold() after getsb so the buffer stays alive across the
> commit. Unlike the original xfs_trans_bhold(), xfs_buf_hold() only
> takes a reference and does not keep the buffer locked across the
> commit, so it doesn't reintroduce the deadlock.
> 
> Alternatively, since xfs_ioc_setlabel() is currently the only caller
> and it's kernel-only, we could just move xfs_sync_sb_buf() out of
> libxfs into xfs_ioctl.c.

Probably safer to do that, since there's no other user of that function,
and none in userspace.

> Since this is already in for-next, would you prefer an incremental follow-up
> patch, or should I resend as v4?

It's already been merged, so whatever fix we come up with has to be a
new patch.

--D

> Thanks,
> Yun
> 
> 
