Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCMDcU043924 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:22:13 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XEu5FInbzOPq6ATm (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:23:56 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:23:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Update inode alloc comments
Message-ID: <20121023122355.GB7341@infradead.org>
References: <1350742099-8397-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350742099-8397-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 20, 2012 at 11:08:19AM -0300, Carlos Maiolino wrote:
> I found some out of date comments while studying the inode allocation code, so I
> believe it's worth to have these comments updated.
> 
> It basically rewrites the comment regarding to "call_again" variable, which is
> not used anymore, but instead, callers of xfs_ialloc() decides if it needs to be
> called again relying only if ialloc_context is NULL or not.
> 
> Also did some small changes in another comment that I thought to be pertinent
> to the current behaviour of these functions and some alignment on both comments.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
