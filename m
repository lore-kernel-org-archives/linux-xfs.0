Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:39340 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeA2LHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 06:07:38 -0500
MIME-Version: 1.0
In-Reply-To: <20180126214404.GE9068@magnolia>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com> <20180126214404.GE9068@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Jan 2018 13:07:36 +0200
Message-ID: <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 26, 2018 at 11:44 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Jan 26, 2018 at 09:44:29AM +0200, Amir Goldstein wrote:
>> Commit 66f364649d870 ("xfs: remove if_rdev") moved storing of rdev
>> value for special inodes to VFS inodes, but forgot to preserve the
>> value of i_rdev when recycling a reclaimable xfs_inode.
>>
>> This was detected by xfstest overlay/017 with inodex=on mount option
>> and xfs base fs. The test does a lookup of overlay chardev and blockdev
>> right after drop caches.
>>
>> Overlayfs inodes hold a reference on underlying xfs inodes when mount
>> option index=on is configured. If drop caches reclaim xfs inodes, before
>> it relclaims overlayfs inodes, that can sometimes leave a reclaimable xfs
>> inode and that test hits that case quite often.
>>
>> When that happens, the xfs inode cache remains broken (zere i_rdev)
>> until the next cycle mount or drop caches.
>>
>> Fixes: 66f364649d870 ("xfs: remove if_rdev")
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>

I recon that now we should now also strap:
Cc: <stable@vger.kernel.org> #v4.15

Can I assume, you'll add it on apply?

Thanks,
Amir.
