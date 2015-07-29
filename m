Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BCD27FA8
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 06:54:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C59DDAC005
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 04:54:17 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	KtLHxQkpSpbtuUAN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 04:54:16 -0700 (PDT)
Received: by wibxm9 with SMTP id xm9so197575966wib.0
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 04:54:14 -0700 (PDT)
Date: Wed, 29 Jul 2015 13:54:12 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [regression 4.2-rc3] loop: xfstests xfs/073 deadlocked in low
	memory conditions
Message-ID: <20150729115411.GF15801@dhcp22.suse.cz>
References: <20150721015934.GY7943@dastard>
	<20150721085859.GG11967@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150721085859.GG11967@dhcp22.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On Tue 21-07-15 10:58:59, Michal Hocko wrote:
> [CCing more people from a potentially affected fs - the reference to the 
>  email thread is: http://marc.info/?l=linux-mm&m=143744398020147&w=2]
> 
> On Tue 21-07-15 11:59:34, Dave Chinner wrote:
> > Hi Ming,
> > 
> > With the recent merge of the loop device changes, I'm now seeing
> > XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
> > 
> > The deadlocked is as follows:
> > 
> > kloopd1: loop_queue_read_work
> > 	xfs_file_iter_read
> > 	lock XFS inode XFS_IOLOCK_SHARED (on image file)
> > 	page cache read (GFP_KERNEL)
> > 	radix tree alloc
> > 	memory reclaim
> > 	reclaim XFS inodes
> > 	log force to unpin inodes
> > 	<wait for log IO completion>
> > 
> > xfs-cil/loop1: <does log force IO work>
> > 	xlog_cil_push
> > 	xlog_write
> > 	<loop issuing log writes>
> > 		xlog_state_get_iclog_space()
> > 		<blocks due to all log buffers under write io>
> > 		<waits for IO completion>
> > 
> > kloopd1: loop_queue_write_work
> > 	xfs_file_write_iter
> > 	lock XFS inode XFS_IOLOCK_EXCL (on image file)
> > 	<wait for inode to be unlocked>
> > 
> > [The full stack traces are below].
> > 
> > i.e. the kloopd, with it's split read and write work queues, has
> > introduced a dependency through memory reclaim. i.e. that writes
> > need to be able to progress for reads make progress.
> > 
> > The problem, fundamentally, is that mpage_readpages() does a
> > GFP_KERNEL allocation, rather than paying attention to the inode's
> > mapping gfp mask, which is set to GFP_NOFS.
> > 
> > The didn't used to happen, because the loop device used to issue
> > reads through the splice path and that does:
> > 
> > 	error = add_to_page_cache_lru(page, mapping, index,
> > 			GFP_KERNEL & mapping_gfp_mask(mapping));
> > 
> > i.e. it pays attention to the allocation context placed on the
> > inode and so is doing GFP_NOFS allocations here and avoiding the
> > recursion problem.
> > 
> > [ CC'd Michal Hocko and the mm list because it's a clear exaple of
> > why ignoring the mapping gfp mask on any page cache allocation is
> > a landmine waiting to be tripped over. ]
> 
> Thank you for CCing me. I haven't noticed this one when checking for
> other similar hardcoded GFP_KERNEL users (6afdb859b710 ("mm: do not
> ignore mapping_gfp_mask in page cache allocation paths")). And there
> seem to be more of them now that I am looking closer.
> 
> I am not sure what to do about fs/nfs/dir.c:nfs_symlink which doesn't
> require GFP_NOFS or mapping gfp mask for other allocations in the same
> context.
> 
> What do you think about this preliminary (and untested) patch?

Dave, did you have chance to test the patch in your environment? Is the
patch good to go or we want a larger refactoring?

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
