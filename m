Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-6-gb0a9dab
Message-Id: <20130709215245.A4D0629E1E@oss.sgi.com>
Date: Tue,  9 Jul 2013 16:52:45 -0500 (CDT)
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
  b0a9dab xfs: dquot log reservations are too small
  f3508bc xfs: remove local fork format handling from xfs_bmapi_write()
      from  862a62937e76a91da218c1ee4dceb7b0700fed67 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit b0a9dab78aee2a479d7c226e6939d553967e4024
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jul 10 07:04:01 2013 +1000

    xfs: dquot log reservations are too small
    
    During review of the separate project quota inode patches, it became
    obvious that the dquot log reservation calculation underestimated
    the number dquots that can be modified in a transaction. This has
    it's roots way back in the Irix quota implementation.
    
    That is, when quotas were first implemented in XFS, it only
    supported user and project quotas as Irix did not have group quotas.
    Hence the worst case operation involving dquot modification was
    calculated to involve 2 user dquots and 1 project dquot or 1 user
    dequot and 2 project dquots. i.e. 3 dquots. This was determined back
    in 1996, and has remained unchanged ever since.
    
    However, back in 2001, the Linux XFS port dropped all support for
    project quota and implmented group quotas over the top. This was
    effectively done with a search-and-replace of project with group,
    and as such the log reservation was not changed. However, with the
    advent of group quotas, chmod and rename now could modify more than
    3 dquots in a single transaction - both could modify 4 dquots. Hence
    this log reservation has been wrong for a long time.
    
    In 2005, project quota support was reintroduced into Linux, but it
    was implemented to be mutually exclusive to group quotas and so this
    didn't add any new changes to the dquot log reservation. Hence when
    project quotas were in use (rather than group quotas) the log
    reservation was again valid, just like in the Irix days.
    
    Now, with the addition of the separate project quota inode, group
    and project quotas are no longer mutually exclusive, and hence
    operations can now modify three dquots per inode where previously it
    was only two. The worst case here is the rename transaction, which
    can allocate/free space on two different directory inodes, and if
    they have different uid/gid/prid configurations and are world
    writeable, then rename can actually modify 6 different dquots now.
    
    Further, the dquot log reservation doesn't take into account the
    space used by the dquot log format structure that precedes the dquot
    that is logged, and hence further underestimates the worst case
    log space required by dquots during a transaction. This has been
    missing since the first commit in 1996.
    
    Hence the worst case log reservation needs to be increased from 3 to
    6, and it needs to take into account a log format header for each of
    those dquots.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f3508bcddf8fae6ebd21000d708cf09e7e77a963
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jul 10 07:04:00 2013 +1000

    xfs: remove local fork format handling from xfs_bmapi_write()
    
    The conversion from local format to extent format requires
    interpretation of the data in the fork being converted, so it cannot
    be done in a generic way. It is up to the caller to convert the fork
    format to extent format before calling into xfs_bmapi_write() so
    format conversion can be done correctly.
    
    The code in xfs_bmapi_write() to convert the format is used
    implicitly by the attribute and directory code, but they
    specifically zero the fork size so that the conversion does not do
    any allocation or manipulation. Move this conversion into the
    shortform to leaf functions for the dir/attr code so the conversions
    are explicitly controlled by all callers.
    
    Now we can remove the conversion code in xfs_bmapi_write.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr_leaf.c   |   2 +
 fs/xfs/xfs_bmap.c        | 199 ++++++++++++++++++++---------------------------
 fs/xfs/xfs_bmap.h        |   1 +
 fs/xfs/xfs_dir2_block.c  |  20 +++--
 fs/xfs/xfs_quota.h       |  25 +++++-
 fs/xfs/xfs_trans_dquot.c |   9 +--
 6 files changed, 123 insertions(+), 133 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
