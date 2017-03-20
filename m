Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754077AbdCTQEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2017 12:04:14 -0400
Date: Mon, 20 Mar 2017 09:01:27 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: statx manpage
Message-ID: <20170320160127.GB31556@bombadil.infradead.org>
References: <91D9638E-C96A-4D1E-9712-5D6543048700@dilger.ca>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <17753.1488965058@warthog.procyon.org.uk>
 <1488986774.2802.18.camel@poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488986774.2802.18.camel@poochiereds.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@poochiereds.net>
Cc: David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 08, 2017 at 10:26:14AM -0500, Jeff Layton wrote:
> On Wed, 2017-03-08 at 09:24 +0000, David Howells wrote:
> > Andreas Dilger <adilger@dilger.ca> wrote:
> > >    To test whether a path is a regular file (for example), one could write:
> > >    .nf
> > >    .in +4n
> > >    rc = statx(AT_FDCWD, pathname, 0, STATX_TYPE, &stx);
> > >    if (stx.stx_mask & STATX_TYPE && S_ISREG(sb.stx_mode)) {
> > >       /* Handle regular file */
> > >    }
> > 
> > Good idea.
> 
> Note that & and && have similar precedence, IIRC, so you probably want
> to wrap that flag check in parenthesis.

They're actually pretty far apart.  & is priority 8 and && is priority 11.
But the fact that you thought they were similar shows that most of
us don't really know what C's operator precedence is (beyond + and *)
and we should err on the side of clarity by using the unnecessary parens.

> If the plan is to eventually (in some far away future) to deprecate
> stat(), then we probably don't want this manpage to refer to it as a
> canonical source of information. I say duplicate it here.

We haven't even deprecated select() in favour of poll() ... indeed,
pselect() was added.  I can't imagine stat() ever being deprecated.
