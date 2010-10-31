Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9VGotPP132195 for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 11:50:56 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E03081C08031
	for <xfs@oss.sgi.com>; Sun, 31 Oct 2010 09:52:16 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id bE2djbD62zK73kD3 for
	<xfs@oss.sgi.com>; Sun, 31 Oct 2010 09:52:16 -0700 (PDT)
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Re: xfs_repair of critical volume
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
Date: Sun, 31 Oct 2010 16:52:13 +0000
Message-Id: <8C4130A7-53BC-460B-8674-1440B479E67D@filmlight.ltd.uk>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
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

Don't do anything which has the potential to write to your drives until you have a full bit-for-bit copy of the existing volumes.

In particular, don't run xfs_repair. This is is a hardware issue. It can't be fixed with software.

Now stop and think. There's a good chance a professional data repair outfit can get stuff off your failed drives.

So before you go any further:

* carefully label all the drives, note down their serial numbers, and their positions in the array. You need to do this for the 'failed' drives too.

* speak to your raid vendor. They will have seen this before. 

* try and find out why multiple drives failed on both your main and your backup systems. Was it power related? Temperature? Vibration? Or a bad batch of disks?

* speak to the drive manufacturer. They will have seen this before.

Come back to this list and give us an update. This isn't an xfs problem per se, but there are several people here who work regularly with multi-terabyte arrays.


--
Roger



On 31 Oct 2010, at 07:54, Eli Morris wrote:

> Hi,
> 
> I have a large XFS filesystem (60 TB) that is composed of 5 hardware RAID 6 volumes. One of those volumes had several drives fail in a very short time and we lost that volume. However, four of the volumes seem OK. We are in a worse state because our backup unit failed a week later when four drives simultaneously went offline. So we are in a bad very state. I am able to mount the filesystem that consists of the four remaining volumes. I was thinking about running xfs_repair on the filesystem in hopes it would recover all the files that were not on the bad volume, which are obviously gone. Since our backup is gone, I'm very concerned about doing anything to lose the data that will still have. I ran xfs_repair with the -n flag and I have a lengthly file of things that program would do to our filesystem. I don't have the expertise to decipher the output and figure out if xfs_repair would fix the filesystem in a way that would retain our remaining data or if it would, let's say!
  t!
> runcate the filesystem at the data loss boundary (our lost volume was the middle one of the five volumes), returning 2/5 of the filesystem or some other undesirable result. I would post the xfs_repair -n output here, but it is more than a megabyte. I'm hoping some one of you xfs gurus will take pity on me and let me send you the output to look at or give me an idea as to what they think xfs_repair is likely to do if I should run it or if anyone has any suggestions as to how to get back as much data as possible in this recovery.
> 
> thanks very much,
> 
> Eli
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
