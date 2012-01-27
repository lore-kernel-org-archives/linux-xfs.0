Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RAqxEv163121 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 04:52:59 -0600
Date: Fri, 27 Jan 2012 05:52:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: pass KM_SLEEP flag to kmem_realloc() in
	xlog_recover_add_to_cnt_trans()
Message-ID: <20120127105253.GA23335@infradead.org>
References: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120127063726.16227.681.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Fri, Jan 27, 2012 at 03:37:26PM +0900, Mitsuo Hayasaka wrote:
> The kmem_realloc() in xfs is given KM_* memory allocation flags. And it
> allocates memory using kmalloc() after they are converted to gfp_mask
> flags. In xlog_recover_add_to_cont_trans(), 0u is passed to kmem_realloc(),
> instead of them. I guess it is preferred to use them, and here memory must
> be allocated but don't have to be done with GFP_ATOMIC. So, this patch
> changes it to KM_SLEEP.

Looks good.  I actually just noticed it when changing the kmem_realloc
implementation, but let's put your patch in before that and send it off
to Linus ASAP.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
