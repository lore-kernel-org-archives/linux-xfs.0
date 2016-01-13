Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B96E7F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 02:01:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31E3AAC002
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 00:01:36 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GkjR6ayjCK6cVuxT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 00:01:33 -0800 (PST)
Date: Wed, 13 Jan 2016 00:01:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] Prefer stdint types over __uint*_t and __int*_t
Message-ID: <20160113080132.GM21939@infradead.org>
References: <cover.1452632647.git.felix.janda@posteo.de>
	<20160112210849.GG10044@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112210849.GG10044@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

>  	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
> -	__int64_t	length;
> +	int64_t	length;
>  
>  	if (bmap[0].bmv_entries <= 0) {
>  		return 1;	/* caller must already be at EOF */
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index 9c6722e..f85128f 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -1935,7 +1935,7 @@ The files are constructed like so:
>  <pre>
>  typedef struct invt_counter {
>      INVT_COUNTER_FIELDS
> -        __uint32_t    ic_vernum;/* on disk version number for posterity */\
> +        uint32_t    ic_vernum;/* on disk version number for posterity */\

please keep the existing alignments for variable declarations or
structure members.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
