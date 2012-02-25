Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1PLvdFg178487 for <xfs@OSS.SGI.com>; Sat, 25 Feb 2012 15:57:41 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	L5vSshSooFkCCWQ8 for <xfs@OSS.SGI.com>;
	Sat, 25 Feb 2012 13:57:36 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647402FEA8D6 for xfs@OSS.SGI.com; Sat, 25 Feb 2012 21:57:33 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S1Pc1-0000q5-Sx
	for <xfs@OSS.SGI.com>; Sat, 25 Feb 2012 21:57:05 +0000
MIME-Version: 1.0
Message-ID: <20297.22833.759182.360340@tree.ty.sabi.co.UK>
Date: Sat, 25 Feb 2012 21:57:05 +0000
Subject: Re: creating a new 80 TB XFS
In-Reply-To: <4F47B020.4000202@cape-horn-eng.com>
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
	<4F47B020.4000202@cape-horn-eng.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

>>> We are getting now 32 x 3 TB Hitachi SATA HDDs. I plan to
>>> configure them in a single RAID 6 set with one or two
>>> hot-standby discs. The raw storage space will then be 28 x 3
>>> TB = 84 TB.  On this one RAID set I will create only one
>>> volume.  Any thoughts on this?

>> Well, many storage experts would be impressed by and support
>> such an audacious plan...

> Audacious?

Please remember that experts reading or responding to this
thread have not objected to the (very) aggressive aspects of
your setup, so obviously it seems mostly fine to them. Just me
pointing out the risks and the one who thinks that 16 drives per
set would be preferable.

> Why? Too many discs together? What would be your recommended
> maximum?

Links below explain. In general I am uncomfortable with storage
redundancy of less then 30% and very worried when it is less
than 20%. Especially for correlated chances of failure due to to
strong common modes such as all disks of the same type and make
in the same box. Fortunately there is a significant report that
the Hitachi 3TB drive has been so far particularly reliable:

  http://blog.backblaze.com/2011/07/20/petabytes-on-a-budget-v2-0revealing-more-secrets/

But consider that several large scale studies report most drives
have a failure rate of 3-5% per year, and in a population of 28
drives with common modes that gives a chance of 3 overlapping
failures which is not comfortable to me.

> We are running our actual backup (remember, this is for
> backups!) on one RAID 6 set on 24 HDDs (21 data + 2 RAID6
> parity + 1 hot-spare) and as you already wrote "it works".

The managers of Lehman and Fukushima also said "it works" until
it did not :-).

>> [ ... ] It is also remarkably brave to use 32 identical
>> drives in a RAID set. But all this is very popular because in
>> the beginning "it works" and is really cheap.

> Yes, costs are an important factor. We could have gone with
> more secure/sophisticated/professional setups, but we would
> have got 1/2 ot 1/4 of the capacity for the same price.

If only it were a cost-free saving... But the saving is upfront
and visible and the cost is in the fat tail and invisible.

However you might want to consider something like a RAID0 of 2+1
RAID5s perhaps.

> But since we need that capacity for the backups we had no
> other choice. As said before, our previous setup with 24 HDDs
> in one RAID 6 worked flawlessly for 5 years. And it still works.

Risk is not a certainty...

>> The proposed setup has only 7% redundancy, RMW issues with
>> large stripe sizes, and 'fsck' time and space issues with
>> large trees.

> 7% ? 2/28 ?  fsck time? and space? Time won't be a problem, as
> long as we are not talking about days.

It could be weeks to months if the filetree is damaged.

> Remember this is a system for storing backups.

And therefore since it is based on RSYNC'ing one that does
vast metadata scans, readings, and quite a few metadata updates.

> How can I estimate the time needed? And what do you mean with
> "space" ?  Memory issues while running fsck?

The time is hard to estimate beyond the time needed to check an
undamaged or very lightly damaged filetree. As to space, you
might need several dozen GiB (depending on metadata size) as per
the link below.

>> Consider this series of blog notes:

>> http://www.sabi.co.uk/blog/12-two.html#120218
>> http://www.sabi.co.uk/blog/12-two.html#120127
>> http://www.sabi.co.uk/blog/1104Apr.html#110401
>> http://groups.google.com/group/linux.debian.ports.x86-64/msg/fd2b4d46a4c294b5

>> [ ... ] presumably from multiple hosts concurrently. You may
>> benefit considerably from putting the XFS log on a separate
>> disk, and if you use Linux MD for RAID the bitmaps on a
>> separate disk.

> No, not concurrently, we run the backups from multiple hosts
> one after another.

Then you have a peculiar situation for such a large capacity
backup system.

>>> *MKFS* We also heavily use ACLs for almost all of our files.

>> That's a daring choice.

> Is there a better way of giving different access rights per user to
> files and directories? Complicated group setups?

Probably yes, and they would not be that complicated. Or really
simple ACLs, btu you seem to have complicated ones, and you
don't seem to work for the NSA :-).

>> 'nobarrier' seems rather optimistic unless you are very very
>> sure there won't be failures.

> There are always failures. But again, this is a backup system.

Sure, but the last thing you want is for your backup system to
fail. Because people often do silly things with "main" systems
because they are confident in there being backups, and if they
try and get those backups and they are not there, because after
all the backups system was designed with the idea that it is
just a backup system...

> And the controller will be battery backed up, and it's
> connected to an UPS that gives about 30 min power in case of a
> power failure.

That's good, but there also hardware failures and kernel
crashes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
