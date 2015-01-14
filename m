Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A29B47F3F
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 00:07:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 812708F8050
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 22:07:25 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id 5wJWK7b9F01PABIP for
	<xfs@oss.sgi.com>; Tue, 13 Jan 2015 22:07:18 -0800 (PST)
Message-ID: <54B60784.5090505@aei.mpg.de>
Date: Wed, 14 Jan 2015 07:07:00 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de>	<54B3CC6A.4080405@aei.mpg.de>	<20150112155206.GD25944@bfoster.bfoster>	<54B3F19D.6030307@aei.mpg.de>	<20150112163749.GE25944@bfoster.bfoster>	<54B40552.50106@aei.mpg.de>
	<54B57ACD.60600@hardwarefreak.com> <54B57C59.9070207@aei.mpg.de>
	<54B58367.1070008@hardwarefreak.com>
In-Reply-To: <54B58367.1070008@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Hi Stan

On 01/13/2015 09:43 PM, Stan Hoeppner wrote:
> With your file sizes that seems a recipe for hotspots.  What do the
> controller metrics tell you about IOs per drive, bytes per drive?  Are
> they balanced?
> 

They looked ok from 10000ft, but unfortunately, the controller is not
that talkative :(

>> After the arrival of "advanced format" HDD and SSDs we usually try to
>> align everything to full 1 MByte or larger, just to be sure any
>> combination of 512b, 4kb, ... will eventually align :)
> 
> It's not that simple with striping.  Partitions need to start and end on
> stripe boundaries, not simply multiples of 4KB or 1MB as with single
> disks. If you use non power of 2 drive counts in a stripe, aligning at
> multiples of 1MB will screw ya, e.g. 12 drives * 64KB is a 768KB stripe.

At the moment there are 16 disks (or 8 "data" disks), so here, power of
2 still prevails. But still, very valid remark!

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
