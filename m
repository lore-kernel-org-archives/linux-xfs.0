Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57E0C7F80
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4601B304059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:56:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Oczo6J6XQLc0cQcP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 07:56:10 -0700 (PDT)
Date: Thu, 31 Oct 2013 07:56:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/30] db: separate out straight buffer IO from map based
	IO.
Message-ID: <20131031145609.GO22359@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-16-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:31:06PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> First step in converting to libxfs based IO.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

The patch description is a little too short, there's not real
explanation of what it actually does.

> -	if (read_bbs(XFS_SB_DADDR, 1, &bufp, NULL)) {
> +	if (read_buf(XFS_SB_DADDR, 1, bufp)) {

E.g. why isn't this already using the normal libxfs routines?

(there probably is an explanation but I don't quite see it yet..)

>  int
> +read_buf(
> +	xfs_daddr_t	bbno,
> +	int		count,
> +	void		*bufp)
> +{

Is read_buf really a good name for something that is a trivial pread
wrapper and doesn't deal with buffers?  Should the function have some
comments explaining when to use it?  The same also applies to the write
side.

> +	int		err;
> +
> +	err = pwrite64(x.dfd, bufp, BBTOB(count), BBTOB(bbno));
> +	if (err < 0)
> +		err = errno;
> +	else if (err < count)
> +		err = -1;
> +	return err;
> +}

> +static void
> +write_cur_buf(void)
> +{
> +	int ret;
> +
> +	ret = write_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
> +
> +	if (ret == -1)
> +		dbprintf(_("incomplete write, block: %lld\n"),
> +			 (iocur_base + iocur_sp)->bb);
> +	else if (ret != 0)
> +		dbprintf(_("write error: %s\n"), strerror(ret));
> +
> +	/* re-read buffer from disk */
> +	ret = read_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
> +	if (ret == -1)
> +		dbprintf(_("incomplete read, block: %lld\n"),
> +			 (iocur_base + iocur_sp)->bb);
> +	else if (ret != 0)
> +		dbprintf(_("read error: %s\n"), strerror(ret));
> +}

What is the point of the write and re-read cycle?

> +	for (j = 0; j < count; j++) {
> +		bbno = bbmap->b[j];
>  		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
>  			rval = errno;
>  			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
>  			return rval;
>  		}
> -		c = BBTOB(bbmap ? 1 : count);
> +		c = BBTOB(1);
>  		i = (int)write(x.dfd, (char *)bufp + BBTOB(j), c);

Shoiuldn't this use the write_buf helper above?

> +	for (j = 0; j < count; j++) {
> +		bbno = bbmap->b[j];
>  		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
>  			rval = errno;
>  			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
> @@ -483,7 +534,7 @@ read_bbs(
>  				xfree(buf);
>  			buf = NULL;
>  		} else {
> -			c = BBTOB(bbmap ? 1 : count);
> +			c = BBTOB(1);
>  			i = (int)read(x.dfd, (char *)buf + BBTOB(j), c);

And read_buf here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
