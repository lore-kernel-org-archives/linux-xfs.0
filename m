Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOD944t109976 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 07:09:05 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17B6F1C6E2A8
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 05:10:41 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id e2AQD4xciKbK4gTv for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 05:10:41 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUMYG1M9E8LGYUDG@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Wed, 24 Nov 2010 14:10:27 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUMYG108CWLGYUEF@mx.isti.cnr.it> for xfs@oss.sgi.com; Wed,
	24 Nov 2010 14:10:26 +0100 (MET)
Date: Wed, 24 Nov 2010 14:12:32 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <20101124002023.GA22876@dastard>
Message-id: <4CED0F40.606@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<4CEC3CB8.8000509@hardwarefreak.com>
	<20101124002023.GA22876@dastard>
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

On 11/24/2010 01:20 AM, Dave Chinner wrote:
>
> 512MB of BBWC backing the disks. The BBWC does a much better job of
> reordering out-of-order writes than the Linux elevators because
> 512MB is a much bigger window than a couple of thousand 4k IOs.
>    

Hmmm very interesting...
so you are using a MD or DM raid-0 above a SATA controller with a BBWC?
That would probably be a RAID controller used as SATA because I have 
never seen SATA controllers with a BBWC. I'd be interested in the brand 
if you don't mind.


Also I wanted to know... the requests to the drives are really only 4K 
in size for linux? Then what purpose do the elevators' merges have? When 
the elevator merges two 4k requests doesn't it create an 8k request for 
the drive?


Also look at this competitor's link:
http://thunk.org/tytso/blog/2010/11/01/i-have-the-money-shot-for-my-lca-presentation/
post #9
these scalability patches submit larger i/o than 4k. I can confirm that 
from within iostat -x 1  (I can't understand what he means with 
"bypasses the buffer cache layer" though, does it mean it's only for 
DIRECTIO? it does not seem to me). When such large requests go into the 
elevator, are they broken up into 4K requests again?


Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
