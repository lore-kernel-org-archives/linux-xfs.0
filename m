Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CD3429DFB
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:22:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 068B8AC003
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:22:12 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hEaktgiaCX62boMn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:22:11 -0700 (PDT)
Date: Sun, 21 Jun 2015 02:22:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: don't truncate attribute extents if no extents
	exist
Message-ID: <20150621092210.GE26833@infradead.org>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
	<1434631741-50856-2-git-send-email-bfoster@redhat.com>
	<20150619151421.GC22842@infradead.org>
	<20150619154522.GH12833@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150619154522.GH12833@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jun 19, 2015 at 11:45:23AM -0400, Brian Foster wrote:
> How about this?
> 
>         /*
>          * Invalidate and truncate the attribute fork extents. Make sure the
>          * fork actually has attributes as otherwise the invalidation has no
>          * blocks to read and returns an error. In this case, just do the fork
>          * removal below.
>          */

Yes, that looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
