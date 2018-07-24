Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388470AbeGXU5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 16:57:09 -0400
Date: Tue, 24 Jul 2018 12:48:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] libxfs: remove crc32 functions
Message-ID: <20180724194854.GY4813@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728634020.22515.16684194597988861920.stgit@magnolia>
 <29c32d83-dfe8-8780-1808-f2c019a78fc5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29c32d83-dfe8-8780-1808-f2c019a78fc5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 03:55:46PM -0700, Eric Sandeen wrote:
> On 5/25/18 3:12 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > XFS uses crc32c, not crc32.  Remove the unnecessary crc32 code, which
> > decreases binary size by the 8K crc32 table.
> 
> Getting back to this ...
> 
> The files have diverged a bit since the initial lift from the kernel.

They've diverged a lot -- in the kernel there's code for some sort of
software parallelized computation, and the self test code has been moved
to a separate file.  There's enough difference in the preprocessor code
that I think we might be better off just removing all the cruft except
for the bare minimum code we need + test code.

The giant ugly table of self test code was created to check the fast
crc32* computations against the slow bit-by-bit versions, so as long as
we maintain the same input and output tables in userspace I don't think
we have much to worry about wrt breakage.

TBH this discussion has also convinced me that perhaps it would be
useful to add a crc test command to xfs_db so that we can have xfstests
run the crc32selftest code on any xfstests target instead of just the
distro package build machines and developers' workstations.

--D

> Commenting out to keep things diffable is a bit pointless now, due
> to that divergence (for example, the crc32test stuff has been moved
> out to its own file, a big swath of code.)
> 
> So, I think we should make a decision about whether we want to try
> to keep this in sync with the kernel, or just let it drift.
> 
> If the former, I'd go with an #if 0 but only after syncing things
> up again.
> 
> If the latter, just nuke the unused code, if we ever need the crc32c
> variants we can re-lift them from the kernel.  I'd still take a brief
> look at whether there's anything that needs to be synced in an ad-hoc
> fashion.
> 
> I guess right now I'm feeling inclined to go with the former, and
> even add the crc32 file(s) to the libxfs-diff and/or libxfs-apply
> scripts, if we plan to keep them more in sync.
> 
> I'd accept either plan, really - but there's no reason to comment
> out or #ifdef code to keep it around if it doesn't even necessarily
> match kernelspace anymore.
> 
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/libxfs.h        |    3 ---
> >  libxfs/crc32.c          |   16 ++++++++++------
> >  libxfs/gen_crc32table.c |    8 +++++++-
> >  libxfs/libxfs_priv.h    |    3 ---
> >  4 files changed, 17 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/include/libxfs.h b/include/libxfs.h
> > index fbaae089..109866de 100644
> > --- a/include/libxfs.h
> > +++ b/include/libxfs.h
> > @@ -43,10 +43,7 @@
> >  
> >  
> >  /* CRC stuff, buffer API dependent on it */
> > -extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
> >  extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
> > -
> > -#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
> >  #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
> >  
> >  #include "xfs_cksum.h"
> > diff --git a/libxfs/crc32.c b/libxfs/crc32.c
> > index 783d62e9..8fe5c42c 100644
> > --- a/libxfs/crc32.c
> > +++ b/libxfs/crc32.c
> > @@ -176,20 +176,26 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
> >  }
> >  
> >  #if CRC_LE_BITS == 1
> > +/*
> > + * not used by xfs.
> >  u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
> >  {
> >  	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
> >  }
> > + */
> 
> ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
