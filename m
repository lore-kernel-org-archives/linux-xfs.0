Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A0C37F85
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:14:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5544F304043
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:14:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 1glaGuflpA2wwDoQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:14:38 -0700 (PDT)
Date: Tue, 15 Jul 2014 03:14:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
Message-ID: <20140715101437.GB30363@infradead.org>
References: <52849CC5.10109@oracle.com>
 <53C091E1.1010907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53C091E1.1010907@sandeen.net>
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
Cc: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jul 11, 2014 at 08:39:45PM -0500, Eric Sandeen wrote:
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> I know hch had grand plans to make this all nicer, but based on Jeff's
> followup emails, it looks like this is the only spot needed to simply
> resolve the problems w/ nonexistent paths in quota, and is a small,
> contained change we can easily make before the next point release.

Didn't I say I'm fine with putting this in earlier even if I'd prefer
a grand solution?

either way, consider this:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
