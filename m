Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B93327F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 19:04:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A5D58F8039
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 17:04:03 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	H4zZ1UZ8Yo5YFUEo for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 17:03:56 -0800 (PST)
Date: Fri, 28 Feb 2014 12:03:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mkfs: default log size for small filesystems too large
Message-ID: <20140228010323.GG30131@dastard>
References: <1393494344-30056-1-git-send-email-david@fromorbit.com>
	<1393494344-30056-2-git-send-email-david@fromorbit.com>
	<530FBC2F.4070301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530FBC2F.4070301@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Feb 27, 2014 at 04:29:03PM -0600, Eric Sandeen wrote:
> On 2/27/14, 3:45 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recent changes to the log size scaling have resulted in using the
> > default size multiplier for the log size even on small filesystems.
> > Commit 88cd79b ("xfs: Add xfs_log_rlimit.c") changed the calculation
> > of the maximum transaction size that the kernel would issues and
> > that significantly increased the minimum size of the default log.
> > As such the size of the log on small filesystems was typically
> > larger than the prefious default, even though the previous default
> > was still larger than the minimum needed.
> > 
> > Rework the default log size calculation such that it will use the
> > original log size default if it is larger than the minimum log size
> > required, and only use a larger log if the configuration of the
> > filesystem requires it.
> > 
> > This is especially obvious in xfs/216, where the default log size is
> > 10MB all the way up to 16GB filesystems. The current mkfs selects a
> > log size of 50MB for the same size filesystems and this is
> > unnecessarily large.
> > 
> > Return the scaling of the log size for small filesystems to
> > something similar to what xfs/216 expects.
> 
> I can confirm that this fixes xfs/216, but I've lost the thread on
> why log size scaling was changed at all in 88cd79b, and why we now
> end up with something different in mkfs.xfs than what we originally
> had....  Are there resulting functional changes?  Cosmetic?  What's
> going on with log scaling, and who moved my cheese?  :)

tl;dr: I screwed up with the original change that caused the log
size to increase. It wasn't caught by review, it caused quite a few
problems for xfstests, and some of the things it was doing made no
sense. So this patch  is reverting the behaviour back to -almost-
the same as the 3.1.x series.

The only difference is that now the minimum log size takes into
account sunit padding on log writes IOWs, the log sizes should be
identical to 3.1.x for filesystems with lsu=0 and that's why tests
like xfs/216 pass again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
