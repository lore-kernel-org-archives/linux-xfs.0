Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12MpkcG078494 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 16:51:47 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sB6RMfA01iexCJJL for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 14:51:44 -0800 (PST)
Date: Fri, 3 Feb 2012 09:51:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfsprogs: add debian linux-libc-dev build dependency
Message-ID: <20120202225141.GZ9090@dastard>
References: <1317955640.69734.1328051152460.JavaMail.root@acxmail-au2.aconex.com>
	<419906537.69741.1328051228836.JavaMail.root@acxmail-au2.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <419906537.69741.1328051228836.JavaMail.root@acxmail-au2.aconex.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 01, 2012 at 10:07:08AM +1100, Nathan Scott wrote:
> Add a build dependency on linux-libc-dev, to ensure we build
> packages with have_fiemap set to true if the headers support
> it.  Noticed by Dave, some package builds didn't enable this
> when they should have.
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Works for me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
