Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 914AA7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 11:48:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AEC9AC005
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 09:48:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id RLlQB2mWEtru99ib (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 09:48:13 -0800 (PST)
Date: Thu, 6 Mar 2014 09:48:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
Message-ID: <20140306174813.GE28297@infradead.org>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
	<1394034699-21187-7-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1394034699-21187-7-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

> +#ifdef HAVE_LINUX_FIEMAP_H
> +struct print_flags fiemap_flags[] = {
> +	{ FIEMAP_FLAG_SYNC, "SYNC"},
> +	{ FIEMAP_FLAG_XATTR, "XATTR"},
> +	{ -1, NULL}
> +};

Can be static.

> +
> +#define translate_fiemap_flags(mode)	\
> +	({translate_flags(mode, "|", fiemap_flags);})
> +#endif

Any reason to not have these two inside fiemap_f?

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
