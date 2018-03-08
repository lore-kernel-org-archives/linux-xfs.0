Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935333AbeCHIMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:12:02 -0500
Date: Thu, 8 Mar 2018 00:12:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] libxfs: move xfs_inode_zone to rdwr.c
Message-ID: <20180308081200.GE15163@infradead.org>
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <ab899bab-b034-1167-21e7-073ce5258082@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab899bab-b034-1167-21e7-073ce5258082@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

> @@ -379,6 +377,7 @@ manage_zones(int release)
>  {
>  	extern kmem_zone_t	*xfs_buf_zone;
>  	extern kmem_zone_t	*xfs_ili_zone;
> +	extern kmem_zone_t	*xfs_inode_zone;

We should really aim to have externs in headers, no in .c files.

But I guess this fits the existing style and should be fixed separately,
so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
