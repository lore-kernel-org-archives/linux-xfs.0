Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n85IVhlh072621 for <xfs@OSS.SGI.com>; Sat, 5 Sep 2009 13:32:04 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E320A15ECEB3
	for <xfs@OSS.SGI.com>; Sat,  5 Sep 2009 11:32:13 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id CBBlH7c5hVXqBjAO
	for <xfs@OSS.SGI.com>; Sat, 05 Sep 2009 11:32:13 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1Mk036-0004yP-VV
	for <xfs@OSS.SGI.com>; Sat, 05 Sep 2009 18:31:45 +0000
Resent-Message-ID: <19106.44684.280884.280828@tree.ty.sabi.co.uk>
Resent-To: xfs@oss.sgi.com
Subject: RE: xfs data loss
Date: Sat, 5 Sep 2009 18:29:35 +0000
MIME-Version: 1.0
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Message-ID: <19106.44559.288658.248853@tree.ty.sabi.co.uk>
References: <B9A7B002C7FAFC469D4229539E909760308DA658CB@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA658CB@DU-EXC-MAIL.empa.emp-eaw.ch>
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
To: Linux XFS <xfs@OSS.SGI.co>

> [ ... ]

> 1) /dev/md4 a 19+1 RAID 5, with the corresponding xfs /raidmd4
> filesystem that had lost half of the directories on the 24th
> of August; for NO PARTICULAR APPARENT REASON (and this still
> makes me crazy).  No logs, nothing.

But there was apparently a power "event" of some sort, and IIRC
the system stopped working, and there were other signs that the
block layer had suffered damage:

> 2) /dev/md5, a 19+1 RAID 5, that could not mount
> anymore...lost superblock.

The fact that were was apparent difficulty means that the
automatic "resync" that RAID5 implementatioqns do if only 1 drive
has been lost did not work, which is ominous.

> 3) /dev/md6 , a 4+1 RAID5, that was not mounting anymore because
> 2 devices were lost.  My collegue zapped the filesystem (which
> was almost empty), and rebuilt the RAID5.

So let's forget about it, except that it indicates that there
was extensive storage system damage, wheter detected or not.

> For 2) it was clear what happened: At the distance of a few
> days, two devices of /dev/md5 died. The information about the
> death of one device is issued in /var/log/warn.  We did not
> check it during the last days, so when the second device died,
> it was too late.

With a 19+1 RAID5 with 2 devices dead you have lost around 5-6%
of the data; regrettably this is not 5-6% of the files, but most
likely 5-6% of most files (and probably quite a bit of XFS metadata).

> BUT: I followed the advice to make a read test on all devices
> (using dd) and all were ok.

That is good news, but it is not clear what "all ok" means here,
when "two devices of /dev/md5 died". Maybe the two ports on the
host adapter died, but it is far from clear even given this:

> So it seemed to be a raid controller problem, of the same kind
> described here
> http://maillists.uci.edu/mailman/public/uci-linux/2007-December/002225.html
> where a solution is proposed including the reassembling of the
> raid using mdadm with the option "assume-clean". This is where
> this "assume-clean" comes from: from a read test, followed by
> the study of the above mailing list post.

Oops. I suspect that one should not believe everything one reads
in a mailing list. The statement over there:

  > It's set up as a RAID5 (one parity disk), with no spares. [
  > ... ] Trying to force mdadm to assemble it did not work: $
  > mdadm --assemble /dev/md0 --chunk 16 /dev/sd*1 mdadm:
  > /dev/md0 assembled from 2 drives - not enough to start the
  > array. It was a 4-disk array, so this is a failure.
  > However, it did not destroy any data either.

Seems to extremely optimistic (I am trying to be emollient and
mellifluous here :->).

> The resync of the /dev/md5 was performed, the raid was again
> with 20 working devices,

The original 20 devices or did you put in 2 new blank hard drives?
I feel like that 2 blank drives went in, but then later I read
that all [original] 20 drives could be read for a few MB at the
beginning.

> but at the end of the day the filesystem still was not able to
> mount. So, I was eventually forced to do xfs_repair -L
> /dev/md5, which was a nightmare: incredible number of forking,
> inodes cleared... but eventually... successful.  I was in the
> meanwhile 10 years older and with all my hair suddenly greyed,
> but... RESULT: /dev/md5 is again up and running, with all
> data.

I suspect that "with all data" is also extremely optimistic.

There is one vital detail here: the XFS design in effect makes
two assumptions:

* The block layer is error free. By and large XFS does not even
  check that the block layer behaves perfectly. It is the sysadm
  responsibility to ensure that.
  
* XFS only ensures consistency of metadata, for data the
  application takes care.

> BUT at the same time, /dev/md4 was not able to mount anymore:
> superblock error.

> So, at that point we bought another big drive (7 TB), we
> performed backup of /dev/md5 , and then we run the same
> procedure on /dev/md4.

Backing up existing data is a very good idea before doing any
repair work.

