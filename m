Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2H6gqL0143125 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 01:43:13 -0500
Date: Tue, 17 Mar 2009 02:42:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Pagecache usage optimization on XFS
Message-ID: <20090317064230.GA26111@infradead.org>
References: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
	<20090316091606.GA1720@infradead.org>
	<6.0.0.20.2.20090317102134.06e60b30@172.19.0.2>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090317102134.06e60b30@172.19.0.2>
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
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Tue, Mar 17, 2009 at 01:03:08PM +0900, Hisashi Hifumi wrote:
> 
> At 18:16 09/03/16, Christoph Hellwig wrote:
> >This looks like it should work.  did you run XFSQA on a small blocksize
> >filesystem with this applied?
> 
> Hi.
> I did XFSQA test on XFS partition with this patch applied.
> 
> arch:ia64
> pagesize:16K
> blocksize:2K

Thanks a lot.  In that case the patch is fine with me.


Reviewed-by: Christoph Hellwig <hch@lst.de>

(as in reviewing the generic function to make sense with XFS :))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
