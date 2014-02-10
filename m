Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.14-rc3,
	created. xfs-for-linus-v3.14-rc1-2-12922-g3895e51
Message-Id: <20140210031650.C4D1A7F4E@oss.sgi.com>
Date: Sun,  9 Feb 2014 21:16:48 -0600 (CST)
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

The branch, xfs-fixes-for-3.14-rc3 has been created
        at  3895e51f6dbf6610519be070a3bede811f6ac4fb (commit)

- Log -----------------------------------------------------------------
commit 3895e51f6dbf6610519be070a3bede811f6ac4fb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Feb 10 10:37:18 2014 +1100

    xfs: ensure correct log item buffer alignment
    
    On 32 bit platforms, the log item vector headers are not 64 bit
    aligned or sized. hence if we don't take care to align them
    correctly or pad the buffer appropriately for 8 byte alignment, we
    can end up with alignment issues when accessing the user buffer
    directly as a structure.
    
    To solve this, simply pad the buffer headers to 64 bit offset so
    that the data section is always 8 byte aligned.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Tested-by: Michael L. Semon <mlsemon35@gmail.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit fe60a8a0919eeee862054137fed49f00b710d9cd
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Feb 10 10:35:22 2014 +1100

    xfs: ensure correct timestamp updates from truncate
    
    The VFS doesn't set the proper ATTR_CTIME and ATTR_MTIME values for
    truncate, so filesystems have to manually add them.  The
    introduction of xfs_setattr_time accidentally broke this special
    case an caused a regression in generic/313.  Fix this by removing
    the local mask variable in xfs_setattr_size so that we only have a
    single place to keep the attribute information.
    
    cc: <stable@vger.kernel.org>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
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
