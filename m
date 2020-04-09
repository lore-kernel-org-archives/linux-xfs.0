Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75ED0C2BA2B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 00:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 496622084D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 00:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgDIAQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 20:16:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38506 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbgDIAQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 20:16:12 -0400
Received: from dread.disaster.area (pa49-180-167-53.pa.nsw.optusnet.com.au [49.180.167.53])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 29E107EBF04;
        Thu,  9 Apr 2020 10:16:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jMKrY-0005tD-Mn; Thu, 09 Apr 2020 10:16:08 +1000
Date:   Thu, 9 Apr 2020 10:16:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsdocs: capture some information about dirs vs. attrs
 and how they use dabtrees
Message-ID: <20200409001608.GR24067@dread.disaster.area>
References: <20200408232753.GC6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408232753.GC6741@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=2xmR08VVv0jSFCMMkhec0Q==:117 a=2xmR08VVv0jSFCMMkhec0Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=4lRNWPaeyBHxEljNZPcA:9 a=dEW4spVcui97qiKV:21 a=x9s9s_Q3rSx-y4DD:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 04:27:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave and I had a short discussion about whether or not xattr trees
> needed to have the same free space tracking that directories have, and
> a comparison of how each of the two metadata types interact with
> dabtrees resulted.  I've reworked this a bit to make it flow better as a
> book chapter, so here we go.
> 
> Original-mail: https://lore.kernel.org/linux-xfs/20200404085203.1908-1-chandanrlinux@gmail.com/T/#mdd12ad06cf5d635772cc38946fc5b22e349e136f
> Originally-from: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Couple of things.

We are talking about btrees and where the record data is being
stored (internal or external). Hence I think it makes sense to refer
to "attribute records" and "directory records" (or "dirent records")
rather than "attributes" and "directory entries"...

"leaves" -> "leaf nodes"

> ---
>  .../extended_attributes.asciidoc                   |   49 ++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> index 99f7b35..d61c649 100644
> --- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> +++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
> @@ -910,3 +910,52 @@ Log sequence number of the last write to this block.
>  
>  Filesystems formatted prior to v5 do not have this header in the remote block.
>  Value data begins immediately at offset zero.
> +
> +== Key Differences Between Directories and Extended Attributes
> +
> +Though directories and extended attributes can take advantage of the same
> +variable length record btree structures (i.e. the dabtree) to map name hashes
> +to disk blocks, there are major differences in the ways that each of those
> +users embed the btree within the information that they are storing.
> +
> +Directory blocks require external free space tracking because the directory
> +blocks are not part of the dabtree itself.  The dabtree leaves for a directory
> +map name hashes to external directory data blocks.  Extended attributes, on

"The dabtree leaves for ...." implies it is going somewhere, not
that you are talking about leaf nodes. :) Perhaps:

"The directory dabtree leaf nodes contain a mapping between name
hash and the location of the dirent record in the external directory
data blocks."

> +the other hand, store all of the attributes in the leaves of the dabtree.

"... store the attribute records directly in the dabtree leaf
nodes."

> +
> +When we add or remove an extended attribute in the dabtree, we split or merge
> +leaves of the tree based on where the name hash index tells us a leaf needs to
> +be inserted into or removed.  In other words, we make space available or
> +collapse sparse leaves of the dabtree as a side effect of inserting or
> +removing attributes.
> +
> +The directory structure is very different.  Directory entries cannot change
> +location because each entry's logical offset into the directory data segment
> +is used as the readdir/seekdir/telldir cookie, and the cookie is required to
> +be stable for the life of the entry.  Therefore, we cannot store directory
> +entries in the leaves of a dabtree (which is indexed in hash order) because

The userspace readdir/seekdir/telldir directory cookie API places a
requirement on the directory structure that dirent record cookie
cannot change for the life of the dirent record. We use the dirent
record's logical offset into the directory data segment for that
cookie, and hence the dirent record cannot change location.
Therefore, we cannot store directory records in the leaf nodes of
the dabtree....

> +the offset into the tree would change as other entries are inserted and
> +removed.  Hence when we remove directory entries, we must leave holes in the
> +data segment so the rest of the entries do not move.
> +
> +The directory name hash index (the dabtree bit) is held in the second
> +directory segment.  Because the dabtree only stores pointers to directory
> +entries in the (first) data segment, there is no need to leave holes in the
> +dabtree itself.  The dabtree merges or splits leaves as required as pointers
> +to the directory data segment are added or removed.  The dabtree itself needs
> +no free space tracking.
> +
> +When we go to add a directory entry, we need to find the best-fitting free

s/go to//

> +space in the directory data segment to turn into the new entry.  This requires
> +a free space index for the directory data segment.  The free space index is
> +held in the third directory segment.  Once we've used the free space index to
> +find the block with that best free space, we modify the directory data block
> +and update the dabtree to point the name hash at the new entry.
> +
> +In other words, the requirement for a free space map in the directory
> +structure results from storing the directory entry data externally to the
> +dabtree.  Extended atttributes are stored directly in the leaves of the

dabtree leaf nodes

> +dabtree (except for remote attributes which can be anywhere in the attr fork
> +address space) and do not need external free space tracking to determine where
> +to best insert them.  As a result, extended attributes exhibit nearly perfect
> +scaling until we run out of memory.

Thanks for doing this, Darrick!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
