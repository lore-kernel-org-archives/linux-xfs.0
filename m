Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89NuCIp066575 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:56:12 -0500
Subject: Re: [PATCH 17/25] xfs: move firstblock and bmap freelist cursor
	into bmalloca structure
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060644.160629525@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060644.160629525@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:56:11 -0500
Message-ID: <1315612571.1999.133.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> Rather than passing the freeblock and freelist structure around, embed it
                          firstblock
> into the bmalloca structure and remove it from the function parameters.
> 
> This also enables the minleft parameter to be set only once in
> xfs_bmapi_write(), and the freelist cursor directly queried in
> xfs_bmapi_allocate to clear it when the lowspace algorithm is activated.
>     
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>

A couple of comments:
- The struct xfs_bmalloca field "low" ought to be eliminated
  (or renamed "pad" or something), since it's now unused
  (->flist->xbf_low is used in its place).
- It might have been a bit simpler to review if using
  ->flist->xbf_low in place of ->low and ->minleft
  in place of minleft were done as separate, min-steps.

In any case, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
