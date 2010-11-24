Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO5gmdw065890 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 23:42:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FE6F1C6CF17
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 21:44:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	oDOVI9FRf9Cu5ttr for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 21:44:25 -0800 (PST)
Date: Wed, 24 Nov 2010 16:44:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101124054422.GE22876@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<4CEC6331.3080300@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEC6331.3080300@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 01:58:25AM +0100, Spelic wrote:
> On 11/23/2010 09:46 PM, Dave Chinner wrote:
> >Hmmmm. We get plenty of reports about problems with 3ware RAID
> >controllers, many of which are RAID controller problems. Can you
> >make sure you are running the latest firmware on the controller?
> 
> No, sorry, my firmware is: FE9X 4.06.00.004
> 
> But when controllers hang, there is usually something in dmesg, and
> in my case there wasn't. Then after a while it resets (it has
> something like a watchdog in it).
> In the past during testing I did have reproducible hangups on high
> load with these controllers (seemed like a lost interrupt), but they
> were fixed by disabling NCQ.
> The controller would reset in those cases, drives caches would reset
> to "off", and there were entries in dmesg.
> But that issue was definitely fixed by disabling NCQ: I tested many
> times with and without NCQ with reproducible results; and after that
> we had reliable operation for more than 1 year on that machine.
> 
> >I've been unable to reproduce the problem with your test case (been
> >running over night) on a 12-disk, 16TB dm RAID0 array, but I'll keep
> >trying to reproduce it for a while.
> 
> It seems to me that 12 disk raid0 dm is quite different from 16 disk
> md raid5 array because you don't have the stripe cache and there are
> likely to be fewer in-flight operations, if it was a pool of
> something which was drained you might not hit it...

But if that is the cause, then it would indicate an MD problem
rather than an XFS problem. Testing on a similar but slightly
different configuration helps isolate where the problem may lie.

As it is, it is probably caused by the same bug as the problem Nick
reported. See my last post in the thread "XFS performance oddity"
for the patch that fixes the hang Nick reported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
