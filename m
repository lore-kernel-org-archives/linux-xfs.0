Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9B7B7CBE
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 17:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D6C48F8066
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:20:46 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id lvPD0WUmq2wgY9CU
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:20:45 -0700 (PDT)
Message-ID: <520C02BE.6060506@hardwarefreak.com>
Date: Wed, 14 Aug 2013 17:20:46 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <520B1B4F.9070800@hardwarefreak.com>
	<520B9CCF.1040908@allmail.net> <520BBEFB.9030002@hardwarefreak.com>
	<520BC8B1.9060106@allmail.net>
In-Reply-To: <520BC8B1.9060106@allmail.net>
Reply-To: stan@hardwarefreak.com
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
To: Michael Maier <m1278468@allmail.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 8/14/2013 1:13 PM, Michael Maier wrote:
> Stan Hoeppner wrote:
>> If you keep growing until you consume the disk, you'll have ~100
>> allocation groups.  Typically you'd want to have no more than 4 AGs per
>> spindle.  You already have 42 (or 45) which will tend to seek the disk
>> to death with many workloads, driving latency through the roof and
>> decreasing throughput substantially.  Do you notice any performance
>> problems yet?
> 
> What are expected rates for copying e.g. a 10GB file? It's a Seagate
> Barracuda 3000GB Model ST3000DM001 SATA connected to SATA 6 Gb/s chip.
> The source and the destination FS is LUKS crypted. About 3 GB usable RAM
> (cache), AMD FX-8350 processor @ max. 3800MHz.

Too many variables really to hazard a guess.  If you put a gun to my
head, I'd say strictly looking at the ingest rate of the Seagate, at a
little less than half capacity, writing about 1/3rd of the way down the
platters, optimum throughput should be 80-100 MB/s or so in the last 3
AGs, if free space isn't too heavily fragmented.

> It's getting slower as more as the free space on the fs is reduced
> (beginning at about the last GB). 

This is due to writing into fragmented free space in the 40+ AGs.  This
occurs after the last large free space extents have been consumed, those
extents in the last 3 AGs created by the last xfs_growfs.

> Resizing it makes the problem
> disappear again.

After adding another ~90 GB of free space XFS will preferentially write
large files into the new large free extents, avoiding the existing
fragmented free space in the preexisting AGs.

>> Or is this XFS strictly being used as a WORM like backup
>> silo?
> 
> yes

With so many smallish AGs, so many grow ops, and this backup workload,
I'm curious as to what your free space map looks like.  Would you mind
posting the output of the following command, if you can?

$ xfs_db -r -c freesp <dev>

Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
