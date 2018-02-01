Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55000 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbeBARId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 12:08:33 -0500
Date: Thu, 1 Feb 2018 09:08:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Add missing braces around xfs_scrub_agfl_info
 initializer
Message-ID: <20180201170826.GP4849@magnolia>
References: <1517480584-4588-1-git-send-email-geert@linux-m68k.org>
 <CAK8P3a1N-Yh65y6bEb+d7DwVOqB8ee=T1gM1cc7k6=cg1c3Jtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK8P3a1N-Yh65y6bEb+d7DwVOqB8ee=T1gM1cc7k6=cg1c3Jtw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Feb 01, 2018 at 12:31:36PM +0100, Arnd Bergmann wrote:
> On Thu, Feb 1, 2018 at 11:23 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > With gcc-4.1.2:
> >
> >     fs/xfs/scrub/agheader.c: In function ‘xfs_scrub_agfl’:
> >     fs/xfs/scrub/agheader.c:770: warning: missing braces around initializer
> >     fs/xfs/scrub/agheader.c:770: warning: (near initialization for ‘sai.oinfo’)
> >
> > The first member of struct xfs_scrub_agfl_info is no longer an integral
> > type, but a struct.  Add the missing curly braces to fix this.
> 
> I suspect gcc-4.5 is affected as well, but not 4.6+
> 
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -767,7 +767,7 @@ int
> >  xfs_scrub_agfl(
> >         struct xfs_scrub_context        *sc)
> >  {
> > -       struct xfs_scrub_agfl_info      sai = { 0 };
> > +       struct xfs_scrub_agfl_info      sai = { { 0 } };
> >         struct xfs_agf                  *agf;
> 
> Looks ok to me, but
> 
>         struct xfs_scrub_agfl_info      sai = { };
> 
> might be slightly better in case the first member changes again.

Frankly I'd rather see it changed to memset(&sai, 0, sizeof(sai)); and
stop having to field all these gcc warnings that vary depending on
compiler version...

--D

> 
>      Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
