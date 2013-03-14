Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05DBE7F86
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:41:23 -0500 (CDT)
Date: Thu, 14 Mar 2013 16:41:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/21] xfs: metadata CRCs, third version
Message-ID: <20130314214122.GZ22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 11:30:33PM +1100, Dave Chinner wrote:
> Hi Folks,
> 
> Another week, another version. Previous versions:
> 
> http://oss.sgi.com/archives/xfs/2013-01/msg00328.html
> http://oss.sgi.com/archives/xfs/2013-02/msg00451.html
> 
> This version is based on 3.9-rc2 + TOT xfsdev. I've just forward
> ported it from a 3.8.0 base where I've been working  on it and
> testing for some time. Bugs that show up are likely to be a result
> of the forward porting, because I'm posting this before I've even
> run a full test cycle on 3.9-rc2. I'll probably send delta patches
> as followup bug fixes rather than reposting full patches, I think...
> 
> The first patch is an outstanding bug fix, the second is a change in
> corruption event output to make it output the entire headers of the
> corrupted buffer to make it easier to triage problems.
> 
> This new version contains:
> 	- numerous bug fixes, mostly in the directory and
> 	  attribute code.
> 	- support for remote attributes
> 	- directory/attribute buffer type tracking for log recovery
> 	- some cleanup of rough corners in the dir/attr code.
> 
> Still to do:
> 
> 	- DT_* type fields in the directory entries
> 	- storage of attributes larger than 256 bytes in shortform
> 	  attribute forks.
> 	- extended superblock feature field checking (i.e. reject
> 	  anything that is not zero)
> 	- add mount warnings about CRC support being experimental
> 	- Documentation (half written, not in series)
> 
> In terms of testing, this patch set seems quite robust running on
> non-CRC enabled filesystems with existing tool chains. There are no
> regressions from xfstests, fsmark, dbench and other worklaods I've
> thrown at it, nor does there appear to be any significant
> performance impact from the modified code.
> 
> The CRC enabled code has been smoke tested. I haven't finished the
> userspace port so there is no repair/check functionality which means
> I cannot run xfstests on it yet. The attribute code is pretty much
> untested, but everything else seems to work fine. I can run it
> through my 50-million inode fsmark test (which creates, walks and
> removes 50 million inodes) without any problems occurring, so
> directory growing and shrinking is not obviously broken like it was
> last time.
> 
> To run with CRCs enabled, however, you need a mkfs.xfs patch to
> change the offsets of entries in short form directories. I'l post an
> updated patch set in the morning that at least enables this in
> userspace.
> 
> Comments, flames and questions welcome.
> 
> -Dave.
> 
> $ git diff --stat -C -M --summary 929724d..
>  fs/xfs/Makefile           |    6 +-
>  fs/xfs/xfs_ag.h           |   56 +-
>  fs/xfs/xfs_alloc.c        |  199 ++++--
>  fs/xfs/xfs_alloc_btree.c  |  105 ++-
>  fs/xfs/xfs_alloc_btree.h  |   12 +-
>  fs/xfs/xfs_attr.c         |  456 +++---------
>  fs/xfs/xfs_attr.h         |    1 -
>  fs/xfs/xfs_attr_leaf.c    | 1780 +++++++++++++++++++++++++++--------------------
>  fs/xfs/xfs_attr_leaf.h    |  122 +++-
>  fs/xfs/xfs_attr_remote.c  |  550 +++++++++++++++
>  fs/xfs/xfs_attr_remote.h  |   46 ++
>  fs/xfs/xfs_bmap.c         |   71 +-
>  fs/xfs/xfs_bmap_btree.c   |  110 ++-
>  fs/xfs/xfs_bmap_btree.h   |   19 +-
>  fs/xfs/xfs_btree.c        |  256 +++++--
>  fs/xfs/xfs_btree.h        |   64 +-
>  fs/xfs/xfs_buf.c          |    6 +
>  fs/xfs/xfs_buf_item.h     |   52 +-
>  fs/xfs/xfs_da_btree.c     | 1500 ++++++++++++++++++++++++---------------
>  fs/xfs/xfs_da_btree.h     |  130 +++-
>  fs/xfs/xfs_dinode.h       |   43 +-
>  fs/xfs/xfs_dir2_block.c   |  179 +++--
>  fs/xfs/xfs_dir2_data.c    |  266 ++++---
>  fs/xfs/xfs_dir2_format.h  |  290 +++++++-
>  fs/xfs/xfs_dir2_leaf.c    |  891 +++++++++++++++---------
>  fs/xfs/xfs_dir2_node.c    |  992 ++++++++++++++++----------
>  fs/xfs/xfs_dir2_priv.h    |   50 +-
>  fs/xfs/xfs_dir2_sf.c      |   12 +-
>  fs/xfs/xfs_dquot.c        |  112 ++-
>  fs/xfs/xfs_error.c        |    2 +-
>  fs/xfs/xfs_file.c         |    2 +-
>  fs/xfs/xfs_fsops.c        |   34 +-
>  fs/xfs/xfs_ialloc.c       |   80 ++-
>  fs/xfs/xfs_ialloc_btree.c |   87 ++-
>  fs/xfs/xfs_ialloc_btree.h |    9 +-
>  fs/xfs/xfs_inode.c        |  212 ++++--
>  fs/xfs/xfs_inode.h        |   31 +-
>  fs/xfs/xfs_inode_item.c   |    2 +-
>  fs/xfs/xfs_log_recover.c  |  219 +++++-
>  fs/xfs/xfs_mount.c        |   97 ++-
>  fs/xfs/xfs_mount.h        |    1 +
>  fs/xfs/xfs_qm.c           |   23 +-
>  fs/xfs/xfs_qm.h           |    2 +
>  fs/xfs/xfs_quota.h        |   11 +-
>  fs/xfs/xfs_sb.h           |  100 ++-
>  fs/xfs/xfs_symlink.c      |  719 +++++++++++++++++++
>  fs/xfs/xfs_symlink.h      |   53 ++
>  fs/xfs/xfs_trace.c        |    2 +-
>  fs/xfs/xfs_trans.h        |    4 +
>  fs/xfs/xfs_trans_buf.c    |   51 +-
>  fs/xfs/xfs_vnodeops.c     |  480 +------------
>  51 files changed, 7034 insertions(+), 3563 deletions(-)
>  create mode 100644 fs/xfs/xfs_attr_remote.c
>  create mode 100644 fs/xfs/xfs_attr_remote.h
>  create mode 100644 fs/xfs/xfs_symlink.c
>  create mode 100644 fs/xfs/xfs_symlink.h

Applied #1 and #3.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
