Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdGNTHp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 15:07:45 -0400
Date: Fri, 14 Jul 2017 15:07:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Parent pointers
Message-ID: <20170714190740.GA43494@bfoster.bfoster>
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Allison Henderson <allison.henderson@oracle.com>, cmaiolino@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jul 14, 2017 at 01:46:27PM -0500, Eric Sandeen wrote:
> On 07/14/2017 12:44 PM, Allison Henderson wrote:
> > On 7/14/2017 7:04 AM, Eric Sandeen wrote:
> >>
> >>
> >> On 07/14/2017 03:50 AM, Carlos Maiolino wrote:
> >>> Hi,
> >>>
> >>> On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
> >>>> Hi all,
> >>>>
> >>>> I've been doing some digging on adding parent pointers to xfs and wanted to
> >>>> send a note to folks here to get peoples opinions on it.
> >>>
> >>> Are you talking about parent pointers in the BTrees?
> >>>
> >>
> >> No, see [RFC 00/17] RFC parent inode pointers. for example, from long
> >> ago.
> >>
> >> "Parent inode support allow XFS to quickly derive a file name and
> >> path from the mount point. This can aid in directory/path policies
> >> and can help relocate items during filesystem shrink."
> >>
> >> It has a long and ... difficult history.
> >>
> >> -Eric
> > Right, so to expand on Eric's answer, it looks like Dave and Brian had been working on some improvements based on that set, but it's not quite finished yet.  The idea is that we add an extended attribute to keep track of the parents inode and generation, and also the child entries offset, and filename. So in this solution the EA is name={parent inode #, parent inode generation, dirent offset}, value={dirent filename}.
> > 
> > My goal at the moment is just to get it compiling again and finish out some of the sub routines that maintain it.  It looks like it hasn't had much attention in a while, so I wanted to let people know the direction I'm planning to move in before I get too far in.
> 
> If you're forward-porting that 17-patch set from Mark, I'd suggest first reading Dave's
> response to it - IIRC it amounted to a firm NAK.  it also highlights the complexity
> of this undertaking, and may explain why nobody has gotten it done (yet) :)
> 

The patches that came from me (to Allison) were last sent to me directly
from Dave. I know he had some objections to the original design, but my
understanding was that he had incorporated fixes for those issues in his
modifications to Mark's original series (such as the xattr format and
whatnot), but the series wasn't completely done yet in terms of
supporting all possible directory operations. (It's probably a good idea
to review that old thread anyways just to confirm, unless Dave catches
this and is able to chime in one way or the other.)

I basically just forwarded ported Dave's patches to more recent kernels
and added a couple minor fixes as I had combed through the existing
code. I never really got to adding anything of substance before Allison
volunteered to take over the series.

FWIW, I think there was some mention of porting some of the operations
over to the deferred ops infrastructure, but it's not clear to me off
the top of my head how important (or appropriate) that is. It's
something to keep in mind, in any event. IIRC there were also missing
Signed-off-by's required for some of Mark's original patches. IMO, the
best next step might be to just finish off the implementation as-is such
that we could have a fairly functional RFC to put on the list and hash
out whether there are in fact any remaining design hurdles, but others
might have a different opinion on that. :)

Brian

> -Eric
>  
> > Allison
> >>
> >>>> I got in touch
> >>>> with Brian Foster not too long ago and he had some code partially done from
> >>>> about a year or so ago (looks like it has patches from Dave Chinner and Mark
> >>>> Tinguely as well).  So I am hoping to be able to use what we have so far to
> >>>> create something updated and finished out.  I am still pretty new to the xfs
> >>>> code, so at the moment I am still just going through old discussion threads,
> >>>> and reviewing the patches.  But for the most part I just wanted to see what
> >>>> people thought and get everyone on board with the idea.  Suggestions and
> >>>> feedback are much appreciated. Thank you!!
> >>>>
> >>>
> >>> It will be better if you can describe in more details if you have any specific
> >>> goal with this, and/or what kind of improvement you expect to have with it,
> >>> adding something new without a reason, is usually not well received.
> >>>
> >>> Cheers
> >>>
> >> -- 
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