> RESULT: /dev/md4 is again up and running, but the data
> disappeared on August 24 were still missing.

> Since the structure was including all devices, at this point I
> run xfs_repair -L /dev/md4. But nothing happens. No error, and
> half of the data still missing. So at this point I don't
> understand.

Well, I can try to explain the bits that maybe are missing.

* Almost all your problems are block layer problems. Since XFS
  assumes error free block layer, it is your task to ensure that
  the black layer is error free. Which means that almost all the
  work that you should have done was to first ensure that the
  block layer is error free, byt testing fully each drive and
  then putting together the array. It is quite likely that none
  of the issues that your have reported has much to do with XFS.

* The array contains an XFS filesystem with a bit of metadata
  and a lot of data. If something like 5% the array is replaced by
  random numbers (usually zeroes) one can be "lucky" and less than
  5% of the metadata will be affected, and what is affected can be
  reconstructed by other information. If this is the case then
  'xfs_repair' will reconstruct the metadata and leave alone the
  data. XFS and its utilities check the metadata and try to
  reconstruct it, but do nothing for the data.

* This makes it look like that the *filesystem* is fine, even if
  quite a bit of data in each file has been replaced. XFS wisely
  does nothing for the data (other than avoiding to deliberately
  damage it) -- if your application does not add redundancy or
  checksums to the data, you have no way to reconstruct it or even
  check whether it is damaged in case of partial loss.

> THERE IS ONE IMPORTANT THING THAT I DID NOT MENTION, BECAUSE IT
> WAS NOT EVIDENT BY LOOKING AT /etc/raidtab, /proc/mdstat, etc.,
> and it was done by my collaborator All structure of the raids,
> partitioning etc. was done using Yast2 with LVM.

That's not important in itself, but it matters whether LVM used DM
for RAIDing, as it has less checking and repair options than MD.

>> Sure you can reassemble the RAID, but what do you mean by
>> "still ok"? Have you read-tested those 2 drives? Have you
>> tested the *other* 18 drives? How do you know none of the other
>> 18 drives got damaged? Have you verified that only the host
>> adapter electronics failed or whatever it was that made those 2
>> drives drop out?

> Tested all drives, but not the host adapter electronics.

Later on you say you tested only the first few MB of each drive.
We still don't know what really happened.

BTW, you mention LVM later but it is not clear whether you are
using LVM on top of MD or LVM on top od DM. If it is on top of
MD a good way to use regularly to check disk health is to use
the option to verify the array. This is for example described
here: http://en.gentoo-wiki.com/wiki/RAID/Software#Data_Scrubbing
but this only works if the array was built with MD, not DM.

>> Why do you *need* to assume clean? If the 2 "lost" drives are
>> really ok, you just resync the array.

> Well, following the post above, after checking that the lost
> drives are ok, first I stop the raid, then I create the raid
> with 20 drives assuming them clean, then I stop it again, then
> assemble it with resyncing.

If the array was very very lucky none of the 20 drives was
actually damaged, some just stopped working momentarily, and you
you could have actually just done the 'resync'; actually the
'resync' is automatic in both DM and MD arrays.

>> If you *need* to assume clean, it is likely that you have lost
>> something like 5% of data in (every stripe and thus) most files
>> and directories (and internal metadata) and will be replacing
>> it with random bytes. That will very likely cause XFS problems
>> (the least of the problems of course).

> On the /raidmd5 fortunately this was not the case.

This still seems most likely extremely optimistic.

[ ... ]

> Well. You would be surprised to know how stupid can scientist
> be they ignore the worst case scenario.

Well, I am familiar with a new "big science" place where lab
time costs several thousand $/hour; most of the scientists have
had data losses at other places before, and they have become
rather paranoid about that :-).

> Just to clarify: assume-clean was an option to the mdadm
> --create command when I discovered that my 20 devices were
> there and running: I run a dd command reading the first
> megabytes of each device.  Was this wrong?

Given that the extent of damage is unknown, you should have done a
scan of each disk in its entirety. The killer for RAID5 is when 2
or more disks have damage at the same offset.

> In the meanwhile I am almost convinced that that 4-5 TB lost
> on /dev/md4 are lost for good. [ ... ]

My current guess is:

* 2 or more in each of the 20 disk arrays is damaged in the same
  offsets, and full data recovery is not possible.

* Somehow 'xfs_repair' managed to rebuild the metadata of
  '/dev/md5' despite a loss of 5-6% of it, so it looks
  "consistent" as far as XFS is concerned, but up to 5-6% of
  each file is essentially random, and it is very difficult to
  know where the random part are.

* With '/dev/md4' 'xfs_repair' the 5-6% metadata lost was in
  more critical parts of the filesystem, so the metadata for
  half of the files is gone. Of the remaining files, up to
  5-6% of their data is random.

It may well be more than 5-6% if in fact more than 2 drives per
array lost data.

Or the malfunction to the 2 or more drives that failed in each
array was "temporary" but then it is hard to imagine why there
were problems with RAID resync and XFS checking.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
