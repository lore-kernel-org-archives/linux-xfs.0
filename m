Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97CButU065837 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 07:11:56 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id PGRMopvfDyCq897X for
	<xfs@oss.sgi.com>; Sun, 15 Jan 2012 16:27:23 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RmaPz-0007Vc-BC
	for xfs@oss.sgi.com; Sun, 15 Jan 2012 16:27:23 -0800
Message-ID: <33145068.post@talk.nabble.com>
Date: Sun, 15 Jan 2012 16:27:23 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: Re: Optimal XFS formatting options?
In-Reply-To: <4F12006F.8080805@hardwarefreak.com>
MIME-Version: 1.0
References: <33140169.post@talk.nabble.com>
	<4F12006F.8080805@hardwarefreak.com>
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
To: xfs@oss.sgi.com


>So let's assume your vendor does the smart thing and allows you 
>flexibility in specifying per drive strip size.  Assume for example the 
>stripe unit (strip, chunk) of the array is 64KB, there are 10 stripe 
>spindles (12-2=10), and the local device name of the LUN is /dev/sdb. 
>To create an aligned XFS filesystem on this you would use something like: 

>$ mkfs.xfs -d su=64k sw=10 /dev/sdb 

Great explanations! (some of it I am still trying to understand :-)  In this
case on my HP P2000 G3, I do have a 64k chunk size so I will do:

$ mkfs.xfs -d su=64k,sw=10 /dev/sdd

Question: Does the above command assume I do not already have a partition
created?  I was 
http://www.fhgfs.com/wiki/wikka.php?wakka=PartitionAlignment reading here 
that the easiest way to acheive partition alignment is to create the file
system directly on the storage device without any paritions - such as $
mkfs.xfs /dev/sdd  (and your example above also hints at this)

When I created my current partiton, I used the following commands:

$ parted -a optimal /dev/sdd
$ mklabel gpt
$ mkpart primary 0 -0
$ q

I would like to align the partiton as well, but I am not sure how to acheive
this using parted.  This will be the only partition on the LUN, so not sure
if I even need to create one (although I do like to stay consistent with my
other volumes). 

When printing the partition info with parted I see:

# (parted) p                                                                
Model: HP P2000 G3 iSCSI (scsi)
Disk /dev/sdd: 4900GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  4900GB  4900GB  xfs          primary

but from reading, I suspect the Sector size should be more like: 
(logical/physical): 512B/65536B.  Any thoughts on partition alignment or
other thoughts in general?  Thank you.

-- 
View this message in context: http://old.nabble.com/Optimal-XFS-formatting-options--tp33140169p33145068.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
