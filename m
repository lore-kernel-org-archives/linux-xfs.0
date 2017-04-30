Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32822 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969314AbdD3FB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Apr 2017 01:01:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170429230159.GM12369@dastard>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com> <20170429230159.GM12369@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 30 Apr 2017 08:01:56 +0300
Message-ID: <CAOQ4uxhObqqK0FSni8nc3k5RGaRv1miPNDhf460FSuV3LZ0zkg@mail.gmail.com>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Apr 30, 2017 at 2:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Apr 27, 2017 at 11:59:29AM +0300, Amir Goldstein wrote:
>> Miklos,
>>
>> As you observed, the sb->s_uuid field is not always filled by filesystems.
>>
>> Consumers, like overlayfs, that wish to use this field can check if is
>> zeroed out as an indication for valid value.
>>
>> Christoph suggested to make the test more explicit and require the
>> filesystems that fill the s_uuid field to set a super block flag.
>>
>> Do you agree with the proposed API?
>>
>> The first patch in the series defines the flag.
>> If you push this patch through your tree to Al or Linus, then filesystem
>> maintainers could later pick the individual patches to their trees.
>>
>> The xfs patch is based on a patch I already sent to Darrick for filling
>> out the s_uuid field.
>>
>> Thanks,
>> Amir.
>>
>> Amir Goldstein (5):
>>   vfs: define a flag to indicate sb->s_uuid is available
>>   ext4: set the super block SB_I_HAVE_UUID flag
>>   f2fs: set the super block SB_I_HAVE_UUID flag
>>   ocfs2: set the super block SB_I_HAVE_UUID flag
>>   xfs: set the super block SB_I_HAVE_UUID flag
>>
>>  fs/ext4/super.c    | 1 +
>>  fs/f2fs/super.c    | 1 +
>>  fs/ocfs2/super.c   | 1 +
>>  fs/xfs/xfs_mount.c | 1 +
>>  include/linux/fs.h | 3 +++
>>  5 files changed, 7 insertions(+)
>
> Doesn't this make the struct export_opierations .get_uuid method
> somewhat redundant?  Shouldn't that now be replaced with generic
> functions that looks at SB_I_HAVE_UUID before allowing PNFS export
> is allowed and then just use s_uuid directly in the PNFS code?
>

There's the tiny issue that get_uuid also returns the offset of the uuid
on disk. Not sure how much that really matters for PNFS?

Amir.
