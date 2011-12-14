Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEDvZli211636 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 07:57:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2B7B1EAD433
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 05:30:16 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	u7lK3dHIiKR6KoHL for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 05:30:16 -0800 (PST)
Date: Wed, 14 Dec 2011 08:30:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] xfs: remove the i_new_size field in struct xfs_inode
Message-ID: <20111214133016.GB30603@infradead.org>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155919.025710280@bombadil.infradead.org>
	<20111213231611.GG3179@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111213231611.GG3179@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 10:16:11AM +1100, Dave Chinner wrote:
> > Note that currently the generic direct I/O code only updates i_size after
> > calling our end_io handler, which requires a small workaround to make
> > sure di_size actually makes it to disk.  I hope to fix this properly in
> > the generic code.
> 
> I think there's a couple of issues with the work around - the
> generic code marks the inode dirty when it updates the inode size.
> With your early setting of the size, it will no longer do this
> because it doesn't see that it needs to update the inode size.
> This may not be a problem if we mark the inode dirty elsewhere, but
> I'm not sure we do in the direct IO path.

We do from I/O completion, once we actually update the on-disk inode
size that actually gets logged.  Before the on-disk inode size has
been updated ->write_inode is a no-op as far as size updates are
concerned, so marking the inode dirty earlier doesn't buy us anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
