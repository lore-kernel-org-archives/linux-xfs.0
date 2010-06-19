Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5J04Zx9245917 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 19:04:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71C203E6E6D
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 17:07:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	QuAJ0vGrJVBSLho8 for <xfs@oss.sgi.com>;
	Fri, 18 Jun 2010 17:07:13 -0700 (PDT)
Date: Sat, 19 Jun 2010 10:07:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: validate untrusted inode numbers during lookup
Message-ID: <20100619000707.GH6590@dastard>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<1276846374-23916-3-git-send-email-david@fromorbit.com>
	<20100618114156.GA5417@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100618114156.GA5417@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: security@kernel.org, xfs@oss.sgi.com

On Fri, Jun 18, 2010 at 07:41:56AM -0400, Christoph Hellwig wrote:
> On Fri, Jun 18, 2010 at 05:32:52PM +1000, Dave Chinner wrote:
> > +static int
> > +xfs_imap_lookup(
> 
> STATIC to keep the gcc inliner from overdoing thing?

*Nod*.

> 
> > +	xfs_mount_t	*mp,
> > +	xfs_trans_t	*tp,
> 
> > +{
> > +	xfs_inobt_rec_incore_t rec;
> > +	xfs_btree_cur_t	*cur;
> > +	xfs_buf_t	*agbp;
> 
> Please use the struct versions of these instead of the typedefs.

Copy-n-paste error - my bad.

> > +#ifdef DEBUG
> > +		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
> > +				"xfs_inobt_get_rec() failed");
> > +#endif /* DEBUG */
> > +		error = XFS_ERROR(EINVAL);
> 
> No need to print these even for debug kernels I think.  And even then
> we shouldn't do it if the untrusted flag is set.

Ok, I killed all the prints - they don't tell us what inode number
the error occurred on anyway, so they aren't very useful anyway....

> > +	}
> > +error0:
> 
> I'd just call it out, or replace the goto by and if/else

Ok, I rearranged the code to kill the goto. I will repost
the series after a QA run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
