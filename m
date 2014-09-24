Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 185A97F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:21:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97A66AC004
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 19:21:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vMWRR3dQ5IdqOgFH for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 19:21:25 -0700 (PDT)
Message-ID: <54222AA4.5010501@sandeen.net>
Date: Tue, 23 Sep 2014 21:21:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx> <54222763.40107@sandeen.net>
	<5422285B.6010306@evermeet.cx>
In-Reply-To: <5422285B.6010306@evermeet.cx>
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
To: Helmut Tessarek <tessarek@evermeet.cx>, xfs@oss.sgi.com

On 9/23/14 9:11 PM, Helmut Tessarek wrote:
> On 23.09.14 22:07 , Eric Sandeen wrote:
>> but!  your raid doesn't have a 64k stripe, so that doesn't apply.
> 
> Yep, that's true, but see below.
> 
>> no geometry because md0 raid1 doesn't export any stripe geometry.
> 
> [root@atvie01s ~]# cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdb1[0] sdd1[1]
>       3906784064 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/30 pages [0KB], 65536KB chunk
> 
> So for some reason it shows a 64k chunk size even for RAID1.
> 
> That was what got me confused.

Hm, 65536KB sounds like 64MB...

Anyway, mkfs.xfs picks up the queue's minimum IO size for
sunit, and optimal io size for swidth.

So:

blkid # blockdev --getiomin --getioopt /dev/md0 

(which here returns:
512
0
here)

will show you what your raid's queue is actually reporting,
and what mkfs.xfs will pick up.

-Eric




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
