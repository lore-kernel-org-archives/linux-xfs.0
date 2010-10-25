Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PDiQrx234961 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:44:26 -0500
Date: Mon, 25 Oct 2010 09:45:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: use a common _filter_test_dir function
Message-ID: <20101025134542.GC4235@infradead.org>
References: <201010221409.o9ME9OTQ003885@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010221409.o9ME9OTQ003885@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 22, 2010 at 09:09:24AM -0500, Alex Elder wrote:
> Christoph Hellwig suggested that a function similar to the common
> "_filter_scratch" function ought to be created to handle filtering
> of the TEST_DIR and TEST_DEV variables.  This patch implements that.
> 
> The name "_filter_test" seems like it might suggest it does
> something different, so I'm calling this one "_filter_test_dir".
> This unfortunately makes the "test" and "scratch" functions have
> different naming conventions, but I guess we should be accustomed
> to that by now (consider "TEST_DIR" and "SCRATCH_MNT").
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
