Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E64339B56
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 23:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926461; cv=none; b=mEPZ9D/gaevSHwHJAhHPQ6g4+wYJ1oXmWEV+1OVKXqDcEjYsvnEdCPOp2ncNrMr+0ug3brRMNEQ5guSnmfBSakXxat1ntv618VLLkL3IYM9du1ZKbFaWRgOvXL7JMIDVwoYCKP+L4tYDx0ZxxpiO91kaI9rElNKsaeYDtRaICbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926461; c=relaxed/simple;
	bh=wxrlwtG2l3f6jiSsDg/DoD0JKkFBFuOgz5hJKHVltxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dg/4QFyNmaYmtGdxrjEtZxu0EDhG8lEEdXykuJoqsYv4YZvYu28EsoqRxZ/FupnBUdpflrzWEgQQ/uzSxASDsbkxBqMDRMl9MlopvK1CRSAdoZ00Dq+UbWdtC+P4zmZ66Hux2vKpoZy8bvuYIQ+PFKvBSCslqfeETjP7bIVVnj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9UA8pn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9UA8pn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F63C4CEF1;
	Tue, 16 Dec 2025 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926461;
	bh=wxrlwtG2l3f6jiSsDg/DoD0JKkFBFuOgz5hJKHVltxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9UA8pn1+KVr4uuDOJrYl80xcN9GmK4Z8DXhzKjSmTjjLdttfB90xSrFaZUL2ElRz
	 iBaDFFC/XaHjW3QMdBcXxx5We+XcvMrCT+Q7d9CBsBXdheXLJt/8LTrHX+7b3tcTAJ
	 +QopKTl9cykQl1F9Ongb6ng0a/YrKvpkhLyO89rM9hMt/WAgrBkVQ7qno736ouoA1D
	 7NU+yjsF19j4M5wf7AdKAY+JOo7x+1sD/+5TjcixN/GhsC9HTnPhcgSGy44qW76TG3
	 ytcga8z+3DZQ/c6vWZloEEzUGoYGaYf8dszLR9bqsdFZfKZy2iGpLCFE57flhuS/to
	 XnDhp1q4Wu3Pg==
Date: Tue, 16 Dec 2025 15:07:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: enable new features by default
Message-ID: <20251216230740.GR7725@frogsfrogsfrogs>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676146.3974899.6119777261763784206.stgit@frogsfrogsfrogs>
 <aTih1FDXt8fMrIb4@dread.disaster.area>
 <20251210234928.GE7725@frogsfrogsfrogs>
 <aUCg7pMw7llKBYJj@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUCg7pMw7llKBYJj@dread.disaster.area>

