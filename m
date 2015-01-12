Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 245FA7F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 11:54:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00F5B8F8033
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:54:18 -0800 (PST)
Received: from mail-yh0-f52.google.com (mail-yh0-f52.google.com
	[209.85.213.52]) by cuda.sgi.com with ESMTP id I46zCfWHfFjKxq5e
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:54:15 -0800 (PST)
Received: by mail-yh0-f52.google.com with SMTP id z6so10267295yhz.11
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:54:15 -0800 (PST)
Date: Mon, 12 Jan 2015 09:54:11 -0800
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150112175411.GA10611@jhereg.localdomain>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-10-git-send-email-hch@lst.de>
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

On Tue, Jan 06, 2015 at 05:28:32PM +0100, Christoph Hellwig wrote:

> +#ifdef CONFIG_NFSD_PNFS
> +static __be32
> +nfsd4_encode_getdeviceinfo(struct nfsd4_compoundres *resp, __be32 nfserr,
> +		struct nfsd4_getdeviceinfo *gdev)
> +{
> +	struct xdr_stream *xdr = &resp->xdr;
> +	const struct nfsd4_layout_ops *ops =
> +		nfsd4_layout_ops[gdev->gd_layout_type];
> +	u32 starting_len = xdr->buf->len, needed_len;
> +	__be32 *p;
> +
> +	dprintk("%s: err %d\n", __func__, nfserr);
> +	if (nfserr)
> +		goto out;

In nfsd4_block_get_device_info_simple(), gdp->gd_device might have
been allocated, but sb->s_export_op->get_uuid() might have returned
an error, which would cause a leak here.

> +
> +	p = xdr_reserve_space(xdr, 4);
> +	if (!p)
> +		return nfserr_resource;

gdp->gd_device can be leaked here.

> +	*p++ = cpu_to_be32(gdev->gd_layout_type);
> +
> +	/* If maxcount is 0 then just update notifications */
> +	if (gdev->gd_maxcount != 0) {
> +		nfserr = ops->encode_getdeviceinfo(xdr, gdev);
> +		if (nfserr) {
> +			/*
> +			 * We don't bother to burden the layout drivers with
> +			 * enforcing gd_maxcount, just tell the client to
> +			 * come back with a bigger buffer if it's not enough.
> +			 */
> +			if (xdr->buf->len + 4 > gdev->gd_maxcount)
> +				goto toosmall;
> +			goto out;
> +		}
> +	}
> +
> +	if (gdev->gd_notify_types) {
> +		p = xdr_reserve_space(xdr, 4 + 4);
> +		if (!p)
> +			return nfserr_resource;

gdp->gd_device can be leaked here.

> +		*p++ = cpu_to_be32(1);			/* bitmap length */
> +		*p++ = cpu_to_be32(gdev->gd_notify_types);
> +	} else {
> +		p = xdr_reserve_space(xdr, 4);
> +		if (!p)
> +			return nfserr_resource;

gdp->gd_device can be leaked here.

> +		*p++ = 0;
> +	}
> +
> +out:
> +	kfree(gdev->gd_device);
> +	dprintk("%s: done: %d\n", __func__, be32_to_cpu(nfserr));
> +	return nfserr;
> +
> +toosmall:
> +	dprintk("%s: maxcount too small\n", __func__);
> +	needed_len = xdr->buf->len + 4 /* notifications */;
> +	xdr_truncate_encode(xdr, starting_len);
> +	p = xdr_reserve_space(xdr, 4);
> +	if (!p)
> +		return nfserr_resource;
> +	*p++ = cpu_to_be32(needed_len);
> +	nfserr = nfserr_toosmall;
> +	goto out;
> +}
> +

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
