Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:09:42 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AF9X4p003888
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:09:34 -0700
Date: Mon, 10 Sep 2007 16:09:35 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] cleanup fid types mess
Message-ID: <20070910150935.GB16595@infradead.org>
References: <20070829134612.GA504@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829134612.GA504@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Aug 29, 2007 at 03:46:12PM +0200, Christoph Hellwig wrote:
> Currently XFs has three different fid types: struct fid, struct xfs_fid
> and struct xfs_fid2 with hte latter two beeing identicaly and the first
> one beeing the same size but an unstructured array with the same size.
> 
> This patch consolidates all this to alway uuse struct xfs_fid.
> 
> This patch is required for an upcoming patch series from me that revamps
> the nfs exporting code and introduces a Linux-wide struct fid.
> 
> 
> Note: the patch is ontop of Eric's inode/vnode tracing cleanup.

Any chance review of this one (and Eric's patch) could be sped up a little
as I have things in the queue relying on this one?
