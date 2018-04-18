Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:42132 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbeDRHPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 03:15:11 -0400
Received: by mail-wr0-f194.google.com with SMTP id s18-v6so1764192wrg.9
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 00:15:10 -0700 (PDT)
Date: Wed, 18 Apr 2018 09:15:05 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Assertion fails on xfs_db when setting erroneous type
Message-ID: <20180418071505.aoal4utub2gtvzlw@odin.usersys.redhat.com>
References: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
 <20180417153355.GA24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417153355.GA24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 08:33:55AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 17, 2018 at 02:23:51PM +0200, Carlos Maiolino wrote:
> > Hi,
> > 
> > recently while playing with a FS image, I've hit an assertion in xfs_db:
> > 
> > xfs_db: print.c:164: print_flist_1: Assertion `fa->arg & 64' failed.
> > Aborted (core dumped)
> > 
> > The reason for this assert was that I tried to print a remote attr3 block, after
> > having set the block pointer to a random, no attr3 location.
> > 
> > I wonder if crashing xfs_db here is the right thing to do?
> > 
> > 
> > I've written a small workaround for it as below:
> > 
> > 
> > @@ -160,9 +160,10 @@ print_flist_1(
> >                                         (f->flags & FLD_ARRAY) != 0);
> >                                 if (neednl)
> >                                         dbprintf("\n");
> > -                       } else {
> > -                               ASSERT(fa->arg & FTARG_OKEMPTY);
> > +                       } else if (fa->arg & FTARG_OKEMPTY) {
> >                                 dbprintf(_("(empty)\n"));
> > +                       } else {
> > +                               dbprintf(_("Invalid arg\n"));
> 
> "Unrecognized metadata\n" ?

Agreed, the message "Invalid arg" was just the first thing that came to my mind
while looking into this, I didn't spend too much time thinking about what would
be a better message, but the Unrecognized metadata message makes more sense for
sure.

Thanks for the review, time to see Eric's comment and work on the decent fix.
Will submit it today yet.

Cheers

> 
> The block space pointer that got us here wasn't necessarily invalid,
> it's just that we don't recognize the block as matching whatever type is
> selected in the io cursor.
> 
> >                         }
> >                 }
> >                 free_strvec(pfx);
> > 
> > 
> > I wonder if something like this makes sense or not? I'm still familiarizing
> > myself with xfs_db code, so I'm not sure if something as the small patch above
> > is a valid fix for it or not, but I believe exiting xfs_db just because somebody
> > tried to print a metadata block using a different type from the on-disk block
> > being read doesn't look like the right thing to do.
> 
> Funny, I've had a debug patch squirreled away in my xfsprogs tree for
> ages to teach those ASSERTs not to abort the binary (which then sprays
> core files everywhere).  This one has been particularly annoying, so...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > 
> > Comments?
> > 
> > Cheers
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
