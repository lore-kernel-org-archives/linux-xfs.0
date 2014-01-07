Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40D2D7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 09:22:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31B208F8035
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 07:22:53 -0800 (PST)
Received: from mail.nvrinc.com (mail.nvrinc.com [204.96.165.75]) by
	cuda.sgi.com with ESMTP id cssTyIktF8GdOoa4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jan 2014 07:22:52 -0800 (PST)
Received: from pps.filterd (vmdcdmzgw03prd.dmz.net [127.0.0.1])
	by vmdcdmzgw03prd.dmz.net (8.14.5/8.14.5) with SMTP id s07FIgkm016096
	for <xfs@oss.sgi.com>; Tue, 7 Jan 2014 10:22:51 -0500
Received: from dcex02prd.nvrinc.com (dcex02prd.nvrinc.com [10.6.1.11])
	by vmdcdmzgw03prd.dmz.net with ESMTP id 1h82st9yef-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 07 Jan 2014 10:22:51 -0500
From: "Fitzgerald, Dan" <dfitzger@nvrinc.com>
Subject: RE: noob question
Date: Tue, 7 Jan 2014 15:22:50 +0000
Message-ID: <15F45A6CEAEFE340A264C3346D71EF04C4CA30@DCEX01PRD.nvrinc.com>
References: <15F45A6CEAEFE340A264C3346D71EF04C4C339@DCEX01PRD.nvrinc.com>
	<52CB5F63.3040204@hardwarefreak.com>
In-Reply-To: <52CB5F63.3040204@hardwarefreak.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Yeah, I walked into this one.  Today's my 7th day at a new job, came into this with it already built, and now the business wants to expand the size of the file system that will house pictures served up on the web. I'm pretty sure I wouldn't have chosen xfs for this app; overkill.

It is a VMWare VM, so we do have snapshots. First thing I did when I inherited this was to test those.

Everyone here is calling this thing an "appliance", and the version of Debian doesn't have parted or gdisk.

I'm thinking I'll go into the meeting I have on this in 40 minutes and ask for a vendor contact, and work with them to rebuild the whole thing with better planning.

-----Original Message-----
From: Stan Hoeppner [mailto:stan@hardwarefreak.com]
Sent: Monday, January 06, 2014 8:59 PM
To: Fitzgerald, Dan; xfs@oss.sgi.com
Subject: Re: noob question

On 1/6/2014 4:11 PM, Fitzgerald, Dan wrote:
> I had our VMWare admin extend the file system on which /space is
> mounted (/dev/sda8).

Repeat at least three times:  Storage requires planning.

xfs_growfs only works on contiguous LBA sectors.  The free space to be grown into must begin one LBA sector after the last LBA sector of the current XFS filesystem.  If XFS resides on a partition, then the partition itself must be expanded into the free space before XFS can be grown into the newly expanded partition.  This seems to be your situation.  Resizing partitions is not a fun exercise, and if not done properly you can lose everything, literally.

If a block device is directly formatted with XFS things are easy.
Simply expand the block device capacity, then run xfs_growfs.

Because of the limitations up above, those wishing to add capacity using partitions, in an ad hoc manner, such as you seem to desire here, put their block device space in LVM volumes.  LVM can create a linear LBA address space from little pieces of capacity strewn all over the place on many different storage devices, regardless of their native LBA addressing.  I don't really care for this method either.

I've worked with ESX and bare metal hosts on FC SANs fairly extensively.
 For each of my guests/hosts I assign a 10GB LUN for the guest's boot/root filesystems, and a separate LUN(s), sized appropriately, for its data volume(s).  I directly format each LUN, no partitions.  In the event I need to expand a LUN to increase capacity, xfs_growfs simply works, the way it should, with no hoop jumping.

If you need PIT snapshot capability you must use LVM, unless your storage has a PIT snapshot facility, or you use VMware's snapshot utility.

--
Stan


_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ This email is confidential and intended solely for the use of the individual to whom it is addressed. If you have received this email in error please contact the sender and be advised that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. The terms for the purchase and sale of any property referenced in this email shall be solely determined by a ratified Purchase Agreement. Any information provided in this email, including but not limited to, pricing, financing, features of a property and/or community, is not to be construed as the basis of the bargain for the purchase and sale of any such property.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
