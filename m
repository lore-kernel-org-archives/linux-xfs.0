Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 83DFE7CA2
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 19:09:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDD9BAC001
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 17:08:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DxwOMpaxDExJc2b7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 17:08:50 -0700 (PDT)
Date: Tue, 29 Mar 2016 17:08:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't hand out pNFS layouts for reflink inodes
Message-ID: <20160330000842.GD5822@birch.djwong.org>
References: <1456936485-21940-1-git-send-email-hch@lst.de>
	<20160328195140.GB5360@birch.djwong.org>
	<20160329072128.GA14940@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329072128.GA14940@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Mar 29, 2016 at 09:21:28AM +0200, Christoph Hellwig wrote:
> On Mon, Mar 28, 2016 at 12:51:40PM -0700, Darrick J. Wong wrote:
> > >  	/*
> > > +	 * The pNFS block layout spec actually supports reflink like
> > > +	 * functionality, but the Linux pNFS server doesn't implement it yet.
> > > +	 */
> > > +	if (!xfs_is_reflink_inode(ip))
> > > +		return -ENXIO;
> > 
> > /me isn't familiar with pNFS, but doesn't this make it so that
> > xfs_fs_map_blocks /only/ works on reflinked files?  Maybe I'm misreading the
> > comment, but it sounds to me like Linux doesn't support reflinked files over
> > pNFS and therefore we want to disable this iomapping functionality any time we
> > find a reflinked file.
> > 
> > But maybe there's a subtlety here that I'm missing?
> 
> You jsut missed me fat fingering the check :)

Fair enough, I'll integrate this patch, but with:

if (xfs_is_reflink_inode(ip))
	return -ENXIO;

> Btw, we'll need something similar to prevent swapfiles which just use
> ->bmap, but unfortunately swap just checks for the existences of method,
> so I'll probably have to do some VFS changes to properly support that.

Yes, please.  ocfs2 will gladly let you call swapon on a reflinked file,
and totally fails to CoW it properly. :)

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
