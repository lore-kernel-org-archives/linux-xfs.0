Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02E6D7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 21:09:14 -0500 (CDT)
Message-ID: <51D4D946.70409@sgi.com>
Date: Wed, 03 Jul 2013 21:09:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: optimise CIL insertion during transaction commit
	[RFC]
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1372657476-9241-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/01/13 00:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Note: This is an RFC right now - it'll need to be broken up into
> several patches for final submission.
>
> The CIL insertion during transaction commit currently does multiple
> passes across the transaction objects and requires multiple memory
> allocations per object that is to be inserted into the CIL. It is
> quite inefficient, and as such xfs_log_commit_cil() and it's
> children show up quite highly in profiles under metadata
> modification intensive workloads.
>
> The current insertion tries to minimise ithe number of times the
> xc_cil_lock is grabbed and the hold times via a couple of methods:
>
> 	1. an initial loop across the transaction items outside the
> 	lock to allocate log vectors, buffers and copy the data into
> 	them.
> 	2. a second pass across the log vectors that then inserts
> 	them into the CIL, modifies the CIL state and frees the old
> 	vectors.
>
> This is somewhat inefficient. While it minimises lock grabs, the
> hold time is still quite high because we are freeing objects with
> the spinlock held and so the hold times are much higher than they
> need to be.
>
> Optimisations that can be made:
>
> 	1. change IOP_SIZE() to return the size of the metadata to
> 	be logged with the number of vectors required. This means we
> 	can allocate the buffer to hold the metadata as part of the
> 	allocation for the log vector array. Once allocation instead
> 	of two.
>
> 	2. Store the size of the allocated region for the log vector
> 	in the log vector itself. This allows us to determine if we
> 	can just reuse the existing log vector for the new
> 	transactions. Avoids all memory allocation for that item.
>
> 	3. when setting up a new log vector, we don't need to
> 	hold the CIL lock while determining the difference in it's
> 	size when compared to the old one. Hence we can do all the
> 	accounting, swapping of the log vectors and freeing the old
> 	log vectors outside the xc_cil_lock.
>
> 	4. We can do all the CIL insertation of items and busy
> 	extents and the accounting under a single grab of the
> 	xc_cil_lock. This minimises the number of times we need to
> 	grab it and hence contention points are kept to a minimum
>
> 	5. the xc_cil_lock is used for serialising both the CIL and
> 	the push/commit ordering. Separate the two functions into
> 	different locks so push/commit ordering does not affect CIL
> 	insertion
>
> 	6. the xc_cil_lock shares cachelines with other locks.
> 	Separate them onto different cachelines.
>
> The result is that my standard fsmark benchmark (8-way, 50m files)
> on my standard test VM (8-way, 4GB RAM, 4xSSD in RAID0, 100TB fs)
> gives the following results with a xfs-oss tree. No CRCs:
>
>                  vanilla         patched         Difference
> create  (time)  483s            435s            -10.0%  (faster)
>          (rate)  109k+/6k        122k+/-7k       +11.9%  (faster)
>
> walk            339s            335s            (noise)
>       (sys cpu)  1134s           1135s           (noise)
>
> unlink          692s            645s             -6.8%  (faster)
>
> So it's significantly faster than the current code, and lock_stat
> reports lower contention on the xc_cil_lock, too. So, big win here.
>
> With CRCs:
>
>                  vanilla         patched         Difference
> create  (time)  510s            460s             -9.8%  (faster)
>          (rate)  105k+/5.4k      117k+/-5k       +11.4%  (faster)
>
> walk            494s            486s            (noise)
>       (sys cpu)  1324s           1290s           (noise)
>
> unlink          959s            889s             -7.3%  (faster)
>
> Gains are of the same order, with walk and unlink still affected by
> VFS LRU lock contention. IOWs, with this changes, filesystems with
> CRCs enabled will still be faster than the old non-CRC kernels...
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Dave,

The idea to separate the transaction commits from the CIL push looks good.

I am still concerned that the xc_ctx->space_used comparison to
XLOG_CIL_SPACE_LIMIT(log) does not also contain any information on
the "stolen" ticket log space. Maybe the future Liu/Chinner minimum
log space series is the best place to address this and my other log
space concerns.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
