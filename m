Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:42:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L8fr79026897
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:41:56 -0700
Date: Mon, 21 Apr 2008 04:42:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] XFS: Name operation vector for hash and compare
Message-ID: <20080421084233.GA10323@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.158168432@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421083644.158168432@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

>  /*
> + * Search comparison results
> + */
> +typedef enum {
> +	XFS_CMP_DIFFERENT,	/* names are completely different */
> +	XFS_CMP_EXACT,		/* names are exactly the same */
> +	XFS_CMP_CASE		/* names are same but differ in case */
> +} xfs_dacmp_t;

Please don't add a typedef for this one, just use the enum type
directly.

Except for this this patch looks good to me.
