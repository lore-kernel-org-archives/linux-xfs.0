Return-Path: <xfs-bounces@oss.sgi.com>
Date: Tue, 31 Jan 2012 11:50:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH] xfs: pass KM_SLEEP flag to kmem_realloc() in
	xlog_recover_add_to_cnt_trans()
Message-ID: <20120131175053.GG7762@sgi.com>
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
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Fri, Jan 27, 2012 at 03:37:26PM +0900, Mitsuo Hayasaka wrote:
> The kmem_realloc() in xfs is given KM_* memory allocation flags. And it
> allocates memory using kmalloc() after they are converted to gfp_mask
> flags. In xlog_recover_add_to_cont_trans(), 0u is passed to kmem_realloc(),
> instead of them. I guess it is preferred to use them, and here memory must
> be allocated but don't have to be done with GFP_ATOMIC. So, this patch
> changes it to KM_SLEEP.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>

Looks good.  Consistent with other kmem_*alloc in log recovery.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
