Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbdGGV2E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 17:28:04 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Date: Fri,  7 Jul 2017 23:27:58 +0200
Message-Id: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jun 30, 2017 at 1:51 PM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> On Thu, Jun 29, 2017 at 3:54 PM, Christoph Hellwig <hch@lst.de> wrote:
>> Switch to the iomap_seek_hole and iomap_seek_data helpers for
>> implementing lseek SEEK_HOLE / SEEK_DATA, and remove all the
>> code that isn't needed any more.
>>
>> Note that with this patch ext4 will now always depend on the iomap
>> code instead of only when CONFIG_DAX is enabled, and it requires
>> adding a call into the extent status tree for iomap_begin as well
>> to properly deal with delalloc extents.
>
> This breaks SEEK_HOLE / SEEK_DATA on filesystems with the inline_data feature.
>
> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> to be added back for consistency between reading i_size and walking
> the file extents.

Here are some possible fixes on top of this patch.

One problem with iomap is that is uses a sector number for the physical offset
instead of a byte offset which prevents iomap from being used for inline data
(ext4) / stuffed inodes (gfs2).  If we convert that into a byte offset,
iomap_fiemap and iomap_seek_{hole,data} will just work for those kinds of files.

Andreas

Andreas Gruenbacher (3):
  ext4: Add missing locking around iomap_seek_{hole,data}
  iomap: Switch from blkno to physical offset
  ext4: Add IOMAP_REPORT support for inline data

 fs/buffer.c           |  2 +-
 fs/dax.c              |  2 +-
 fs/ext2/inode.c       |  4 ++--
 fs/ext4/ext4.h        |  4 ++++
 fs/ext4/file.c        |  4 ++++
 fs/ext4/inline.c      | 33 +++++++++++++++++++++++++++++++++
 fs/ext4/inode.c       | 13 +++++++++----
 fs/iomap.c            | 14 ++++++++------
 fs/nfsd/blocklayout.c |  4 ++--
 fs/xfs/xfs_iomap.c    |  6 +++---
 include/linux/iomap.h |  5 +++--
 11 files changed, 70 insertions(+), 21 deletions(-)

-- 
2.7.5

