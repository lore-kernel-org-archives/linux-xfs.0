Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. v3.10-rc1-25-g59913f1
Message-Id: <20130604223700.CF1B929DF8@oss.sgi.com>
Date: Tue,  4 Jun 2013 17:37:00 -0500 (CDT)
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
  59913f1 xfs: fix remote attribute invalidation for a leaf
  6fcdc59 xfs: rework dquot CRCs
      from  5ae6e6a401957698f2bd8c9f4a86d86d02199fea (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 59913f14dfe8eb772ff93eb442947451b4416329
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jun 3 15:28:49 2013 +1000

    xfs: fix remote attribute invalidation for a leaf
    
    When invalidating an attribute leaf block block, there might be
    remote attributes that it points to. With the recent rework of the
    remote attribute format, we have to make sure we calculate the
    length of the attribute correctly. We aren't doing that in
    xfs_attr3_leaf_inactive(), so fix it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinuguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6fcdc59de28817d1fbf1bd58cc01f4f3fac858fb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jun 3 15:28:46 2013 +1000

    xfs: rework dquot CRCs
    
    Calculating dquot CRCs when the backing buffer is written back just
    doesn't work reliably. There are several places which manipulate
    dquots directly in the buffers, and they don't calculate CRCs
    appropriately, nor do they always set the buffer up to calculate
    CRCs appropriately.
    
    Firstly, if we log a dquot buffer (e.g. during allocation) it gets
    logged without valid CRC, and so on recovery we end up with a dquot
    that is not valid.
    
    Secondly, if we recover/repair a dquot, we don't have a verifier
    attached to the buffer and hence CRCs are not calculated on the way
    down to disk.
    
    Thirdly, calculating the CRC after we've changed the contents means
    that if we re-read the dquot from the buffer, we cannot verify the
    contents of the dquot are valid, as the CRC is invalid.
    
    So, to avoid all the dquot CRC errors that are being detected by the
    read verifier, change to using the same model as for inodes. That
    is, dquot CRCs are calculated and written to the backing buffer at
    the time the dquot is flushed to the backing buffer. If we modify
    the dquot directly in the backing buffer, calculate the CRC
    immediately after the modification is complete. Hence the dquot in
    the on-disk buffer should always have a valid CRC.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr_leaf.c   |  2 +-
 fs/xfs/xfs_dquot.c       | 37 ++++++++++++++++---------------------
 fs/xfs/xfs_log_recover.c | 10 ++++++++++
 fs/xfs/xfs_qm.c          | 40 ++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_quota.h       |  2 ++
 5 files changed, 59 insertions(+), 32 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
