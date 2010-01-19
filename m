Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9CG5Q179779 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:12:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B303F173602
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:13:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GeWUBtWs4ECh6D54 for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:13:16 -0800 (PST)
Date: Tue, 19 Jan 2010 04:13:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsteststs: get fsstress DIO working on non-xfs
	filesystems
Message-ID: <20100119091316.GB24737@infradead.org>
References: <4B54C8AB.6080607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B54C8AB.6080607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 18, 2010 at 02:46:35PM -0600, Eric Sandeen wrote:
> Pretty sure all DIO IO fails in fsstress today since XFS_IOC_DIOINFO
> fails.  If so, rather than just bailing out on the op, assign
> some sane default DIO parameters.
> 
> This falls down for 4k sector devices but not really sure how to get
> the underlying sector size easily from here; I think we can live
> with this for now.
> 
> hch suggested moving XFS_IOC_DIOINFO up higher in the vfs, that's
> probably a good idea in the long run.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 6978381..dab6bf7 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -1818,9 +1818,9 @@ dread_f(int opno, long r)
>  			printf(
>  			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s failed %d\n",
>  				procid, opno, f.path, errno);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		diob.d_maxiosz = -1U;
> +		diob.d_miniosz = 512;
> +		diob.d_mem = 512;
>  	}
>  	align = (__int64_t)diob.d_miniosz;
>  	lr = ((__int64_t)random() << 32) + random();
> @@ -1888,9 +1888,9 @@ dwrite_f(int opno, long r)
>  			printf("%d/%d: dwrite - xfsctl(XFS_IOC_DIOINFO)"
>  				" %s failed %d\n",
>  				procid, opno, f.path, errno);
> -		free_pathname(&f);
> -		close(fd);
> -		return;
> +		diob.d_maxiosz = -1U;
> +		diob.d_miniosz = 512;
> +		diob.d_mem = 512;

Can you factor out the alignment bits into a small helper and use it
in both places?


static void get_alignment(pathname_t *f, int fd, struct dioattr *dio)
{
	if (xfsctl(f->path, fd, XFS_IOC_DIOINFO, dio) < 0) {
		if (v)
			printf(...);

		/* use fallback values if the query fails. */
		diob.d_maxiosz = -1U;
		diob.d_miniosz = 512;
		diob.d_mem = 512;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
