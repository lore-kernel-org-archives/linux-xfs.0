Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8FC929DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:11:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B901AC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:11:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dGBSNgG8wpFPDMBb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:11:04 -0800 (PST)
Date: Mon, 2 Dec 2013 09:11:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/15] mkfs: structify input parameter passing
Message-ID: <20131202171103.GC14935@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +	const char	name;
> +	const char	*subopts[MAX_SUBOPTS];
> +	struct subopt_param {
> +		int		index;
> +		long long	minval;
> +		long long	maxval;
> +	}		subopt_params[MAX_SUBOPTS];
> +};

Any reason to have a separate array for subopts instead of
moving it into struct subopt_param?

Except for that I really like the approach!

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
