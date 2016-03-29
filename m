Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF0367CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 02:21:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A26C5304032
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 00:21:32 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id KHBBzE3rbfNA3bja (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 00:21:30 -0700 (PDT)
Date: Tue, 29 Mar 2016 09:21:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: don't hand out pNFS layouts for reflink inodes
Message-ID: <20160329072128.GA14940@lst.de>
References: <1456936485-21940-1-git-send-email-hch@lst.de>
	<20160328195140.GB5360@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160328195140.GB5360@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Mar 28, 2016 at 12:51:40PM -0700, Darrick J. Wong wrote:
> >  	/*
> > +	 * The pNFS block layout spec actually supports reflink like
> > +	 * functionality, but the Linux pNFS server doesn't implement it yet.
> > +	 */
> > +	if (!xfs_is_reflink_inode(ip))
> > +		return -ENXIO;
> 
> /me isn't familiar with pNFS, but doesn't this make it so that
> xfs_fs_map_blocks /only/ works on reflinked files?  Maybe I'm misreading the
> comment, but it sounds to me like Linux doesn't support reflinked files over
> pNFS and therefore we want to disable this iomapping functionality any time we
> find a reflinked file.
> 
> But maybe there's a subtlety here that I'm missing?

You jsut missed me fat fingering the check :)

Btw, we'll need something similar to prevent swapfiles which just use
->bmap, but unfortunately swap just checks for the existences of method,
so I'll probably have to do some VFS changes to properly support that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
