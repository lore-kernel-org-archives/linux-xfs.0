Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qANCZViu072433 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 06:35:31 -0600
Date: Fri, 23 Nov 2012 07:37:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix to build src/realpath and the correct the
	existence of target devices
Message-ID: <20121123123740.GA12150@infradead.org>
References: <20121121135123.092349449@sgi.com>
	<20121121135210.840563563@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121121135210.840563563@sgi.com>
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
To: rjohnston@sgi.com
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Nov 21, 2012 at 07:51:24AM -0600, rjohnston@sgi.com wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Commit d5ea873f is not the same as the the following original Eric's patch.
> 
> http://oss.sgi.com/archives/xfs/2010-06/msg00080.html
> 
> It does not modify src/Makefile and realpath is never compiled.
> 
> In addition, `[ -L $TEST_DEV ]' and `[ -L $SCRATCH_DEV ]' always returns 0
> if $TEST_DEV or $SCRATCH_DEV are not defined.
> 
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Rich Johnston <rjohnston@sgi.com>

Thanks for the fixes, this looks good.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
