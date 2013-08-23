Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12211-g00574da
Message-Id: <20130823202510.A399C29DFB@oss.sgi.com>
Date: Fri, 23 Aug 2013 15:25:09 -0500 (CDT)
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
  00574da xfs: introduce object readahead to log recovery
  8d1d408 xfs: Simplify xfs_ail_min() with list_first_entry_or_null()
  46677e6 xfs: Register hotcpu notifier after initialization
      from  3e3c51cee9a07d67e3910cc514867b56ac60ec94 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 00574da199291751bfaaee15ad0f42a7144276ad
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 14 15:16:03 2013 +0800

    xfs: introduce object readahead to log recovery
    
      It can take a long time to run log recovery operation because it is
    single threaded and is bound by read latency. We can find that it took
    most of the time to wait for the read IO to occur, so if one object
    readahead is introduced to log recovery, it will obviously reduce the
    log recovery time.
    
    Log recovery time stat:
    
              w/o this patch        w/ this patch
    
    real:        0m15.023s             0m7.802s
    user:        0m0.001s              0m0.001s
    sys:         0m0.246s              0m0.107s
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8d1d40832b1c53ae73931f1b536ce1ab7375b3c8
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Thu Aug 15 13:08:35 2013 +0800

    xfs: Simplify xfs_ail_min() with list_first_entry_or_null()
    
    At xfs_ail_min(), we do check if the AIL list is empty or not before
    returning the first item in it with list_empty() and list_first_entry().
    
    This can be simplified a bit with a new list operation routine that is
    the list_first_entry_or_null() which has been introduced by:
    
    commit 6d7581e62f8be462440d7b22c6361f7c9fa4902b
        list: introduce list_first_entry_or_null
    
    v2: make xfs_ail_min() as a static inline function and move it to
        xfs_trans_priv.h as per Dave Chinner's comments.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 46677e679fba8c2db7c94a7142ad9abb72192ebc
Author: Richard Weinberger <richard@nod.at>
Date:   Mon Aug 19 22:56:44 2013 +0200

    xfs: Register hotcpu notifier after initialization
    
    Currently the code initializizes mp->m_icsb_mutex and other things
    _after_ register_hotcpu_notifier().
    As the notifier takes mp->m_icsb_mutex it can happen
    that it takes the lock before it's initialization.
    
    Signed-off-by: Richard Weinberger <richard@nod.at>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_log_recover.c | 159 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c       |  13 ++--
 fs/xfs/xfs_trans_ail.c   |  14 -----
 fs/xfs/xfs_trans_priv.h  |  12 ++++
 4 files changed, 171 insertions(+), 27 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
