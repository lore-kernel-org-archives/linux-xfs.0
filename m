Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 890077F55
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 09:56:46 -0500 (CDT)
Date: Fri, 30 Aug 2013 09:56:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
Message-ID: <20130830145645.GA1935@sgi.com>
References: <52165830.8050006@redhat.com> <20130826041330.GU6023@dastard>
	<521F4096.9040707@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521F4096.9040707@sgi.com>
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
Cc: Brian Foster <bfoster@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 29, 2013 at 07:37:42AM -0500, Mark Tinguely wrote:
> On 08/25/13 23:13, Dave Chinner wrote:
> >xfs: fix calculation of the number of node entries in a dir3 node
> >
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The calculation doesn't take into account the size of the dir v3
> >header, so overestimates the hash entries in a node. This causes
> >directory buffer overruns when splitting and merging nodes.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Makes sense to me for the inode v3 assert.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> The remove assert with the same test must be in common code; it can
> be triggered in both versions of the inode (Linux 3.10 - TOT). The
> assert on the remove may require the test to be run until the
> filesystem is full before doing the remove.

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
