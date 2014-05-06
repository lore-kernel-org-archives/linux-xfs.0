Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-in-kernel-RFC,
	created. xfs-for-linus-3.15-rc2-52-g6579dd8
Message-Id: <20140506071855.F152E7FBC@oss.sgi.com>
Date: Tue,  6 May 2014 02:18:55 -0500 (CDT)
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

The branch, xfs-libxfs-in-kernel-RFC has been created
        at  6579dd808ddf0ddc10e59e715dc8f2eb09705203 (commit)

- Log -----------------------------------------------------------------
commit 6579dd808ddf0ddc10e59e715dc8f2eb09705203
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 6 17:13:06 2014 +1000

    libxfs: provide extern include file
    
    There will be different include files for userspace and
    kernel versions of the library as userspace needs to stub out or
    provide it's own versions of kernel only functionality. The header
    file that external libxfs users will need to include is libxfs.h,
    and there will be different implementations for both user and kernel
    space.
    
    All external users of libxfs will include this header file, thereby
    eliminating the need for direct knowledge of the internal dependency
    structure of the libxfs code. This significantly reduces the
    complexity of including libxfs functioanlity into the kernel code,
    and brings it in line with the way libxfs is used in userspace.
    
    This also allows us to untangle some of the mess with kernel only
    header files including shared header files directly, but does come
    with one piece of baggage - the dependency that libxfs has on the
    kernel xfs_mount.h. We'll deal with that at a later time, though.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 5e51adf5d9bba8f91fb5a99551878781bcc392f9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 6 16:23:33 2014 +1000

    libxfs: consolidate internal include files
    
    There will be different include files for userspace and
    kernel versions of the library as userspace needs to stub out or
    provide it's own versions of kernel only functionality, convert all
    the internal libxfs source code to use the same single header file
    infrastructure that userspace currently contains. This means all the
    C source files will be identical, and only the header file will need
    to change. Call this internal consolidated header file libxfs_int.h
    to discriminate it from any other kernel or userspace header file.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 612480ce6bf4f96535f766eb27eb1b360a5a0714
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue May 6 14:55:30 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/include. This is done as one big chunk simpy to get it done
    quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 22b8ea8e926ea378a1066174a02147b90caebc12
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 6 14:54:32 2014 +1000

    libxfs: move header files
    
    Move all the header files that are shared with userspace into
    libxfs/include. This is done as one big chunk simpy to get it done
    quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 20c53cba45be9da5a49a19042ec151abbf4b365e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 6 14:54:24 2014 +1000

    xfs: create libxfs infrastructure
    
    TO minimise the differences between kernel and userspace code,
    split the kernel code into the same structure as the userspace code.
    That is, the gneric core functionality of XFS is moved to a libxfs/
    directory and treat it as a layering barrier in the XFS code.
    
    This patch introduces the libxfs and libxfs/include directories,
    the build infrastructure and an initial source and header file to
    build. The libxfs/include directory will contain the header files
    that are needed to build libxfs - most of userspace does not care
    about the location of these header files as they are accessed
    indirectly. Hence keeping them inside libxfs makes it easy to track
    the changes and script the sync process as the directory structure
    will be identical.
    
    TO allow this changeover to occur in the kernel code, there are some
    temporary infrastructure in the makefiles to grab the header
    filesystem from both locations. Once all the files are moved,
    modifications will be made in the source code that will make the
    need for these include directives go away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
