Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 395BA7F50
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 16:13:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 264F8304032
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:13:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TJ4lY5H7OUt8h9vc for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 14:13:18 -0800 (PST)
Date: Tue, 4 Mar 2014 09:13:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
Message-ID: <20140303221314.GI13647@dastard>
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
	<1393825194-1719-2-git-send-email-david@fromorbit.com>
	<5314BD2B.1010904@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5314BD2B.1010904@sandeen.net>
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

On Mon, Mar 03, 2014 at 11:34:35AM -0600, Eric Sandeen wrote:
> On 3/2/14, 11:39 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > While the verifier reoutines may return EFSBADCRC when a buffer ahs
> > a bad CRC, we need to translate that to EFSCORRUPTED so that the
> > higher layers treat the error appropriately and so we return a
> > consistent error to userspace. This fixes a xfs/005 regression.
> 
> Can you say a little more about the philosophy here?
> 
> xfs/005 regresses because it expects "structure needs cleaning"
> 
> So if we instead return our (icky) CRC error code, we get something else.
> 
> But it is truly a different root cause.
> 
> So the goal is to NEVER leak EFSBADCRC to userspace?  Maybe a comment
> above that error definition would help document that.

Not permanently.  At the moment, none of the code handles it
correctly, and the leak to userspace is just a symptom that tells us
we got somethign wrong. We have plenty of places where we check for
EFSCORRUPTED and do something special, but if we get EFSBADCRC
instead it will do the wrong thing....

> And I'm bit worried that we'll leak more in the future if things changed,
> or if things got missed here.  Everything you have here looks fine, but
> it's not obvious that every path has been caught; it seems a bit random.

It's not random. It's buffer reads that matter, and I
checked all the calls to xfs_buf_read, xfs_buf_read_map,
xfs_trans_read_buf and xfs_trans_read_buf. There aren't any other
read interfaces that use verifiers, and so nothing else can return
EFSBADCRC. For the log recovery cases, the buffer reads don' use
verifiers, and those that do won't return EFSBADCRC (e.g. inode
buffers).

> I know we _just_ merged my "differentiator" patches, but I wonder if
> it would be better to add XFS_BSTATE_BADCRC to b_state or some other 
> field, and go back to always assigning EFSCORRUPTED.  What do you think?

It's just the first layer of adding differentiating support. We've
just put the mechanism in place to do the differentiation because we
need it for *userspace functionality* before we need it for
in-kernel functionality. We put it in the kernel because it has
value to us developers to indicate what type of corruption error was
detected in the dmesg output. We can't however, do everything at
once, so for the moment the kernel code needs to translate it back
to something the higher layers understand and treat correctly.

> When I wrote those I wasn't thinking about keeping it all internal
> to the filesystem.

Only for the moment, until there's code in the kernel that makes it
a meaningfully different error.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
