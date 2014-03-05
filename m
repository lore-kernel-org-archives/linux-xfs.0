Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21A5F7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 16:34:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA6108F8078
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 14:34:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 4Q0D3WgpUKcNKz6f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 14:34:29 -0800 (PST)
Date: Wed, 5 Mar 2014 14:34:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: inode log reservations are still too small
Message-ID: <20140305223428.GA25588@infradead.org>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-3-git-send-email-david@fromorbit.com>
	<20140305171441.GD11667@infradead.org>
	<20140305214002.GI6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140305214002.GI6851@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


> We don't. We need to, I just haven't had the time to audit the rest
> of the reservations to fix them all up yet. AFAIA, only the quota
> off transactions don't have any slack in them for xlog_op_header
> space - all the others that are incorrect probably have enough
> overhead from the buffer overhead roundup to cover the lack ophdr
> accounting on things like dquots.

That's more or less what I expected..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
