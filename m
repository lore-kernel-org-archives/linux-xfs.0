Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E57XgO101070 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 23:07:34 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A08612123CE
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 21:10:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Nyj7DhRBOmjGZuqV for <xfs@oss.sgi.com>;
	Sun, 13 Feb 2011 21:10:08 -0800 (PST)
Date: Mon, 14 Feb 2011 16:10:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Message-ID: <20110214051005.GI2559@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-3-git-send-email-david@fromorbit.com>
	<1297288144.2513.228.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297288144.2513.228.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 09, 2011 at 03:49:03PM -0600, Alex Elder wrote:
> On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Update libxlog with the current 2.6.38 kernel code and well as
> > updating the necessary parts of libxfs and variaous header files to
> > ensure that it compiles correctly.
> 
> OK, I went through this fairly exhaustively.  That being
> said, I only verified that the stuff you are changing
> makes sense as compared to the stuff that was there
> before.  I have not done any significant checks to
> try to be sure the existing code was all good.
> 
> At a very high level, I think this all looks good.
> 
> It points out that there is (or will be) a fairly
> small set of things that need to really differ
> between the kernel and libxfs/libxfslog code.
> I don't expect we'll ever truly converge on one
> set of code, but we probably could come closer to
> that with a little restructuring of some things.
> 
> Since so much of this is code shared with the
> kernel, I think it should be pretty solid.  I
> have a little bit of concern about the things
> that do differ--specifically the problems you
> note in the next patch about the log sector
> size and the inode reference counting.  It
> seems that ought to get a bit more scrutiny
> or testing somehow.  Stuff in "libxfs/logitem.c"
> and "libxfs_trans.c" I didn't really think too
> hard about, for example.

I think they can be dealt with separately to the syncing of the
code. They are relatively small, isolated pieces of work comapred to
the large sync up that needs tobe done first...

> Otherwise, I guess I'll say that I've reviewed
> this code and, with perhaps a little bit of
> trepidation say it looks OK.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  include/Makefile           |    5 +-
> >  include/atomic.h           |   31 ++
> >  include/hlist.h            |   76 +++++
> >  include/libxfs.h           |   17 +-
> >  include/libxlog.h          |   16 +-
> >  include/list.h             |   11 +
> >  include/xfs_buf_item.h     |   50 ++---
> >  include/xfs_extfree_item.h |   17 +-
> >  include/xfs_inode_item.h   |    2 -
> >  include/xfs_log.h          |   70 +++--
> >  include/xfs_log_priv.h     |  331 +++++++++++++++++------
> >  include/xfs_log_recover.h  |   25 +-
> >  include/xfs_trace.h        |    9 +
> >  include/xfs_trans.h        |  648 ++++++--------------------------------------
> >  include/xfs_types.h        |    2 +
> >  libxfs/logitem.c           |  365 +------------------------
> >  libxfs/trans.c             |  209 +++++----------
> >  libxfs/xfs.h               |   12 +-
> >  libxfs/xfs_mount.c         |    1 -
> >  libxfs/xfs_trans.c         |  492 ++++++++++++++++++++++++++++++---
> >  libxlog/xfs_log_recover.c  |  606 ++++++++++++++++++++++-------------------
> >  logprint/log_print_all.c   |   13 +-
> >  logprint/log_print_trans.c |    4 +-
> >  23 files changed, 1431 insertions(+), 1581 deletions(-)
> >  create mode 100644 include/atomic.h
> >  create mode 100644 include/hlist.h
> >  create mode 100644 include/xfs_trace.h
> > 
> 
> . . .
> 
> > diff --git a/include/hlist.h b/include/hlist.h
> > new file mode 100644
> > index 0000000..6d814ab
> > --- /dev/null
> > +++ b/include/hlist.h
> > @@ -0,0 +1,76 @@
> > +/*
> 
> This is a technicality unrelated to the code itself.
> 
> No copyright ownership assertion?  I realize it was
> taken from the kernel headers and therefore you don't
> want to pretend it's your work.  But on the other hand,
> shouldn't *someone* own this particular set of bits?

There is no specific copyright on the kernel header file these
are derived from, so I can't really add anything specific other
than document where it came from....


> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +#ifndef __HLIST_H__
> > +#define __HLIST_H__
> > +
> > +/*
> > + * double-linked hash list with single head implementation taken from linux
> > + * kernel headers.
> 
> Maybe you could add a commit id, or perhaps just a kernel
> version (like 2.6.37) to make more precise the version from
> which this code derives (as long as you're creating a new
> file to contain this).

Sure, I can add "taken from linux kernel header file
include/linux/list.h as of 2.6.38-rc1".

> > diff --git a/include/libxfs.h b/include/libxfs.h
> > index 13fbf79..69b24ac 100644
> > --- a/include/libxfs.h
> > +++ b/include/libxfs.h
> 
> . . .
> 
> > @@ -330,6 +340,7 @@ typedef struct xfs_inode_log_item {
> >  	unsigned short		ili_flags;		/* misc flags */
> >  	unsigned int		ili_last_fields;	/* fields when flushed*/
> >  	xfs_inode_log_format_t	ili_format;		/* logged structure */
> > +	int			ili_lock_flags;
> >  } xfs_inode_log_item_t;
> 
> There is a file "include/xfs_inode_item.c" present in the
> xfsprogs tree (and it would otherwise also need this field
> added to it).  As far as I can tell, nobody uses it.  Do
> you know why it's there?  Would you mind including its
> deletion along with this change?  (There may be other
> similar unused files, but I won't worry about that for
> now.)

