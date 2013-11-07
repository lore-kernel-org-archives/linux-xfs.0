Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80B2D7FEF
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 14:54:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F588AC005
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 12:54:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id NbNpXoZypKHdjdmG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 12:54:54 -0800 (PST)
Date: Thu, 7 Nov 2013 12:54:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 30/37] libxfs: work around do_div() not handling 32 bit
	numerators
Message-ID: <20131107205454.GE23118@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-31-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383700043-32305-31-git-send-email-david@fromorbit.com>
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

On Wed, Nov 06, 2013 at 12:07:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The libxfs dquot buffer code uses do_div() with a 32 bit numerator.
> This gives incorrect results as do_div() passes the numerator by
> reference as a pointer to a 64 bit value. Hence it does the division
> using 32 bits of garbage gives the wrong result.
> 
> As per Christoph's suggestion, we can kill the usage of do_div()
> here completely and just do the division directly, both in userspace
> and kernel space.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
