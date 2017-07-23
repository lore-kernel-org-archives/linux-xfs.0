Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:23982 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751731AbdGWXqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 19:46:05 -0400
Date: Mon, 24 Jul 2017 09:45:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/22] xfs: create an ioctl to scrub AG metadata
Message-ID: <20170723234539.GA17762@dastard>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061192762.14732.9274339959944172701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150061192762.14732.9274339959944172701.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 09:38:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an ioctl that can be used to scrub internal filesystem metadata.
> The new ioctl takes the metadata type, an (optional) AG number, an
> (optional) inode number and generation, and a flags argument.  This will
> be used by the upcoming XFS online scrub tool.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, I'm starting completely cold on this code (never seen it before)
so there's a few things about the patch series that hit me straight
away.

1. I can't really review the previous tracepoint patch because I
have no context of how they are used or what is being passed into
them. Tracepoint patches really need to be added when there's
already context available to verify them Can you split that patch up
so that tracepoints are introduced with the code that uses them?

2. Macros. Ugh.

3. Lots of different, disjoint bits of infrastructure in this patch,
but I have no clear idea how it gets used yet. Makes it hard to
review....

Hence I think this patch also needs to be broken up into individual
infrastructure operations, with the patch description describing
what each operation is used for. That way when it comes to adding
the actual metadata scrub code, the reviewer knows how the pieces
all go together and what the functions being called are supposed to
do and return...

Once I understand the infrastructure and how it is supposed to drive
all the other bits, then larger patches for scrubbing individual
structures are fine, but large patches for infrastructure just lead
to long, long emails and missed problems...

> +/* metadata scrubbing */
> +struct xfs_scrub_metadata {
> +	__u32 sm_type;		/* What to check? */
> +	__u32 sm_flags;		/* flags; see below. */
> +	__u64 sm_ino;		/* inode number. */
> +	__u32 sm_gen;		/* inode generation. */
> +	__u32 sm_agno;		/* ag number. */
> +	__u64 sm_reserved[5];	/* pad to 64 bytes */
> +};
> +
> +/*
> + * Metadata types and flags for scrub operation.
> + */
> +#define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
> +#define XFS_SCRUB_TYPE_MAX	0
> +
> +/* i: repair this metadata */
> +#define XFS_SCRUB_FLAG_REPAIR		(1 << 0)

If you're going to document a direction, so it in the variable name,
not the comment. XFS_SCRUB_IFLAG_REPAIR, XFS_SCRUB_OFLAG_CORRUPT,
etc. Especially as you don't separate the definitions  of i/o flags,
future flags are going to intertwine i/o in the definitions and
it's not going to be obvious from a quick look where a flag should
be used...

> +/* o: metadata object needs repair */
> +#define XFS_SCRUB_FLAG_CORRUPT		(1 << 1)
> +/* o: metadata object could be optimized */
> +#define XFS_SCRUB_FLAG_PREEN		(1 << 2)

What does "could be optimised" mean?

> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> new file mode 100644
> index 0000000..6931793
> --- /dev/null
> +++ b/fs/xfs/scrub/common.c
> @@ -0,0 +1,533 @@

Rather than "common.c", shouldn't this be named "scrub.c" to
indicate it's the entry point/main infrastructure file? "common"
usually indicates library/shared functions, not ioctl entry points..

[...]

> + * We use a bit of trickery with transactions to avoid buffer deadlocks
> + * if there is a cycle in the metadata.  The basic problem is that
> + * travelling down a btree involves locking the current buffer at each
> + * tree level.  If a pointer should somehow point back to a buffer that
> + * we've already examined, we will deadlock due to the second buffer
> + * locking attempt.  Note however that grabbing a buffer in transaction
> + * context links the locked buffer to the transaction.  If we try to
> + * re-grab the buffer in the context of the same transaction, we avoid
> + * the second lock attempt and continue.  Between the verifier and the
> + * scrubber, something will notice that something is amiss and report
> + * the corruption.  Therefore, each scrubber will allocate an empty
> + * transaction, attach buffers to it, and cancel the transaction at the
> + * end of the scrub run.  Cancelling a non-dirty transaction simply
> + * unlocks the buffers.

This whole chunk of trickery should definitely be in it's own patch...

> + * There are four pieces of data that scrub can communicate to
> + * userspace.  The first is the error code (errno), which can be used to
> + * communicate operational errors in performing the scrub.  There are
> + * also three flags that can be set in the scrub context.  If the data
> + * structure itself is corrupt, the CORRUPT flag will be set.  If
> + * the metadata is correct but otherwise suboptimal, the PREEN flag
> + * will be set.
> + */
> +
> +struct xfs_scrub_meta_fns {
> +	int		(*setup)(struct xfs_scrub_context *,
> +				 struct xfs_inode *);
> +	int		(*scrub)(struct xfs_scrub_context *);
> +	bool		(*has)(struct xfs_sb *);
> +};

What's this structure do? And why "fns" rather than "ops" as we
normally call operation callout structures like this?

