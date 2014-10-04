Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50C8E7F3F
	for <xfs@oss.sgi.com>; Sat,  4 Oct 2014 02:16:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D60F8F8059
	for <xfs@oss.sgi.com>; Sat,  4 Oct 2014 00:16:53 -0700 (PDT)
Date: Sat, 4 Oct 2014 00:16:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/16] xfs: implement demand load of utf8norm.ko
Message-ID: <20141004071651.GB5168@infradead.org>
References: <20141003214758.GY1865@sgi.com>
 <20141003220357.GM1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003220357.GM1865@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

> +int
> +xfs_init_utf8_module(struct xfs_mount	*mp)
> +{
> +	request_module("utf8norm");
> +
> +	spin_lock(&utf8norm_lock);
> +	if (utf8norm_initialized) {
> +		spin_unlock(&utf8norm_lock);
> +		return 0;
> +	}
> +
> +	utf8version_is_supported_func = symbol_get(utf8version_is_supported);
> +	if (!utf8version_is_supported_func)
> +		goto error;
> +
> +	utf8nfkdi_func = symbol_get(utf8nfkdi);
> +	if (!utf8nfkdi_func)
> +		goto error;

Please export a structure with a function pointes so that we just need
a single symbol_get call.  I'd have to look up how symbol_get works,
but unless there's something that speaks against this it might be
simpler to than just do a symbol_get per mounst structure that uses
utf8 and can point to that structure so that we don't have to add
additional reference counting infrastructure around it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
