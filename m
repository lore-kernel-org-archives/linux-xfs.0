Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CC7A8060
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 03:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E10EDAC013
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 01:56:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	I2sRXIHqXRRFViEt for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 01:56:43 -0700 (PDT)
Date: Tue, 8 Apr 2014 18:56:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix directory hash ordering bug
Message-ID: <20140408085612.GK27017@dastard>
References: <20140328173430.622616177@sgi.com>
	<20140407190101.292316075@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140407190101.292316075@sgi.com>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Apr 07, 2014 at 02:00:34PM -0500, Mark Tinguely wrote:
> Commit f5ea1100 ("xfs: add CRCs to dir2/da node blocks") introduced
> in 3.10 incorrectly converted the btree hash index array pointer in
> xfs_da3_fixhashpath(). It resulted in the the current hash always
> being compared against the first entry in the btree rather than the
> current block index into the btree block's hash entry array. As a
> result, it was comparing the wrong hashes, and so could misorder the
> entries in the btree.
> 
> For most cases, this doesn't cause any problems as it requires hash
> collisions to expose the ordering problem. However, when there are
> hash collisions within a directory there is a very good probability
> that the entries will be ordered incorrectly and that actually
> matters when duplicate hashes are placed into or removed from the
> btree block hash entry array.
> 
> This bug results in an on-disk directory corruption and that results
> in directory verifier functions throwing corruption warnings into
> the logs. While no data or directory entries are lost, access to
> them may be compromised, and attempts to remove entries from a
> directory that has suffered from this corruption may result in a
> filesystem shutdown.  xfs_repair will fix the directory hash
> ordering without data loss occuring.
> 
> [dchinner: wrote useful a commit message]
> 
> Ported from equivalent kernel commit c88547a8.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  libxfs/xfs_da_btree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/libxfs/xfs_da_btree.c
> ===================================================================
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -1313,7 +1313,7 @@ xfs_da3_fixhashpath(
>  		node = blk->bp->b_addr;
>  		xfs_da3_node_hdr_from_disk(&nodehdr, node);
>  		btree = xfs_da3_node_tree_p(node);
> -		if (be32_to_cpu(btree->hashval) == lasthash)
> +		if (be32_to_cpu(btree[blk->index]->hashval) == lasthash)
                                                 ^^
xfs_da_btree.c: In function 'xfs_da3_fixhashpath':
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')
xfs_da_btree.c:1316:7: error: invalid type argument of '->' (have 'struct xfs_da_node_entry')

I've fixed the copy I've got in my testing tree, but please be more
careful to test patches before you send them for review in future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
