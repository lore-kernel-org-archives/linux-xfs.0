Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13I5QiP238437 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 12:05:26 -0600
Date: Wed, 3 Feb 2010 12:07:06 -0600
From: bpm@sgi.com
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100203180706.GH5702@sgi.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
	<20100203112753.GA19996@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203112753.GA19996@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Wed, Feb 03, 2010 at 06:27:53AM -0500, Christoph Hellwig wrote:
> That leaves open the NFSD case thought.  I'd prefer to have that fixed
> if possibly.  Ben, any chance you could send your patch to use fsync
> to the nfs list ASAP?

I'll make some time to work on it.

> I think we'd be even better off to just force
> -o wsync and disable ->write_inode entirely for NFS, any chance you
> could test such a patch on your setup?

Sure.  IIRC, previous tests were w/ -o wsync and write_inode switched to
fsync passing 1 for fdatasync.  I'll try this too.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