> +/* Check for operational errors. */
> +bool
> +xfs_scrub_op_ok(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agnumber_t			agno,
> +	xfs_agblock_t			bno,
> +	const char			*type,
> +	int				*error,
> +	const char			*func,
> +	int				line)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +
> +	switch (*error) {
> +	case 0:
> +		return true;
> +	case -EDEADLOCK:
> +		/* Used to restart an op with deadlock avoidance. */
> +		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
> +		break;
> +	case -EFSBADCRC:
> +	case -EFSCORRUPTED:
> +		/* Note the badness but don't abort. */
> +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> +		*error = 0;
> +		/* fall through */
> +	default:
> +		trace_xfs_scrub_op_error(mp, agno, bno, type, *error, func,
> +				line);
> +		break;
> +	}
> +	return false;
> +}

These looks like boiler plate functions that aren't used yet, which
makes it harder to see all the actual ioctl code that is supposed
to be introduced in this patch. Again, I'm not sure how they are
supposed to be used, so I can't actually review this code yet....

Also, it looks like we're passing func/line to tracing functions,
which further implies wrapper macros to insert them. We've avoided
this with all the other tracing functions by passing
__return_address and/or _THIS_IP_ to the tracing function. Doing so
in all this boiler plate checking code gets rid of the macros.


> +/* Dummy scrubber */
> +
> +int
> +xfs_scrub_dummy(
> +	struct xfs_scrub_context	*sc)
> +{
> +	if (sc->sm->sm_ino || sc->sm->sm_agno)
> +		return -EINVAL;
> +	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_CORRUPT)
> +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> +	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_PREEN)
> +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
> +	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_XFAIL)
> +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_XFAIL;
> +	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_XCORRUPT)
> +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_XCORRUPT;
> +	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
> +		return -ENOENT;
> +
> +	return 0;
> +}

What's the purpose of the dummy? Does it get removed later?

> +/* Per-scrubber setup functions */
> +
> +/* Set us up with a transaction and an empty context. */
> +int
> +xfs_scrub_setup_fs(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	return xfs_scrub_trans_alloc(sc->sm, sc->mp,
> +			&M_RES(sc->mp)->tr_itruncate, 0, 0, 0, &sc->tp);
> +}

Why are you using a truncate reservation for this transaction?