It is used by the newer kernel ijoin/trans_iget code that I have not
pooorted the rest of across. I added to the inode item rather than
leave it as an unexplained  difference between the userspace/kernel
header files...

> 
> >  typedef struct xfs_buf_log_item {
> > @@ -353,7 +364,7 @@ typedef struct xfs_trans {
> >  	long		t_fdblocks_delta;	/* superblock fdblocks chg */
> >  	long		t_frextents_delta;	/* superblock freextents chg */
> >  	unsigned int	t_items_free;		/* log item descs free */
> > -	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
> > +	struct list_head	t_items;	/* first log item desc chunk */
> >  } xfs_trans_t;
> 
> Here too, file "include/xfs_trans.h" also defines xfs_trans_t
> but doesn't have a t_items field.  The header file itself does
> not appear to be used.

Sure - that's because userspace doesn't have any of the transaction
infrastructure, and we are using the kernel header files which does
need them. Once again, the cahnge is made to keep the userspace hdr
the same as the kernel hdr even though userspace doesn't use that
field...

> Maybe we do need to do a sweep through
> all the files and kill off the ones that are never used.  Do
> you know the history here, whether/why files like that were
> ever used?  Maybe they are used, and I'm somehow missing it
> with my cscope database.

No, I don't know the exact history - the original xfsprogs code on
Irix used the Irix kernel code and headers directly, but the linux
xfsprogs could not do that. Hence libxfs started out as ijust the
necessary subset of the kernel headers and code that was needed by
xfsprogs. As the code has changed, I'm sure there's bits that are
now unused by userspace and should be cleaned up. We also need to
make another pass over the kernel headers to refine what is in
#idef__KERNEL__ regions as there is some problems in that area as
well.  That doesn't have to be done right now, though...

> . . .
> 
> > diff --git a/include/xfs_extfree_item.h b/include/xfs_extfree_item.h
> > index 2f049f6..375f68e 100644
> > --- a/include/xfs_extfree_item.h
> > +++ b/include/xfs_extfree_item.h
> 
> I think it would be worth noting in the commit message that
> this file is becoming identical to the file in the kernel
> at "fs/xfs/xfs_extfree_item.h".  This is the case for a
> number of other files as well (I'll try to call attention
> to them as I go through).

I don't see much point in adding such messages as the header files
_should_ be identical to the kernel headers. After all, that's the
reason for the "ifdef __KERNEL__" sections of the kernel header
files...

> Actually, I dug a little deeper on this and I see it's
> a bit more complicated than that.  Many of the files
> are becoming identical to their kernel counterparts.
> I'll send something out later with some analysis on that.
> 
> > diff --git a/include/xfs_log.h b/include/xfs_log.h
> > index d47b91f..916eb7d 100644
> > --- a/include/xfs_log.h
> > +++ b/include/xfs_log.h
> 
> The latest change to this file in the kernel source
> changes the return type of xfs_log_commit_cil() to
> void (not reflected in this version for user space).

That's because that commit occurred after I did this sync... ;)

> > diff --git a/include/xfs_trace.h b/include/xfs_trace.h
> > new file mode 100644
> > index 0000000..fef82d0
> > --- /dev/null
> > +++ b/include/xfs_trace.h
> 
> You should add a boilerplate copyright and license
> section to this file.  I realize this will probably
> triple its size...

OK.

> > diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> > index d6ef10b..0856ca6 100644
> > --- a/libxfs/logitem.c
> > +++ b/libxfs/logitem.c
> 
> Stuff in this file I find is generally quite different
> from what's in the kernel.  I'm going to chalk that up
> to some of the stuff that still needs to be sorted out
> between kernel and user space reference counting model.

Partially, also due to the fact there is no journaling subsystemin
userspace and hence a slightly different life cycle for objects...

> I have looked at the differences in the hunks here and
> unless I've noted it I've tried to verify that the
> change looks sensible.
> 
> . . .
> 
> > @@ -250,149 +41,21 @@ xfs_trans_buf_item_match(
> 
> This appears to be identical to the one in the
> kernel, but the spacing is slightly different and
> the header comment differs a bit.  You should
> make them actually identical.

I thought I did. I'll clean it up.

> 
> . . .
> 
> > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > index 1c60f38..c5dd2ca 100644
> > --- a/libxfs/trans.c
> > +++ b/libxfs/trans.c
> > @@ -36,8 +36,7 @@ libxfs_trans_alloc(
> >  	}
> >  	ptr->t_mountp = mp;
> >  	ptr->t_type = type;
> > -	ptr->t_items_free = XFS_LIC_NUM_SLOTS;
> 
> t_items_free is removed from the xfs_trans structure
> in "include/xfs_trans.h" but it remains in the version
> of that structure defined in "include/libxfs.h".
> 
> I believe the latter is the one we want to keep,
> but if that's the case you'd better delete the
> field definition there.  (The compiler isn't
> warning you that you neglected to initialize a
> field.)

Nor is it warning about a duplicate definition by the sound of it.
I'll fix it up.

> 
> > -	xfs_lic_init(&ptr->t_items);
> > +	INIT_LIST_HEAD(&ptr->t_items);
> >  #ifdef XACT_DEBUG
> >  	fprintf(stderr, "allocated new transaction %p\n", ptr);
> >  #endif
> 
> . . .
> 
> > @@ -224,19 +235,14 @@ xfs_trans_log_inode(
> >  	xfs_inode_t		*ip,
> >  	uint			flags)
> >  {
> > -	xfs_log_item_desc_t	*lidp;
> > -
> >  	ASSERT(ip->i_transp == tp);
> >  	ASSERT(ip->i_itemp != NULL);
> >  #ifdef XACT_DEBUG
> >  	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
> >  #endif
> 
> The only difference between this function and the
> one in the kernel is that the kernel has an assert
> here (xfs_isilocked()) rather than the debug fprintf().

That's because there is no inode locking in userspace:

#define xfs_ilock(ip,mode)		((void) 0)

so the assert is meaningless. Knowing that the inode was modified,
however, is actually useful ;)

> > diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
> > index 02bff42..dde9678 100644
> > --- a/libxfs/xfs_mount.c
> > +++ b/libxfs/xfs_mount.c
> > @@ -270,7 +270,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
> >  	mp->m_blockmask = sbp->sb_blocksize - 1;
> >  	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
> >  	mp->m_blockwmask = mp->m_blockwsize - 1;
> > -	INIT_LIST_HEAD(&mp->m_del_inodes);
> 
> This hunk belongs in the next patch, not this one.
> 

OK.

> >  
> >  	/*
> >  	 * Setup for attributes, in case they get created.
> > diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
> > index 9036995..635de8f 100644
> > --- a/libxfs/xfs_trans.c
> > +++ b/libxfs/xfs_trans.c
> 
> This file looks good.
> 
> . . .
> 
> > diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> > index 9e0e567..23fe6fd 100644
> > --- a/libxlog/xfs_log_recover.c
> > +++ b/libxlog/xfs_log_recover.c
> 
> This file looks generally good, but I've made a few notes
> below.
> 
> . . .
> 
> 
> > @@ -82,26 +136,24 @@ xlog_bread(
> 
> . . .
> 
> > +int
> > +xlog_bread(
> 
> This function is marked STATIC in the kernel, not here.
> (They're otherwise identical.)

Because they are used by the logprint code directly. same for all
the other ones.

> > +/*
> > + * Perform the transaction.
> > + *
> > + * If the transaction modifies a buffer or inode, do it now.  Otherwise,
> > + * EFIs and EFDs get queued up by adding entries into the AIL for them.
> > + */
> >  STATIC int
> >  xlog_recover_commit_trans(
> 
> This function differs from the kernel version.  Is this
> an example of where the old ijoin/ihold interface is
> being preserved?

No, it's a reflection that we don't actually do recovery in
userspace. Hence we don't reorder transaction items, nor do we do
multiple passes across the transactions to find cancelled
transactions to avoid replaying them...

> 
> . . .
> 
> > @@ -1148,7 +1179,7 @@ xlog_recover_unmount_trans(
> >  STATIC int
> >  xlog_recover_process_data(
> 
> This function is missing a call to WARN_ON()
> in the case "bad length" gets reported.  Is
> that just because we have no WARN_ON() macro
> already?  The kernel and user space versions
> are otherwise identical.

I just ignored differences like this when merging - the original
userspace code doesn't have any WARN_ON() calls in it at all, so I
didn't merge this one...

I'll fix all these things up. Thanks for looking at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