On Tue, Dec 16, 2025 at 10:59:42AM +1100, Dave Chinner wrote:
> On Wed, Dec 10, 2025 at 03:49:28PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 10, 2025 at 09:25:24AM +1100, Dave Chinner wrote:
> > > On Tue, Dec 09, 2025 at 08:16:08AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Since the LTS is coming up, enable parent pointers and exchange-range by
> > > > default for all users.  Also fix up an out of date comment.
> > > > 
> > > > I created a really stupid benchmarking script that does:
> > > > 
> > > > #!/bin/bash
> > > > 
> > > > # pptr overhead benchmark
> > > > 
> > > > umount /opt /mnt
> > > > rmmod xfs
> > > > for i in 1 0; do
> > > > 	umount /opt
> > > > 	mkfs.xfs -f /dev/sdb -n parent=$i | grep -i parent=
> > > > 	mount /dev/sdb /opt
> > > > 	mkdir -p /opt/foo
> > > > 	for ((i=0;i<5;i++)); do
> > > > 		time fsstress -n 100000 -p 4 -z -f creat=1 -d /opt/foo -s 1
> > > > 	done
> > > > done
> > > 
> > > Hmmm. fsstress is an interesting choice here...
> > 
> > <flush all the old benchmarks and conclusions>
> > 
> > I have an old 40-core Xeon E5-2660V3 with a pair of 1.5T Intel nvme ssds
> > and 128G of RAM running 6.18.0.  For this sample, I tried to keep the
> > memory usage well below the amount of DRAM so that I could measure the
> > pure overhead of writing parent pointers out to disk and not anything
> > else.  I also omit ls'ing and chmod'ing the directory tree because
> > neither of those operations touch parent pointers.  I also left the
> > logbsize at the defaults (32k) because that's what most users get.
> 
> ok.
> 
> .....
> 
> > benchme() {
> >         agcount="$(xfs_info /nvme/ | grep agcount= | sed -e 's/^.*agcount=//g' -e 's/,.*$//g')"
> >         dirs=()
> >         mkdirme
> > 
> >         #time ~djwong/cdev/work/fstests/build-x86_64/ltp/fsstress -n 400000 -p 40 -z -f creat=1,mkdir=1,rmdir=1,unlink=1 -d /nvme/ -s 1
> >         time fs_mark -w "${writesz}" -D "${subdirs}" -S 0 -n "${files_per_iter}" -s "${filesz}" -L "${iter}" "${dirs[@]}"
> > 
> >         time bulkme
> >         time rmdirme
> 
> Ok, so this is testing cache-hot bulkstat and rm, so it's not
> exercising the cold-read path and hence is not needing to read and
> initialising parent pointers for unlinking. Can you drop caches
> between the bulkstat and the unlink phases so we exercise cold cache
> parent pointer instantiation overhead somewhere?
> 
> > }
> > 
> > for p in 0 1; do
> >         umount /dev/nvme1n1 /nvme /mnt
> >         #mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 -n parent=$p || break
> >         mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1 $feature=$p || break
> >         mount /dev/nvme1n1 /nvme/ -o logdev=/dev/nvme0n1 || break
> >         benchme
> >         umount /dev/nvme1n1 /nvme /mnt
> > done
> > 
> > I get this mkfs output:
> > # mkfs.xfs -f -l logdev=/dev/nvme0n1,size=1g /dev/nvme1n1
> > meta-data=/dev/nvme1n1           isize=512    agcount=40, agsize=9767586 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> >          =                       exchange=0   metadir=0
> > data     =                       bsize=4096   blocks=390703440, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> > log      =/dev/nvme0n1           bsize=4096   blocks=262144, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >          =                       rgcount=0    rgsize=0 extents
> >          =                       zoned=0      start=0 reserved=0
> > # grep nvme1n1 /proc/mounts
> > /dev/nvme1n1 /nvme xfs rw,relatime,inode64,logbufs=8,logbsize=32k,logdev=/dev/nvme0n1,noquota 0 0
> > 
> > and this output from fsmark with parent=0:
> 
> ....
> 
> a table-based summary would have made this easier to read
> 
> 	parent		real		user		sys
> create	0		0m57.573s	3m53.578s	19m44.440s
> create	1		1m2.934s	3m53.508s	25m14.810s
> 
> bulk	0		0m1.122s	0m0.955s	0m39.306s
> bulk	1		0m1.158s	0m0.882s	0m39.847s
> 
> unlink	0		0m59.649s	0m41.196s	13m9.566s
> unlink	1		1m12.505s	0m47.489s	20m33.844s
> 
> > fs_mark itself shows a decrease in file creation/sec of about 9%, an
> > increase in wall clock time of about 9%, and an increase in kernel time
> > of about 28%.  That's to be expected, since parent pointer updates cause
> > directory entry creation and deletion to hold more ILOCKs and for
> > longer.
> 
> ILOCK isn't an issue with this test - the whole point of the
> segmented directory structure is that each thread operates in it's
> own directory, so there is no ILOCK contention at all. i.e. the
> entire difference is the CPU overhead of the adding the xattr fork
> and creating the parent pointer xattr.
> 
> I suspect that the create side overhead is probably acceptible,
> because we also typically add security xattrs at create time and
> these will be slightly faster as the xattr fork is already
> prepared...
> 
> > Parallel bulkstat (aka bulkme) shows an increase in wall time of 3% and
> > system time of 1%, which is not surprising since that's just walking the
> > inode btree and cores, no parent pointers involved.
> 
> I was more interested in the cold cache behaviour - hot cache is
> generally uninteresting as the XFS inode cache scales pretty much
> perfectly in this case. Reading the inodes from disk, OTOH, adds a
> whole heap of instantiation and lock contention overhead and changes
> the picture significantly. I'm interested to know what the impact of
> having PPs is in that case....
> 
> > Similarly, deleting all the files created by fs_mark shows an increase
> > in wall time of about ~21% and an increase in system time of about 56%.
> > I concede that parent pointers has a fair amount of overhead for the
> > worst case of creating a large directory tree or deleting it.
> 
> Ok, so an increase in unlink CPU overhead of 56% is pretty bad. On
> single threaded workloads, that's going to equate to be a ~50%
> reduction in performance for operations that perform unlinks in CPU
> bound loops (e.g. rm -rf on hot caches). Note that the above test is
> not CPU bound - it's only running at about 50% CPU utilisation
> because of some other contention point in the fs (possibly log space
> or pinned/stale directory buffers requiring a log force to clear).
> 
> However, results like this make me think that PP unlink hasn't been
> optimised for the common case: removing the last parent pointer
> (i.e. nlink 1 -> 0) when the inode is being placed on the unlinked
> list in syscall context. This is the common case in the absence of
> hard links, and it puts the PP xattr removal directly in application
> task context.
> 
> In this case, it seems to me that we don't actually need
> to remove the parent pointer xattr. When the inode is inactivated by
> bakground inodegc after last close, the xattr fork is truncated and
> that will remove all xattrs including the stale remaining PP without
> needing to make a specific PP transaction.
> 
> Doing this would remove the PP overhead completely from the final
> unlink syscall path. It would only add  minimal extra overhead on
> the inodegc side as (in the common case) we have to remove security
> xattrs in inodegc. 

