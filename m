Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM2Ysk1148332 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 20:34:54 -0600
Subject: Re: [PATCH 06/34] xfs: dynamic speculative EOF preallocation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101221234412.GC4907@dastard>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-7-git-send-email-david@fromorbit.com>
	<20101221151511.GA26127@infradead.org> <20101221214240.GB4907@dastard>
	<20101221234412.GC4907@dastard>
Date: Tue, 21 Dec 2010 20:29:37 -0600
Message-ID: <1292984977.2408.359.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-12-22 at 10:44 +1100, Dave Chinner wrote:
> On Wed, Dec 22, 2010 at 08:42:40AM +1100, Dave Chinner wrote:
> > On Tue, Dec 21, 2010 at 10:15:11AM -0500, Christoph Hellwig wrote:
> > > This patch causes tesr 014 to take ~ 870 seconds instead of 6, thus
> > > beeing almost 150 times slower on mt 32-bit test VM, so I'll have to NAK
> > > it for now.
> > 
> > It's not the speculative preallocation changes - ithey are just
> > exposing some other regression. That is, using MOUNT_OPTIONS="-o
> > allocsize=4k" gives the previous behaviour, while allocsize=512m
> > gives the same behaviour as the dynamic preallocation.
> > 
> > The dynamic behaviour is resulting in megabyte sized IOs being
> > issued for random 512 byte writes (which is wrong), so I'm tending
> > towards it being a regression caused by the reecent writeback path
> > changes. I'll dig deeper today.
> 
> Ok, it's not a recent regression - it's the fact that the test is 
> writing and truncating to random offsets so the file size is
> constantly changing resulting in xfs_zero_eof() writing huge amounts
> of zeros into preallocated extents beyond EOF. The patch below
> explains the situation and the change to the test to avoid
> the extended runtime.
> 
> Ultimately, we probably need to change xfs_zero_eof() to allocate
> unwritten extents rather than write megabytes of zero for
> speculative allocation beyond EOF. However, I'm going to worry about
> that when (if) we come across applications that trigger this issue.

Your change to test 014 looks good to me, and makes
the test take about the same time it did previously.

Reviewed-by: Alex Elder <aelder@sgi.com>

> --
> 
> xfstests: 014 takes forever with large preallocation sizes
> 
> From: Dave Chinner <dchinner@redhat.com>
> 

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
