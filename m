Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:33822 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759297AbdCVKzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 06:55:13 -0400
Received: by mail-qt0-f172.google.com with SMTP id n21so150508621qta.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2017 03:55:12 -0700 (PDT)
Message-ID: <1490180109.2593.13.camel@poochiereds.net>
Subject: Re: statx manpage
From: Jeff Layton <jlayton@poochiereds.net>
Date: Wed, 22 Mar 2017 06:55:09 -0400
In-Reply-To: <20170320160127.GB31556@bombadil.infradead.org>
References: <91D9638E-C96A-4D1E-9712-5D6543048700@dilger.ca>
         <20170307050140.GA12946@infradead.org>
         <20170307000609.GG5280@birch.djwong.org>
         <10435.1488907375@warthog.procyon.org.uk>
         <17753.1488965058@warthog.procyon.org.uk>
         <1488986774.2802.18.camel@poochiereds.net>
         <20170320160127.GB31556@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, 2017-03-20 at 09:01 -0700, Matthew Wilcox wrote:
> On Wed, Mar 08, 2017 at 10:26:14AM -0500, Jeff Layton wrote:
> > On Wed, 2017-03-08 at 09:24 +0000, David Howells wrote:
> > > Andreas Dilger <adilger@dilger.ca> wrote:
> > > >    To test whether a path is a regular file (for example), one could write:
> > > >    .nf
> > > >    .in +4n
> > > >    rc = statx(AT_FDCWD, pathname, 0, STATX_TYPE, &stx);
> > > >    if (stx.stx_mask & STATX_TYPE && S_ISREG(sb.stx_mode)) {
> > > >       /* Handle regular file */
> > > >    }
> > > 
> > > Good idea.
> > 
> > Note that & and && have similar precedence, IIRC, so you probably want
> > to wrap that flag check in parenthesis.
> 
> They're actually pretty far apart.  & is priority 8 and && is priority 11.
> But the fact that you thought they were similar shows that most of
> us don't really know what C's operator precedence is (beyond + and *)
> and we should err on the side of clarity by using the unnecessary parens.
> 

Ahh, good to know. My rules are generally: multiplication and division
come before addition and subtraction, and put parenthesis around
everything else. :)

> > If the plan is to eventually (in some far away future) to deprecate
> > stat(), then we probably don't want this manpage to refer to it as a
> > canonical source of information. I say duplicate it here.
> 
> We haven't even deprecated select() in favour of poll() ... indeed,
> pselect() was added.  I can't imagine stat() ever being deprecated.

Ok, deprecated is probably the wrong choice of words. You're correct
that we'll never be able to fully rip it out just due to the volume of
old programs that use it.

My thinking is that statx will come to supplant stat in newer code, and
stat will eventually become a "legacy" syscall. Typically we don't want
to have to refer to "legacy" manpages for canonical info in new
interfaces. If anything we may want to remove that info from stat(2)
manpage and have it refer to statx(2) for it.
-- 
Jeff Layton <jlayton@poochiereds.net>
