Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41533 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430815AbdDZBih (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:38:37 -0400
Date: Wed, 26 Apr 2017 03:38:15 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Message-ID: <20170426013815.GS28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
 <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
 <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 08:28:23AM -0500, Eric Sandeen wrote:
> On 4/25/17 2:45 AM, Jan Tulak wrote:
> > On Tue, Apr 25, 2017 at 5:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> >> On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
> >>> Merge separate instances of opt_params into one indexable table. Git
> >>> makes this patch looks a bit more complicated, but it does not change
> >>> values or structure of anything else. It only moves all the "struct
> >>> opt_params dopts = {...}", changes indentation for these substructures
> >>> and replaces their usage (dopts -> opts[OPT_D]).
> >>>
> >>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >>> ---
> >>>  mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
> >>>  1 file changed, 683 insertions(+), 633 deletions(-)
> >>>
> >>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >>> index 7a72b11..513e106 100644
> >>> --- a/mkfs/xfs_mkfs.c
> >>> +++ b/mkfs/xfs_mkfs.c
> >>> @@ -42,6 +42,7 @@ static int  ispow2(unsigned int i);
> >>>  uint64_t             blocksize;
> >>>  uint64_t             sectorsize;
> >>>
> >>> +#define MAX_OPTS     16
> >>
> >> This is fragile, every time a new opt is added this needs to be updated
> 
> <pedantic>There are only 8 now, so there are still 8 free slots</pedantic>
> 
> >> and so is the index, and we should be pedantic over not going out of bounds.
> >> We could instead use a flexible array and compute the max opts at run time
> >> as a global. This way the max opts is always updated automatically.
> 
> I don't think it's all that fragile;

We can avoid such compilation warnings.

> this is used only for a global structure
> declaration & initialization.

*Currently used*. I'll later use it to bail out early if the mkfs.xfs.conf stat
file size is too big compared to what we max expect prior letting a library
chew on data. This lets us bail out early instead of having the library stall.
Its a rare corner case but can easily be considered and dealt with.

> If you add too many new members to opt_params,
> compilation will issue warnings:
> 
> xfs_mkfs.c:342: warning: excess elements in array initializer
> xfs_mkfs.c:342: warning: (near initialization for ‘opts’)
> xfs_mkfs.c:424: warning: excess elements in array initializer
> xfs_mkfs.c:424: warning: (near initialization for ‘opts’)
> xfs_mkfs.c:543: warning: excess elements in array initializer
> xfs_mkfs.c:543: warning: (near initialization for ‘opts’)
> ...

Warnings are not treated as failures though AFAICT, and if you fly
by through then yes, its fragile and will crash with out of bound
array access / segfault.

> and it will be quite obvious, at which point you can bump it up before
> you send that patch.  ;)

Mater of taste I guess, but then again I tend to only deal with kernel code and
to me the above is just recipe for disaster.

> Anyway, because the the definition is never used at runtime, there's
> no need to be computing it at runtime, either.

Not currently used at run time. I do plan on using it later at run time but its
for a rather odd corner case to avoid stalls on parsing  a large file when we
know its just not possible to be parsing it.

> > Mmm, that is a good idea and I see no issue with it. But I'm not sure
> > if it is worth of rewriting this patch as we already use MAX_SUBOPTS
> > anyway. Rather I see it as a standalone patch in the next set. What do
> > you think?
> 
> I think that given how it's used, there is no real need for any extra
> complexity.

I find it much simpler, but that seems to be subjective.

> In any case, any changes around this behavior would certainly
> be part of a different patch, because you'd want to be consistent with all
> the other structure initializers, and it would be a functionally separate
> change if it is warranted at all.

The opt_params are separate today though, this patch folds them in together,
what I propose is just to use a flexible array to avoid an explicit size
from the start. Not sure how much more functional of a change that is ?

  Luis
