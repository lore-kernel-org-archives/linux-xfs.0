Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42456 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751741AbdF1Sig (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 14:38:36 -0400
Subject: Re: [PATCH] xfs_db: improve argument naming in set_cur and
 set_iocur_type
References: <20170628150913.15934-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <38019898-7c12-428e-3760-dd0cbbf397b4@sandeen.net>
Date: Wed, 28 Jun 2017 13:38:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170628150913.15934-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On 6/28/17 10:09 AM, Bill O'Donnell wrote:
> In set_cur and set_iocur_type, the current naming for arguments
> type, block number, and length are t, d, and c, respectively.
> Replace these with more intuitive and descriptive names:
> type, blknum, and len. Additionally remove extra blank line
> in io.c.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Could you resend this, rebased on top of the patch you just sent
for set_iocur_type() please?

(also: watch out for long lines ...)

That'll give you a chance to change the type pointed out earlier,
as well.

Thanks,
-Eric

> ---
>  db/io.c | 31 +++++++++++++++----------------
>  db/io.h |  6 +++---
>  2 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 9918a51d..45cbf3be 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -535,9 +535,9 @@ write_cur(void)
>  
>  void
>  set_cur(
> -	const typ_t	*t,
> -	__int64_t	d,
> -	int		c,
> +	const typ_t	*type,
> +	__int64_t	blknum,
> +	int		len,
>  	int		ring_flag,
>  	bbmap_t		*bbmap)
>  {
> @@ -545,14 +545,13 @@ set_cur(
>  	xfs_ino_t	dirino;
>  	xfs_ino_t	ino;
>  	__uint16_t	mode;
> -	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
> +	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>  
>  	if (iocur_sp < 0) {
>  		dbprintf(_("set_cur no stack element to set\n"));
>  		return;
>  	}
>  
> -
>  	ino = iocur_top->ino;
>  	dirino = iocur_top->dirino;
>  	mode = iocur_top->mode;
> @@ -562,7 +561,7 @@ set_cur(
>  	if (bbmap) {
>  #ifdef DEBUG_BBMAP
>  		int i;
> -		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
> +		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
>  		printf(_("\tblock map"));
>  		for (i = 0; i < bbmap->nmaps; i++)
>  			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
> @@ -576,7 +575,7 @@ set_cur(
>  		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
>  					bbmap->nmaps, 0, ops);
>  	} else {
> -		bp = libxfs_readbuf(mp->m_ddev_targp, d, c, 0, ops);
> +		bp = libxfs_readbuf(mp->m_ddev_targp, blknum, len, 0, ops);
>  		iocur_top->bbmap = NULL;
>  	}
>  
> @@ -592,13 +591,13 @@ set_cur(
>  	if (!ops)
>  		bp->b_flags |= LIBXFS_B_UNCHECKED;
>  
> -	iocur_top->bb = d;
> -	iocur_top->blen = c;
> +	iocur_top->bb = blknum;
> +	iocur_top->blen = len;
>  	iocur_top->boff = 0;
>  	iocur_top->data = iocur_top->buf;
> -	iocur_top->len = BBTOB(c);
> -	iocur_top->off = d << BBSHIFT;
> -	iocur_top->typ = cur_typ = t;
> +	iocur_top->len = BBTOB(len);
> +	iocur_top->off = blknum << BBSHIFT;
> +	iocur_top->typ = cur_typ = type;
>  	iocur_top->ino = ino;
>  	iocur_top->dirino = dirino;
>  	iocur_top->mode = mode;
> @@ -612,16 +611,16 @@ set_cur(
>  
>  void
>  set_iocur_type(
> -	const typ_t	*t)
> +	const typ_t	*type)
>  {
>  	struct xfs_buf	*bp = iocur_top->bp;
>  
> -	iocur_top->typ = t;
> +	iocur_top->typ = type;
>  
>  	/* verify the buffer if the type has one. */
>  	if (!bp)
>  		return;
> -	if (!t->bops) {
> +	if (!type->bops) {
>  		bp->b_ops = NULL;
>  		bp->b_flags |= LIBXFS_B_UNCHECKED;
>  		return;
> @@ -629,7 +628,7 @@ set_iocur_type(
>  	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
>  		return;
>  	bp->b_error = 0;
> -	bp->b_ops = t->bops;
> +	bp->b_ops = type->bops;
>  	bp->b_ops->verify_read(bp);
>  	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
>  }
> diff --git a/db/io.h b/db/io.h
> index b415b82d..ebf51f1d 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -59,10 +59,10 @@ extern void	print_iocur(char *tag, iocur_t *ioc);
>  extern void	push_cur(void);
>  extern int	read_buf(__int64_t daddr, int count, void *bufp);
>  extern void     write_cur(void);
> -extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
> -			bbmap_t *bbmap);
> +extern void	set_cur(const struct typ *type, __int64_t blknum,
> +			int len, int ring_add, bbmap_t *bbmap);
>  extern void     ring_add(void);
> -extern void	set_iocur_type(const struct typ *t);
> +extern void	set_iocur_type(const struct typ *type);
>  extern void	xfs_dummy_verify(struct xfs_buf *bp);
>  extern void	xfs_verify_recalc_inode_crc(struct xfs_buf *bp);
>  extern void	xfs_verify_recalc_dquot_crc(struct xfs_buf *bp);
> 
