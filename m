Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96Jle14198216 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:47:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0E116B768C
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 12:54:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mQONXazSbZhQhsBg for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 12:54:29 -0700 (PDT)
Date: Thu, 6 Oct 2011 15:47:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make 258 more forgiving of timestamp rounding
Message-ID: <20111006194738.GE13434@infradead.org>
References: <4E89E851.80203@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E89E851.80203@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 03, 2011 at 11:52:33AM -0500, Eric Sandeen wrote:
> Rather than testing for an exact timestamp, which could vary
> due to rounding, just check that it is not positive,
> which is the failure case we're looking for.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
