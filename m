Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.15-rc6,
	created. xfs-for-linus-3.15-rc5-1275-gee4eec4
Message-Id: <20140514234848.F37027F47@oss.sgi.com>
Date: Wed, 14 May 2014 18:48:48 -0500 (CDT)
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

The branch, xfs-fixes-for-3.15-rc6 has been created
        at  ee4eec478be4677b93775d17bc079efb5922b276 (commit)

- Log -----------------------------------------------------------------
commit ee4eec478be4677b93775d17bc079efb5922b276
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:23:24 2014 +1000

    xfs: list_lru_init returns a negative error
    
    And we don't invert it properly when initialising the dquot lru
    list.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bc147822d5ada188fff792691efffe89589e2e19
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:23:07 2014 +1000

    xfs: negate xfs_icsb_init_counters error value
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 45687642e43d5a3b700d6c1df0e07b3976c90c08
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:22:53 2014 +1000

    xfs: negate mount workqueue init error value
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6670232b48848e5ad949dbd4866850aec7035f32
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:22:37 2014 +1000

    xfs: fix wrong err sign on xfs_set_acl()
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a5a14de22e8afd771775c7106b3b081c23bac783
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:22:21 2014 +1000

    xfs: fix wrong errno from xfs_initxattrs
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 65149e3fab7f053396d09a429085f3071fa50825
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:22:07 2014 +1000

    xfs: correct error sign on COLLAPSE_RANGE errors
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b38a134b22fbd0bed90f3e079bbf8cb2962a52be
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:21:52 2014 +1000

    xfs: xfs_commit_metadata returns wrong errno
    
    Invert it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8ff1e6705a4c711247708f23881feea169e6fc3c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:21:37 2014 +1000

    xfs: fix incorrect error sign in xfs_file_aio_read
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 43ec1460a2189fbee87980dd3d3e64cba2f11e1f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 15 09:21:11 2014 +1000

    xfs: xfs_dir_fsync() returns positive errno
    
    And it should be negative.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
