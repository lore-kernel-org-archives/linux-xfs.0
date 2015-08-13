Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2DFC7F50
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 03:46:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 604ACAC004
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 01:46:54 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id krnmnPV9GgVrcNgM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 01:46:52 -0700 (PDT)
Date: Thu, 13 Aug 2015 10:46:47 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfsprogs: Fix attr leaf block definition
Message-ID: <20150813084647.GB26599@quack.suse.cz>
References: <1439387594-8747-1-git-send-email-jack@suse.com>
	<20150813012940.GO3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813012940.GO3902@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.com>

On Thu 13-08-15 11:29:40, Dave Chinner wrote:
> On Wed, Aug 12, 2015 at 03:53:14PM +0200, Jan Kara wrote:
> > struct xfs_attr_leafblock contains 'entries' array which is declared
> > with size 1 altough it can in fact contain much more entries. Since this
> > array is followed by further struct members, gcc (at least in version
> > 4.8.3) thinks that the delared size of the array is the real one and
> > thus optimizes away all accesses beyond the end of array resulting in
> > non-working code.
> 
> What are the symptoms displayed by this "non-working code"? I'm
> using 4.9.3 (more recent than 4.8.3) for all my kernel and xfsprogs
> testing, and I'm not seeing any issues....

Sorry for not revealing all the details. The real failure actually happened
with somewhat older version of xfsprogs (3.1.8) to which I was backporting
xfs_metadump fixes. The manifestation of the problem was that loop in
process_attr_block() was taken only once instead of being taken 'nentries'
times.

Somehow the code in current xfsprogs is reorganized enough that the same
compiler didn't decide to do the optimization. Not sure why but certainly
the compiler is allowed to optimize away accesses beyond end of array since
they are undefined and gcc heuristics on identifying "struct hack" (flexible
sized array) don't trigger when there are further elements in the struct.
 
> > Signed-off-by: Jan Kara <jack@suse.com>
> > ---
> >  include/xfs_da_format.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
> > index 11f142078e12..39bfeb042844 100644
> > --- a/include/xfs_da_format.h
> > +++ b/include/xfs_da_format.h
> > @@ -1180,8 +1180,14 @@ typedef struct xfs_attr_leaf_name_remote {
> >  typedef struct xfs_attr_leafblock {
> >  	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
> >  	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
> > +	/*
> > +	 * Definitions below are commented out so that gcc doesn't optimize
> > +	 * away accesses into 'entries' for indexes larger than 1
> > +	 */
> > +#if 0
> >  	xfs_attr_leaf_name_local_t namelist;	/* grows from bottom of buf */
> >  	xfs_attr_leaf_name_remote_t valuelist;	/* grows from bottom of buf */
> > +#endif
> >  } xfs_attr_leafblock_t;
> 
> So this same declaration is in the kernel code.
> 
> FWIW, if you look at the struct xfs_attr3_leafblock, this
> structure is declared like this:
> 
> struct xfs_attr3_leafblock {
>         struct xfs_attr3_leaf_hdr       hdr;
>         struct xfs_attr_leaf_entry      entries[1];
> 
>         /*
>          * The rest of the block contains the following structures after the
>          * leaf entries, growing from the bottom up. The variables are never
>          * referenced, the locations accessed purely from helper functions.
>          *
>          * struct xfs_attr_leaf_name_local
>          * struct xfs_attr_leaf_name_remote
>          */
> };
> 
> This situation is the same - the xfs_attr_leafblock variables are
> only accessed by helper functions that return pointers. Can you
> modify the declaration to match the xfs_attr3_leafblock declaration?

Sure I didn't notice the kernel has done it differently. I'll send an
updated patch.

> FWIW, if gcc 4.8.3 is producing non-working xfsprogs code due to
> these declarations, then I have to wonder if it is also generating
> bad kernel code. There's also a bigger issue: XFS uses the array[1]
> declaration technique for several variable size structures across
> the code base. Are all of these declarations resulting in gcc 4.8.3
> doing the wrong thing? Or does the problem only manifest when the
> array definition is followed by more variables?

So using array[1] for flexible sized array has always been undefined
according to C standard but people use it and compiler people kept it
working. But it has always been a fuzzy thing - apparently there are
heuristics in gcc determining whether array[1] is actually a flexible size
array (accesses beyond end are kept) or normal array (accesses beyond end
are undefined). When the array is at the end of struct, I'd hope it is
always considered a flexible size array (otherwise too much code would
break and we'd notice quickly). When the array is in the middle of the
struct I can understand that the compiler decided this isn't a flexible
size array and started to optimize.

> If the problem does not manifest in the second case, why is this
> inconsistency not considered a broken compiler optimisation?
> 
> Hence I'm guessing we need to convert all the "array[1]"
> definitions for variable sized arrays in XFS structures to "array[]"
> to avoid gcc making wrong assumptions about the code? i.e: all of
> these in kernel space:

Using array[] is definitely a safer option than array[1] since there the
behavior is well defined by C99 standard and you don't have to rely on gcc
heuristics (similarly safe is also array[0]).

> $ git grep "\[1\];" fs/xfs/*.h fs/xfs/*/*.h
> fs/xfs/libxfs/xfs_attr_sf.h:            __uint8_t nameval[1];   /* name & value bytes concatenated */
> fs/xfs/libxfs/xfs_attr_sf.h:    } list[1];                      /* variable sized array */

This one is interesting but likely OK...

> fs/xfs/libxfs/xfs_da_format.h:  __u8    nameval[1];             /* name/value bytes */
> fs/xfs/libxfs/xfs_da_format.h:  __u8    name[1];                /* name bytes */

These two are safe.

> fs/xfs/libxfs/xfs_da_format.h:  xfs_attr_leaf_entry_t   entries[1];     /* sorted on key, not name */

Here gcc could optimize I think.

> fs/xfs/libxfs/xfs_da_format.h:  struct xfs_attr_leaf_entry      entries[1];
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_t            efi_extents[1]; /* array of extents to free */
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_32_t         efi_extents[1]; /* array of extents to free */
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_64_t         efi_extents[1]; /* array of extents to free */
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_t            efd_extents[1]; /* array of extents freed */
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_32_t         efd_extents[1]; /* array of extents freed */
> fs/xfs/libxfs/xfs_log_format.h: xfs_extent_64_t         efd_extents[1]; /* array of extents freed */
> fs/xfs/xfs_attr.h:      __s32   al_offset[1];   /* byte offsets of attrs [var-sized] */
> fs/xfs/xfs_attr.h:      char    a_name[1];

These are all safe.

> ----
> 
> FWIW, I'm getting quite worried by the reports over the past year or
> so about different versions of gcc compilers that produce
> "non-working" XFS code. e.g.  the ARM do_div() kernel bug that only
> manifests on certain compiler versions with certain optimisation
> options, the reports of certain versions of gcc intel->arm
> cross-compilers producing broken code, etc.
> 
> I used to not have to think about whether the compiler generated
> good code or not - if we now have to start considering that the
> compiler is equally suspect as a random user's hardware then we're
> being put in a really, really bad situation here....

Yeah, compiler issues are bad (it took me the whole morning to figure this
particular issue out). The issue is that we sometimes rely on undefined
behavior and when compiler people decide how that behaves, we are screwed
(and I'm sometimes surprised by the amount of things that are undefined by
the standard).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
