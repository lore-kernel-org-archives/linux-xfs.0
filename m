Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668jpuv095367 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:45:51 -0500
Date: Wed, 6 Jul 2011 04:45:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/27] xfs: avoid usage of struct xfs_dir2_data
Message-ID: <20110706084549.GG19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.003170984@bombadil.infradead.org>
	<1309923502.3381.35.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309923502.3381.35.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 10:38:22PM -0500, Alex Elder wrote:
> On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
> > which is the first and most important member of struct xfs_dir2_data instead
> > of the full structure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> In xfs_dir2_data_freescan() you get the address of the
> dir2_data_t by forcibly casting the address of the
> header to that type.  We all know that's fine, but
> it's an unsavory practice.  Why don't you pass the
> full dir2_data_t in that case where it's needed?
> Are you simply trying to avoid passing *any* pointers
> to variable-sized types?

I'm restricting the dir2_data_t scope to where we needed it,
to kill it (and thus the cast) off entirely in the next patch.

> (Update: I think you eliminate that line in the next
> patch anyway...)

Exactly!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
