Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6OBCRge261109 for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 06:12:27 -0500
Subject: Re: [RFC, PATCH 0/3] serialise concurrent direct IO sub-block zeroing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100724000946.GK32635@dastard>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<4C49EB67.6020509@sandeen.net>  <20100724000946.GK32635@dastard>
Date: Sat, 24 Jul 2010 06:12:29 -0500
Message-ID: <1279969949.4737.3.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sat, 2010-07-24 at 10:09 +1000, Dave Chinner wrote:
> On Fri, Jul 23, 2010 at 02:20:07PM -0500, Eric Sandeen wrote:
> > Dave Chinner wrote:
> > > Patches for discussion seeing as git.kernel.org is being slow to update.
> > > 
> > 
> > I can confirm that this fixes the qemu problems, too.
> > 
> > Also makes the install take about 30min vs. 10 ;)
> 
> Yeah, that's no surprise - it'll be serialising all the IO even when
> it doesn't need to. Good to know that we've found the cause of the
> problem, though, so we can work from here towards a more robust
> solution.

The patchesmade test 240 in the xfstests suite pass when
it consistently did not for me without it.

However I found that test 104 hung the two times I tried it.
At first I thought it could have been just taking a long time
but the fsstress processes were unkillable and shutdown
didn't complete either.  I tried again after removing the
patches and 104 passed again.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
