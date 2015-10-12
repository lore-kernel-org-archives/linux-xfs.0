Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AE6F7F53
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 19:22:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9AE0AC006
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 17:22:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mhHFxqTqaCtWb3un for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 17:22:19 -0700 (PDT)
Date: Mon, 12 Oct 2015 11:22:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 38/46] richacl: Add support for unmapped identifiers
Message-ID: <20151012002200.GB27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-39-git-send-email-andreas.gruenbacher@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444604337-17651-39-git-send-email-andreas.gruenbacher@gmail.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Oct 12, 2015 at 12:58:49AM +0200, Andreas Gruenbacher wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> Some remote file systems like nfs may return user or group identifiers
> that cannot be mapped to local uids / gids.  Allow to represent such
> unmapped identifiers in richacls.  (We still cannot represent unmapped
> owners and owning groups, however.)
> 
> In the in-memory representation, the richacl is followed by a list of
> NUL-terminated strings, with no padding.  Entries with an unmapped
> identifier have the RICHACE_UNMAPPED_WHO flag set, and ace->e_id.offs
> specifies the offset into this list.  Multiple entries can refer to the
> same offset.
> 
> The xattr representation is similar, but ace->e_id is ignored, and the
> list of unmapped identifier strings contains a string for each acl entry
> whose RICHACE_UNMAPPED_WHO flag is set.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
....
> +/**
> + * richacl_has_unmapped_identifiers
> + *
> + * Check if an acl has unmapped identifiers.
> + */
> +bool richacl_has_unmapped_identifiers(struct richacl *acl)
> +{
> +	struct richace *ace;
> +
> +	richacl_for_each_entry(ace, acl) {
> +		if (ace->e_flags & RICHACE_UNMAPPED_WHO)
> +			return true;
> +	}
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(richacl_has_unmapped_identifiers);

This was used by the XFS support patch earlier in the series. Bisect
problem here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
