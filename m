Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A7777FD0
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 07:07:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB2ACAC003
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 05:07:11 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id B7PpdDJxrBb9kkF4 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Mar 2013 05:07:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 19D631B971B00
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 14:07:01 +0100 (CET)
Received: from tyrex.lisa.loc ([127.0.0.1])
	by localhost (tyrex.lisa.loc [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id jofqQcjkj2wJ for <xfs@oss.sgi.com>;
	Fri,  8 Mar 2013 14:06:52 +0100 (CET)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: [PATCH] xfs: ensure we capture IO errors correctly
Date: Fri, 08 Mar 2013 14:06:52 +0100
Message-ID: <1407262.RNsTtTSyZy@xrated>
In-Reply-To: <1362708074-14987-1-git-send-email-david@fromorbit.com>
References: <1362708074-14987-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi, =


this sounds like stable material after a little simmering..

Cheers,
Pete

Am Freitag, 8. M=E4rz 2013, 13:01:14 schrieb Dave Chinner:
> From: Dave Chinner <dchinner@redhat.com>
> =

> Failed buffer readahead can leave the buffer in the cache marked
> with an error. Most callers that then issue a subsequent read on the
> buffer do not zero the b_error field out, and so we may incorectly
> detect an error during IO completion due to the stale error value
> left on the buffer.
> =

> Avoid this problem by zeroing the error before IO submission. This
> ensures that the only IO errors that are detected those captured
> from are those captured from bio submission or completion.
> =

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> =

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 50eb603..82b70bd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1336,6 +1336,12 @@ _xfs_buf_ioapply(
>  	int		size;
>  	int		i;
> =

> +	/*
> +	 * Make sure we capture only current IO errors rather than stale errors
> +	 * left over from previous use of the buffer (e.g. failed readahead).
> +	 */
> +	bp->b_error =3D 0;
> +
>  	if (bp->b_flags & XBF_WRITE) {
>  		if (bp->b_flags & XBF_SYNCIO)
>  			rw =3D WRITE_SYNC;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
