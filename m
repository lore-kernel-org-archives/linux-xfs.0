Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBRE64wJ022541 for <xfs@oss.sgi.com>; Mon, 27 Dec 2010 08:06:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F0D21531846
	for <xfs@oss.sgi.com>; Mon, 27 Dec 2010 06:08:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	5HVQovrdRqheTqwS for <xfs@oss.sgi.com>;
	Mon, 27 Dec 2010 06:08:03 -0800 (PST)
Date: Tue, 28 Dec 2010 01:07:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101227140750.GB24828@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101227061629.GA2275@pandora.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On Mon, Dec 27, 2010 at 08:16:29AM +0200, Petre Rodan wrote:
> 
> Hello Dave,
> 
> On Mon, Dec 27, 2010 at 01:19:04PM +1100, Dave Chinner wrote:
> > On Thu, Dec 23, 2010 at 06:55:32PM +0200, Petre Rodan wrote:
> > > 
> > > Hello,
> [..]
> > > upon closer inspection it turns out that after the first Write
> > > action to that partition, an xfssyncd process continues to write
> > > to that partition each 36 seconds and it doesn't stop doing that,
> > > even if there are no more Writes from the exterior. this keeps the
> > > drive busy with varying consequences. more about that later.
> > 
> > Should be fixed in 2.6.37 by the commit:
> > 
> > 1a387d3 xfs: dummy transactions should not dirty VFS state
> 
> nice that someone else was also keen on having this bug fixed, but this particular fix is already present in 2.6.36 [1], [2]
> 
> unfortunately something is still written to the log every 36s, as per the first mail in this thread.

Turn on the XFS tracing so we can see what is being written every
36s.  When the problem shows up:

# echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
# sleep 100
# cat /sys/kernel/debug/tracing/trace > trace.out
# echo 0 > /sys/kernel/debug/tracing/events/xfs/enable

And post the trace.out file for us to look at.

Cheers,

Dave.



-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
