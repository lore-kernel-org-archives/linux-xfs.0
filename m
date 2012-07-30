Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UFnAIX057019 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 10:49:11 -0500
Date: Mon, 30 Jul 2012 11:39:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Message-ID: <20120730153935.GE4547@phenom.dumpdata.com>
References: <201207301514247032532@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201207301514247032532@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, ocfs2-devel <ocfs2-devel@oss.oracle.com>, mfasheh <mfasheh@suse.com>, linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@ZenIV.linux.org.uk>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, jlbec <jlbec@evilplan.org>

On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,

What about submit_bio? That sets the bi_rw as well?
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().

function.
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> if ((bvm->bi_rw & 1) == WRITE)
> >> return biovec->bv_len; /* always allow writes to be mergeable */

So what does that mean? Without this patch what happens?

> 
> 
> Jianpeng Ma (8):

Can you collapse all of this in just one patch?

>   Evalue bio->bi_rw after calling bio_alloc() and before calling

It is 'evaluate'
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
> 
>  block/blk-lib.c                     |    1 +
>  drivers/block/xen-blkback/blkback.c |    1 +

I am not really sure if that is correct. Does 'submit_bio' not do the
job properly?

>  fs/btrfs/check-integrity.c          |    1 +
>  fs/direct-io.c                      |    1 +
>  fs/ext4/page-io.c                   |    1 +
>  fs/jfs/jfs_metapage.c               |    1 +
>  fs/ocfs2/cluster/heartbeat.c        |    8 +++++---
>  fs/xfs/xfs_aops.c                   |    2 ++
>  fs/xfs/xfs_buf.c                    |    1 +
>  9 files changed, 14 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
