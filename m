Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZMVP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 08:21:15 -0400
Date: Wed, 26 Jun 2019 08:20:42 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <868182386.37358699.1561551642881.JavaMail.zimbra@redhat.com>
In-Reply-To: <156151633004.2283456.4175543089138173586.stgit@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia> <156151633004.2283456.4175543089138173586.stgit@magnolia>
Subject: Re: [Cluster-devel] [PATCH 1/5] vfs: create a generic checking and
 prep function for FS_IOC_SETFLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: matthew garrett <matthew.garrett@nebula.com>, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard biesheuvel <ard.biesheuvel@linaro.org>, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger kernel <adilger.kernel@dilger.ca>, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

----- Original Message -----
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic function to check incoming FS_IOC_SETFLAGS flag values
> and later prepare the inode for updates so that we can standardize the
> implementations that follow ext4's flag values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c    |   13 +++++--------
>  fs/efivarfs/file.c  |   26 +++++++++++++++++---------
>  fs/ext2/ioctl.c     |   16 ++++------------
>  fs/ext4/ioctl.c     |   13 +++----------
>  fs/f2fs/file.c      |    7 ++++---
>  fs/gfs2/file.c      |   42 +++++++++++++++++++++++++++++-------------
>  fs/hfsplus/ioctl.c  |   21 ++++++++++++---------
>  fs/inode.c          |   24 ++++++++++++++++++++++++
>  fs/jfs/ioctl.c      |   22 +++++++---------------
>  fs/nilfs2/ioctl.c   |    9 ++-------
>  fs/ocfs2/ioctl.c    |   13 +++----------
>  fs/orangefs/file.c  |   35 ++++++++++++++++++++++++++---------
>  fs/reiserfs/ioctl.c |   10 ++++------
>  fs/ubifs/ioctl.c    |   13 +++----------
>  include/linux/fs.h  |    3 +++
>  15 files changed, 146 insertions(+), 121 deletions(-)

The gfs2 portion looks correct.

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

Regards,

Bob Peterson
