Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B15A7F4E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 02:00:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9475EAC001
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 00:00:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id q1DsV1BRxaRYAqDI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 00:00:09 -0700 (PDT)
Date: Mon, 21 Apr 2014 00:00:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] db: don't claim unchecked CRCs are correct
Message-ID: <20140421070009.GC20384@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-2-git-send-email-david@fromorbit.com>
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

> +	switch (iocur_crc_valid()) {
> +	case -1:
> +		ok = "unchecked";
> +		break;
> +	case 0:
> +		ok = "bad";
> +		break;
> +	case 1:
> +		ok = "correct";
> +		break;
> +	default:
> +		ok = "unknown state";
> +		break;
> +	}

We should have symbolic constants for these return values.  But then
again iocur_crc_valid only has a single caller currently, is it even
worth the effort, or should we simply inline it?

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
