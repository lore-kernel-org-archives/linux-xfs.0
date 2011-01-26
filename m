Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLL48q165925 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:21:04 -0600
Subject: Re: [PATCH 0/8] xfs: 2.6.38-rc candidate fixes V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:23:28 -0600
Message-ID: <1296077008.1980.947.camel@doink>
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
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> These are all the pending 2.6.38-rc candidate fixes I have in my queue.

After looking this latest series over I think these
are ready to go:

[1/8] xfs: fix log ticket leak on forced shutdown
[3/8] xfs: speculative delayed allocation uses rounddown_power_of_2
badly
[6/8] xfs: limit extsize to size of AGs and/or MAXEXTLEN
[7/8] xfs: handle CIl transaction commit failures correctly

The next two are marked reviewed by Christoph, but I have
made a few minor suggestions for you to consider.  One is
ready to go, the other may be but you need to verify it.
Changes--if any--would be minor, to make them ready:

[4/8] xfs: limit extent length for allocation to AG size 
[5/8] xfs: prevent extsize alignment from exceeding maximum extent size 

These last two appear to need a small bit of work.
[2/8] xfs: fix efi item leak on forced shutdown
[8/8] xfs: fix dquot shaker deadlock

I don't expect it will take much time to fix these, but
if you want I could take the ones that are ready right
away, without waiting for the rest to get completed.

Let me know how you want me to handle it.  Unless I
hear otherwise I'm awaiting pull requests from you
on reviewed patches.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
