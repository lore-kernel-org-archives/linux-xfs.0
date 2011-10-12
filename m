Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9CMXBEH104660 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 17:33:12 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B42114682C0
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 15:40:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nECtJEOCemQyCeMN for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 15:40:32 -0700 (PDT)
Date: Thu, 13 Oct 2011 09:33:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Hex Offset Map/Values
Message-ID: <20111012223305.GJ3159@dastard>
References: <CAOmWOSDnJ-wC73AhJwMpWzFrOaLPoX7xC0ppPwthsdJfad3t7w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOmWOSDnJ-wC73AhJwMpWzFrOaLPoX7xC0ppPwthsdJfad3t7w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter McManus <maltmanic@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 12, 2011 at 05:59:34PM +1100, Peter McManus wrote:
> Hi,
> 
> I'm fairly new to XFS and am preparing a report (for both my own and my
> team's education) on the low-level partition structure of an XFS primary
> superblock. This is from a computer forensic perspective.

You're doing it the hard way....

> I'm currently trying to determine the actual hexidecimal offset structure
> for all the fields within a primary superblock of an XFS partition.
> 
> For example, I know that the value for the field XFS_SB_MAGIC is 0x58465342
> as this is readily available in XFS documentation, however I need to know
> the hex offsets, byte lengths, and method of interpretation for all of the
> following fields as defined within xfs_sb:
> 
> __uint32_t          sb_magicnum;         /* magic number == XFS_SB_MAGIC */
> __uint32_t          sb_blocksize;           /* logical block size, bytes */
> xfs_drfsbno_t      sb_dblocks;            /* number of data blocks */
> xfs_drfsbno_t      sb_rblocks;             /* number of realtime blocks */
> xfs_drtbno_t        sb_rextents;           /* number of realtime extents */
> uuid_t                  sb_uuid;                 /* file system unique id */
> xfs_dfsbno_t       sb_logstart;            /* starting block of log if
> internal */
> xfs_ino_t             sb_rootino;             /* root inode number */
> xfs_ino_t             sb_rbmino;             /* bitmap inode for realtime
> extents */
> xfs_ino_t             sb_rsumino;           /* summary inode for rt bitmap
> */
> xfs_agblock_t      sb_rextsize;           /* realtime extent size, blocks */
> xfs_agblock_t       sb_agblocks;        /* size of an allocation group */
> xfs_agnumber_t   sb_agcount;         /* number of allocation groups */
> xfs_extlen_t         sb_rbmblocks;      /* number of rt bitmap blocks */
> xfs_extlen_t        sb_logblocks;        /* number of log blocks */
> __uint16_t           sb_versionnum;    /* header version == XFS_SB_VERSION
> */
> __uint16_t           sb_sectsize;         /* volume sector size, bytes */
> __uint16_t           sb_inodesize;       /* inode size, bytes */
> __uint16_t           sb_inopblock;      /* inodes per block */
> char                     sb_fname[12];     /* file system name */
> __uint8_t             sb_blocklog;        /* log2 of sb_blocksize */
> __uint8_t             sb_sectlog;          /* log2 of sb_sectsize */
> __uint8_t             sb_inodelog;        /* log2 of sb_inodesize */
> __uint8_t             sb_inopblog;        /* log2 of sb_inopblock */
> __uint8_t             sb_agblklog;        /* log2 of sb_agblocks (rounded
> up) */
> __uint8_t             sb_rextslog;         /* log2 of sb_rextents */
> __uint8_t             sb_inprogress;     /* mkfs is in progress, don't mount
> */
> __uint8_t             sb_imax_pct;       /* max % of fs for inode space */

Go look at the xfs_sb_info array for offsets, and the definition of
the struct xfs_dsb for the raw field sizes.

> At http://kerneldox.net/dir_73a2d815072069310dd9b6b9499ac462.html I was able
> to look through the code of the "alloc" files for further info however was
> not able to find a full or definitive list. I understand that it may be
> possible that the field values are contiguous but I still require a byte
> length description for each field.
> 
> Can someone please let me know if/where I can find documentation for this
> kind of very low level partition structure analysis?

It's all documented in the kernel code. The on-disk structures use
well defined types of known length, or use structures that encode
the length for variable length fields. In fact, it's probably better
documented in the source code for xfs_db....

The on-disk structure with descriptions also has external
documentation as well here:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

E.g. the superblock:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Allocation_Groups.html#Superblocks


> Also, can you please tell me if the values are all in little or big endian?

XFS on-disk format is big endian, except for the log which is in
native endian format.

BTW, if you want to dig around in the corpses of XFS filesystems,
I'd suggest you start with learning about xfs_db - most of your
forensic needs will be covered by that tool....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
