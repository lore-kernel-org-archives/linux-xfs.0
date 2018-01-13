Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:13907 "EHLO
        greer.hardwarefreak.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965304AbeAMA1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 19:27:05 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
From: Stan Hoeppner <stan@hardwarefreak.org>
Message-ID: <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
Date: Fri, 12 Jan 2018 18:20:22 -0600
MIME-Version: 1.0
In-Reply-To: <5A58F5FB.7000101@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>, Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 01/12/2018 11:52 AM, Wols Lists wrote:
> On 12/01/18 14:25, Emmanuel Florac wrote:
>> Le Fri, 12 Jan 2018 13:32:49 +0000
>> Wols Lists <antlists@youngman.org.uk> écrivait:
>>
>>> On 11/01/18 03:07, Dave Chinner wrote:
>>>> XFS comes from a different background - high performance, high
>>>> reliability and hardware RAID storage. Think hundreds of drives in a
>>>> filesystem, not a handful. i.e. The XFS world is largely enterprise
>>>> and HPC storage, not small DIY solutions for a home or back-room
>>>> office.  We live in a different world, and MD rarely enters mine.
>>> So what happens when the hardware raid structure changes?
>> hardware RAID controllers don't expose RAID structure to the software.
>> So As far as XFS knows, a hardware RAID is just a very large disk.
>> That's when using stripe unit and stripe width options make sense in
>> mkfs_xfs.
> Umm... So you can't partially populate a chassis and add more disks as
> you need them? So you have to manually pass stripe unit and width at
> creation time and then they are set in stone? Sorry that doesn't sound
> that enterprisey to me :-(

It's not set in stone.  If the RAID geometry changes one can specify the 
new geometry at mount say in fstab.  New writes to the filesystem will 
obey the new specified geometry.
>>> Ext allows you to grow a filesystem. Btrfs allows you to grow a
>>> filesystem. Reiser allows you to grow a file system. Can you add more
>>> disks to XFS and grow the filesystem?
>> Of course. xfs_growfs is your friend. Worked with online filesystems
>> many years before that functionality came to other filesystems.
>>
>>> My point is that all this causes geometries to change, and ext and
>>> btrfs amongst others can clearly handle this. Can XFS?
>> Neither XFS, ext4 or btrfs can handle this. That's why Dave mentioned
>> the fact that growing your RAID is almost always the wrong solution.
>> A much better solution is to add a new array and use LVM to aggregate
>> it with the existing ones.
> Isn't this what btrfs does with a rebalance? And I may well be wrong,
> but I got the impression that some file systems could change stripe
> geometries dynamically.
>
> Adding a new array imho breaks the KISS principle. So I now have
> multiple arrays sitting on the hard drives (wasting parity disks if I
> have raid5/6), multiple instances of LVM on top of that, and then the
> filesystem sitting on top of multiple volumes.
>
> As a hobbyist I want one array, with one LVM on top of that, and one
> filesystem per volume. Anything else starts to get confusing. And if I'm
> a professional sys-admin I would want that in spades! It's all very well
> expecting a sys-admin to cope, but the fewer boobytraps and landmines
> left lying around, the better!
>
> Squaring the circle, again :-(
>> Basically growing an array then the filesystem on it generally works
>> OK, BUT it may kill performance (or not). YMMV. At least, you *probably
>> won't* get the performance gain that the difference of stripe width
>> would permit when starting anew.
>>
> Point taken - but how are you going to backup your huge petabyte XFS
> filesystem to get the performance on your bigger array? Catch 22 ...
>
>>> Because if it can, it seems to me the obvious solution to changing
>>> raid geometries is that you need to grow the filesystem, and get that
>>> to adjust its geometries.
>> Unfortunately that's nigh impossible. No filesystem in existence does
>> that. The closest thing is ZFS ability to dynamically change stripe
>> sizes, but when you extend a ZFS zpool it doesn't rebalance existing
>> files and data (and offers absolutely no way to do it). Sorry, no pony.
>>
> Well, how does raid get away with it, rebalancing and restriping
> everything :-)
>
> Yes I know, it's a major change if the original file system design
> didn't allow for it, and major file system changes can be extremely
> destructive to user data ...
>
>>> Bear in mind, SUSE has now adopted XFS as the default filesystem for
>>> partitions other than /. This means you are going to get a lot of
>>> "hobbyist" systems running XFS on top of MD and LVM. Are you telling
>>> me that XFS is actually very badly suited to be a default filesystem
>>> for SUSE?
>> Doesn't seem so. In fact XFS is less permissive than other filesystems,
>> and it's a *darn good thing* IMO. It's better having frightening error
>> messages "XFS force shutdown" than corrupted data, isn't it?
> False dichotomy, I'm afraid. Do you really want a filesystem that
> guarantees integrity, but trashes performance when you want to take
> advantage of features such as resizing? I'd rather have integrity,
> performance *and* features :-) (Pick any two, I know :-)
>>> What concerns me here is, not having a clue how LVM handles changing
>>> partition sizes, what effect this will have on filesystems ... The
>>> problem is the Unix philosophy of "do one thing and do it well".
>>> Sometimes that's just not practical.
>> LVM volumes changes are propagated to upper levels.
> And what does the filesystem do with them? If LVM is sat on MD, what then?
>> If you don't like Unix principles, use Windows then :)
>>
> The phrase "a rock and a hard place" comes to mind. Neither were
> designed with commercial solidity and integrity and reliability in mind.
> And having used commercial systems I get the impression NIH is alive and
> kicking far too much. Both Linux and Windows are much more reliable and
> solid than they were, but too many of those features are bolt-ons, and
> they feel like it ...
>
>>> The Unix philosophy says "leave
>>> partition management to lvm, leave redundancy to md, leave the files
>>> to the filesystem, ..." and then the filesystem comes along and says
>>> "hey, I can't do my job very well, if I don't have a clue about the
>>> physical disk layout". It's a hard circle to square ... :-)
>> Yeah, that was apparently the very same thinking that brought us ZFS.
>>
>>> (Anecdotes about btrfs are that it's made a right pigs ear of trying
>>> to do everything itself.)
>>>
>> Not so sure. Btrfs is excellent, taking into account how little love it
>> received for many years at Oracle.
>>
> Yep. The solid features are just that - solid. Snag is, a lot of the
> nice features are still experimental, and dangerous! Parity raid, for
> example ... and I've heard rumours that the flaws could be unfixable, at
> least not until btrfs-2 whenever that gets started ...
>
> When MD adds disks, it rewrites the array from top to bottom or the
> other way round, moving everything over to the new layout. Is there no
> way a file system can do the same sort of thing? Okay, it would probably
> need to be a defrag-like utility and linux prides itself on not needing
> defrag :-)
>
> Or could it simply switch over to optimising for the new geometry,
> accept the fact that the reshape will have caused hotspots, and every
> time it rewrites (meta)data, it adjusts it to the new geometry to
> reduce/remove hotspots over time?
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

