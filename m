Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F5BA7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:06:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F19D6304039
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:06:10 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id U7rMMGtJEaF5Kh12
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:06:09 -0800 (PST)
Message-ID: <54B57ACD.60600@hardwarefreak.com>
Date: Tue, 13 Jan 2015 14:06:37 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de>
	<54B3CC6A.4080405@aei.mpg.de>	<20150112155206.GD25944@bfoster.bfoster>	<54B3F19D.6030307@aei.mpg.de>	<20150112163749.GE25944@bfoster.bfoster>
	<54B40552.50106@aei.mpg.de>
In-Reply-To: <54B40552.50106@aei.mpg.de>
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

On 01/12/2015 11:33 AM, Carsten Aulbert wrote:
...
> The FS was never grown, the machine was installed on November 5th, 2012
> and was (ab)using the FS ever since. On average there have been about
> 1-2 million file creations per day (ranging from a few kByte files to a
> few 100 kBytes) and also an equally large number of deletions (after
> some time). Thus overall, a somewhat busy server.

This workload seems more suited to a database than a filesystem. Though
surely you've already considered such, and chose not to go that route.

With high fragmentation you get lots of seeking.  What model disks are
these?  What is your RAID10 geometry?  Are your partitions properly
aligned to that geometry, and to the drives (512n/512e)?


Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
