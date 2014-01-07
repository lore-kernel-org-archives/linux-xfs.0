Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEE4C7F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 19:59:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6B08304081
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 17:59:04 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id azrXiN827r4KrGHH
	for <xfs@oss.sgi.com>; Mon, 06 Jan 2014 17:59:04 -0800 (PST)
Message-ID: <52CB5F63.3040204@hardwarefreak.com>
Date: Mon, 06 Jan 2014 19:58:59 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: noob question
References: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
In-Reply-To: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
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
To: "Fitzgerald, Dan" <dfitzger@nvrinc.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/6/2014 4:11 PM, Fitzgerald, Dan wrote:
> I had our VMWare admin extend the file system on which /space is
> mounted (/dev/sda8).

Repeat at least three times:  Storage requires planning.

xfs_growfs only works on contiguous LBA sectors.  The free space to be
grown into must begin one LBA sector after the last LBA sector of the
current XFS filesystem.  If XFS resides on a partition, then the
partition itself must be expanded into the free space before XFS can be
grown into the newly expanded partition.  This seems to be your
situation.  Resizing partitions is not a fun exercise, and if not done
properly you can lose everything, literally.

If a block device is directly formatted with XFS things are easy.
Simply expand the block device capacity, then run xfs_growfs.

Because of the limitations up above, those wishing to add capacity using
partitions, in an ad hoc manner, such as you seem to desire here, put
their block device space in LVM volumes.  LVM can create a linear LBA
address space from little pieces of capacity strewn all over the place
on many different storage devices, regardless of their native LBA
addressing.  I don't really care for this method either.

I've worked with ESX and bare metal hosts on FC SANs fairly extensively.
 For each of my guests/hosts I assign a 10GB LUN for the guest's
boot/root filesystems, and a separate LUN(s), sized appropriately, for
its data volume(s).  I directly format each LUN, no partitions.  In the
event I need to expand a LUN to increase capacity, xfs_growfs simply
works, the way it should, with no hoop jumping.

If you need PIT snapshot capability you must use LVM, unless your
storage has a PIT snapshot facility, or you use VMware's snapshot utility.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
