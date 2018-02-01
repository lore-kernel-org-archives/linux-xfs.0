Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35906 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbeBAA1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 19:27:24 -0500
MIME-Version: 1.0
In-Reply-To: <20180129155054.GJ9359@magnolia>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
 <20180126214404.GE9068@magnolia> <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
 <20180129155054.GJ9359@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Feb 2018 02:27:23 +0200
Message-ID: <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable@kernel.org

On Mon, Jan 29, 2018 at 5:50 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Jan 29, 2018 at 01:07:36PM +0200, Amir Goldstein wrote:
>> On Fri, Jan 26, 2018 at 11:44 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > On Fri, Jan 26, 2018 at 09:44:29AM +0200, Amir Goldstein wrote:
>> >> Commit 66f364649d870 ("xfs: remove if_rdev") moved storing of rdev
>> >> value for special inodes to VFS inodes, but forgot to preserve the
>> >> value of i_rdev when recycling a reclaimable xfs_inode.
>> >>
>> >> This was detected by xfstest overlay/017 with inodex=on mount option
>> >> and xfs base fs. The test does a lookup of overlay chardev and blockdev
>> >> right after drop caches.
>> >>
>> >> Overlayfs inodes hold a reference on underlying xfs inodes when mount
>> >> option index=on is configured. If drop caches reclaim xfs inodes, before
>> >> it relclaims overlayfs inodes, that can sometimes leave a reclaimable xfs
>> >> inode and that test hits that case quite often.
>> >>
>> >> When that happens, the xfs inode cache remains broken (zere i_rdev)
>> >> until the next cycle mount or drop caches.
>> >>
>> >> Fixes: 66f364649d870 ("xfs: remove if_rdev")
>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >
>> > Looks ok,
>> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> >
>>
>> I recon that now we should now also strap:
>> Cc: <stable@vger.kernel.org> #v4.15
>>
>> Can I assume, you'll add it on apply?
>
> I'll do a proper backport of this and a couple other critical cow
> fixes after I get the 4.16 stuff merged.
>

I am not sure what "proper backport" means in the context of
this patch.
This is a v4.15-rc1 regression fix that is based on v4.15-rc8.
It applied cleanly on v4.15.

CC'ing stable for attention.

This patch is now in master, but due to its timing it did not
get the CC: stable tag.

Thanks,
Amir.
