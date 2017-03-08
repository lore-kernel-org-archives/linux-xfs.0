Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33008 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbdCHP1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 10:27:00 -0500
Received: by mail-qk0-f180.google.com with SMTP id y76so71250161qkb.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 07:26:19 -0800 (PST)
Message-ID: <1488986774.2802.18.camel@poochiereds.net>
Subject: Re: statx manpage
From: Jeff Layton <jlayton@poochiereds.net>
Date: Wed, 08 Mar 2017 10:26:14 -0500
In-Reply-To: <17753.1488965058@warthog.procyon.org.uk>
References: <91D9638E-C96A-4D1E-9712-5D6543048700@dilger.ca>
         <20170307050140.GA12946@infradead.org>
         <20170307000609.GG5280@birch.djwong.org>
         <10435.1488907375@warthog.procyon.org.uk>
         <17753.1488965058@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Wed, 2017-03-08 at 09:24 +0000, David Howells wrote:
> Andreas Dilger <adilger@dilger.ca> wrote:
> 
> > > (Note that reserved space and padding is ommitted)
> > 
> > Do you think that not including the padding could be problematic for users?
> 
> Interesting question.  Do you think it would be?  I don't see why it should be
> a problem, since they shouldn't be touching it anyway.  Also, the stat(2)
> manpage also gives the same warning and omits padding and doesn't seem to have
> been amended.
> 
> But if you would prefer, I can put it back.
> 
> The only reason I can really see for explicitly including it is to say that
> this is where future extensions will go.
> 

It seems like we really ought to have 2 statx manpages:

A small statx(2) manpage that describes the kernel<->userland interface
(showing structs with padding), and then the "real" statx(3) manpage
that shows the glibc userland API.

The kernel<->userland one could be very small, and just say "This is not
the function you're interested in. Look at statx(3) for the C library
interface.", similar to what readdir(2) does.


> > > STATX_ATTR_IMMUTABLE	File is marked immutable
> > 
> > ...
> > > STATX_ATTR_APPEND	File is append-only
> 
> I should copy the definitions in chattr(1).
> 
> >    To test whether a path is a regular file (for example), one could write:
> >    .nf
> >    .in +4n
> >    rc = statx(AT_FDCWD, pathname, 0, STATX_TYPE, &stx);
> >    if (stx.stx_mask & STATX_TYPE && S_ISREG(sb.stx_mode)) {
> >       /* Handle regular file */
> >    }
> 
> Good idea.

Note that & and && have similar precedence, IIRC, so you probably want
to wrap that flag check in parenthesis.

> 
> > > Because tests of the above form are common, additional macros are defined by
> > > POSIX to allow the test of the file type in
> > > .I stx_mode
> > > to be written more concisely:
> > 
> > Should this all just reference the existing stat(2) man page instead of
> > duplicating the whole contents here?  This is spending a lot of space
> > discussing the stx_mode field which could be avoided.
> 
> Possibly.  On the other hand, it means that everything you need to refer to is
> in one page from the user's PoV.  I'm not sure what the best policy on this
> is.
> 
> If I do defer to stat(2), I do need to make some sort of note that the
> examples are different and the field name is stx_mask, not st_mask.
> 

If the plan is to eventually (in some far away future) to deprecate
stat(), then we probably don't want this manpage to refer to it as a
canonical source of information. I say duplicate it here.

It might also not hurt to consider updating the stat(2) manpage with a
NOTE that points to the statx manpage as well.

-- 
Jeff Layton <jlayton@poochiereds.net>
