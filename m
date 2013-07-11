Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-8-g92f8ff7
Message-Id: <20130711205455.C5E037F4E@oss.sgi.com>
Date: Thu, 11 Jul 2013 15:54:55 -0500 (CDT)
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
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, master has been updated
  92f8ff7 xfs: Add pquota fields where gquota is used.
      from  42c49d7f249c2487f36d3314753d5d8ebcee8249 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 92f8ff73f18672b03ec8b92197cdddf2b5de7ea0
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jul 11 00:00:40 2013 -0500

    xfs: Add pquota fields where gquota is used.
    
    Add project quota changes to all the places where group quota field
    is used:
       * add separate project quota members into various structures
       * split project quota and group quotas so that instead of overriding
         the group quota members incore, the new project quota members are
         used instead
       * get rid of usage of the OQUOTA flag incore, in favor of separate
         group and project quota flags.
       * add a project dquot argument to various functions.
    
    Not using the pquotino field from superblock yet.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dquot.c       |  15 ++-
 fs/xfs/xfs_dquot.h       |   7 +-
 fs/xfs/xfs_icache.c      |   1 +
 fs/xfs/xfs_inode.h       |   1 +
 fs/xfs/xfs_ioctl.c       |  14 +--
 fs/xfs/xfs_iops.c        |   4 +-
 fs/xfs/xfs_qm.c          | 243 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_qm.h          |  20 ++--
 fs/xfs/xfs_qm_bhv.c      |  10 +-
 fs/xfs/xfs_qm_syscalls.c |  19 +++-
 fs/xfs/xfs_quota.h       |  32 ++++---
 fs/xfs/xfs_symlink.c     |  10 +-
 fs/xfs/xfs_trans_dquot.c |  26 ++++-
 fs/xfs/xfs_vnodeops.c    |  13 ++-
 14 files changed, 291 insertions(+), 124 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
