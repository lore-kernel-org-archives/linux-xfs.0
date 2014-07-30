Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ABBB27F66
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 12:18:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D3DFAC004
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 10:18:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jgWg5AURtTrXb3CQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 10:18:31 -0700 (PDT)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6 v5] fiemap: introduce DATA_COMPRESSED and PHYS_LENGTH flags
Date: Wed, 30 Jul 2014 19:18:29 +0200
Message-Id: <cover.1406739708.git.dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: adilger@dilger.ca, linux-nilfs@vger.kernel.org, mfasheh@suse.com, David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

The original FIEMAP patch did not define the bits, btrfs would like to use a
flag for compressed extents. The PHYS_LENGTH flag emerged during patchset
revisions to keep backward compatibility and flexible fiemap API.

Currently, the 'filefrag' utility has no way to recognize and denote a
compressed extent. As implemented in btrfs right now, the compression step
splits a big extent into smaller chunks and this is reported as a heavily
fragmented file. Adding the flag to filefrag will at least give some
explanation why, this has been confusing users for some time already.

fiemap_fill_next_extent is extended and takes argument to fill the physical
length.

V5:
Physical length is by default undefined. Btrfs use of compressed flag was
enhanced to reflect the fiemap changes. Patches reordered so the generic fiemap
go first.

V4:
The physical length is always set and equal to logical, or different and
then sets the COMPRESSED flag.
fiemap_extent::fe_length renamed to fe_logi_length

V3:
Based on feedback from Andreas, implement #1 from V2, current users of
fiemap_fill_next_extent (fs/, ext4, gfs2, ocfs2, nilfs2, xfs) updated
accordingly, no functional change.

V2:
Based on feedback from Andreas, the fiemap_extent is now able to hold the
physical extent length, to be filled by the filesystem callback.

1) extend fiemap_fill_next_extent to take phys_length and update all
   users (ext4, gfs2, ocfs2, nilfs2, xfs)


David Sterba (6):
  fiemap: fix comment at EXTENT_DATA_ENCRYPTED
  fiemap: add fe_phys_length and EXTENT_PHYS_LENGTH flag
  fiemap: add FIEMAP_EXTENT_DATA_COMPRESSED flag
  Documentation/fiemap: Document DATA_COMPRESSED and PHYS_LENGTH flags
  fiemap: rename fe_length to fe_logi_length
  btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents

 Documentation/filesystems/fiemap.txt | 24 ++++++++++++++++++++----
 fs/btrfs/extent_io.c                 | 11 ++++++++---
 fs/ext4/extents.c                    |  4 ++--
 fs/ext4/inline.c                     |  2 +-
 fs/gfs2/inode.c                      |  2 +-
 fs/ioctl.c                           | 21 ++++++++++++++-------
 fs/nilfs2/inode.c                    |  8 +++++---
 fs/ocfs2/extent_map.c                |  4 ++--
 fs/xfs/xfs_iops.c                    |  2 +-
 include/linux/fs.h                   |  2 +-
 include/uapi/linux/fiemap.h          | 16 +++++++++++++---
 11 files changed, 68 insertions(+), 28 deletions(-)

-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
