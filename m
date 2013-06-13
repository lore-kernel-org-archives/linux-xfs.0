Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B973C7F72
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 21:08:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85E14304039
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 19:08:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ciqCksVyImU2RfEC for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 19:08:28 -0700 (PDT)
Date: Thu, 13 Jun 2013 12:08:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130613020827.GG29338@dastard>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613010441.GX20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 08:04:41PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Wed, Jun 12, 2013 at 12:19:06PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Unfortunately, we cannot guarantee that items logged multiple times
> > and replayed by log recovery do not take objects back in time. When
> > theya re taken back in time, the go into an intermediate state which
> > is corrupt, and hence verification that occurs on this intermediate
> > state causes log recovery to abort with a corruption shutdown.
> > 
> > Instead of causing a shutdown and unmountable filesystem, don't
> > verify post-recovery items before they are written to disk. This is
> > less than optimal, but there is no way to detect this issue for
> > non-CRC filesystems If log recovery successfully completes, this
> > will be undone and the object will be consistent by subsequent
> > transactions that are replayed, so in most cases we don't need to
> > take drastic action.
> > 
> > For CRC enabled filesystems, leave the verifiers in place - we need
> > to call them to recalculate the CRCs on the objects anyway. This
> > recovery problem canbe solved for such filesystems - we have a LSN
> > stamped in all metadata at writeback time that we can to determine
> > whether the item should be replayed or not. This is a separate piece
> > of work, so is not addressed by this patch.
> 
> Is there a test case for this one?  How are you reproducing this?

The test case was Dave Jones running sysrq-b on a hung test machine.
The machine would occasionally end up with a corrupt home directory.

http://oss.sgi.com/pipermail/xfs/2013-May/026759.html

Analysis from a metdadump provided by Dave:

http://oss.sgi.com/pipermail/xfs/2013-June/026965.html

And Cai also appeared to be hitting this after a crash on 3.10-rc4,
as it's giving exactly the same "verifier failed during log recovery"
stack trace:

http://oss.sgi.com/pipermail/xfs/2013-June/026889.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
