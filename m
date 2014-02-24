Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-collapse-range,
	created. xfs-for-linus-v3.14-rc1-2-12922-ge1d8fb8
Message-Id: <20140224005334.12FC17F57@oss.sgi.com>
Date: Sun, 23 Feb 2014 18:53:31 -0600 (CST)
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

The branch, xfs-collapse-range has been created
        at  e1d8fb88a64c1f8094b9f6c3b6d2d9e6719c970d (commit)

- Log -----------------------------------------------------------------
commit e1d8fb88a64c1f8094b9f6c3b6d2d9e6719c970d
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Mon Feb 24 10:58:19 2014 +1100

    xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
    
    This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for XFS.
    
    The semantics of this flag are following:
    1) It collapses the range lying between offset and length by removing any data
       blocks which are present in this range and than updates all the logical
       offsets of extents beyond "offset + len" to nullify the hole created by
       removing blocks. In short, it does not leave a hole.
    2) It should be used exclusively. No other fallocate flag in combination.
    3) Offset and length supplied to fallocate should be fs block size aligned
       in case of xfs and ext4.
    4) Collaspe range does not work beyond i_size.
    
    Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
    Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 00f5e61998dd17f5375d9dfc01331f104b83f841
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Mon Feb 24 10:58:15 2014 +1100

    fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
    
    This patch is in response of the following post:
    http://lwn.net/Articles/556136/
    "ext4: introduce two new ioctls"
    
    Dave chinner suggested that truncate_block_range
    (which was one of the ioctls name) should be a fallocate operation
    and not any fs specific ioctl, hence we add this functionality to new flags of fallocate.
    
    This new functionality of collapsing range could be used by media editing tools
    which does non linear editing to quickly purge and edit parts of a media file.
    This will immensely improve the performance of these operations.
    The limitation of fs block size aligned offsets can be easily handled
    by media codecs which are encapsulated in a conatiner as they have to
    just change the offset to next keyframe value to match the proper alignment.
    
    Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
    Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
