Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59504 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbfGRNIj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 09:08:39 -0400
Date: Thu, 18 Jul 2019 15:08:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Message-ID: <20190718130835.GA28520@lst.de>
References: <20190718125509.775525-1-arnd@arndb.de> <20190718125703.GA28332@lst.de> <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Jani Nikula <jani.nikula@intel.com>

On Thu, Jul 18, 2019 at 03:03:15PM +0200, Arnd Bergmann wrote:
> The inclusion comes from the recently added header check in commit
> c93a0368aaa2 ("kbuild: do not create wrappers for header-test-y").
> 
> This just tries to include every header by itself to see if there are build
> failures from missing indirect includes. We probably don't want to
> add an exception for iomap.h there.

I very much disagree with that check.  We don't need to make every
header compilable with a setup where it should not be included.

That being said if you feel this is worth fixing I'd rather define
SECTOR_SIZE/SECTOR_SHIFT unconditionally.
