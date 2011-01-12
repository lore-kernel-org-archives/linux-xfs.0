Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CFsh1m215340 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 09:54:43 -0600
Subject: XFS master branch update
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110112121946.GD16267@dastard>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-2-git-send-email-david@fromorbit.com>
	<20110112121010.GA32321@infradead.org> <20110112121946.GD16267@dastard>
Date: Wed, 12 Jan 2011 09:56:31 -0600
Message-ID: <1294847791.4269.31.camel@doink>
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
To: xfs@oss.sgi.com

I just pushed an update to the master branch on oss.
It includes:
- Dave's fixes to address corruption due to overlapping
  concurrent async direct I/O (and associated code
  cleanup).
- Dave's patch to avoid repeated log covering transactions
  while idle.
- Christoph's patch to add FITRIM support to XFS.
- Christoph's change (with credit to others) to
  rework the buffer I/O completion code, fixing
  problems that occur should a sync I/O fail.
- Three more, described below.

I plan to send this stuff to Linus in another pull
request for 2.6.38--probably next week sometime--after
it's spent some time in the -next tree.

Dave, you're going to want to pay particular note
to the last three of these.  They affect patch
series you have but which have not been accepted
yet:
- xfs: prevent NMI timeouts in cmn_err
    This was the first in your recent log API series
- xfs: Add log level to assertion printk
    This one gets eliminated by the log API series,
    but the last one in your series won't apply
    cleanly because one is in place.  (Trivial fix.)
- xfs: fix an assignment within an ASSERT()
    This one was proposed by Anton Blanchard but
    you said it had already been covered by a
    patch you had.  But that patch was held back
    with the percpu counters stuff, and I wanted
    to include the fix now.  Again, easy to fix
    but I just wanted to call your attention to it.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
