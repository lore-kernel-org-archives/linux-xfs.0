Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q289AYRX003632 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 03:10:34 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id ohb1CVHy38aoiYur for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 01:10:33 -0800 (PST)
Date: Thu, 8 Mar 2012 09:10:33 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308091033.GC23992@nsrc.org>
References: <20120307155439.GA23360@nsrc.org>
	<20120307171619.GA23557@nsrc.org> <4F57A32A.5010704@sandeen.net>
	<20120308021054.GM3592@dastard> <4F5816D6.80801@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5816D6.80801@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 08:17:58PM -0600, Eric Sandeen wrote:
> It seems worth thinking about.  I guess I'm still a little concerned
> about the ENOSPC case; it could lead to some confusion - I could imagine
> several hundreds of gigs under preallocation, with a reasonable-sized
> filesystem returning ENOSPC quite early.

And presumably df on the filesystem would also show it approaching 100%
utilisation?

I'm used to this where a large file has been unlinked but is still open. 
The preallocation case is a new one to me though.

How about if the total of all preallocations were limited to some small
percentage of the total filesystem size?  If you reach this limit and want
to preallocate some space for another file you'd have to either drop or
shrink an older preallocation.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
