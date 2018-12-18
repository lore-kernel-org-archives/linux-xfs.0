Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbeLRSf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 13:35:59 -0500
Date: Tue, 18 Dec 2018 10:35:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: stringify btree cursor types in ftrace output
Message-ID: <20181218183555.GD27208@magnolia>
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344776323.4341.3184468728000538253.stgit@magnolia>
 <e5a62cf6-baac-7652-dd5e-4e1cb1793030@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5a62cf6-baac-7652-dd5e-4e1cb1793030@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 11:27:42AM -0600, Eric Sandeen wrote:
> On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use __print_symbolic to print the btree type in ftrace output.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ignore my previous question.
> 
> (if scrub's trace file starts duplicating too much of the common trace stuff,
> though, we may want a common include file?)

I wasn't planning to expand any further than the scrub type.

--D

> But for now
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  fs/xfs/libxfs/xfs_types.h |    9 +++++++++
> >  fs/xfs/scrub/trace.h      |   38 ++++++++++++++++++++++++++------------
> >  fs/xfs/xfs_trace.h        |   12 ++++++++++--
> >  3 files changed, 45 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 297cf2318f83..eb04afe9cce0 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -114,6 +114,15 @@ typedef enum {
> >  	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
> >  } xfs_btnum_t;
> >  
> > +#define XFS_BTNUM_STRINGS \
> > +	{ XFS_BTNUM_BNOi,	"bnobt" }, \
> > +	{ XFS_BTNUM_CNTi,	"cntbt" }, \
> > +	{ XFS_BTNUM_RMAPi,	"rmapbt" }, \
> > +	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
> > +	{ XFS_BTNUM_INOi,	"inobt" }, \
> > +	{ XFS_BTNUM_FINOi,	"finobt" }, \
> > +	{ XFS_BTNUM_REFCi,	"refcbt" }
> > +
> >  struct xfs_name {
> >  	const unsigned char	*name;
> >  	int			len;
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > index d67e915cf91a..0141eb1ac091 100644
> > --- a/fs/xfs/scrub/trace.h
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -12,6 +12,20 @@
> >  #include <linux/tracepoint.h>
> >  #include "xfs_bit.h"
> >  
> > +/*
> > + * ftrace's __print_symbolic requires that all enum values be wrapped in the
> > + * TRACE_DEFINE_ENUM macro so that the enum value can be encoded in the ftrace
> > + * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
> > + * code.
> > + */
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_BMAPi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_INOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
> > +
> >  DECLARE_EVENT_CLASS(xchk_class,
> >  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
> >  		 int error),
> > @@ -278,10 +292,10 @@ TRACE_EVENT(xchk_btree_op_error,
> >  		__entry->error = error;
> >  		__entry->ret_ip = ret_ip;
> >  	),
> > -	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
> > +	TP_printk("dev %d:%d type %u btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->type,
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->level,
> >  		  __entry->ptr,
> >  		  __entry->agno,
> > @@ -321,12 +335,12 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
> >  		__entry->error = error;
> >  		__entry->ret_ip = ret_ip;
> >  	),
> > -	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
> > +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __entry->whichfork,
> >  		  __entry->type,
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->level,
> >  		  __entry->ptr,
> >  		  __entry->agno,
> > @@ -360,10 +374,10 @@ TRACE_EVENT(xchk_btree_error,
> >  		__entry->ptr = cur->bc_ptrs[level];
> >  		__entry->ret_ip = ret_ip;
> >  	),
> > -	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
> > +	TP_printk("dev %d:%d type %u btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->type,
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->level,
> >  		  __entry->ptr,
> >  		  __entry->agno,
> > @@ -400,12 +414,12 @@ TRACE_EVENT(xchk_ifork_btree_error,
> >  		__entry->ptr = cur->bc_ptrs[level];
> >  		__entry->ret_ip = ret_ip;
> >  	),
> > -	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
> > +	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __entry->whichfork,
> >  		  __entry->type,
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->level,
> >  		  __entry->ptr,
> >  		  __entry->agno,
> > @@ -439,10 +453,10 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
> >  		__entry->nlevels = cur->bc_nlevels;
> >  		__entry->ptr = cur->bc_ptrs[level];
> >  	),
> > -	TP_printk("dev %d:%d type %u btnum %d agno %u agbno %u level %d nlevels %d ptr %d",
> > +	TP_printk("dev %d:%d type %u btree %s agno %u agbno %u level %d nlevels %d ptr %d",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->type,
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->agno,
> >  		  __entry->bno,
> >  		  __entry->level,
> > @@ -643,11 +657,11 @@ TRACE_EVENT(xrep_init_btblock,
> >  		__entry->agbno = agbno;
> >  		__entry->btnum = btnum;
> >  	),
> > -	TP_printk("dev %d:%d agno %u agbno %u btnum %d",
> > +	TP_printk("dev %d:%d agno %u agbno %u btree %s",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->agno,
> >  		  __entry->agbno,
> > -		  __entry->btnum)
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS))
> >  )
> >  TRACE_EVENT(xrep_findroot_block,
> >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 94e289aca220..6fcc893dfc91 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2194,6 +2194,14 @@ DEFINE_DISCARD_EVENT(xfs_discard_exclude);
> >  DEFINE_DISCARD_EVENT(xfs_discard_busy);
> >  
> >  /* btree cursor events */
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_BMAPi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_INOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
> > +TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
> > +
> >  DECLARE_EVENT_CLASS(xfs_btree_cur_class,
> >  	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
> >  	TP_ARGS(cur, level, bp),
> > @@ -2213,9 +2221,9 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
> >  		__entry->ptr = cur->bc_ptrs[level];
> >  		__entry->daddr = bp ? bp->b_bn : -1;
> >  	),
> > -	TP_printk("dev %d:%d btnum %d level %d/%d ptr %d daddr 0x%llx",
> > +	TP_printk("dev %d:%d btree %s level %d/%d ptr %d daddr 0x%llx",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  __entry->btnum,
> > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> >  		  __entry->level,
> >  		  __entry->nlevels,
> >  		  __entry->ptr,
> > 
