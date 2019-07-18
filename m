Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59415 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbfGRM5G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 08:57:06 -0400
Date: Thu, 18 Jul 2019 14:57:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Message-ID: <20190718125703.GA28332@lst.de>
References: <20190718125509.775525-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718125509.775525-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, linux-kernel@vger.kernel.org

On Thu, Jul 18, 2019 at 02:55:01PM +0200, Arnd Bergmann wrote:
> When CONFIG_BLOCK is disabled, SECTOR_SHIFT is unknown:
> 
> In file included from <built-in>:3:
> include/linux/iomap.h:76:48: error: use of undeclared identifier 'SECTOR_SHIFT'
>         return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> 
> Since there are no callers in this case, just hide the function in
> the same ifdef.
> 
> Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Can we just not include iomap.c when CONFIG_BLOCK is not set?
Which file do you see this with?
