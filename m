Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FLIM9R224881 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 16:18:23 -0500
Date: Thu, 15 Jul 2010 17:21:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
Message-ID: <20100715212116.GA7013@infradead.org>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279219605-12631-1-git-send-email-segooon@gmail.com>
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
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Felix Blyakher <felixb@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> below zero. So, check exact expression instead of map_len.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
