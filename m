Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754772AbdDFMkM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 08:40:12 -0400
Date: Thu, 6 Apr 2017 14:40:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [xfsprogs] Do we need so many data types for user input?
Message-ID: <20170406124010.GI28800@wotan.suse.de>
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de>
 <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
 <CACj3i73u11rNPK701aVm07qOPpT2r-1r_m--iW-D6SwLfb-pbw@mail.gmail.com>
 <83915e74-6198-4b0a-9aff-96cdedfad97a@sandeen.net>
 <CACj3i71xWPTZRUE+mF5CNT4OsfJEKstvgJPEviEOC9d=U3noAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71xWPTZRUE+mF5CNT4OsfJEKstvgJPEviEOC9d=U3noAA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Apr 05, 2017 at 04:24:18PM +0200, Jan Tulak wrote:
> On Wed, Apr 5, 2017 at 4:08 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > On 4/5/17 3:26 AM, Jan Tulak wrote:
> >> On Tue, Apr 4, 2017 at 10:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >>> On 4/4/17 2:48 PM, Luis R. Rodriguez wrote:
> >>>>
> >>>> And then agsize is capped artificially later via validate_ag_geometry():
> >>>>
> >>>>         if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
> >>>>               ...
> >>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
> >>>>               ...
> >>>>       if (agsize > dblocks) {
> >>>>               ...
> >>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
> >>>>               ...
> >>>>
> >>>> Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.
> >>>
> >>> .maxval = XFS_AG_MAX_BYTES,
> >>>
> >>> #define XFS_AG_MAX_BYTES        ((XFS_AG_BYTES(31)))    /* 1 TB */
> >>> #define XFS_AG_BYTES(bblog)     ((long long)BBSIZE << (bblog))
> >>>
> >>> so the maximum is (long long)(512) << 31
> >>>
> >>> so, no - agsize won't fit in a 32 bit var, if that's the question...
> >>>
> >>
> >> Yeah. I think that we can make it uint64 everywhere unless it is
> >> causing an issue in a specific case with a bit shift or something, and
> >> just limit the input value where appropriate explicitly.
> >>
> >>
> >> And...
> >>> And at the end of the day, we are converting all numbers into unsigned
> >>
> >> I take back this part, we are going through long long, not unsigned long long.
> >> Everything else is still valid.
> >
> > Ok, for those who aren't immersed 24/7 in mkfs ;) can you help us understand
> > where you're going with this?  What's the change you're proposing, and how
> > does it help?
> >
> 
> If you ask only about the last sentence - I was just taking back my
> claim that we already convert all numbers into unsigned in getnum. We
> convert them to long long right now.

Yes but this is just general best practice -- typically strtoll() is used
and then folks cast as needed, this is done to avoid loosing information.
The casting is also where a lot of potential bugs can lurk.

getnum() returns long long, we currently cast this mostly to int.

> (It was too late evening for me,
> apparently. :-) )
> 
> If you ask more about summarising what I want to do, then:
> 
> I'm already moving these standalone variables into an options table,
> that holds all the information in one place. As I'm already touching
> them, I can as well clean the differences and changes accumulated over
> the years and change a lot of mkfs's internal variables from a mix of
> signed and unsigned, 32bit and 64bit, to a single type, unsigned
> 64bits long.
> 
> That would simplify the code in some places and make it clear what
> type numerical values are - less things like foo((long long) bar);

Yes please ! Modulo -- as I noted I think in practice this may be:

a) self contained work -- if the changes from say int to another unsigned
   type on xfs_mkfs.c only affect this file.

b) a lot changes: if the type changes require much more changes to API calls
   outside of this xfs_mkfs.c file, say when the file calls to helpers.

I think a) seems reasonable to do now. b) I think this should be welcomed but
it means much more patches to your series, so if it turns out to be a lot
perhaps best left as a secondary effort for later. I don't think it clear
where this falls yet.

  Luis
