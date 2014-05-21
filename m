Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 163197F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 09:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF2B88F8035
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 07:29:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id GugDKmao8OR4J7C9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 07:29:18 -0700 (PDT)
Date: Wed, 21 May 2014 07:29:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] [XFS] indent an if statement
Message-ID: <20140521142909.GA22281@infradead.org>
References: <20140521122746.GD23396@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140521122746.GD23396@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 21, 2014 at 03:27:46PM +0300, Dan Carpenter wrote:
> The "n += 32;" goes with the if statement on the line before so it
> should be indented.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_bit.h b/fs/xfs/xfs_bit.h
> index f1e3c90..f685942 100644
> --- a/fs/xfs/xfs_bit.h
> +++ b/fs/xfs/xfs_bit.h
> @@ -67,7 +67,7 @@ static inline int xfs_lowbit64(__uint64_t v)
>  	} else {	/* upper bits */
>  		w = (__uint32_t)(v >> 32);
>  		if (w && (n = ffs(w)))
> -		n += 32;
> +			n += 32;

If we want to clean up this stuff let's do it properly:

		if (w) {
			n = ffs(w);
			if (n)
				n += 32;
		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
