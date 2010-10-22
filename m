Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9MBlfqU173921 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 06:47:41 -0500
Date: Fri, 22 Oct 2010 07:48:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: use a common _filter_scratch function
Message-ID: <20101022114855.GA13867@infradead.org>
References: <201010211900.o9LJ086G002762@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010211900.o9LJ086G002762@stout.americas.sgi.com>
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

On Thu, Oct 21, 2010 at 02:00:08PM -0500, Alex Elder wrote:
> There are a number of tests that use a shell function called
> "filter_scratch" or "_filter_scratch" in order to have the actual
> scratch device or mount point show up in test output with a symbolic
> name.  There are two sets, each following a slightly different
> convention.  Put a common _filter_scratch function definition in
> "common.filter" and have all test scripts use that instead.
> Choosing one of the two conventions meant that a few test output
> files had to be changed.
> 
> In addition, add a call to _filter_scratch to test 185, and update
> its output accordingly.

Looks good.  It might be worth to add a TEST_DIR filter for completeness
as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
