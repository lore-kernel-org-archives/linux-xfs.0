Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34041 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932937AbcIVCws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 22:52:48 -0400
MIME-Version: 1.0
In-Reply-To: <20160922022510.GI10172@birch.djwong.org>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-3-git-send-email-amir73il@gmail.com> <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
 <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
 <20160921214814.GC10454@dastard> <20160921215724.GV2356@ZenIV.linux.org.uk>
 <20160921223331.GE10454@dastard> <20160922022510.GI10172@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Sep 2016 05:52:46 +0300
Message-ID: <CAOQ4uxh369C2r19pLSz9Cba7517za8ncgjUC3CvO4q7B6XZ9JQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 22, 2016 at 5:25 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Sep 22, 2016 at 08:33:31AM +1000, Dave Chinner wrote:
>> On Wed, Sep 21, 2016 at 10:57:24PM +0100, Al Viro wrote:
>> > On Thu, Sep 22, 2016 at 07:48:15AM +1000, Dave Chinner wrote:
>> >
>> > > If you get any error other than -EXDEV or -EOPNOTSUPP from a clone
>> > > operation, there's somethign seriously wrong with the metadata of
>> > > the inode or the underlying storage.
>> >
>> > Such as -ENOSPC?
>>
>> Yup, that's a fatal error, too.  i.e. if a clone returns ENOSPC
>> because there isn't space for the extra metadata, then the fallback
>> data copy is almost certainly going to fail with ENOSPC when trying
>> to reserve/allocate space for both the extra data copy and the extra
>> metadata....
>
> XFS will return ENOSPC during reflink if one of the relevant AGs is
> running low on space for the refcount/rmap trees; however there might be
> enough blocks in another AG to make a regular old copy.
>

That settles it then. I rather be prudent and retry copy anyway.
Other (maybe future) filesystems may have their own non-fatal reasons
to fail clone
and they have the right to do so.

I will resend the ACKed clone_range patch pair for Miklos to pick up

For now, I am not at ease about resending the copy_range patch pair
without a proper way for users to get independent test coverage for it.

Unless Miklos or Al feel confident enough about taking those patches
on my testing testimony and their review?

Darrick, do you have an easy way to reproduce the extreme case of
clone failure due to certain AG ENOSPC? any xfstest for it?
I recon that the fallback to copy_range could be useful in that case
(i.e. very large file with one block in the unfortunate AG)

Cheers,
Amir.
