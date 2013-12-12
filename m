Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D749A7F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 09:26:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5985BAC004
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:26:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hxCtIh3LzgDy7eNg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 07:26:04 -0800 (PST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4 v3] fiemap: introduce EXTENT_DATA_COMPRESSED flag
Date: Thu, 12 Dec 2013 16:25:57 +0100
Message-Id: <cover.1386778302.git.dsterba@suse.cz>
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

The original FIEMAP patch did not define this bit, btrfs will make use of
it.  The defined constant maintains the same value as originally proposed.

Currently, the 'filefrag' utility has no way to recognize and denote a
compressed extent. As implemented in btrfs right now, the compression step
splits a big extent into smaller chunks and this is reported as a heavily
fragmented file. Adding the flag to filefrag will at least give some
explanation why, this has been confusing users for some time already.

V3:
Based on feedback from Andreas, implement #1 from V2, current users of
fiemap_fill_next_extent (fs/, ext4, gfs2, ocfs2, nilfs2, xfs) updated
accordingly, no functional change.

V2:
Based on feedback from Andreas, the fiemap_extent is now able to hold the
physical extent length, to be filled by the filesystem callback.

The filesystems do not have access to the structure that is passed back to
userspace and are supposed to call fiemap_fill_next_extent, there's no direct
way to fill fe_phys_length. There are two ways to pass it:

1) extend fiemap_fill_next_extent to take phys_length and update all
   users (ext4, gfs2, ocfs2, nilfs2, xfs)

2) add new function that takes arguments for all the fiemap_extent items,
   newly added phys_length compared to fiemap_fill_next_extent

David Sterba (4):
  fiemap: fix comment at EXTENT_DATA_ENCRYPTED
  fiemap: add EXTENT_DATA_COMPRESSED flag
  btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
  Documentation/fiemap: Document the DATA_COMPRESSED flag

 Documentation/filesystems/fiemap.txt |   17 +++++++++++++----
 fs/btrfs/extent_io.c                 |    9 +++++++--
 fs/ext4/extents.c                    |    3 ++-
 fs/ext4/inline.c                     |    2 +-
 fs/gfs2/inode.c                      |    2 +-
 fs/ioctl.c                           |   18 ++++++++++++------
 fs/nilfs2/inode.c                    |    8 +++++---
 fs/ocfs2/extent_map.c                |    4 ++--
 fs/xfs/xfs_iops.c                    |    2 +-
 include/linux/fs.h                   |    2 +-
 include/uapi/linux/fiemap.h          |    8 ++++++--
 11 files changed, 51 insertions(+), 24 deletions(-)

-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
