Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E7BC61D85
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 05:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjKUFSY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Nov 2023 00:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbjKUFSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2023 00:18:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7823C8;
        Mon, 20 Nov 2023 21:18:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B1C433C8;
        Tue, 21 Nov 2023 05:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1700543898;
        bh=HHFNcoinUUnz4YyZc9hJOkB9KXU8EP7u8Y91b6MuxQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H/0AgPObmOvNZjmvJ9GoFHs5Y52IlYf2hAfGdabj/uvNdNiwC1BrcRvtEaodSLsLX
         hNWVEMWAJYSo813Ud+p0BQXwELt6Z8Dcy9FOzOOxgL/YEvdn+nV+85+NGH2y8kNVAM
         i61khY8RdyWrd6Q/8XJ82HgcKor/6mlqnm0b0WUw=
Date:   Tue, 21 Nov 2023 06:18:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org,
        linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH 5.15 09/17] xfs: fix NULL pointer dereference in
 xfs_getbmap()
Message-ID: <2023112143-wavy-helpline-c557@gregkh>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
 <20231116022833.121551-9-leah.rumancik@gmail.com>
 <2023112053-monogamy-corned-68ba@gregkh>
 <20231120191130.GE36190@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120191130.GE36190@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 11:11:30AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 20, 2023 at 04:38:24PM +0100, Greg KH wrote:
> > On Wed, Nov 15, 2023 at 06:28:25PM -0800, Leah Rumancik wrote:
> > > From: ChenXiaoSong <chenxiaosong2@huawei.com>
> > > 
> > > [ Upstream commit 001c179c4e26d04db8c9f5e3fef9558b58356be6 ]
> > > 
> > > Reproducer:
> > >  1. fallocate -l 100M image
> > >  2. mkfs.xfs -f image
> > >  3. mount image /mnt
> > >  4. setxattr("/mnt", "trusted.overlay.upper", NULL, 0, XATTR_CREATE)
> > >  5. char arg[32] = "\x01\xff\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00"
> > >                    "\x00\x00\x00\x00\x00\x08\x00\x00\x00\xc6\x2a\xf7";
> > >     fd = open("/mnt", O_RDONLY|O_DIRECTORY);
> > >     ioctl(fd, _IOC(_IOC_READ|_IOC_WRITE, 0x58, 0x2c, 0x20), arg);
> > > 
> > > NULL pointer dereference will occur when race happens between xfs_getbmap()
> > > and xfs_bmap_set_attrforkoff():
> > > 
> > >          ioctl               |       setxattr
> > >  ----------------------------|---------------------------
> > >  xfs_getbmap                 |
> > >    xfs_ifork_ptr             |
> > >      xfs_inode_has_attr_fork |
> > >        ip->i_forkoff == 0    |
> > >      return NULL             |
> > >    ifp == NULL               |
> > >                              | xfs_bmap_set_attrforkoff
> > >                              |   ip->i_forkoff > 0
> > >    xfs_inode_has_attr_fork   |
> > >      ip->i_forkoff > 0       |
> > >    ifp == NULL               |
> > >    ifp->if_format            |
> > > 
> > > Fix this by locking i_lock before xfs_ifork_ptr().
> > > 
> > > Fixes: abbf9e8a4507 ("xfs: rewrite getbmap using the xfs_iext_* helpers")
> > > Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > [djwong: added fixes tag]
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> > > Acked-by: Chandan Babu R <chandanbabu@kernel.org>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 17 +++++++++--------
> > >  1 file changed, 9 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index fd2ad6a3019c..bea6cc26abf9 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -439,29 +439,28 @@ xfs_getbmap(
> > >  		whichfork = XFS_COW_FORK;
> > >  	else
> > >  		whichfork = XFS_DATA_FORK;
> > > -	ifp = XFS_IFORK_PTR(ip, whichfork);
> > >  
> > >  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > >  	switch (whichfork) {
> > >  	case XFS_ATTR_FORK:
> > > +		lock = xfs_ilock_attr_map_shared(ip);
> > >  		if (!XFS_IFORK_Q(ip))
> > > -			goto out_unlock_iolock;
> > > +			goto out_unlock_ilock;
> > >  
> > >  		max_len = 1LL << 32;
> > > -		lock = xfs_ilock_attr_map_shared(ip);
> > >  		break;
> > >  	case XFS_COW_FORK:
> > > +		lock = XFS_ILOCK_SHARED;
> > > +		xfs_ilock(ip, lock);
> > > +
> > >  		/* No CoW fork? Just return */
> > > -		if (!ifp)
> > > -			goto out_unlock_iolock;
> > > +		if (!XFS_IFORK_PTR(ip, whichfork))
> 
> Is this the line 457 that the compiler complains about below?
> 
> If so, then whichfork == XFS_COW_FORK here, because the code just
> switch()d on that.  The XFS_IFORK_PTR macro decomposes into:
> 
> #define XFS_IFORK_PTR(ip,w)		\
> 	((w) == XFS_DATA_FORK ? \
> 		&(ip)->i_df : \
> 		((w) == XFS_ATTR_FORK ? \
> 			(ip)->i_afp : \
> 			(ip)->i_cowfp))
> 
> which means this test /should/ be turning into:
> 
> 		if (!(ip->i_cowfp))
> 			goto out_unlock_ilock;
> 
> I'm not sure why your compiler is whining about &ip->i_df; that's not
> what's being selected here for testing.  Unless your compiler is somehow
> deciding that XFS_DATA_FORK == XFS_COW_FORK?  This should not ever be
> possible.

This is using gcc-12, and gcc-13, no idea what happened, just that it
throws up that warning which stops my builds :(

thanks,

greg k-h
