Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGaxqH173417 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:37:02 -0500
Date: Fri, 30 Apr 2010 12:39:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Message-ID: <20100430163903.GA14107@infradead.org>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
	<20100429064943.GB3774@dastard>
	<20100429104611.GA17317@infradead.org>
	<20100430012630.GC32515@dastard> <1272594520.3221.154.camel@doink>
	<20100430085511.GE32515@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100430085511.GE32515@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Apr 30, 2010 at 06:55:11PM +1000, Dave Chinner wrote:
> autoconf is supposed to handle that. If you don't have a critical
> package, autoconf will fail and ask you to install it. For
> non-critical packages or libraries, it just compiles it out.  The
> above error indicates that my autoconf changes are not detecting the
> libgdbm_compat library correctly (no surprise, I just hacked a hack
> to make it work on my system) so once that is sorted dbtest won't
> even be built unless the libraries are installed and detected.
> 
> FWIW, Christoph, does the problem go away with a 'make distclean;
> make'?

Yes, that fixes it and now I can run 010.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
