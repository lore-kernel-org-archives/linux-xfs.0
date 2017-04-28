Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33049 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163951AbdD1GSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 02:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20170428055658.GD22884@birch.djwong.org>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427193118.GH23371@birch.djwong.org> <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
 <20170428054945.rg54cm5yftfuqfsf@brain> <20170428055658.GD22884@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Apr 2017 09:18:39 +0300
Message-ID: <CAOQ4uxjuo=jnifmDDc2yT_A9tDGxaX56=HCg+7aaCpzVFCuMNg@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 28, 2017 at 8:56 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Apr 28, 2017 at 06:49:45AM +0100, Andy Whitcroft wrote:
>> On Thu, Apr 27, 2017 at 03:30:35PM -0500, Eric Sandeen wrote:
>>
>> > It'd be trivial to make that a vfs function and set a flag on the vfs super
>> > if the UUID is not unique.  Would that be worthwhile?  I can send a patch
>> > if so.
>>
>> This only tells you that the UUID it has is unique now.  As you are
>> contemplating storing them in the FS they have to be unique in space
>> _and_ time.  No check you can do now can tell you if the UUID is unique
>> for all time.  Right ?
>
> Well, since we're talking about all time: "probably" :P
>
> That said, Eric was talking about a refactoring of one of XFS's mount
> time checks that errors out if there's already a mounted fs with the
> same uuid.  We use it to avoid catastrophic mounting of the same fs from
> multiple (misconfigured) multipaths/snapshots/volumes/whatever on the
> same machine.  Not sure if that's useful for Amir's case.
>

As far as I can tell, we don't mind that sb->s_uuid is not unique.
All we care about is to verify that the file handle we are holding was encoded
from the same file system instance OR from one of its derivative (LVM
snapshot etc), just as a sanity that we won't get a completely different
object (from a different fs type even) by mistake.

If admin zygotes all his ext4 fs with the same uuid and fill them with
different content and copies overlay layers between them....
Let me know if you think there is a real use case for this so I can sympathize.

Amir.
