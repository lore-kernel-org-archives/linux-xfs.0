Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 321467CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 10:54:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4CC8AC006
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 08:54:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dVYddf28iYsl2Yba (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 08:54:10 -0800 (PST)
Date: Wed, 17 Feb 2016 08:54:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3 V2] xfs: convert mount option parsing to tokens
Message-ID: <20160217165409.GA16723@infradead.org>
References: <56BBC982.50804@redhat.com> <56BBC9E6.5030100@sandeen.net>
	<56C2412B.9040603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C2412B.9040603@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> -suffix_kstrtoint(char *s, unsigned int base, int *res)
> +suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
> -	char	*value = s;
> +	char	*value = match_strdup(s);
> +	int	ret = 0;
> +

Needs to check for a NULL return value.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
