Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F92D7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:13:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D6F58F8040
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:13:24 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id amIRUNGdcOfL1QCz for
	<xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:13:21 -0800 (PST)
Message-ID: <54B57C59.9070207@aei.mpg.de>
Date: Tue, 13 Jan 2015 21:13:13 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de>	<54B3CC6A.4080405@aei.mpg.de>	<20150112155206.GD25944@bfoster.bfoster>	<54B3F19D.6030307@aei.mpg.de>	<20150112163749.GE25944@bfoster.bfoster>	<54B40552.50106@aei.mpg.de>
	<54B57ACD.60600@hardwarefreak.com>
In-Reply-To: <54B57ACD.60600@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi Stan

On 01/13/2015 09:06 PM, Stan Hoeppner wrote:
> This workload seems more suited to a database than a filesystem. Though
> surely you've already considered such, and chose not to go that route.
> 

Yepp, but as we do not fully control the server software and need to
work further on the binary blobs arriving, a database is also not that
well suited for it, but yes, we looked into it (and run mysql, marida,
cassandra, mongo, postgresql, ...)

> With high fragmentation you get lots of seeking.  What model disks are
> these?  What is your RAID10 geometry?  Are your partitions properly
> aligned to that geometry, and to the drives (512n/512e)?

Disks are 2TB Hitachi SATA drives (Ultrastar, HUA722020ALA330). As these
are some yrs old, they are native 512byte ones. They are connected via
an Areca 1261ML controller with a Supermicro backplane.

RAID striping is not ideal (128kByte per member disk) and thus our xfs
layout is not ideal as well. Things we plan to change with the next
attempt ;)

After the arrival of "advanced format" HDD and SSDs we usually try to
align everything to full 1 MByte or larger, just to be sure any
combination of 512b, 4kb, ... will eventually align :)

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
