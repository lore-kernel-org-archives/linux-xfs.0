Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LCNGc7141159 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:23:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A819D17BBAE
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 05:23:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HqUv1FzOGDQl8SjP for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 05:23:14 -0700 (PDT)
Date: Wed, 21 Sep 2011 08:23:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: fix possible overflow in xfs_ioc_trim()
Message-ID: <20110921122313.GA28663@infradead.org>
References: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Sep 21, 2011 at 11:42:30AM +0200, Lukas Czerner wrote:
> In xfs_ioc_trim it is possible that computing the last allocation group
> to discard might overflow for big start & len values, because the result
> might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
> allowing the start and end block of the range to be beyond the end of the
> file system.
> 
> Note that if the start is beyond the end of the file system we have to
> return -EINVAL, but in the "end" case we have to truncate it to the fs
> size.
> 
> Also introduce "end" variable, rather than using start+len which which
> might be more confusing to get right as this bug shows.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
