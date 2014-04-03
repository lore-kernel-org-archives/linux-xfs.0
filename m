Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-bug-fixes-for-3.15-3,
	created. xfs-for-linus-v3.14-rc1-2-12927-gc88547a
Message-Id: <20140403211618.B49477FB3@oss.sgi.com>
Date: Thu,  3 Apr 2014 16:16:17 -0500 (CDT)
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

The branch, xfs-bug-fixes-for-3.15-3 has been created
        at  c88547a8119e3b581318ab65e9b72f27f23e641d (commit)

- Log -----------------------------------------------------------------
commit c88547a8119e3b581318ab65e9b72f27f23e641d
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Fri Apr 4 07:10:49 2014 +1100

    xfs: fix directory hash ordering bug
    
    Commit f5ea1100 ("xfs: add CRCs to dir2/da node blocks") introduced
    in 3.10 incorrectly converted the btree hash index array pointer in
    xfs_da3_fixhashpath(). It resulted in the the current hash always
    being compared against the first entry in the btree rather than the
    current block index into the btree block's hash entry array. As a
    result, it was comparing the wrong hashes, and so could misorder the
    entries in the btree.
    
    For most cases, this doesn't cause any problems as it requires hash
    collisions to expose the ordering problem. However, when there are
    hash collisions within a directory there is a very good probability
    that the entries will be ordered incorrectly and that actually
    matters when duplicate hashes are placed into or removed from the
    btree block hash entry array.
    
    This bug results in an on-disk directory corruption and that results
    in directory verifier functions throwing corruption warnings into
    the logs. While no data or directory entries are lost, access to
    them may be compromised, and attempts to remove entries from a
    directory that has suffered from this corruption may result in a
    filesystem shutdown.  xfs_repair will fix the directory hash
    ordering without data loss occuring.
    
    [dchinner: wrote useful a commit message]
    
    cc: <stable@vger.kernel.org>
    Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 805eeb8e04706a16cb0b23fd4c4abbb0bc7df82d
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Apr 4 06:56:30 2014 +1100

    xfs: extra semi-colon breaks a condition
    
    There were some extra semi-colons here which mean that we return true
    unintentionally.
    
    Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
