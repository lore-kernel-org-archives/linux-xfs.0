Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbeI0XwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 19:52:07 -0400
Date: Thu, 27 Sep 2018 10:32:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 00/24] xfs-4.20: major documentation surgery
Message-ID: <20180927173241.GB20086@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
 <20180927085005.21f7e34a@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927085005.21f7e34a@lwn.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 27, 2018 at 08:50:05AM -0600, Jonathan Corbet wrote:
> On Wed, 26 Sep 2018 12:34:14 -0700
> "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > This series converts the existing in-kernel xfs documentation to rst
> > format, links it in with the rest of the kernel's rst documetation, and
> > then begins pulling in the contents of the Data Structures & Algorithms
> > book from the xfs-documentation git tree.  No changes are made to the
> > text during the import process except to fix things that the conversion
> > process (asciidoctor + pandoc) didn't do correctly.  The goal of this
> > series is to tie together the XFS code with the on-disk format
> > documentation for the features supported by the code.
> 
> Some overall comments:
> 
>  - I certainly approve of improving the documentation and bringing it into
>    the docs tree - even if you don't CC the docs maintainer :)

Oops.  Sorry about that. :/

>  - When people do this work, I often end up asking them to think about who
>    the audience is for the documentation.  Developers tend to want to
>    group all of their docs together, but readers - the people the docs are
>    for - tend to have different ideas.
> 
>    So, for example, the xfs.txt document converted in part 1 really, IMO,
>    belongs in the admin guide - it's information for system
>    administrators.  The data structures and algorithms stuff, instead, is
>    aimed at developers.  I would really argue for separating the two.
>    It's more work, but it's friendlier to our readers in the long term,
>    and moves us away from our current pile of unorganized text.

If the xfs.txt file moves to the administration guide, how difficult is
it to have it link to the data structures & algorithms book, and vice
versa?

There's probably more administrative stuff from the old SGI guides that
could be cleaned up and added to the administration guide, but that's
something for later.

>  - CC-SA is a great license for documentation; I would rather use it for
>    all kernel docs.  But I think we head into dangerous territory if we
>    introduce non-GPL-compatible licenses into the kernel documentation.
>    The docs pull a lot of text from the code itself, to the point that it's
>    really hard to say that the processed docs are not a derived product of
>    the kernel code itself.  Do we really want to create a situation where
>    the output of "make *docs" can't be legally distributed?

Well... as discussed in a different part of the thread we can move the
documentation to CC-BY-SA 4.0 trivially, since the old docs were
CC-BY-SA 3.0+.

Relicensing the DS&A book to GPLv2 would be a /much/ bigger lift, one
which would require figuring out exactly which pieces of SGI have gone
where since 2006 and asking those organization(s) to allow relicensing.
I think that's more work than I'm willing to put in on this, since the
alternative would be to keep xfs-documentation.git running.

To address 'pull[ing] a lot of text from the code itself', AFAICT the
code snippets can be classified into three(?) categories:

 1. Structure definitions that were put in the book by someone at SGI
    which roughly speaking resemble what's in the kernel now.  They're
    not directly pulled from fs/xfs/; rather, someone at SGI put them
    in the book and they've been updated to match the kernel irregularly
    and not necessarily concurrently with feature development.

 2. Structure definitions and code put in the book by me; I'm fine with
    licensing those pieces GPLv2+ or CC-BY-SA 3.0+.

 3. Structure definitions and code put in the book by Dave Chinner (and
    anyone else).

Note that the only /code/ in the DS&A book were put there by me
(directory hash function) and Dave (sample metadata verifier functions),
and it probably isn't difficult to get either of us to agree to
relicense.

So... do separate structure definitions that just happen to have the
same layout as the kernel code create a derived product which would
prohibit us from simply having CC-SA 4.0 licensed documentation in the
kernel?

>    Hmm...it looks like we have exactly one document asserting CC-SA now,
>    slipped in by Willy for 4.16.  If I'd noticed it, I would have
>    complained at the time; maybe I'll do so now.  In any case, I think we
>    need to be careful about adding more.

<nod>

--D

> Thanks,
> 
> jon
