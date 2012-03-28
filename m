Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2S0rgTS212466 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 19:53:43 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OYrhfy1CKrZAleT7 for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 17:53:40 -0700 (PDT)
Date: Wed, 28 Mar 2012 11:53:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] remove xfsbufd
Message-ID: <20120328005337.GH3592@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164400.967415009@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:00PM -0400, Christoph Hellwig wrote:
> Now that we all dirty metadata is tracked in the AIL, and except for few
> special cases only written through it there is no point to keep the current
> delayed buffers list and xfsbufd around.
> 
> This series remove a few more of the remaining special cases and then
> replaced the global delwri buffer list with a local on-stack one.  The
> main consumer is xfsaild, which is used more often now.
> 
> Besides removing a lot of code this change reduce buffer cache lookups
> on loaded systems from xfsaild because we can figure out that a buffer
> already is under writeback entirely locally now.

>From a quick set of tests, I can't see any significant degradation
in IO patterns and performance under heavy load here with this
patch set. it doesn't however, reduce the buffer cache lookups all
that much on such workloads - about 10% at most - as most of the
lookups are common from the directory and inode buffer
modifications. Here's a sample profile:

-  10.09%  [kernel]  [k] _xfs_buf_find
   - _xfs_buf_find
      - 99.57% xfs_buf_get
         - 99.35% xfs_buf_read
            - 99.87% xfs_trans_read_buf
               + 50.36% xfs_da_do_buf
               + 26.12% xfs_btree_read_buf_block.constprop.24
               + 12.36% xfs_imap_to_bp.isra.9
               + 10.73% xfs_read_agi

This shows that 50% of the lookups from the directory code, 25% from
the inode btree lookups, 12% from mapping inodes, and 10% from
reading the AGI buffer during inode allocation. 

You know, I suspect that we could avoid almost all those AGI buffer
lookups by moving to a similar in-core log and flush technique that
the inodes use. We've already got all the information in the struct
xfs_perag - rearranging it to have a "in-core on disk" structures
for the AGI, AGF and AGFL would make a lot of the "select an AG"
code much simpler than having to read and modify the AG buffers
directly. It might even be possible to do such a change without
needing to change the on-disk journal format for them...

I think I'll put that on my list of stuff to do - right next to
in-core unlinked inode lists....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
