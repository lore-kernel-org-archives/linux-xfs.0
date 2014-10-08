Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFC487F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 16:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F8EA304039
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 14:24:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NBIYpiuRGiBtWH8p for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 14:24:02 -0700 (PDT)
Date: Thu, 9 Oct 2014 08:23:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Can you help me to investiage a soft lockup?
Message-ID: <20141008212346.GS2301@dastard>
References: <1211918248.8179166.1412774638265.JavaMail.zimbra@enovance.com>
	<734140413.8186921.1412777666412.JavaMail.zimbra@enovance.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <734140413.8186921.1412777666412.JavaMail.zimbra@enovance.com>
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
To: victor stinner <victor.stinner@enovance.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2014 at 04:14:26PM +0200, victor stinner wrote:
> Hello,
> 
> I'm working on OpenStack, and we hit a bug on Swift (distributed
> storage). The Linux kernel 3.2 logged many "soft lockup" messages
> which looks to be related to XFS: see kernel messages at the end
> of this email (it's only an extract of first messages, there are
> more later).

It's contending on the AIL lock, which is then causing contention on
the next layer of locking above that (the iclog locks).

There were lots of optimisations for AIL contention issues around
the 3.2 timeframe as a result of the more widespread use of the
recently introduced delayed logging functionality (which was made
the default config in 3.2).

I'm pretty sure these symptoms were a result of a bug that caused
out-of-order items to be placed on the AIL, hence causing a
walk of the AIL to find the insertion point for every item being
added to the AIL rather than using the cursor to track the current
insertion point and avoid repeated insertion point lookups.

You best bet would be to upgrade to a more recent kernel rather than
try to indentify and backport a bunch of fixes to an old kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
