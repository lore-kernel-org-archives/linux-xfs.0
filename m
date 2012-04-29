Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLnIES161935 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:49:19 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OkliFzVdX4bNoxnA (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:49:17 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:49:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 28/37] xfs: move xfsagino_t to xfs_types.h
Message-ID: <20120429214917.GG19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-29-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-29-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 03:58:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Untangle the header file includes a bit by moving the definition of
> xfs_agino_t to xfs_types.h. This removes the dependency that xfs_ag.h has on
> xfs_inum.h, meaning we don't need to include xfs_inum.h everywhere we include
> xfs_ag.h.

This patch by itself looks good to me, but is there any good reason to
keep xfs_inum.h around at all?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
