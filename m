Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n197lAkh232924 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 01:47:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC1A4FD00A
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 23:46:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Hln7SesXyxyiBvhw for
	<xfs@oss.sgi.com>; Sun, 08 Feb 2009 23:46:32 -0800 (PST)
Date: Mon, 9 Feb 2009 02:46:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/17] xfs: get rid of indirections in the quotaops
	implementation
Message-ID: <20090209074632.GA32322@infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.961302000@bombadil.infradead.org>
	<20090209024115.GH8830@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090209024115.GH8830@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 09, 2009 at 01:41:15PM +1100, Dave Chinner wrote:
> > +STATIC int
> > +xfs_fs_get_xstate(
> > +	struct super_block	*sb,
> > +	struct fs_quota_stat	*fqs)
> > +{
> > +	struct xfs_mount	*mp = XFS_M(sb);
> > +
> > +	if (!XFS_IS_QUOTA_RUNNING(mp))
> > +		return -ENOSYS;
> > +	return xfs_qm_scall_getqstat(mp, fqs);
> 
> The return of xfs_qm_scall_getqstat() needs to be negated.

Currently it only ever returns 0.  But I agree, if this ever returns
an error it would be a positive one, so I added the inversion.

> > +	return xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
> 
> That should be negated as well.

But this one can already return a positive error, so it's definitively
needed.

Thanks, I've commited the updated version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
