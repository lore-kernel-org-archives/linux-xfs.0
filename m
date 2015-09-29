Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BAD687F37
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 17:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB8AA8F8059
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 15:02:50 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	S4RfU4CJJkFHA6Ro (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2015 15:02:48 -0700 (PDT)
Date: Tue, 29 Sep 2015 15:02:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm, fs: Obey gfp_mapping for add_to_page_cache
Message-Id: <20150929150246.286cc6013bce3eec170376aa@linux-foundation.org>
In-Reply-To: <1443193461-31402-1-git-send-email-mhocko@kernel.org>
References: <1443193461-31402-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
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
To: mhocko@kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <andreas.dilger@intel.com>, Christoph Hellwig <hch@lst.de>

On Fri, 25 Sep 2015 17:04:21 +0200 mhocko@kernel.org wrote:

> From: Michal Hocko <mhocko@suse.com>
> 
> 6afdb859b710 ("mm: do not ignore mapping_gfp_mask in page cache
> allocation paths) has caught some users of hardcoded GFP_KERNEL
> used in the page cache allocation paths. This, however, wasn't complete
> and there were others which went unnoticed.
> 
> Dave Chinner has reported the following deadlock for xfs on loop device:
> : With the recent merge of the loop device changes, I'm now seeing
> : XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
> :
> : The deadlocked is as follows:
> :
> : kloopd1: loop_queue_read_work
> :       xfs_file_iter_read
> :       lock XFS inode XFS_IOLOCK_SHARED (on image file)
> :       page cache read (GFP_KERNEL)
> :       radix tree alloc
> :       memory reclaim
> :       reclaim XFS inodes
> :       log force to unpin inodes
> :       <wait for log IO completion>
> :
> : xfs-cil/loop1: <does log force IO work>
> :       xlog_cil_push
> :       xlog_write
> :       <loop issuing log writes>
> :               xlog_state_get_iclog_space()
> :               <blocks due to all log buffers under write io>
> :               <waits for IO completion>
> :
> : kloopd1: loop_queue_write_work
> :       xfs_file_write_iter
> :       lock XFS inode XFS_IOLOCK_EXCL (on image file)
> :       <wait for inode to be unlocked>
> :
> : i.e. the kloopd, with it's split read and write work queues, has
> : introduced a dependency through memory reclaim. i.e. that writes
> : need to be able to progress for reads make progress.
> :
> : The problem, fundamentally, is that mpage_readpages() does a
> : GFP_KERNEL allocation, rather than paying attention to the inode's
> : mapping gfp mask, which is set to GFP_NOFS.
> :
> : The didn't used to happen, because the loop device used to issue
> : reads through the splice path and that does:
> :
> :       error = add_to_page_cache_lru(page, mapping, index,
> :                       GFP_KERNEL & mapping_gfp_mask(mapping));
> 
> This has changed by aa4d86163e4 (block: loop: switch to VFS ITER_BVEC).

xfs-on-loop deadlocks since April would appear to warrant a -stable
backport, yes?

> this is a rebase on top of the current mmotm
> (2015-09-22-15-28)

So I've redone the patch against current mainline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
