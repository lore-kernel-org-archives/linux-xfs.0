Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 268867F59
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 20:04:45 -0500 (CDT)
Date: Wed, 12 Jun 2013 20:04:41 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130613010441.GX20932@sgi.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371003548-4026-2-git-send-email-david@fromorbit.com>
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

Hey Dave,

On Wed, Jun 12, 2013 at 12:19:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unfortunately, we cannot guarantee that items logged multiple times
> and replayed by log recovery do not take objects back in time. When
> theya re taken back in time, the go into an intermediate state which
> is corrupt, and hence verification that occurs on this intermediate
> state causes log recovery to abort with a corruption shutdown.
> 
> Instead of causing a shutdown and unmountable filesystem, don't
> verify post-recovery items before they are written to disk. This is
> less than optimal, but there is no way to detect this issue for
> non-CRC filesystems If log recovery successfully completes, this
> will be undone and the object will be consistent by subsequent
> transactions that are replayed, so in most cases we don't need to
> take drastic action.
> 
> For CRC enabled filesystems, leave the verifiers in place - we need
> to call them to recalculate the CRCs on the objects anyway. This
> recovery problem canbe solved for such filesystems - we have a LSN
> stamped in all metadata at writeback time that we can to determine
> whether the item should be replayed or not. This is a separate piece
> of work, so is not addressed by this patch.

Is there a test case for this one?  How are you reproducing this?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
