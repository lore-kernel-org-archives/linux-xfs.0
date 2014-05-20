Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-feature-bit-cleanup,
	created. xfs-for-linus-3.15-rc5-1271-gab3e57b
Message-Id: <20140520054053.DC0797F59@oss.sgi.com>
Date: Tue, 20 May 2014 00:40:53 -0500 (CDT)
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

The branch, xfs-feature-bit-cleanup has been created
        at  ab3e57b53f549ad51cbdf85e846ca4eaf0f3be30 (commit)

- Log -----------------------------------------------------------------
commit ab3e57b53f549ad51cbdf85e846ca4eaf0f3be30
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 07:47:05 2014 +1000

    xfs: remove shared supberlock feature checking
    
    We reject any filesystem that is mounted with this feature bit set,
    so we don't need to check for it anywhere else. Remove the function
    for checking if the feature bit is set and any code that uses it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5d074a4f8005b988c9d48d29250e36ad64083252
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 07:46:55 2014 +1000

    xfs: don't need dirv2 checks anymore
    
    If the the V2 directory feature bit is not set in the superblock
    feature mask the filesystem will fail the good version check.
    Hence we don't need any other version checking on the dir2 feature
    bit in the code as the filesystem will not mount without it set.
    Remove the checking code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 263997a6842b27a49f42bd795c5dd12242917b22
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 07:46:40 2014 +1000

    xfs: turn NLINK feature on by default
    
    mkfs has turned on the XFS_SB_VERSION_NLINKBIT feature bit by
    default since November 2007. It's about time we simply made the
    kernel code turn it on by default and so always convert v1 inodes to
    v2 inodes when reading them in from disk or allocating them. This
    This removes needless version checks and modification when bumping
    link counts on inodes, and will take code out of a few common code
    paths.
    
       text    data     bss     dec     hex filename
     783251  100867     616  884734   d7ffe fs/xfs/xfs.o.orig
     782664  100867     616  884147   d7db3 fs/xfs/xfs.o.patched
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 32bf1deae15b67839a2f0cb233254125be73fc78
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 07:41:43 2014 +1000

    xfs: keep sb_bad_features2 the same a sb_features2
    
    Whenever we update sb_features2, we need to update sb_bad_features2
    so that they remain identical on disk. This prevents future mounts
    or userspace utilities from getting confused over which features the
    filesystem supports.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit f68a373525d26d1cd7920f9d5dbf0d3aa1b9b889
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 07:41:16 2014 +1000

    xfs: make superblock version checks reflect reality
    
    We only support filesystems that have v2 directory support, and than
    means all the checking and handling of superblock versions prior to
    this support being added is completely unnecessary overhead.
    
    Strip out all the version 1-3 support, sanitise the good version
    checking to reflect the supported versions, update all the feature
    supported functions and clean up all the support bit definitions to
    reflect the fact that we no longer care about Irix bootloader flag
    regions for v4 feature bits. Also, convert the return values to
    boolean types and remove typedefs from function declarations to
    clean up calling conventions, too.
    
    Because the feature bit checking is all inline code, this relatively
    small cleanup has a noticable impact on code size:
    
       text    data     bss     dec     hex filename
     785195  100867     616  886678   d8796 fs/xfs/xfs.o.orig
     783595  100867     616  885078   d8156 fs/xfs/xfs.o.patched
    
    i.e. it reduces it by 1600 bytes.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
