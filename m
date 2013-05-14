Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66BBB7F4E
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 03:56:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FD2D8F8040
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 01:56:24 -0700 (PDT)
Received: from postout.lrz.de (postout.lrz.de [129.187.254.115]) by
	cuda.sgi.com with ESMTP id 6JveCcTvoqX5ce25 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 01:56:22 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout3.mail.lrz.de (Postfix) with ESMTP id 57BF2200BB
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 10:56:21 +0200 (CEST)
Received: from postout3.mail.lrz.de ([127.0.0.1])
	by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new,
	port 20024) with LMTP id 527t2OBTg4r6 for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 10:56:20 +0200 (CEST)
Received: from [129.187.51.94] (e094.tum.vpn.lrz.de [129.187.51.94])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by postout3.mail.lrz.de (Postfix) with ESMTPSA id D969C200AD
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 10:56:20 +0200 (CEST)
Message-ID: <5191FC34.10105@tum.de>
Date: Tue, 14 May 2013 10:56:20 +0200
From: Benedikt Schmidt <benedikt.schmidt@tum.de>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de> <519165F2.80902@sandeen.net>
	<5191C772.4020607@tum.de> <5191ECCD.2070806@gmail.com>
In-Reply-To: <5191ECCD.2070806@gmail.com>
Reply-To: benediktibk@aon.at
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 14.05.2013 09:50, Michael L. Semon wrote:
> On 05/14/2013 01:11 AM, Benedikt Schmidt wrote:
>> First of all: Thanks for your very fast and helpful response.
>>
>> I copied actually only the partition, not the whole disk: /dd_rescue
>> --force -r1 /dev/sdd1 /dev/sdc1/
>> The cause for this is that I don't have enough space left on another
>> device to store a whole copy of the faulty disk. I thought it would be
>> possible, like in some examples I found with google, that you can rescue
>> a partition directly.
>
> Understood.  This seems like a valid option.  Had fdisk, cfdisk, and =

> gdisk been more cooperative over the past year, this would have been =

> my first option.
>
>> /file -s /dev/sdc1/ says:
>> //dev/sdc1: data/
>
> This is different from what I got, but maybe Eric sees something in =

> your answer.
>
>> The disks look like this (/fdisk -l/):
>> /Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes, 5860533168 sectors//
>> //Units =3D Sektoren of 1 * 512 =3D 512 bytes//
>> //Sector size (logical/physical): 512 bytes / 4096 bytes//
>> //I/O size (minimum/optimal): 4096 bytes / 4096 bytes//
>> //Disk identifier: 0xcba506ee//
>> //
>> //   Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id System//
>> ///dev/sdc1             256   732566645   366283195   83 Linux//
>> //
>> //Disk /dev/sdd: 2000.4 GB, 2000397852160 bytes, 3907027055 sectors//
>> //Units =3D Sektoren of 1 * 512 =3D 512 bytes//
>> //Sector size (logical/physical): 512 bytes / 512 bytes//
>> //I/O size (minimum/optimal): 512 bytes / 512 bytes//
>> //Disk identifier: 0x3c34826b//
>> //
>> //   Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id System//
>> ///dev/sdd1              63  3907024064  1953512001   83 Linux/
>>
>> If it is not possible to rescue the partition this way I will have to
>> extend my to RAID5 so that I can put the copy of the faulty disk on this
>> one, like Michael explained in his answer. I just hoped that I can avoid
>> this, because it would save me more than 100=80.
>
> I had not much information to use, so I set up the safest possible =

> scenario and hoped that you were getting results that were close to that.
>
> If the few extra files that you're rescuing aren't worth 100 euros, =

> then it's not worth 100 euros to make a duplicate of a dump of an =

> already-damaged filesystem.
>
> The crazy, reckless guide is this:
>
> 1) use `xfs_repair -n /dev/sdc1`.  If that looks nice,...
>
> 2) use `xfs_repair /dev/sdc1`...
>
>   a) A repaired partition is a good sign.  Mount that partition!
>
>   b) If the "attempting to find secondary superblock" search ends in =

> "Sorry, could not find valid secondary superblock," then maybe =

> something went wrong in the original data transfer.  You might have to =

> give this step some time to complete, and it will print dots for a =

> while.  Either that or the failures in your hard drive really did hit =

> all of the superblocks.
>
>   c) If the "attempting to find secondary superblock" finds something, =

> it might make everything well but spit some files into lost+found.  If =

> the repair goes badly, there's a chance you'll be using dd to look for =

> your data.
>
>   d) If it's something else--xfs_repair segfaults, needs to be run =

> again, whatever, mention it--and at least you'll be closer to the real =

> answer.
>
> 3) If all else fails, and especially when a backup is handy, you could =

> try `xfs_repair -L` to zero the log.  This helps when xfs_repair asks =

> you to mount the filesystem to allow metadata updates to happen, but =

> Linux has an oops as the filesystem is mounted.  In many other =

> scenarios, it can work against you.  This is the second-to-last resort.
>
>> As last information: The content of this copy is not totally lost,
>> actually only the last few files I have added. All the other stuff is
>> already stored on the RAID5, only the latest stuff is not contained in
>> this backup. So I don't loose everything if something goes wrong (at
>> least one thing :-) ).
>
> Really, it becomes a question of whether it would be faster to search =

> for the data using dd and grep, use xfs_repair and hope it works, or =

> recreate the data from scratch.
>
> The hope is that dd_rescue does a credible job for you, and that XFS =

> can be made to mount something, somewhere, so that you can grab those =

> last few files.  The very last resort would be to do all of this =

> repair stuff on the original damaged partition, but the safety net =

> goes away after that.
>
> Michael

I see, I should have mentioned this earlier. I already tried xfs_repair =

and it failed to find the second superblock. Because I am still able to =

mount the original disk and most parts of it I guessed that xfs_repair =

is confused by the different disk geometries. What I have also already =

tried out was, naturally, to copy the whole stuff with for example cp or =

xfs_copy, but both failed because of filesystem errors. The only program =

which didn't fail to copy the data was dd_rescue, which can handle the =

errors. That is why I used, as it was my only option (as far as I can see).

Kind regards,
Benedikt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
