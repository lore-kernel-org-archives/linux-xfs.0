Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45863 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390481AbfGRNDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 09:03:34 -0400
MIME-Version: 1.0
References: <20190718125509.775525-1-arnd@arndb.de> <20190718125703.GA28332@lst.de>
In-Reply-To: <20190718125703.GA28332@lst.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 18 Jul 2019 15:03:15 +0200
Message-ID: <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Jani Nikula <jani.nikula@intel.com>

On Thu, Jul 18, 2019 at 2:57 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 18, 2019 at 02:55:01PM +0200, Arnd Bergmann wrote:
> > When CONFIG_BLOCK is disabled, SECTOR_SHIFT is unknown:
> >
> > In file included from <built-in>:3:
> > include/linux/iomap.h:76:48: error: use of undeclared identifier 'SECTOR_SHIFT'
> >         return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> >
> > Since there are no callers in this case, just hide the function in
> > the same ifdef.
> >
> > Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Can we just not include iomap.c when CONFIG_BLOCK is not set?
> Which file do you see this with?

The inclusion comes from the recently added header check in commit
c93a0368aaa2 ("kbuild: do not create wrappers for header-test-y").

This just tries to include every header by itself to see if there are build
failures from missing indirect includes. We probably don't want to
add an exception for iomap.h there.

      Arnd
