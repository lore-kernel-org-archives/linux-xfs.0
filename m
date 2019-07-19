Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from conssluserg-01.nifty.com ([210.131.2.80]:61955 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfGSCdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 22:33:16 -0400
MIME-Version: 1.0
References: <20190718125509.775525-1-arnd@arndb.de> <20190718125703.GA28332@lst.de>
 <CAK8P3a2k3ddUD-b+OskpDfAkm6KGAGAOBabkXk3Uek1dShTiUA@mail.gmail.com>
 <20190718130835.GA28520@lst.de> <20190718142525.GE7116@magnolia>
 <CAK7LNASN5d_ppx6wJSm+fcf9HiX9i6zX4fxiR5_WuF6QUOExXQ@mail.gmail.com> <d63adfdf-7ac2-bc42-38c6-db1404a87d47@infradead.org>
In-Reply-To: <d63adfdf-7ac2-bc42-38c6-db1404a87d47@infradead.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 19 Jul 2019 11:32:16 +0900
Message-ID: <CAK7LNAT-E-2j-kDJ9qSjydRrW__PrCMy4D3GSw-+PP20Ax3zyA@mail.gmail.com>
Subject: Re: [PATCH] iomap: hide iomap_sector with CONFIG_BLOCK=n
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jani Nikula <jani.nikula@intel.com>

On Fri, Jul 19, 2019 at 11:24 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/18/19 7:19 PM, Masahiro Yamada wrote:
> > Hi.
> >
> > On Thu, Jul 18, 2019 at 11:28 PM Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> >>
> >> On Thu, Jul 18, 2019 at 03:08:35PM +0200, Christoph Hellwig wrote:
> >>> On Thu, Jul 18, 2019 at 03:03:15PM +0200, Arnd Bergmann wrote:
> >>>> The inclusion comes from the recently added header check in commit
> >>>> c93a0368aaa2 ("kbuild: do not create wrappers for header-test-y").
> >>>>
> >>>> This just tries to include every header by itself to see if there are build
> >>>> failures from missing indirect includes. We probably don't want to
> >>>> add an exception for iomap.h there.
> >>>
> >>> I very much disagree with that check.  We don't need to make every
> >>> header compilable with a setup where it should not be included.
> >>
> >> Seconded, unless there's some scenario where someone needs iomap when
> >> CONFIG_BLOCK=n (???)
> >
> > I agree.
> >
> > There is no situation that iomap.h is included when CONFIG_BLOCK=n.
> > So, it is pointless to surround offending code with #ifdef
> > just for the purpose of satisfying the header-test.
> >
> >
> > I started to think
> > compiling all headers is more painful than useful.
> >
> >
> > MW is closing, so I am thinking of disabling it for now
> > to take time to re-think.
> >
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index bd7d650d4a99..cbb31d134f7e 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -111,6 +111,7 @@ config HEADER_TEST
> >  config KERNEL_HEADER_TEST
> >         bool "Compile test kernel headers"
> >         depends on HEADER_TEST
> > +       depends on BROKEN
> >         help
> >           Headers in include/ are used to build external moduls.
> >           Compile test them to ensure they are self-contained, i.e.
> >
> >
> >
> > Maybe, we should compile-test headers
> > only when it is reasonable to do so.
>
> Maybe.  But I would find it easier to use if it were a make target
> instead of a Kconfig symbol, so someone could do
> $ make compile_test_headers


You can do equivalent with this:

$ ./scripts/config -e HEADER_TEST
$ make include/


-- 
Best Regards
Masahiro Yamada
