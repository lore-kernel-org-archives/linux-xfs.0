Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p122FG1T259188 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 20:15:16 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C01F1A64715
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 18:17:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mLGC5uriZyU74FUm for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 18:17:44 -0800 (PST)
Date: Wed, 2 Feb 2011 13:17:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfstests: add test to reproduce bmap btree corruption.
Message-ID: <20110202021741.GQ11040@dastard>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-3-git-send-email-david@fromorbit.com>
	<1296610194.2350.159.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296610194.2350.159.camel@doink>
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

On Tue, Feb 01, 2011 at 07:29:54PM -0600, Alex Elder wrote:
> On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The problem was reprted here:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=626244
> > 
> > With the simple test case:
> > 
> > # mkfs.xfs -f -d agsize=16m,size=50g <dev>
> > # mount <dev> /mnt
> > # xfs_io -f -c 'resvsp 0 40G' /mnt/foo
> > 
> > Triggering the problem. Turn this into a new xfsqa test so that we
> > exercise the problem code and prevent future regressions.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This looks good, HOWEVER, since the test crashes
> the target system please remove it from (at least)
> the "auto" group before you commit.

If causes an assert failure on a DEBUG kernel, a shutdown on a
non-debug kernel. Either way, I'd prefer to leave it enabled as a
good reminder that we need to fix the damn bug (*) sooner rather
than later...

(*) This patch prevents the assert failure, but, like Lachlan, I'm
not sure it is the right fix.

http://oss.sgi.com/archives/xfs/2010-09/msg00337.html

I'm working on it at the moment, along with all the other allocation
things...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
