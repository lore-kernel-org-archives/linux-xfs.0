Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D4DB77F4E
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:00:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71964AC004
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 21:59:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3HyjoiOkmFOhkpBy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 21:59:56 -0800 (PST)
Date: Mon, 25 Nov 2013 21:59:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/4] xfs: add xfs_create_tmpfile() for O_TMPFILE
	support
Message-ID: <20131126055950.GA1376@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-3-git-send-email-zwu.kernel@gmail.com>
	<20131125213601.GH8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125213601.GH8803@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 08:36:01AM +1100, Dave Chinner wrote:
> 
> Is XFS_PROJID_DEFAULT correct here? If we are getting a parent inode
> from ->tmpfile, then this should be handled the same way as for
> xfs_create.

It should.  And while we're at it that code from create and symlink
should be factored into:

static inline projid_t xfs_initial_projid(struct xfs_inode *dp)
{
	 if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
	 	return xfs_get_projid(dp);
	return XFS_PROJID_DEFAULT;
}

fist.

> I don't think this is necessary here. The ENOSPC flushing in
> xfs_create() is done to ensure we have space for directory block
> creation, not so much for inode allocation. Hence it doesn't make a
> lot of sense to have this here....

Point.  I take back my earlier comment that it should be factored.

> I'm not sure that XFS_MOUNT_DIRSYNC shoul dbe checked here, as there
> is no directory operations to synchronise at all...

It probably shouldn't indeed.  Reminds me of my old patch to make this
a flag to xfs_trans_commit instead of all that boilerplate code..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