Better question: what initial conditions is a setup function
supposed to create for (I'm guessing here) a scrubber function to
run?

> +
> +/* Scrub setup and teardown */
> +
> +/* Free all the resources and finish the transactions. */
> +STATIC int
> +xfs_scrub_teardown(
> +	struct xfs_scrub_context	*sc,
> +	int				error)
> +{
> +	if (sc->tp) {
> +		xfs_trans_cancel(sc->tp);
> +		sc->tp = NULL;
> +	}
> +	return error;
> +}

So we have scrub function specific setup, but only a global
teardown? Does that mean scrubber functions are not supposed to
allocate any memory for keeping state and cross references? i.e.
they can only store what they can keep attached to a transaction
handle?

> +
> +/* Perform common scrub context initialization. */
> +STATIC int
> +xfs_scrub_setup(
> +	struct xfs_inode		*ip,
> +	struct xfs_scrub_context	*sc,
> +	const struct xfs_scrub_meta_fns	*fns,
> +	struct xfs_scrub_metadata	*sm,
> +	bool				try_harder)
> +{
> +	memset(sc, 0, sizeof(*sc));
> +	sc->mp = ip->i_mount;
> +	sc->sm = sm;
> +	sc->fns = fns;
> +	sc->try_harder = try_harder;
> +
> +	return sc->fns->setup(sc, ip);
> +}

Does this really need a wrapper function? It means main function is
somewhat convoluted....

> +
> +/* Scrubbing dispatch. */
> +
> +static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
> +	{ /* dummy verifier */
> +		.setup	= xfs_scrub_setup_fs,
> +		.scrub	= xfs_scrub_dummy,
> +	},
> +};
> +
> +/* Dispatch metadata scrubbing. */
> +int
> +xfs_scrub_metadata(
> +	struct xfs_inode		*ip,
> +	struct xfs_scrub_metadata	*sm)
> +{
> +	struct xfs_scrub_context	sc;
> +	struct xfs_mount		*mp = ip->i_mount;
> +	const struct xfs_scrub_meta_fns	*fns;
> +	bool				try_harder = false;
> +	int				error = 0;
> +
> +	trace_xfs_scrub(ip, sm, error);

	memset(sc, 0, sizeof(*sc));
	sc->mp = ip->i_mount;
	sc->sm = sm;
	sc->try_harder = false;

And we reference everything thru the scrub context from here on.
I find it a bit confusing to hide sm inside sc, and everywhere else
references sc.sm, yet later on in this function we make the
assumption that the structure pointed to by sm is the one that the
scrubber is actually modifying when it is running. e.g. the
xfs_scrub_found_corruption() call at the end. Better to make it
clear all the code is working on the same structure...

> +
> +	/* Forbidden if we are shut down or mounted norecovery. */
> +	error = -ESHUTDOWN;
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		goto out;

Shutdown conditions should return EFSCORRUPTED.

> +	error = -ENOTRECOVERABLE;
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> +		goto out;

Same for read only mounts, yes?

Or do we allow scrub on read only, but not repair or whatever
"optimisation" is?

> +	/* Check our inputs. */
> +	error = -EINVAL;
> +	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
> +	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
> +		goto out;
> +	if (memchr_inv(sm->sm_reserved, 0, sizeof(sm->sm_reserved)))
> +		goto out;
> +
> +	/* Do we know about this type of metadata? */
> +	error = -ENOENT;
> +	if (sm->sm_type > XFS_SCRUB_TYPE_MAX)
> +		goto out;
> +	fns = &meta_scrub_fns[sm->sm_type];

	sc.fns = &meta_scrub_fns[sm->sm_type];

> new file mode 100644
> index 0000000..4f3113a
> --- /dev/null
> +++ b/fs/xfs/scrub/common.h

scrub.h

> @@ -0,0 +1,179 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#ifndef __XFS_REPAIR_COMMON_H__
> +#define __XFS_REPAIR_COMMON_H__
> +
> +/* Did we find something broken? */
> +static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
> +{
> +	return sm->sm_flags & (XFS_SCRUB_FLAG_CORRUPT |
> +			       XFS_SCRUB_FLAG_XCORRUPT);
> +}

Unless this is going to get more complex, a single call wrapper is
not necessary.

> +/*
> + * Grab a transaction.  If we're going to repair something, we need to
> + * ensure there's enough reservation to make all the changes.  If not,
> + * we can use an empty transaction.
> + */
> +static inline int
> +xfs_scrub_trans_alloc(
> +	struct xfs_scrub_metadata	*sm,
> +	struct xfs_mount		*mp,
> +	struct xfs_trans_res		*resp,
> +	uint				blocks,
> +	uint				rtextents,
> +	uint				flags,
> +	struct xfs_trans		**tpp)
> +{
> +	return xfs_trans_alloc_empty(mp, tpp);
> +}

If we only ever use an empty transaction here, then can we get rid
of the wrapper, too?

> +
> +/* Check for operational errors. */
> +bool xfs_scrub_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
> +		     xfs_agblock_t bno, const char *type, int *error,
> +		     const char	*func, int line);
> +#define XFS_SCRUB_OP_ERROR_GOTO(sc, agno, bno, type, error, label) \
> +	do { \
> +		if (!xfs_scrub_op_ok((sc), (agno), (bno), (type), \
> +				(error), __func__, __LINE__)) \
> +			goto label; \
> +	} while (0)

Ok, I though this is where the func/line variables was going. Can we
please try to avoid these macros? It's not much extra work to do
this:

	if (!xfs_scrub_op_ok(sc, agno, bno, type, error, _THIS_IP_))
		goto label;

But it's much nicer to read than shouty macros, it doesn't hide
goto's in macros, and it provides exactly the same debug info to the
tracing code as the macro.

[snip more macros]

> +/* Setup functions */
> +
> +#define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
> +SETUP_FN(xfs_scrub_setup_fs);
> +#undef SETUP_FN

Please, no. This sort of construct is highly unfriendly to grep and
cscope. It costs us nothing extra to define the names in full, but
it makes finding the code so much easier...


> --- /dev/null
> +++ b/fs/xfs/scrub/xfs_scrub.h
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#ifndef __XFS_SCRUB_H__
> +#define __XFS_SCRUB_H__
> +
> +#ifndef CONFIG_XFS_ONLINE_SCRUB
> +# define xfs_scrub_metadata(ip, sm)	(-ENOTTY)
> +#else
> +int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
> +#endif /* CONFIG_XFS_ONLINE_SCRUB */
> +
> +#endif	/* __XFS_SCRUB_H__ */

This ioctl module stub code should be separated out into it's own
patch with all the other code that enables building scrub as a
module.

...
> index 2e7e193..d4de29b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3312,7 +3312,7 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  
>  /* scrub */
>  #define XFS_SCRUB_TYPE_DESC \
> -	{ 0, NULL }
> +	{ XFS_SCRUB_TYPE_TEST,		"dummy" }
>  DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
> @@ -3330,6 +3330,11 @@ DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
>  		__entry->ino = ip->i_ino;
> +		__entry->type = sm->sm_type;
> +		__entry->agno = sm->sm_agno;
> +		__entry->inum = sm->sm_ino;
> +		__entry->gen = sm->sm_gen;
> +		__entry->flags = sm->sm_flags;
>  		__entry->error = error;
>  	),
>  	TP_printk("dev %d:%d ino %llu type %s agno %u inum %llu gen %u flags 0x%x error %d",

So the tracepoints in the previous patch are dependent on structures
that have no yet been defined? Doesn't that break compilation?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
