Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7B6F7F58
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 17:02:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49928AC00F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 15:02:11 -0800 (PST)
Received: from mail-yh0-f51.google.com (mail-yh0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id 9W0zV9AGobCjp0Cq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2015 15:02:06 -0800 (PST)
Received: by mail-yh0-f51.google.com with SMTP id a41so5444699yho.10
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2015 15:02:06 -0800 (PST)
Date: Fri, 9 Jan 2015 15:02:02 -0800
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: [PATCH 03/18] nfsd: factor out a helper to decode nfstime4 values
Message-ID: <20150109230202.GB107259@kitty>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-4-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:26PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nfsd/nfs4xdr.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 15f7b73..fe31178 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -235,6 +235,22 @@ static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
>  }
>  
>  static __be32
> +nfsd4_decode_time(struct nfsd4_compoundargs *argp, struct timespec *tv)
> +{
> +	DECODE_HEAD;
> +	u64 sec;
> +
> +	READ_BUF(12);
> +	p = xdr_decode_hyper(p, &sec);
> +	tv->tv_sec = sec;
> +	tv->tv_nsec = be32_to_cpup(p++);
> +	if (tv->tv_nsec >= (u32)1000000000)
> +		return nfserr_inval;
> +
> +	DECODE_TAIL;
> +}
> +
> +static __be32
>  nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
>  {
>  	u32 bmlen;
> @@ -267,7 +283,6 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
>  {
>  	int expected_len, len = 0;
>  	u32 dummy32;
> -	u64 sec;
>  	char *buf;
>  
>  	DECODE_HEAD;
> @@ -358,15 +373,10 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
>  		dummy32 = be32_to_cpup(p++);
>  		switch (dummy32) {
>  		case NFS4_SET_TO_CLIENT_TIME:
> -			/* We require the high 32 bits of 'seconds' to be 0, and we ignore
> -			   all 32 bits of 'nseconds'. */

Have you done away with these requirements?

> -			READ_BUF(12);
>  			len += 12;

I think this code makes it clear that the magic number 12 is the
same on both lines. With the change, that gets lost.

Do I think that the 12 will ever change? No.

Do I think this becomes more "magic"? Yes.
 
> -			p = xdr_decode_hyper(p, &sec);
> -			iattr->ia_atime.tv_sec = (time_t)sec;
> -			iattr->ia_atime.tv_nsec = be32_to_cpup(p++);
> -			if (iattr->ia_atime.tv_nsec >= (u32)1000000000)
> -				return nfserr_inval;
> +			status = nfsd4_decode_time(argp, &iattr->ia_atime);
> +			if (status)
> +				return status;
>  			iattr->ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
>  			break;
>  		case NFS4_SET_TO_SERVER_TIME:
> @@ -382,15 +392,10 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
>  		dummy32 = be32_to_cpup(p++);
>  		switch (dummy32) {
>  		case NFS4_SET_TO_CLIENT_TIME:
> -			/* We require the high 32 bits of 'seconds' to be 0, and we ignore
> -			   all 32 bits of 'nseconds'. */
> -			READ_BUF(12);
>  			len += 12;
> -			p = xdr_decode_hyper(p, &sec);
> -			iattr->ia_mtime.tv_sec = sec;
> -			iattr->ia_mtime.tv_nsec = be32_to_cpup(p++);
> -			if (iattr->ia_mtime.tv_nsec >= (u32)1000000000)
> -				return nfserr_inval;
> +			status = nfsd4_decode_time(argp, &iattr->ia_mtime);
> +			if (status)
> +				return status;
>  			iattr->ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
>  			break;
>  		case NFS4_SET_TO_SERVER_TIME:
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
