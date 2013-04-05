Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 360CE29E10
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 08:41:28 -0500 (CDT)
Message-ID: <515ED49E.6020406@sgi.com>
Date: Fri, 5 Apr 2013 08:41:50 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] xfstests: random regression tests
References: <1364813864-10820-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1364813864-10820-1-git-send-email-eguan@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

Thanks for submitting this patchset, it has been committed.

--Rich

commit 797c82f0e22528df369cf198c2a9d6109e085838
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:57:44 2013 +0000

     xfstests generic 309: test dir mtime and ctime are updated on rename

     Test directory mtime and ctime are updated when moving a file onto an
     existing file in the directory

     Regression test for commit:
     0b23076 ext3: fix update of mtime and ctime on rename

     Signed-off-by: Eryu Guan <eguan@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com renumbered test to next in group sequence]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit f7922730727844c6dee837bd1a64221342fef1d1
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:57:43 2013 +0000

     xfstests ext4 305: test read /proc/fs/ext4/<dev>/mb_groups while 
the fs is being unmounted

     Regression test for commit:
     9559996 ext4: remove mb_groups before tearing down the buddy_cache

     Signed-off-by: Eryu Guan <eguan@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com renumbered test to next in group sequence]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit 94e1e7e53a89d9a3387bee7dea60091afaf79704
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:57:42 2013 +0000

     xfstests generic 308: test write to the last block of max file size 
on ext4

     On unpatched ext4 if an extent exists which includes the block right
     before the maximum file offset, and the block for the maximum file
     offset is written, the kernel panics.

     On patched ext4, the write would get EFBIG since we lower s_maxbytes
     by one fs block.

     Regression test for commit:
     f17722f ext4: Fix max file size and logical block counting of 
extent format file

     Though it's an ext4 specific issue, it's no harm to run on all file
     systems, so put it in generic.
     Signed-off-by: Eryu Guan <eguan@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com renumbered test to next in group sequence]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit 6422b818388c652183b6b517be1feac554f5f004
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:57:41 2013 +0000

     xfstests generic 307: check ctime updates for setfacl

     Check if ctime is updated and written to disk after setfacl

     Regression test for the following extN commits
     c6ac12a ext4: update ctime when changing the file's permission by 
setfacl
     30e2bab ext3: update ctime when changing the file's permission by 
setfacl
     523825b ext2: update ctime when changing the file's permission by 
setfacl

     Signed-off-by: Eryu Guan <eguan@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com renumbered test to next in group sequence]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
