Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1NVZKw251057 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 18:31:35 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37971137E1C4
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 16:49:04 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id LkyEN24D6Y9smCYZ for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 16:49:04 -0700 (PDT)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <4CCF3D68.6060201@sandeen.net>
Date: Mon, 1 Nov 2010 16:32:54 -0700
Message-Id: <00C51060-5205-4E95-B27C-8E31468ED45C@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCF3D68.6060201@sandeen.net>
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


On Nov 1, 2010, at 3:21 PM, Eric Sandeen wrote:

> On 10/31/10 2:54 AM, Eli Morris wrote:
>> I have a large XFS filesystem (60 TB) that is composed of 5 hardware
>> RAID 6 volumes. One of those volumes had several drives fail in a
>> very short time and we lost that volume. However, four of the volumes
>> seem OK. We are in a worse state because our backup unit failed a
>> week later when four drives simultaneously went offline. So we are in
>> a bad very state. I am able to mount the filesystem that consists of
>> the four remaining volumes. I was thinking about running xfs_repair
>> on the filesystem in hopes it would recover all the files that were
>> not on the bad volume, which are obviously gone. Since our backup is
>> gone, I'm very concerned about doing anything to lose the data that
>> will still have. I ran xfs_repair with the -n flag and I have a
>> lengthly file of things that program would do to our filesystem. I
>> don't have the expertise to decipher the output and figure out if
>> xfs_repair would fix the filesystem in a way that would retain our
>> remaining data or if it would, let's say t!
> 
> 
> One thing you could do is make an xfs_metadump image, xfs_mdrestore
> it to a sparse file, and then do a real xfs_repair run on that.
> You can then mount the repaired image and see what's there.
> So from a metadata perspective, you can do a real-live repair
> run on an image, and see what happens.
> 
> -Eric

Hi Eric,

Thanks for the suggestion. I tried is out and this is what happened when I ran xfs_mdrestore:

# xfs_mdrestore -g xfs_dump_image vol5_dump
xfs_mdrestore: cannot set filesystem image size: File too large
# 

Any ideas? Is the file as large as the volume or something? I think you had a really good suggestion. If you know how to make this work, I think that would be great.

thanks,

Eli


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
