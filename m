Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbfGHQlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 12:41:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68GXfkc131985
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jul 2019 16:41:50 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tjm9qfgej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2019 16:41:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68Gbb6V107225
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jul 2019 16:41:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tjgrtkxe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2019 16:41:49 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x68GfmND019065
        for <linux-xfs@vger.kernel.org>; Mon, 8 Jul 2019 16:41:48 GMT
Date: Mon, 8 Jul 2019 09:41:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: refactor setflags to use setattr code directly
Message-ID: <20190708164149.GO1404256@magnolia>
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
 <156174693300.1557952.1660572699951099381.stgit@magnolia>
 <75ea899b-f1db-1f32-e7e4-ad3b001a8592@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ea899b-f1db-1f32-e7e4-ad3b001a8592@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jul 07, 2019 at 03:29:42PM -0700, Allison Collins wrote:
> 
> 
> On 6/28/19 11:35 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the SETFLAGS implementation to use the SETXATTR code directly
> > instead of partially constructing a struct fsxattr and calling bits and
> > pieces of the setxattr code.  This reduces code size with no functional
> > change.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   fs/xfs/xfs_ioctl.c |   48 +++---------------------------------------------
> >   1 file changed, 3 insertions(+), 45 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 552f18554c48..6f55cd7eb34f 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1490,11 +1490,8 @@ xfs_ioc_setxflags(
> >   	struct file		*filp,
> >   	void			__user *arg)
> >   {
> > -	struct xfs_trans	*tp;
> >   	struct fsxattr		fa;
> > -	struct fsxattr		old_fa;
> >   	unsigned int		flags;
> > -	int			join_flags = 0;
> >   	int			error;
> >   	if (copy_from_user(&flags, arg, sizeof(flags)))
> > @@ -1505,52 +1502,13 @@ xfs_ioc_setxflags(
> >   		      FS_SYNC_FL))
> >   		return -EOPNOTSUPP;
> > -	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
> > +	xfs_fill_fsxattr(ip, false, &fa);
> 
> While reviewing this patch, it looks like xfs_fill_fsxattr comes in with a
> different set?  Not sure if you meant to stack them that way.  I may come
> back to this patch later if there is a dependency.  Or maybe it might make
> sense to move this patch into the set it depends on?

This series depends on the two that were posted immediately before it,
though I admit the cover letters don't really make that explicit.

--D

> Allison
> 
> > +	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
> >   	error = mnt_want_write_file(filp);
> >   	if (error)
> >   		return error;
> > -
> > -	error = xfs_ioctl_setattr_drain_writes(ip, &fa, &join_flags);
> > -	if (error) {
> > -		xfs_iunlock(ip, join_flags);
> > -		goto out_drop_write;
> > -	}
> > -
> > -	/*
> > -	 * Changing DAX config may require inode locking for mapping
> > -	 * invalidation. These need to be held all the way to transaction commit
> > -	 * or cancel time, so need to be passed through to
> > -	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
> > -	 * appropriately.
> > -	 */
> > -	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
> > -	if (error) {
> > -		xfs_iunlock(ip, join_flags);
> > -		goto out_drop_write;
> > -	}
> > -
> > -	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
> > -	if (IS_ERR(tp)) {
> > -		error = PTR_ERR(tp);
> > -		goto out_drop_write;
> > -	}
> > -
> > -	xfs_fill_fsxattr(ip, false, &old_fa);
> > -	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, &fa);
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		goto out_drop_write;
> > -	}
> > -
> > -	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		goto out_drop_write;
> > -	}
> > -
> > -	error = xfs_trans_commit(tp);
> > -out_drop_write:
> > +	error = xfs_ioctl_setattr(ip, &fa);
> >   	mnt_drop_write_file(filp);
> >   	return error;
> >   }
> > 
