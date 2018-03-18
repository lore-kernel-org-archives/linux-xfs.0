Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:40097 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeCRGVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Mar 2018 02:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20180317212814.GI7000@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com> <20180317212814.GI7000@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 18 Mar 2018 08:21:16 +0200
Message-ID: <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Mar 17, 2018 at 11:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Mar 17, 2018 at 09:56:19AM +0200, Amir Goldstein wrote:
>> On Sat, Mar 17, 2018 at 7:40 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > On Fri, Mar 16, 2018 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> On Fri, Mar 16, 2018 at 04:05:22PM +0200, Amir Goldstein wrote:
>> >>> Hi guys,
>> >>>
>> >>> I am trying to get a lower bound for unused inode number MSB on
>> >>> a mounted xfs super block, so I can publish it on struct super_block.
>> >>
>> >> Sorry, what?
>> >>
>> >> The inode number is owned by the filesystem - nobody should be
>> >> touching it or making assumptions they can screw with it in any way.
>> >>
>>
>> Let me clarify with the simplest example:
>>
>> With overlay of 2 layers, lower and upper on 2 different xfs fs
>> assuming that stat(2) from xfs will not be using the 63 MSB:
>>
>> On stat(2) of an overlay upper inode we want to return:
>>   st_dev = <overlay anon bdev>
>>   st_ino = <real upper st_ino>
>>
>> On stat(2) of an overlay lower inode we want to return:
>>   st_dev = <overlay anon bdev>
>>   st_ino = <real lower st_ino> | 1 << 63

>>
>> Now for ext4 this is always safe to do and we find that automatically
>> due to the fact that ext4 uses the default encode_fh generic 32bit
>> inode encoding.
>>
>> For xfs this should also be safe, but we don't want to whitelist xfs
>> by name/magic, so we want xfs to publish the max amount of bits
>> exposed to user with stat(2)/getdents(3).
>>
>> Recently, I became aware of an nfsd use case that also looks
>> at inode->i_ino, so we may want to also be able to assume
>> max_ino_bits also applies to inode->i_ino, but if you tell us to
>> stay clear of inode->i_ino, then we can always use stat.st_ino.
>>
>> Thanks,
>> Amir.
>>
>
> On Sat, Mar 17, 2018 at 10:24:39AM +0200, Amir Goldstein wrote:
>> On Sat, Mar 17, 2018 at 10:04 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Mar 17, 2018 at 06:40:23AM +0100, Miklos Szeredi wrote:
>> [...]
>> >> I ask, because we've thought long and hard about what to do for
>> >> multiplexing inum space in overlayfs, and found no other sane options.
>> >> Ideas welcome, of course.
>> >
>> > Why do you need to "multiplex" the inum space? perhaps you'd do
>> > better to start with a description of why you want to play games
>> > with inode numbers, rather than just posting a patch to steal bits
>> > from other filesytem inode number spaces....
>> >
>>
>> I think this patch perhaps explains best what we want to do:
>> https://marc.info/?l=linux-unionfs&m=151007386219743&w=2
>>
>> I had already given a simple example in an earlier response.
>
> So, I'll quote that here:
>
>> > > On stat(2) of an overlay upper inode we want to return:
>> > >   st_dev = <overlay anon bdev>
>> > >   st_ino = <real upper st_ino>
>> > >
>> > > On stat(2) of an overlay lower inode we want to return:
>> > >   st_dev = <overlay anon bdev>
>> > >   st_ino = <real lower st_ino> | 1 << 63
>
> This makes no sense to me - this implies the inode number changes on
> copy-up, and ....
>

I tried to keep the example simple, but failed to mention that lower and
upper refer to different file, say foo and bar.

I should have mentioned that "foo" is a pure upper - a file that was created
as upper and let's suppose the real ino of "foo" in upper fs is 10.
And let's suppose that the real ino of "bar" on lower fs is also 10, which is
possible when lower fs is a different fs than upper fs.

>> As the the "why" question, we have several requirements for
>> overlay inode numbers:
>> 1. st_ino is persistent
>> 2. st_ino/st_dev pair is unique in the system
>> 3. st_ino is consistent with d_ino
>> 4. st_ino doesn't change on copy up
>> 5. st_dev is uniform across all overlay inodes
>
> .... this means requierment #4 isn't met, even on the same
> filesystem.
>
> IOWs, if overlay has already met #4 on the same filesystem, then
> there is a persistent mapping between lower and upper inodes (Req.
> #1) that maps the upper inode # to the lower inode #. That has to be
> overlay information, because the underlying filesystem doesn't store

Correct. #4 is met because we keep track of "copy up origin" by storing
the lower inode file handle in "origin" xattr of coped up file.
Therefore, for an upper file that originated in a lower file we will use
the real lower multiplexed ino across copy up and across mount cycle.

> it. And because the lower inode/dev is unique, then req. 2 is met,
> too.
>

Correct. But notice that overlay does not use the real st_dev. If it did,
that would break the requirement that the real fs st_ino/_st_dev pair
is unique in the system.
So for non-samefs, overlay uses a different anon bdev for each layer
to satisfy #2, but breaks #5.

> FWIW, req 5 is badly worded - st_dev is uniform across all inodes in
> a single overlay filesystem, not all overlay inodes.
>

Correct. FYI, #5 has never been met for non-samefs.
What overlayfs now is it meets #5 for directory inodes
(to make find -xdev happy) at the cost of trading off #1.

>> With upstream overlayfs we meet all requirements above for
>> the case of all underlying layers on the same fs, by using a real
>> underlying inode st_ino and the overlay st_dev.
>
> Yeah, that's what I thought. So why can't you do exactly the same
> thing for different underlying filesystems? You've already got a
> mapping between upper and lower inode numbers, why can't that map
> across different superblocks? Why do you need special "inode number
> bits" exposed to userspace to identify upper->lower inode
> mappings that overlay should already have a persistent mapping
> mechanism for?

Because real pure upper inode and lower inode can have the same
inode number and we want to multiplex our way our of this collision.

Note that we do NOT maintain a data structure for looking up used
lower/upper inode numbers, nor do we want to maintain a persistent
data structure for persistent overlay inode numbers that map to
real underlying inodes. AFAIK, aufs can use a small db for it's 'xino'
feature. This is something that we wish to avoid.

>
>> With the 'xino' patch set [1], we can meet all requirements above
>> also for the case of underlying layers on different fs, by multiplpexing
>> the inum space, as long as we know about unused high ino bits.
>
> Your example makes no sense to me - I don't see how adding extra
> bits to the lower inode number allows you to meet requirement #4,
> not why presenting "st_ino = <real upper st_ino>" for inodes that
> have been copied up iis being done because that violates requirement
> #4....

The example was miss communicated. I hope I was able to make the
problem clear now.

>
>> The ovl-xino branch already has the xfs patch (not yet posted) to publish
>> max_ino_bits.
>
> That has no explanation of why you need to screw with inode number
> bits, either. It's all mechanism, and there's zero explanation of
> what problem it solves.
>

It's true. The explanation is now scattered in previous patches, that
incrementally fixed samefs case and improved non-samefs case.
I think currently, the most documented version could be found in this
new helper:
https://github.com/amir73il/linux/blob/overlayfs-devel/fs/overlayfs/inode.c#L62
but I will make sure to add proper full doumentation including the requiremetns
and how they are met in the next version I post.

Please let me know if I missed something and if motivation is still not clear.

Thanks!
Amir.
