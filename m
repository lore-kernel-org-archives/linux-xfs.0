Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO0tnK4037539 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:55:49 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A1641A03D8
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:56:39 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id XeOwMSz3atAazwW3 for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:56:39 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUM8SULRXCLGYSJW@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Wed, 24 Nov 2010 01:56:18 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUM8SUFYU8LGYSJV@mx.isti.cnr.it> for xfs@oss.sgi.com; Wed,
	24 Nov 2010 01:56:18 +0100 (MET)
Date: Wed, 24 Nov 2010 01:58:25 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <20101123204609.GW22876@dastard>
Message-id: <4CEC6331.3080300@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/23/2010 09:46 PM, Dave Chinner wrote:
> Hmmmm. We get plenty of reports about problems with 3ware RAID
> controllers, many of which are RAID controller problems. Can you
> make sure you are running the latest firmware on the controller?
>    

No, sorry, my firmware is: FE9X 4.06.00.004

But when controllers hang, there is usually something in dmesg, and in 
my case there wasn't. Then after a while it resets (it has something 
like a watchdog in it).
In the past during testing I did have reproducible hangups on high load 
with these controllers (seemed like a lost interrupt), but they were 
fixed by disabling NCQ.
The controller would reset in those cases, drives caches would reset to 
"off", and there were entries in dmesg.
But that issue was definitely fixed by disabling NCQ: I tested many 
times with and without NCQ with reproducible results; and after that we 
had reliable operation for more than 1 year on that machine.

> I've been unable to reproduce the problem with your test case (been
> running over night) on a 12-disk, 16TB dm RAID0 array, but I'll keep
> trying to reproduce it for a while.

It seems to me that 12 disk raid0 dm is quite different from 16 disk md 
raid5 array because you don't have the stripe cache and there are likely 
to be fewer in-flight operations, if it was a pool of something which 
was drained you might not hit it... But I understand that you had the 
raid0 array already up :-D I'll see if I can reproduce this but I can't 
guarantee: the machine should go back to production very soon.
If I hit it again, what should I look at?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
