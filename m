Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A54029DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 16:01:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B48AAC003
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 14:01:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gIheOmz2eTFNgLy7 for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 14:01:22 -0800 (PST)
Date: Tue, 1 Dec 2015 09:00:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS corruption - Ubuntu 14.04 VM with RDM
Message-ID: <20151130220039.GN26718@dastard>
References: <CAN9JxOBRynxTiEcsgYWKO2SVNFwdeV7gDHfZcbPb4umWXsj5DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAN9JxOBRynxTiEcsgYWKO2SVNFwdeV7gDHfZcbPb4umWXsj5DQ@mail.gmail.com>
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
To: Amir Soroka <amirsoroka@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 30, 2015 at 10:48:45PM +0200, Amir Soroka wrote:
> Hello,
> We have a corruption issue. Would be happy to get a solution.
> 
> Configuration is Ubuntu 14.04 (generic) as a VM over ESXi 5.5, with 1.6 TB
> RDM - storage has a Cache battery, Raid 6, SSD disks.

Please reproduce on bare metal, and with a recent kernel.

> During some heavy indexing activity we get a corruption as you can see
> below.

Doesn't tell me anything about the workload. Please include:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> Some more information:
> * Mount options: defaults,noatime,nodiratime,nobarrier,inode64,logbufs=8 0 0
> * XFS was created like this: mkfs.xfs -f -d su=131072,sw=8 -i size=1024
> /dev/sdb1
> * Parted command was: /sbin/parted -s $i mklabel gpt mkpart /dev/sdb1 xfs
> 2048s 100%
> 
> 
> [   10.395575] XFS (sdb1): Mounting V4 Filesystem
> [   10.430107] XFS (sdb1): Ending clean mount
> [  675.504000] XFS (sdb1): Metadata corruption detected at
> xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1

There should be lots more error logging than that. Where are the
stack traces, the hex dumps, etc that go along with normal
corruption reports?

> [84997.869987] XFS (sdb1): Metadata corruption detected at
> xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110

There's more than one type of corruption - I'd suggest that you have
a vmware/esx level problem....

> [84997.871163] XFS (sdb1): Unmount and run xfs_repair
> [84997.871760] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
> [84997.874798] XFS (sdb1): metadata I/O error: block 0x110

Yup, you've removed all the detailed corruption information in the
output. i.e. all the bits that might tell us what went wrong.
Please post the logs *in full*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
