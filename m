Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5B6bsbQ138536 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 01:37:54 -0500
Date: Sun, 1 Aug 2010 10:15:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: have getfacl(1) report numeric id's
Message-ID: <20100801141549.GB10192@infradead.org>
References: <201007302154.o6ULsNdm008915@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007302154.o6ULsNdm008915@stout.americas.sgi.com>
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

On Fri, Jul 30, 2010 at 04:54:23PM -0500, Alex Elder wrote:
> This patch arranges for calls to getfacl(1) to be given the "-n"
> flag, which requests that user and group id's be listed numerically
> rather than using names.  The affected test output files are also
> updated to indicate the effect of the change.
> 
> This eliminates some spurious output differences I was seeing, due
> to the presence of NIS in my test environment.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonder if this usage should be documented somewhere for future tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
