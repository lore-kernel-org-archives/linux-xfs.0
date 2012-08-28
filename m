Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SKJJao145500 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 15:19:19 -0500
Date: Tue, 28 Aug 2012 15:20:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfstests: test 110 sometimes fails to unmount
	scratch dev
Message-ID: <20120828202007.GF3274@sgi.com>
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-2-git-send-email-david@fromorbit.com>
	<20120828200611.GA31348@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828200611.GA31348@infradead.org>
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

On Tue, Aug 28, 2012 at 04:06:11PM -0400, Christoph Hellwig wrote:
> On Thu, Jul 26, 2012 at 06:35:03PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It runs a bunch of rm processes in the background, then immediately
> > calls _check_scratch_fs without waiting for them to complete, hence
> > the unmount can fail with a busy filesystem error.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

These four are in the oss xfstests master branch... just a heads up.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
