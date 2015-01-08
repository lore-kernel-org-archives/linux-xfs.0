Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB8157F47
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 17:40:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B221AC003
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:40:16 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	D9SydPGmU6UgxkGh for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 15:40:14 -0800 (PST)
Date: Fri, 9 Jan 2015 10:20:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: consolidate superblock logging functions
Message-ID: <20150108232030.GL25000@dastard>
References: <1420667465-7453-1-git-send-email-david@fromorbit.com>
	<1420667465-7453-3-git-send-email-david@fromorbit.com>
	<20150108143632.GB33789@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108143632.GB33789@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 09:36:33AM -0500, Brian Foster wrote:
> On Thu, Jan 08, 2015 at 08:51:04AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We now have several superblock loggin functions that are identical
> > except for the transaction reservation and whether it shoul dbe a
> > synchronous transaction or not. Consolidate these all into a single
> > function, a single reserveration and a sync flag and call it
> > xfs_sync_sb().
> > 
> > Also, xfs_mod_sb() is not really a modification function - it's the
> > operation of logging the superblock buffer. hence change the name of
> > it to reflect this.
> > 
> > Note that we have to change the mp->m_update_flags that are passed
> > around at mount time to a boolean simply to indicate a superblock
> > update is needed.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> A question and one other little thing...

[snip]

> >  #define XFS_TRANS_QM_DQCLUSTER		32
> >  #define XFS_TRANS_QM_QINOCREATE		33
> >  #define XFS_TRANS_QM_QUOTAOFF_END	34
> > -#define XFS_TRANS_SB_UNIT		35
> > -#define XFS_TRANS_FSYNC_TS		36
> > -#define	XFS_TRANS_GROWFSRT_ALLOC	37
> > -#define	XFS_TRANS_GROWFSRT_ZERO		38
> > -#define	XFS_TRANS_GROWFSRT_FREE		39
> > -#define	XFS_TRANS_SWAPEXT		40
> > -#define	XFS_TRANS_SB_COUNT		41
> > -#define	XFS_TRANS_CHECKPOINT		42
> > -#define	XFS_TRANS_ICREATE		43
> > -#define	XFS_TRANS_CREATE_TMPFILE	44
> > -#define	XFS_TRANS_TYPE_MAX		44
> > +#define XFS_TRANS_FSYNC_TS		35
> > +#define	XFS_TRANS_GROWFSRT_ALLOC	36
> > +#define	XFS_TRANS_GROWFSRT_ZERO		37
> > +#define	XFS_TRANS_GROWFSRT_FREE		38
> > +#define	XFS_TRANS_SWAPEXT		39
> > +#define	XFS_TRANS_CHECKPOINT		40
> > +#define	XFS_TRANS_ICREATE		41
> > +#define	XFS_TRANS_CREATE_TMPFILE	42
> > +#define	XFS_TRANS_TYPE_MAX		43
> >  /* new transaction types need to be reflected in xfs_logprint(8) */
> >  
> >  #define XFS_TRANS_TYPES \
> > @@ -113,7 +111,6 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> >  	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
> >  	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
> >  	{ XFS_TRANS_CREATE,		"CREATE" }, \
> > -	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
> >  	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
> >  	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
> >  	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
> > @@ -134,23 +131,23 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> >  	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
> >  	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
> >  	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
> > -	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
> > +	{ XFS_TRANS_SB_CHANGE,		"SBCHANGE" }, \
> > +	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
> > +	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
> 
> I take it we can't just remove these dummy types, for userspace
> compatibility reasons, right? At least, it looks like logprint could get
> confused if other transaction types inherited these values.

With delayed logging, userspace will never see these as they never
get to disk. Userspace will only ever see checkpoints and unmount
records. My plan is to eventually remove this stuff from the kernel
(it isn['t used anymore except in tracing) and define it in
xfs_logprint in a way that works for current and legacy filesystems.
So for the moment, I'm just making the kernel/user values
consistent.

> > @@ -1574,29 +1574,6 @@ xfs_qm_dqfree_one(
> >  	xfs_qm_dqdestroy(dqp);
> >  }
> >  
> > -/*
> > - * Start a transaction and write the incore superblock changes to
> > - * disk. flags parameter indicates which fields have changed.
> > - */
> > -int
> > -xfs_qm_write_sb_changes(
> 
> This guy still has a function declaration in xfs_qm.h. The rest looks
> good to me:

Good catch, I'll kill it.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
