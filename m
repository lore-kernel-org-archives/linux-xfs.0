Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AHRYwS113755 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:27:44 -0600
Date: Thu, 10 Mar 2011 12:30:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix parallel make
Message-ID: <20110310173025.GE13390@infradead.org>
References: <201103042235.p24MZ75i023399@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201103042235.p24MZ75i023399@stout.americas.sgi.com>
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

On Fri, Mar 04, 2011 at 04:35:07PM -0600, Alex Elder wrote:
> Having both "include/builddefs" and "include/config.h" as
> dependencies for the default target results in a parallel
> invocation of "make" spawning two concurrent attempts to
> do the configure step--and that doesn't work.
> 
> Creating one of those two will result in the other getting
> created, so there's no need to list both as dependencies.
> 
> There are several other mysterious dependencies that serve
> no purpose, so get rid of them.


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
