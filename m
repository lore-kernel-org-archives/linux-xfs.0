Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32931 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeCQFkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Mar 2018 01:40:25 -0400
Received: by mail-oi0-f66.google.com with SMTP id e9so10385397oii.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Mar 2018 22:40:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180316222456.GG7000@dastard>
References: <CAOQ4uxg=tK7fBCVuh74jzfYs99bp3XOSEUphpC01saCdEooLBA@mail.gmail.com>
 <20180316222456.GG7000@dastard>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 17 Mar 2018 06:40:23 +0100
Message-ID: <CAJfpegvoFwEVP6ijUW3iUpfc4_2xTiw=AfE8P6O6VDhrGiDEqw@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Mar 16, 2018 at 04:05:22PM +0200, Amir Goldstein wrote:
>> Hi guys,
>>
>> I am trying to get a lower bound for unused inode number MSB on
>> a mounted xfs super block, so I can publish it on struct super_block.
>
> Sorry, what?
>
> The inode number is owned by the filesystem - nobody should be
> touching it or making assumptions they can screw with it in any way.
>
>> This doesn't need to be a tight lower bound, but it needs to be
>> a loewr bound that cannot change with growfs nor when
>> remounting with different options (i.e. inode64).
>>
>> This is needed for overlayfs to be able to use the unused upper bits
>> for overlayfs inode number namespace (see [1]).
>
> SO you're assuming that filesystems don't ever encode information
> into their inode numbers. I've already got plans to use a bunch of
> the unused upper bits in the inode number internally in XFS for
> subvolumes, and ISTR that Darrick was mulling a use for some of
> them a while back, too...
>
>> I realize that for a given agcount, a "soft" lower bound of unused
>> upper bits is agno_log-agblklog-inopblog, which makes the "hard"
>> lower bound 32-agblklog-inopblog, so I think I can use this number.
>>
>> I was staring at this definition and tried to figure out where this
>> absolute limit of 56 used bits came from:
>>  #define XFS_MAXINUMBER          ((xfs_ino_t)((1ULL << 56) - 1ULL))
>>
>> Is this number really correct? If yes, then where does the constrain
>> on maximum 56 bits come from?
>
> Yes, 56 bits is the current maximum *physical* inode number - the
> inode number is currently a physical representation of the location
> on disk. 56 bits is needed to represent inodes in 2^63 bytes of
> physical space.
>
> Off the top of my head, it works out something like this for a
> a 512 byte inode, 4k block size filesystem:
>
> bits            range           meaning
> 6               0-63            inode # in chunk
> 7-22            1TB             block offset in AG of inode 0
>                                 blkspag / bsize / inopblk
>                                 2^30 / 2^12 / 2^3 = 2^15
> 23-55           AGNO            AG number
>
> The breakdown of bits change for different inode and block sizes,
> but the worse case comes out somewhere around 56 bits...
>
> *but*
>
> #define NULLFSINO ((xfs_ino_t)-1)
>
> is a valid inode number on disk, indicating that the field is not
> holding an inode number. the MSB indicates the inode number is a
> "virtual" inode number, holding some special significance that is
> not directly a physical inode number.  Hence we actually use all 64
> bits of the inode number on disk, and hence there are no free bits
> in the inode number for anyone outside XFS to use.
>
> IOWs, I think your plan is DOA because we already use the entire 64
> bit space in the inode number field and have plans for the "unused
> bits" already in motion....

We don't care about internal or on-disk use.

Does that still make it DOA?

I ask, because we've thought long and hard about what to do for
multiplexing inum space in overlayfs, and found no other sane options.
Ideas welcome, of course.

Thanks,
Miklos
