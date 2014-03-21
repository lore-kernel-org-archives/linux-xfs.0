Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 191687F83
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 18:10:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00BB88F804B
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 16:10:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	n7vQzxBVWglNNjji for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 16:10:34 -0700 (PDT)
Date: Sat, 22 Mar 2014 10:10:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [FAQ] XFS speculative preallocation
Message-ID: <20140321231032.GC1389@dastard>
References: <20140321162920.GA3087@laptop.bfoster>
	<87eh1vuxam.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eh1vuxam.fsf@mid.deneb.enyo.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Mar 21, 2014 at 09:11:29PM +0100, Florian Weimer wrote:
> * Brian Foster:
> 
> > Although speculative preallocation can lead to reports of excess space
> > usage, the preallocated space is not permanent unless explicitly made so
> > via fallocate or a similar interface.
> 
> How does an explicit allocation with posix_fallocate interact with
> speculative preallocation?  Does it disable it?

fallocate is permanent preallocation using unwritten extents.
Speculative preallocation is an extension of delayed allocation that
is done when extending the file and the EOF falls into a hole. If
there is unwritten extents beyond EOF, speulative preallocation is
not performed.

> I see rather dramatic fragmentation of the systemd journal when it is
> stored on XFS, and it calls posix_fallocate before writing data to the
> file.

There's your problem - systemd is preventing delayed allocation, and
so it fragmenting the file itself with it's write pattern.
Basically, that's a bug in systemd, and not something the filesystem
can avoid because userspace is directly controlling block
allocation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
