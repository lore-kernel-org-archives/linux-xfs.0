Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F29429DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 17:09:07 -0500 (CDT)
Date: Thu, 13 Jun 2013 17:09:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130613220903.GA20932@sgi.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com> <20130613020827.GG29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613020827.GG29338@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Thu, Jun 13, 2013 at 12:08:27PM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2013 at 08:04:41PM -0500, Ben Myers wrote:
> > On Wed, Jun 12, 2013 at 12:19:06PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Unfortunately, we cannot guarantee that items logged multiple times
> > > and replayed by log recovery do not take objects back in time. When
> > > theya re taken back in time, the go into an intermediate state which
> > > is corrupt, and hence verification that occurs on this intermediate
> > > state causes log recovery to abort with a corruption shutdown.
> > > 
> > > Instead of causing a shutdown and unmountable filesystem, don't
> > > verify post-recovery items before they are written to disk. This is
> > > less than optimal, but there is no way to detect this issue for
> > > non-CRC filesystems If log recovery successfully completes, this
> > > will be undone and the object will be consistent by subsequent
> > > transactions that are replayed, so in most cases we don't need to
> > > take drastic action.
> > > 
> > > For CRC enabled filesystems, leave the verifiers in place - we need
> > > to call them to recalculate the CRCs on the objects anyway. This
> > > recovery problem canbe solved for such filesystems - we have a LSN
> > > stamped in all metadata at writeback time that we can to determine
> > > whether the item should be replayed or not. This is a separate piece
> > > of work, so is not addressed by this patch.
> > 
> > Is there a test case for this one?  How are you reproducing this?
> 
> The test case was Dave Jones running sysrq-b on a hung test machine.
> The machine would occasionally end up with a corrupt home directory.
> 
> http://oss.sgi.com/pipermail/xfs/2013-May/026759.html
> 
> Analysis from a metdadump provided by Dave:
> 
> http://oss.sgi.com/pipermail/xfs/2013-June/026965.html
>
> And Cai also appeared to be hitting this after a crash on 3.10-rc4,
> as it's giving exactly the same "verifier failed during log recovery"
> stack trace:
> 
> http://oss.sgi.com/pipermail/xfs/2013-June/026889.html

Thanks.  It appears that the verifiers have found corruption due to a
flaw in log recovery, and the fix you are proposing is to stop using
them.  If we do that, we'll have no way of detecting the corruption and
will end up hanging users of older kernels out to dry.

I think your suggestion that non-debug systems could warn instead of
fail is a good one, but removing the verifier altogether is
inappropriate.

Can you make the metadump available?  I need to understand this better
before I can sign off.  Also:  Any idea how far back this one goes?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
