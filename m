Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CGMDkI005473 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 10:22:13 -0600
Date: Thu, 12 Jan 2012 11:22:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
Message-ID: <20120112162210.GA3925@infradead.org>
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com> <4F0DF9C1.2060302@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0DF9C1.2060302@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: jeff.liu@oracle.com, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

With all the complications that we got compared to the initial version,
namely multiple hole extents, dirty unwritten extent detection and
so on I think it's time to stop using xfs_bmapi_read against Dave's
initial suggestion, and switch to using xfs_bmap_search_extents
directly.

The rationale for that is that

  a) using xfs_bmapi_read makes hole detection more complex, given
     that it has to fill potentially multiple xfs_bmbt_irec structures
     instead of skipping over them
  b) reading two extents at a time means we have to duplicate all the
     detection code.

if we use xfs_bmap_search_extents we need a bit of boilerplate code,
but xfs_seek_data becomes really simple - we just loop over
xfs_bmap_search_extents until we either find an extent or EOF.
If we find an extent and it's unwritten we might have to probe for
dirty areas from one single point, or just skip it but the code is
still simple.  xfs_seek_hole is just as simple - if
xfs_bmap_search_extents fits the condition for a hole as written
down in xfs_bmapi_read we've found it, if not we might again have
to do the unwritten extent probing, but just from a single place
instead of duplicating it twice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
