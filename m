Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B280CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 23:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiEWXIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 19:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEWXIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 19:08:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC75070369
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 16:08:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D3142535566;
        Tue, 24 May 2022 09:08:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntH9p-00Fbmb-Gq; Tue, 24 May 2022 09:08:13 +1000
Date:   Tue, 24 May 2022 09:08:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH V1.1] xfs_repair: Search for conflicts in
 inode_tree_ptrs[] when processing uncertain inodes
Message-ID: <20220523230813.GV1098723@dread.disaster.area>
References: <20220523043441.394700-1-chandan.babu@oracle.com>
 <20220523083410.1159518-1-chandan.babu@oracle.com>
 <Yovuf/JZiMkJzot6@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yovuf/JZiMkJzot6@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c13e0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=C7iet_oUHHIDxTXPZn0A:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 01:28:47PM -0700, Darrick J. Wong wrote:
> On Mon, May 23, 2022 at 02:04:10PM +0530, Chandan Babu R wrote:
> > When processing an uncertain inode chunk record, if we lose 2 blocks worth of
> > inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
> > xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
> > inode as either free or used. However, before adding the new chunk record,
> > xfs_repair has to check for the existance of a conflicting record.
> > 
> > The existing code incorrectly checks for the conflicting record in
> > inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
> > record being processed was originally obtained from
> > inode_uncertain_tree_ptrs[agno].
> > 
> > This commit fixes the bug by changing xfs_repair to search
> > inode_tree_ptrs[agno] for conflicts.
> 
> Just out of curiosity -- how did you come across this bug?  I /think/ it
> looks reasonable, but want to know more context...
> 
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> > Changelog:
> > V1 -> V1.1:
> >    1. Fix commit message.
> >    
> >  repair/dino_chunks.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> > index 11b0eb5f..80c52a43 100644
> > --- a/repair/dino_chunks.c
> > +++ b/repair/dino_chunks.c
> > @@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
> >  		/*
> >  		 * ok, put the record into the tree, if no conflict.
> >  		 */
> > -		if (find_uncertain_inode_rec(agno,
> > -				XFS_AGB_TO_AGINO(mp, start_agbno)))
> > +		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
> 
> ...because the big question I have is: why not check both the certain
> and the uncertain records for confliects?

Yeah, that was my question, too.

WHile I'm here, Chandan, a small patch admin note: tools like b4
don't handle patch versions like "V1.1" properly.

If you are replying in line with a new patch, just call it "V2" or
"V3" - the version of the entire patchset (in the [PATCH 0/N V2]
header) doesn't matter in this case, what matters is that it the
second version of the patch in this thread. Us humans are smart
enough to tell the difference between "series version" and "patch
within series version", and it turns out if you use the right
version formats the tools are smart enough, too. :)

As such, b4 will automatically pick up the V2 patch as a newer
version of the patch in the current series rather than miss it
entirely because it doesn't understand the V1.1 version numbering
you've used...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
