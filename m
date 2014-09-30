Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDBF67F86
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 17:13:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DEC4AC006
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:13:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DIraZkiRKGAmTDuQ for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 15:13:49 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XZ5fN-0007de-HY
	for xfs@oss.sgi.com; Wed, 01 Oct 2014 08:13:05 +1000
Date: Wed, 1 Oct 2014 08:13:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: only set extent size hint when asked
Message-ID: <20140930221305.GS4758@dastard>
References: <1412041565-18873-1-git-send-email-david@fromorbit.com>
	<1412041565-18873-3-git-send-email-david@fromorbit.com>
	<20140930055829.GB15186@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140930055829.GB15186@teal.hq.k1024.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue, Sep 30, 2014 at 07:58:29AM +0200, Iustin Pop wrote:
> On Tue, Sep 30, 2014 at 11:46:05AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the extent size hint is set unconditionally in
> > xfs_ioctl_setattr(), even when the FSX_EXTSIZE flag is not set. This
> > means we can set values from uninitialised stack variables. Hence
> > only set the extent size hint from userspace when both the mask
> > falg is set and the inode has the XFS_DIFLAG_EXTSIZE flag set to
> > indicate that we should have an extent size hint set on the inode.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 87c3bd1..24c926b 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1231,13 +1231,25 @@ xfs_ioctl_setattr(
> >  
> >  	}
> >  
> > -	if (mask & FSX_EXTSIZE)
> > -		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> >  	if (mask & FSX_XFLAGS) {
> >  		xfs_set_diflags(ip, fa->fsx_xflags);
> >  		xfs_diflags_to_linux(ip);
> >  	}
> >  
> > +	/*
> > +	 * Only set the extent size hint if we've already determined that the
> > +	 * extent size hint should be set on the inode. If no extent size flags
> > +	 * are set on the inode then unconditionally clear the extent size hint.
> > +	 */
> > +	if (mask & FSX_EXTSIZE) {
> > +		int	extsize = 0;
> > +
> > +		if (ip->i_d.di_flags &
> > +				(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> > +			extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> > +		ip->i_d.di_extsize = extsize;
> 
> Quick question: this sounds sane, but it will have the following effect
> (if I understand things correctly): updating other flags on the inode
> (e.g. XFS_XFLAG_NOATIME) might change the recorded extent size.

That's no different to what happens before this patch. As I said in
the cover note, I'm not attempting to fix those problem with these
patches.

Besides, you're still thinking that you can just call
XFS_IOC_SETXATTR without a preceeding XFS_IOC_GETXATTR call. That's
just broken - if applications use getxattr/setxattr correctly then
this isn't an issue. i.e. do this:

	ioctl(XFS_IOC_GETXATTR, &fsx)
	fsx.fsx_xflags |= XFS_XFLAG_NOATIME;
	ioctl(XFS_IOC_SETXATTR, &fsx)

and the problem you allude to does not occur because it will set the
extent size to the same value as it currently has.

> True, it
> will correct the size if not appropriate and it will have a noop impact,
> but still it will be an unrelated inode change. Would it make sense to
> document this in the xfsctl man page then?

There's no point in documenting what *might* happen if you abuse the
interface in ways it was not intended to be used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
