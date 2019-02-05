Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:47086 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfBEGo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 01:44:57 -0500
MIME-Version: 1.0
References: <20190204165427.23607-1-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Feb 2019 08:44:45 +0200
Message-ID: <CAOQ4uxiMdaeKvGAmnswWZAbJQZTRsFfQKGthkxnCyfOPC+xosQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Sasha Levin <Alexander.Levin@microsoft.com>, stable <stable@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

On Mon, Feb 4, 2019 at 6:54 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> Kernel stable team,
>
> here is a v2 respin of my XFS stable patches for v4.19.y. The only
> change in this series is adding the upstream commit to the commit log,
> and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> were spotted or raised with this series.
>
> Reviews, questions, or rants are greatly appreciated.

Luis,

Thanks a lot for doing this work.

For the sake of people not following "oscheck", could you please
write a list of configurations you tested with xfstests. auto group?
Any expunged tests we should know about?

I went over the candidate patches and to me, they all look like stable
worthy patches and I have not identified any dependencies.

Original authors and reviewers are in the best position to  verify
those assessments, so please guys, if each one of you acks his
own patch, that shouldn't take a lot of anyone's time.

Specifically, repeating Luis's request from v1 cover letter -
There are two patches by Dave ([6,7/10]) that are originally from
a 7 patch series of assorted fixes:
https://patchwork.kernel.org/cover/10689445/

Please confirm that those two patches do stand on their own.

Thanks,
Amir.


>
>   Luis
>
> Brian Foster (1):
>   xfs: fix shared extent data corruption due to missing cow reservation
>
> Carlos Maiolino (1):
>   xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
>
> Christoph Hellwig (1):
>   xfs: cancel COW blocks before swapext
>
> Christophe JAILLET (1):
>   xfs: Fix error code in 'xfs_ioc_getbmap()'
>
> Darrick J. Wong (1):
>   xfs: fix PAGE_MASK usage in xfs_free_file_space
>
> Dave Chinner (3):
>   xfs: fix overflow in xfs_attr3_leaf_verify
>   xfs: fix transient reference count error in
>     xfs_buf_resubmit_failed_buffers
>   xfs: delalloc -> unwritten COW fork allocation can go wrong
>
> Eric Sandeen (1):
>   xfs: fix inverted return from xfs_btree_sblock_verify_crc
>
> Ye Yin (1):
>   fs/xfs: fix f_ffree value for statfs when project quota is set
>
>  fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
>  fs/xfs/libxfs/xfs_bmap.c      |  5 ++++-
>  fs/xfs/libxfs/xfs_btree.c     |  2 +-
>  fs/xfs/xfs_bmap_util.c        | 10 ++++++++--
>  fs/xfs/xfs_buf_item.c         | 28 +++++++++++++++++++++-------
>  fs/xfs/xfs_ioctl.c            |  2 +-
>  fs/xfs/xfs_qm_bhv.c           |  2 +-
>  fs/xfs/xfs_reflink.c          |  1 +
>  fs/xfs/xfs_stats.c            |  2 +-
>  9 files changed, 47 insertions(+), 16 deletions(-)
>
> --
> 2.18.0
>
