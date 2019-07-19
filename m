Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfGSF7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 01:59:01 -0400
Date: Thu, 18 Jul 2019 22:58:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Message-ID: <20190719055855.GB29082@infradead.org>
References: <20190718125509.775525-1-arnd@arndb.de>
 <20190718125703.GA28332@lst.de>
 <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
 <20190718130835.GA28520@lst.de>
 <20190718142525.GE7116@magnolia>
 <CAK7LNASN5d_ppx6wJSm+fcf9HiX9i6zX4fxiR5_WuF6QUOExXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASN5d_ppx6wJSm+fcf9HiX9i6zX4fxiR5_WuF6QUOExXQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jani Nikula <jani.nikula@intel.com>

On Fri, Jul 19, 2019 at 11:19:15AM +0900, Masahiro Yamada wrote:
> I started to think
> compiling all headers is more painful than useful.
> 
> 
> MW is closing, so I am thinking of disabling it for now
> to take time to re-think.

For now this seems like the best idea.  In the long run maybe we can
limit the tests to certain configs, e.g.


headers-$(CONFIG_IOMAP)		+= iomap.h

in include/linux/Kbuild

and base it off that?
