Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BF737CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 22:26:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2012F304059
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 20:26:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dvgPGxkQEijAkfn3 for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 20:26:41 -0700 (PDT)
Date: Tue, 4 Jun 2013 13:26:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: increase number of ACL entries for V5 superblocks
Message-ID: <20130604032640.GE29466@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-7-git-send-email-david@fromorbit.com>
	<51AD13E6.2090502@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51AD13E6.2090502@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 05:08:38PM -0500, Mark Tinguely wrote:
> On 06/03/13 00:28, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> >format.  For version 5 superblocks, increase it to the maximum nuber
> >of ACLs that can fit into a single xattr.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >Reviewed-by: Brian Foster<bfoster@redhat.com>
> >---
> 
> >@@ -189,16 +193,17 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> >
> >  	if (acl) {
> >  		struct xfs_acl *xfs_acl;
> >-		int len;
> >+		int len = XFS_ACL_SIZE(ip->i_mount);
> >
> >-		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
> >+		xfs_acl = kzalloc(len, GFP_KERNEL);
> 
> Isn't that physical contiguous allocator? wouldn't a virtual
> contiguous be good enough for the acl?

posix_acl_alloc() uses kmalloc, so if it's not failing to allocate
there, then we don't need to use vmalloc here. besides, if we've got
over a single page of acls, then we are talking about 350 ACLs on an
inode. Most admins go insane at more than 20, and the people asking
for more than 25 are using 30-40 ACLs at most. So i don't see there
being a problem here using kzalloc.

> >  	if (type == ACL_TYPE_ACCESS) {
> >diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> >index 39632d9..0da8725 100644
> >--- a/fs/xfs/xfs_acl.h
> >+++ b/fs/xfs/xfs_acl.h
> >@@ -22,19 +22,35 @@ struct inode;
> >  struct posix_acl;
> >  struct xfs_inode;
> >
> >-#define XFS_ACL_MAX_ENTRIES 25
> >  #define XFS_ACL_NOT_PRESENT (-1)
> >
> >  /* On-disk XFS access control list structure */
> >+struct xfs_acl_entry {
> >+	__be32	ae_tag;
> >+	__be32	ae_id;
> >+	__be16	ae_perm;
> >+	__be16	ae_pad;		/* fill the implicit hole in the structure */
> >+};
> >+
> >  struct xfs_acl {
> >-	__be32		acl_cnt;
> >-	struct xfs_acl_entry {
> >-		__be32	ae_tag;
> >-		__be32	ae_id;
> >-		__be16	ae_perm;
> >-	} acl_entry[XFS_ACL_MAX_ENTRIES];
> >+	__be32			acl_cnt;
> >+	struct xfs_acl_entry	acl_entry[0];
> >  };
> >
> >+/*
> >+ * The number of ACL entries allowed is defined by the on-disk format.
> >+ * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> >+ * limited only by the maximum size of the xattr that stores the information.
> >+ */
> >+#define XFS_ACL_MAX_ENTRIES(mp)	\
> >+	(xfs_sb_version_hascrc(&mp->m_sb) \
> >+	   ?  (XATTR_SIZE_MAX - sizeof(__be32)) / sizeof(struct xfs_acl_entry) \
> >+	   : 25)
> 
> 
> XFS_ACL_MAX_ENTRIES(mp)  == (65536 - 4) / 12 == 5461
> 
> >+
> >+#define XFS_ACL_SIZE(mp) \
> >+	(sizeof(struct xfs_acl) + \
> >+		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
> 
> XFS_ACL_SIZE(mp) == (4 + 12) + 12 * ((64K - 4) / 12) == 65548
> 
> Did you want to add in the sizeof(struct xfs_acl) to the first term
> or the sizeof(__be32)? I would think the acl_entry[0] is the start
> of the array.

Ugh, I lost that in translation somewhere. Good catch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
