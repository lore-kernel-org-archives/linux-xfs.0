Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SBVxPv229078 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 06:31:59 -0500
Date: Wed, 28 Apr 2010 07:33:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] XFS: Let the broken fiemap work in query mode.
Message-ID: <20100428113359.GB27769@infradead.org>
References: <20100428023058.GD9783@dastard>
	<1272423625-20142-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272423625-20142-1-git-send-email-tao.ma@oracle.com>
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
To: Tao Ma <tao.ma@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 11:00:25AM +0800, Tao Ma wrote:
> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
> +	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
> +					fieinfo->fi_extents_max + 1;
> +	bm.bmv_count = MIN(bm.bmv_count,
> +			   (__s32)(PAGE_SIZE * 16 / sizeof(struct getbmapx)));

I would use min_t here instead of the case, but otherwise the patch
looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
