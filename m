Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LKmtLU175959 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:48:55 -0500
Subject: Re: [PATCH 0/4] xfs: candidate fixes for 2.6.39-rc4
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1303360144-10632-1-git-send-email-david@fromorbit.com>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
Date: Thu, 21 Apr 2011 15:48:50 -0500
Message-ID: <1303418930.2581.546.camel@doink>
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

On Thu, 2011-04-21 at 14:29 +1000, Dave Chinner wrote:
> This is my current bug fix stack. They are probably all candidates
> for 2.6.39, though I don't mind if we put any of them off
> until.40...

I thought I had said so before on the first three of
these but I guess not.  They look good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

As far as whether to send them to Linus for
2.6.39--I think they'd all four be OK, but
none of them are (recent) regressions and I'm
on a pretty good long streak of not getting
flamed by Linus.  So unless you feel strongly
about it, I'm going to hold them for 2.6.40.


The fourth one I have been following along on the
sidelines without really looking closely at the
code involved.  Now that you and Lachlan seem to
have agreed on this tiny fix I'll take a much
closer look, as I consider all your discussion
along the way.

However, without even doing that I'm OK with
committing it, since I think the change is
very small, it fixes the test 250 crash issue,
and the worst it would do appears to be exhausting
space just a little earlier when it's almost
gone already.

So I'm prepared to pull this series when you
request it.  I'm testing with it right now and
have seen no trouble.


Oh, except that test 250 appears to have no
saved golden output, and the test itself may
need a little work to allow for that.  (Will
you look into that?)

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
