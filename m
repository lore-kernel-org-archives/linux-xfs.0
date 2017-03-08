Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38579 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdCHJfi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:35:38 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <91D9638E-C96A-4D1E-9712-5D6543048700@dilger.ca>
References: <91D9638E-C96A-4D1E-9712-5D6543048700@dilger.ca> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17752.1488965058.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Mar 2017 09:24:18 +0000
Message-ID: <17753.1488965058@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Andreas Dilger <adilger@dilger.ca> wrote:

> > (Note that reserved space and padding is ommitted)
> 
> Do you think that not including the padding could be problematic for users?

Interesting question.  Do you think it would be?  I don't see why it should be
a problem, since they shouldn't be touching it anyway.  Also, the stat(2)
manpage also gives the same warning and omits padding and doesn't seem to have
been amended.

But if you would prefer, I can put it back.

The only reason I can really see for explicitly including it is to say that
this is where future extensions will go.

> > STATX_ATTR_IMMUTABLE	File is marked immutable
> ...
> > STATX_ATTR_APPEND	File is append-only

I should copy the definitions in chattr(1).

>    To test whether a path is a regular file (for example), one could write:
>    .nf
>    .in +4n
>    rc = statx(AT_FDCWD, pathname, 0, STATX_TYPE, &stx);
>    if (stx.stx_mask & STATX_TYPE && S_ISREG(sb.stx_mode)) {
>       /* Handle regular file */
>    }

Good idea.

> > Because tests of the above form are common, additional macros are defined by
> > POSIX to allow the test of the file type in
> > .I stx_mode
> > to be written more concisely:
> 
> Should this all just reference the existing stat(2) man page instead of
> duplicating the whole contents here?  This is spending a lot of space
> discussing the stx_mode field which could be avoided.

Possibly.  On the other hand, it means that everything you need to refer to is
in one page from the user's PoV.  I'm not sure what the best policy on this
is.

If I do defer to stat(2), I do need to make some sort of note that the
examples are different and the field name is stx_mask, not st_mask.

David
