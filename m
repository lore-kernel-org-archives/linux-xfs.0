Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD339oV015027 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 21:03:09 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	S58qH93DNomaUQu6 for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 19:05:10 -0800 (PST)
Date: Tue, 13 Nov 2012 14:05:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: fixes for 3.7-rc6
Message-ID: <20121113030507.GE25039@dastard>
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
	<20121113020150.GY9783@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121113020150.GY9783@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 08:01:50PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, Nov 12, 2012 at 10:09:43PM +1100, Dave Chinner wrote:
> > These are the remaining fixes I have in my tree for the 3.7 cycle.
> > One is a corruption fix, the other two are problems I'm seeing
> > during shutdown and recovery testing. That testing lasts 400-500
> > cycles (3-4 hours) now before it fails with another, as yet unknown
> > buffer/perag reference assert failure. Without these fixes, it lasts
> > 3-4 cycles before assert failing or triggering a BUG.
> > 
> > I'd like these fixes to be in the 3.7 cycle if at all possible, with
> > both patch 1 and 2 being stable kernel candidates.
> 
> I think we can make that happen.  I noticed that you posted patches 2 and 3
> earlier today and had to chuckle, but I understand.

Fixing a nasty bug or regression bug and asking it be merged into
the current -rc cycle after initial testing is not unusual, so I'm
not sure why you'd chuckle at that....

> We'll put this 3.7 work at
> the top of the priority queue, followed by your 3.8 queue, and then the few
> items left for the userspace release.

Just FYI, the first thing that needs to be done after the userspace
release is to resync the libxfs/libxlog code with the kernel code.
That needs to be done before any of the CRC changes can be merged,
so be prepared for a pretty major update that'll need review soon
after the release.

IIRC, the last kernel/user resync I did was about 15,000 lines of
change I don't expect this to be quite as big (the previous one
contained the btree consolidation changes), but I'd expect it to be
in the order of 2-3000 lines of change to be needed.

> Thanks for reposting your 3.8 queue, BTW.  Sometimes I think that frequent
> reposts are inconvenient, but in this case I think it will be helpful.

When I'm having trouble tracking of several of my own patch sets for
the same release, it's time for re-organisation and a repost.
Besides, it's a habit Christoph and I got into a while back when we
had lots of work going on and we needed to make sure nothing
slipped through the cracks..... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
