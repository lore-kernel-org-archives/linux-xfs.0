Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:46123 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752613AbeCQH4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Mar 2018 03:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegvoFwEVP6ijUW3iUpfc4_2xTiw=AfE8P6O6VDhrGiDEqw@mail.gmail.com>
References: <CAOQ4uxg=tK7fBCVuh74jzfYs99bp3XOSEUphpC01saCdEooLBA@mail.gmail.com>
 <20180316222456.GG7000@dastard> <CAJfpegvoFwEVP6ijUW3iUpfc4_2xTiw=AfE8P6O6VDhrGiDEqw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 17 Mar 2018 09:56:19 +0200
Message-ID: <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Mar 17, 2018 at 7:40 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Mar 16, 2018 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Fri, Mar 16, 2018 at 04:05:22PM +0200, Amir Goldstein wrote:
>>> Hi guys,
>>>
>>> I am trying to get a lower bound for unused inode number MSB on
>>> a mounted xfs super block, so I can publish it on struct super_block.
>>
>> Sorry, what?
>>
>> The inode number is owned by the filesystem - nobody should be
>> touching it or making assumptions they can screw with it in any way.
>>

Let me clarify with the simplest example:

With overlay of 2 layers, lower and upper on 2 different xfs fs
assuming that stat(2) from xfs will not be using the 63 MSB:

On stat(2) of an overlay upper inode we want to return:
  st_dev = <overlay anon bdev>
  st_ino = <real upper st_ino>

On stat(2) of an overlay lower inode we want to return:
  st_dev = <overlay anon bdev>
  st_ino = <real lower st_ino> | 1 << 63

Now for ext4 this is always safe to do and we find that automatically
due to the fact that ext4 uses the default encode_fh generic 32bit
inode encoding.

For xfs this should also be safe, but we don't want to whitelist xfs
by name/magic, so we want xfs to publish the max amount of bits
exposed to user with stat(2)/getdents(3).

Recently, I became aware of an nfsd use case that also looks
at inode->i_ino, so we may want to also be able to assume
max_ino_bits also applies to inode->i_ino, but if you tell us to
stay clear of inode->i_ino, then we can always use stat.st_ino.

Thanks,
Amir.
