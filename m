Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbdAYPJb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 10:09:31 -0500
Date: Wed, 25 Jan 2017 07:09:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: work around unlikely() profiler glitch
Message-ID: <20170125150929.GA19906@infradead.org>
References: <20170125140821.2677725-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170125140821.2677725-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Nicolas Pitre <nico@linaro.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Jan 25, 2017 at 03:08:10PM +0100, Arnd Bergmann wrote:
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d22f7930eb75..dca3ddd737d4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3629,7 +3629,7 @@ xfs_bmap_btalloc(
>  		align = xfs_get_cowextsz_hint(ap->ip);
>  	else if (xfs_alloc_is_userdata(ap->datatype))
>  		align = xfs_get_extsz_hint(ap->ip);
> -	if (unlikely(align)) {
> +	if (unlikely_notrace(align)) {
>  		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>  						align, 0, ap->eof, 0, ap->conv,
>  						&ap->offset, &ap->length);

The unlikely calls on align in xfs_bmap_btalloc should simply be
removed.  They aren't actually unlikely for many workloads.  I have
a patch in my queue that I can expedite based on your report.
