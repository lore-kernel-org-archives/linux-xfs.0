Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11EBD7F9D
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 19:09:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D76F88F8049
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 17:09:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bkGWocD6jFVBCQCD for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 17:09:32 -0700 (PDT)
Date: Wed, 22 Jul 2015 10:09:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150722000923.GB7943@dastard>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<55AE6670.40903@redhat.com> <20150721174753.GA8563@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150721174753.GA8563@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jul 21, 2015 at 01:47:53PM -0400, Mike Snitzer wrote:
> On Tue, Jul 21 2015 at 11:34am -0400, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 7/20/15 5:36 PM, Dave Chinner wrote:
> > The issue we had discussed previously is that there is no agreement
> > across block devices about whether ENOSPC is a permanent or temporary
> > condition.  Asking the admin to tune  the fs to each block device's
> > behavior sucks, IMHO.
> 
> It does suck, but it beats the alternative of XFS continuing to do
> nothing about the problem.

Just a comment on that: doing nothing is better than doing the wrong
thing and being stuck with it forever. :)

> Disucssing more with Vivek, might be that XFS would be best served to
> model what dm-thinp has provided with its 'no_space_timeout'.  It
> defaults to queueing IO for 60 seconds, once the timeout expires the
> queued IOs getted errored.  If set to 0 dm-thinp will queue IO
> indefinitely.

Yes, that's exactly what I proposed in the thread I referenced in
my previous email, and what got stuck on the bikeshed wall because
of these concerns about knob twiddling:

http://oss.sgi.com/archives/xfs/2015-02/msg00346.html

| e.g. if we need configurable error handling, it needs to be
| configurable for different error types, and it needs to be
| configurable on a per-mount basis. And it needs to be configurable
| at runtime, not just at mount time. That kind of leads to using
| sysfs for this. e.g. for each error type we ned to handle different
| behaviour for:
| 
| $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
| [transient] permanent
| $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
| 300
| $ cat
| /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
| 50
| $ cat
| /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
| 1

I've rebased this patchset, and I'm cleaning it up now, so in a few
days I'll have something for review, likely for the 4.3 merge
window....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
