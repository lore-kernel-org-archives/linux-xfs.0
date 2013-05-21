Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2D1829DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:27:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C1C8AC003
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 13:27:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kUrdOWFiNfKs7CMB for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 13:27:16 -0700 (PDT)
Date: Wed, 22 May 2013 06:27:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfs: increase number of ACL entries for V5
	superblocks
Message-ID: <20130521202714.GP24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-12-git-send-email-david@fromorbit.com>
	<519B7DE9.8030604@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519B7DE9.8030604@redhat.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Tue, May 21, 2013 at 10:00:09AM -0400, Brian Foster wrote:
> On 05/21/2013 04:02 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> > format.  For version 5 superblocks, increase it to the maximum nuber
> > of ACLs that can fit into a single xattr.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_acl.c |   31 ++++++++++++++++++-------------
> >  fs/xfs/xfs_acl.h |   30 +++++++++++++++++++++++-------
> >  2 files changed, 41 insertions(+), 20 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> > index 39632d9..5310a52 100644
> > --- a/fs/xfs/xfs_acl.h
> > +++ b/fs/xfs/xfs_acl.h
> > @@ -22,19 +22,35 @@ struct inode;
> >  struct posix_acl;
> >  struct xfs_inode;
> >  
> > -#define XFS_ACL_MAX_ENTRIES 25
> >  #define XFS_ACL_NOT_PRESENT (-1)
> >  
> >  /* On-disk XFS access control list structure */
> > +struct xfs_acl_entry {
> > +	__be32	ae_tag;
> > +	__be32	ae_id;
> > +	__be16	ae_perm;
> > +	__be16	ae_pad;		/* fill the implicit hole in the structure */
> > +};
> > +
> >  struct xfs_acl {
> > -	__be32		acl_cnt;
> > -	struct xfs_acl_entry {
> > -		__be32	ae_tag;
> > -		__be32	ae_id;
> > -		__be16	ae_perm;
> > -	} acl_entry[XFS_ACL_MAX_ENTRIES];
> > +	__be32			acl_cnt;
> > +	struct xfs_acl_entry	acl_entry[0];
> >  };
> >  
> > +/*
> > + * The number of ACL entries allowed is defined by the on-disk format.
> > + * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> > + * limited only by the maximum size of the xattr that stores the information.
> > + */
> > +#define XFS_ACL_MAX_ENTRIES(mp)	\
> > +	(xfs_sb_version_hascrc(&mp->m_sb) \
> > +	   ?  (XATTR_SIZE_MAX - sizeof(__be32) / sizeof(struct xfs_acl_entry)) \
> 					
> It looks like this should be:
> 
> 	(XATTR_SIZE_MAX - sizeof(__be32)) / sizeof(struct xfs_acl_entry)
> 
> (i.e., misplaced parens)

Yup, good catch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