At some point hch suggested that the parent pointer code could shortcut
the entire xattr intent machinery if the child file has shortform
xattrs.  For this fsmark benchmark where we're creating a lot of empty
files, doing so actually /does/ cut the creation overhead from ~30% to
~3%; and the deletion overhead to nearly zero.

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 589f810eedc0d8..c59e5ef47ed95d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -49,6 +49,7 @@ void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
+int	xfs_attr_try_sf_addname(struct xfs_inode *dp, struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
 struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d489c..89cc913a2b4345 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -349,7 +349,7 @@ xfs_attr_set_resv(
  * xfs_attr_shortform_addname() will convert to leaf format and return -ENOSPC.
  * to use.
  */
-STATIC int
+int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
 	struct xfs_da_args	*args)
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 69366c44a70159..048f822951103c 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -29,6 +29,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_attr_item.h"
 #include "xfs_health.h"
+#include "xfs_attr_leaf.h"
 
 struct kmem_cache		*xfs_parent_args_cache;
 
@@ -202,6 +203,16 @@ xfs_parent_addname(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	if (xfs_inode_has_attr_fork(child) &&
+	    xfs_attr_is_shortform(child)) {
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
+
+		error = xfs_attr_try_sf_addname(child, &ppargs->args);
+		if (error != -ENOSPC)
+			return error;
+	}
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
@@ -224,6 +235,10 @@ xfs_parent_removename(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	if (xfs_attr_is_shortform(child))
+		return xfs_attr_sf_removename(&ppargs->args);
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
 	return 0;
 }
@@ -250,6 +265,27 @@ xfs_parent_replacename(
 			child->i_ino, old_name);
 
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
+
+	if (xfs_attr_is_shortform(child)) {
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
+
+		error = xfs_attr_sf_removename(&ppargs->args);
+		if (error)
+			return error;
+
+		xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->new_rec,
+				child, child->i_ino, new_name);
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
+
+		error = xfs_attr_try_sf_addname(child, &ppargs->args);
+		if (error == -ENOSPC) {
+			xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
+			return 0;
+		}
+
+		return error;
+	}
+
 	ppargs->args.new_name = new_name->name;
 	ppargs->args.new_namelen = new_name->len;
 	ppargs->args.new_value = &ppargs->new_rec;

> Hence I think we really need to try to mitigate this common case
> overhead before we make PP the default for everyone. The perf
> decrease
> 
> 
> > If I then re-run the benchmark with a file size of 1M and tell it to
> > create fewer files, then I get the following for parent=0:
> 
> These are largely meaningless as the create benchmark is throttling
> hard on disk bandwidth (1.5-2GB/s) in the write() path, not limited
> by PP overhead.
> 
> The variance in runtime comes from the data IO path behaviour, and
> the lack of sync() operations after the create means that writeback
> is likely still running when the unlink phase runs. Hence it's
> pretty difficult to conclude anything about parent pointers
> themselves because of the other large variants in this workload.

They're not meaningless numbers, Dave.  Writing data into user files is
always going take up a large portion of the time spent creating a real
dreictory tree.  Anyone unpacking a tarball onto a filesystem can run
into disk throttling on write bandwidth, which just reduces the relative
overhead of the pptr updates further.

The only times it becomes painful is in this microbenchmarking case
where someone is trying to create millions of empty files; and when
deleting a directory tree.

Anyway, we now have a patch, and I'll rerun the benchmark if this
survives overnight testing.

--D

> > I then decided to simulate my maildir spool, which has 670,000 files
> > consuming 12GB for an average file size of 17936 bytes.  I reduced the
> > file size to 16K, increase the number of files per iteration, and set
> > the write buffer size to something not aligned to a block, and got this
> > for parent=0:
> 
> Same again, but this time the writeback thread will be seeing
> delalloc latencies w.r.t. AGF locks vs incoming directory and inode
> chunk allocation operations. That can be seen by:
> 
> > 
> > #  fs_mark  -w  778  -D  1000  -S  0  -n  6000  -s  16384  -L  8  -d  /nvme/0  -d  /nvme/1  -d  /nvme/2  -d  /nvme/3  -d  /nvme/4  -d  /nvme/5  -d  /nvme/6  -d  /nvme/7  -d  /nvme/8  -d  /nvme/9  -d  /nvme/10  -d  /nvme/11  -d  /nvme/12  -d  /nvme/13  -d  /nvme/14  -d  /nvme/15  -d  /nvme/16  -d  /nvme/17  -d  /nvme/18  -d  /nvme/19  -d  /nvme/20  -d  /nvme/21  -d  /nvme/22  -d  /nvme/23  -d  /nvme/24  -d  /nvme/25  -d  /nvme/26  -d  /nvme/27  -d  /nvme/28  -d  /nvme/29  -d  /nvme/30  -d  /nvme/31  -d  /nvme/32  -d  /nvme/33  -d  /nvme/34  -d  /nvme/35  -d  /nvme/36  -d  /nvme/37  -d  /nvme/38  -d  /nvme/39 
> > #       Version 3.3, 40 thread(s) starting at Wed Dec 10 15:21:38 2025
> > #       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
> > #       Directories:  Time based hash between directories across 1000 subdirectories with 180 seconds per subdirectory.
> > #       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
> > #       Files info: size 16384 bytes, written with an IO size of 778 bytes per write
> > #       App overhead is time in microseconds spent in the test not doing file writing related system calls.
> > 
> > FSUse%        Count         Size    Files/sec     App Overhead
> >      2       240000        16384      40085.3          2492281
> >      2       480000        16384      37026.7          2780077
> >      2       720000        16384      28445.5          2591461
> >      3       960000        16384      28888.6          2595817
> >      3      1200000        16384      25160.8          2903882
> >      3      1440000        16384      29372.1          2600018
> >      3      1680000        16384      26443.9          2732790
> >      4      1920000        16384      26307.1          2758750
> > 
> > real    1m11.633s
> > user    0m46.156s
> > sys     3m24.543s
> 
> .. creates only managing ~270% CPU utilisation for a 40-way
> operation.
> 
> IOWs, parent pointer overhead is noise compared to the losses caused
> by data writeback locking/throttling interactions, so nothing can
> really be concluded from there here.
> 
> > Conclusion: There are noticeable overheads to enabling parent pointers,
> > but counterbalancing that, we can now repair an entire filesystem,
> > directory tree and all.
> 
> True, but I think that the unlink overhead is significant enough
> that we need to address that before enabling PP by default for
> everyone.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
