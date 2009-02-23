Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NLIt8v110773 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 15:18:56 -0600
Received: from mda1.es.uci.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6310514374A
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 13:18:24 -0800 (PST)
Received: from mda1.es.uci.edu (mda1.es.uci.edu [128.200.80.3]) by
	cuda.sgi.com with ESMTP id 9vyiLOaxRZl5zPGH for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 13:18:24 -0800 (PST)
Received: from smtp1.es.uci.edu (smtp1.es.uci.edu [128.200.80.34])
	by mda1.es.uci.edu (8.13.1/8.13.1) with ESMTP id n1NLIOQ9005748
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 13:18:24 -0800
From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
Date: Mon, 23 Feb 2009 13:20:05 -0800
References: <200902231243.33897.harry.mangalam@uci.edu>
	<49A30CB3.4040100@sandeen.net>
In-Reply-To: <49A30CB3.4040100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902231320.05320.harry.mangalam@uci.edu>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks for the quick response Eric!

On Monday 23 February 2009, Eric Sandeen wrote:
> Harry Mangalam wrote:
> > Here's an unusual (long) tale of woe.
> >
> > We had a USRobotics 8700 NAS appliance with 4 SATA disks in
> > RAID5:

<snip>

> However this wouldn't cause a superblock mis-read like this.  If
> you get it mounted, you *may* run into what looks like directory
> corruption on the PC, though, due to the alignment issue.
>
> Anyway, first, I'd look around for "XFSB" in the early few blocks
> of your raid and see if the raid might possibly have been rebuilt
> out of order.
>
> # dd if=/dev/md0 bs=4k count=32 | hexdump -C | grep XFSB
>
> or so...
>
> -Eric

No, I didn't find this - I did find some disk ID header stuff which 
confirms that the filesystem is XFS and some other info that might be 
useful, but no XFSB strings, even grepping 8MB into the device.

|<IPStorPartition|
| version="3.0" s|
|ize="595" owner=|
|"NACS-SW-DIST" c|
|hecksum="" signa|
|ture="IpStOrDyNa|
|MiCdIsK" dataSta|
|rtAtSectorNo="16|
|128" logvol="0" |
|category="Virtua|
|l Device"/>.<Phy|
|sicalDev guid="5|
|95e9fbb-1951-09c|
|3-a30c-000045d3a|
|a3b" Comment="" |
|WorldWideID="FAL|
|CON  LVMDISK-M09|
|N01  v1.0-0-0-00|
|"/>.............|
|................|

|<DynamicDiskSegm|
|ent guid="126de9|
|2f-98a1-3c06-01e|
|5-000045d3aa4d" |
|firstSector="161|
|28" lastSector="|
|22271" owner="NA|
|CS-SW-DIST" data|
|set="1171499597"|
| seqNo="0" isLas|
|tSegment="true" |
|sectorSize="512"|
| type="Umap" lun|
|Type="0" timesta|
|mp="1171499597" |
|umapTimestamp="0|
|" deviceName="NA|
|SDisk-00002" fil|
|eSystem="XFS"/>.|
|<DynamicDiskSegm|
|ent guid="126de9|
|2f-98a1-3c06-01e|
|5-000045d3aa4d" |
|firstSector="222|
|72" lastSector="|
|2928740095" owne|
|r="NACS-SW-DIST"|
| dataset="117149|
|9597" seqNo="1" |
|isLastSegment="t|
|rue" sectorSize=|
|"512" type="NAS"|
| lunType="0" tim|
|estamp="11714995|
|97" umapTimestam|
|p="0" deviceName|
|="NASDisk-00002"|
|/>..............|
|................|


-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
