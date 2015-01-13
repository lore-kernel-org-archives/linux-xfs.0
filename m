Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E72B77F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:42:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C57F9304043
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:42:50 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id UyzA35I6ipZXyC62
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:42:48 -0800 (PST)
Message-ID: <54B58367.1070008@hardwarefreak.com>
Date: Tue, 13 Jan 2015 14:43:19 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de>	<54B3CC6A.4080405@aei.mpg.de>	<20150112155206.GD25944@bfoster.bfoster>	<54B3F19D.6030307@aei.mpg.de>	<20150112163749.GE25944@bfoster.bfoster>	<54B40552.50106@aei.mpg.de>
	<54B57ACD.60600@hardwarefreak.com> <54B57C59.9070207@aei.mpg.de>
In-Reply-To: <54B57C59.9070207@aei.mpg.de>
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
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 01/13/2015 02:13 PM, Carsten Aulbert wrote:
> Hi Stan
> 
> On 01/13/2015 09:06 PM, Stan Hoeppner wrote:
>> This workload seems more suited to a database than a filesystem. Though
>> surely you've already considered such, and chose not to go that route.
>>
> 
> Yepp, but as we do not fully control the server software and need to
> work further on the binary blobs arriving, a database is also not that
> well suited for it, but yes, we looked into it (and run mysql, marida,
> cassandra, mongo, postgresql, ...)
> 
>> With high fragmentation you get lots of seeking.  What model disks are
>> these?  What is your RAID10 geometry?  Are your partitions properly
>> aligned to that geometry, and to the drives (512n/512e)?
> 
> Disks are 2TB Hitachi SATA drives (Ultrastar, HUA722020ALA330). As these
> are some yrs old, they are native 512byte ones. They are connected via
> an Areca 1261ML controller with a Supermicro backplane.
> 
> RAID striping is not ideal (128kByte per member disk) and thus our xfs
> layout is not ideal as well. Things we plan to change with the next
> attempt ;)

With your file sizes that seems a recipe for hotspots.  What do the
controller metrics tell you about IOs per drive, bytes per drive?  Are
they balanced?

> After the arrival of "advanced format" HDD and SSDs we usually try to
> align everything to full 1 MByte or larger, just to be sure any
> combination of 512b, 4kb, ... will eventually align :)

It's not that simple with striping.  Partitions need to start and end on
stripe boundaries, not simply multiples of 4KB or 1MB as with single
disks. If you use non power of 2 drive counts in a stripe, aligning at
multiples of 1MB will screw ya, e.g. 12 drives * 64KB is a 768KB stripe.

Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
