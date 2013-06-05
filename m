Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC5D229DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 20:58:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B03898F8035
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 18:58:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ckYIC0PPtAQKYRsv for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 18:58:40 -0700 (PDT)
Date: Wed, 5 Jun 2013 11:58:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: increase number of ACL entries for V5 superblocks
Message-ID: <20130605015817.GJ29338@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-7-git-send-email-david@fromorbit.com>
	<51AD13E6.2090502@sgi.com> <20130604032640.GE29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604032640.GE29466@dastard>
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

On Tue, Jun 04, 2013 at 01:26:40PM +1000, Dave Chinner wrote:
> On Mon, Jun 03, 2013 at 05:08:38PM -0500, Mark Tinguely wrote:
> > On 06/03/13 00:28, Dave Chinner wrote:
> > >From: Dave Chinner<dchinner@redhat.com>
> > >
> > >The limit of 25 ACL entries is arbitrary, but baked into the on-disk
> > >format.  For version 5 superblocks, increase it to the maximum nuber
> > >of ACLs that can fit into a single xattr.
> > >
> > >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >Reviewed-by: Brian Foster<bfoster@redhat.com>
> > >---
....
> > >  /* On-disk XFS access control list structure */
> > >+struct xfs_acl_entry {
> > >+	__be32	ae_tag;
> > >+	__be32	ae_id;
> > >+	__be16	ae_perm;
> > >+	__be16	ae_pad;		/* fill the implicit hole in the structure */
> > >+};
> > >+
> > >  struct xfs_acl {
> > >-	__be32		acl_cnt;
> > >-	struct xfs_acl_entry {
> > >-		__be32	ae_tag;
> > >-		__be32	ae_id;
> > >-		__be16	ae_perm;
> > >-	} acl_entry[XFS_ACL_MAX_ENTRIES];
> > >+	__be32			acl_cnt;
> > >+	struct xfs_acl_entry	acl_entry[0];
> > >  };
> > >
> > >+/*
> > >+ * The number of ACL entries allowed is defined by the on-disk format.
> > >+ * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> > >+ * limited only by the maximum size of the xattr that stores the information.
> > >+ */
> > >+#define XFS_ACL_MAX_ENTRIES(mp)	\
> > >+	(xfs_sb_version_hascrc(&mp->m_sb) \
> > >+	   ?  (XATTR_SIZE_MAX - sizeof(__be32)) / sizeof(struct xfs_acl_entry) \
> > >+	   : 25)
> > 
> > 
> > XFS_ACL_MAX_ENTRIES(mp)  == (65536 - 4) / 12 == 5461
> > 
> > >+
> > >+#define XFS_ACL_SIZE(mp) \
> > >+	(sizeof(struct xfs_acl) + \
> > >+		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
> > 
> > XFS_ACL_SIZE(mp) == (4 + 12) + 12 * ((64K - 4) / 12) == 65548
> > 
> > Did you want to add in the sizeof(struct xfs_acl) to the first term
> > or the sizeof(__be32)? I would think the acl_entry[0] is the start
> > of the array.
> 
> Ugh, I lost that in translation somewhere. Good catch.

Actually, I didn't lose anything - your calculation of sizeof(struct
xfs_acl) is wrong. I went back to the output from pahole to check
this:

struct xfs_acl {
        __be32                     acl_cnt;              /*     0     4 */
        struct xfs_acl_entry       acl_entry[0];         /*     4     0 */

        /* size: 4, cachelines: 1, members: 2 */
        /* last cacheline: 4 bytes */
};

sizeof(struct xfs_acl) = 4, not 16 as you calculated above. Therefore
code as posted is correct, if not immediately obvious.

The needed fix is to use sizeof(struct xfs_acl) in the
XFS_ACL_MAX_ENTRIES() calcluation rather than sizeof(__be32) so that
the two macros are clearly using the same structures for the
calculations...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
