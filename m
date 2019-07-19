Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from conssluserg-06.nifty.com ([210.131.2.91]:46295 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSGRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 02:17:40 -0400
MIME-Version: 1.0
References: <20190718125509.775525-1-arnd@arndb.de> <20190718125703.GA28332@lst.de>
 <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
 <20190718130835.GA28520@lst.de> <20190718142525.GE7116@magnolia>
 <CAK7LNASN5d_ppx6wJSm+fcf9HiX9i6zX4fxiR5_WuF6QUOExXQ@mail.gmail.com> <20190719055855.GB29082@infradead.org>
In-Reply-To: <20190719055855.GB29082@infradead.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 19 Jul 2019 15:16:55 +0900
Message-ID: <CAK7LNAQrPRKUCbTY9pSWrUTw=kshhE2CSz5jqXOuD7ziChdsGg@mail.gmail.com>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, linux-xfs <linux-xfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jani Nikula <jani.nikula@intel.com>

On Fri, Jul 19, 2019 at 2:59 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jul 19, 2019 at 11:19:15AM +0900, Masahiro Yamada wrote:
> > I started to think
> > compiling all headers is more painful than useful.
> >
> >
> > MW is closing, so I am thinking of disabling it for now
> > to take time to re-think.
>
> For now this seems like the best idea.  In the long run maybe we can
> limit the tests to certain configs, e.g.
>
>
> headers-$(CONFIG_IOMAP)         += iomap.h

I cannot find CONFIG_IOMAP.

Do you mean

header-test-$(CONFIG_BLOCK) += iomap.h

?


> in include/linux/Kbuild
>
> and base it off that?

Yes, I was thinking of that.

-- 
Best Regards
Masahiro Yamada
