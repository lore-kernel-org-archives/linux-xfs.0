Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KKPmHN081684 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:25:48 -0500
Subject: Re: xfs_repair segfaut in stage 6
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110914153852.GA11050@infradead.org>
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl> <20110912161215.GA17798@infradead.org>
	<4E707624.9030703@nasza-klasa.pl>
	<20110914142430.GA28049@infradead.org>
	<4E70C15C.3030502@nasza-klasa.pl>
	<20110914153852.GA11050@infradead.org>
Date: Tue, 20 Sep 2011 15:25:41 -0500
Message-ID: <1316550341.2912.54.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Wed, 2011-09-14 at 11:38 -0400, Christoph Hellwig wrote:
> On Wed, Sep 14, 2011 at 04:59:40PM +0200, Bartosz Cisek wrote:
> > Stack trace is pasted in bug issue [1] that is linked in first mail ;)
> > Compiled by hand from git: "DEBUG=-DDEBUG make". I don't know why some
> > of values are 'optimized out'.
> > 
> > [1] http://oss.sgi.com/bugzilla/show_bug.cgi?id=914
> 
> Looks like we do not handle read I/O errors very well (to say at all)
> in phase6.  Can you see if the patch below makes a difference?

Christoph, I'm assuming you want this reviewed
as a submitted patch.


> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: repair: fix I/O error handling
> 
> Currently libxfs_trans_read_buf never returns an error, even if
> libxfs_readbuf did not manage to complete the I/O.  This is different
> from the kernel behaviour and can lead to segfaults in code that
> doesn't expect it.  Add a new b_error member to xfs_buf (mirroring
> the kernel version) and use that to propagate proper error codes
> to the caller.  Also fix libxfs_readbufr to handle short reads
> properly, and to not override errno values e.g. by a fprintf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/include/libxfs.h
> ===================================================================
> --- xfsprogs-dev.orig/include/libxfs.h	2011-09-14 11:17:42.660738577 -0400
> +++ xfsprogs-dev/include/libxfs.h	2011-09-14 11:20:45.959738580 -0400
> @@ -230,6 +230,7 @@ typedef struct xfs_buf {
>  	void			*b_fsprivate2;
>  	void			*b_fsprivate3;
>  	char			*b_addr;
> +	int			b_error;
>  #ifdef XFS_BUF_TRACING
>  	struct list_head	b_lock_list;
>  	const char		*b_func;
> Index: xfsprogs-dev/libxfs/rdwr.c
> ===================================================================
> --- xfsprogs-dev.orig/libxfs/rdwr.c	2011-09-14 11:12:08.807741720 -0400
> +++ xfsprogs-dev/libxfs/rdwr.c	2011-09-14 11:20:21.183238272 -0400
> @@ -314,6 +314,7 @@ libxfs_initbuf(xfs_buf_t *bp, dev_t devi
>  	bp->b_blkno = bno;
>  	bp->b_bcount = bytes;
>  	bp->b_dev = device;
> +	bp->b_error = 0;
>  	if (!bp->b_addr)
>  		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
>  	if (!bp->b_addr) {
> @@ -454,15 +455,17 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t b
>  {
>  	int	fd = libxfs_device_to_fd(dev);
>  	int	bytes = BBTOB(len);
> +	int	error;
>  
>  	ASSERT(BBTOB(len) <= bp->b_bcount);
>  
> -	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) < 0) {
> +	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) != bytes) {

If we reach EOF this returns 0, but errno is I think
going to be 0.  Do we want to print a "read failed"
message in that case?  Is EOF a failure, or just
a somewhat normal condition?

Also, it may not matter in the calling code (I
did only a quick check) but maybe it would be
better to set bp->b_error here, where the error
really occurred, rather than in libxfs_readbuf().

Other than that, this change looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
