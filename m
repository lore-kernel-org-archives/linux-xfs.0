Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C21C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 16:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiEZQ6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiEZQ6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 12:58:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365CC674C3
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 09:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2693B82176
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 16:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DBC385A9;
        Thu, 26 May 2022 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653584280;
        bh=ixj2k9IA+ie6Uau85SNu2Sk4CJFcFjOGlJt9cKKyjXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/elbdf9OmNPlAZYws79bJmVYU+eCvRjv3V9i1Z3pX+6Dyaz3eNgPJuLHe9OyWY1O
         nAXCHcy7IxR0ztSPlO3Xfh+KsQt1dy2+mP3kDHqOYLmqATAEKJTlkRfsoOpnwj6ELg
         uuIGOPO3ifLoIQe5jRoLfCjBOk7LLj/R0QV5Bf+GzzbqA8L+aZ93hjycZBLqDa0Nbi
         /gcL3AUGsPrFkziTmumL8auwubjJdX0yTl+puf2fz+xJLu7OE6MaPWuIQmpb1djWLX
         OZY+KWId95+wrXKSn6kHe2aaaENHSBRoCT7RY/UyN1yFDjwlHBhR7z7jIHQheskMyL
         y0NExJrZb3ciw==
Date:   Thu, 26 May 2022 09:57:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH V1.1] xfs_repair: Search for conflicts in
 inode_tree_ptrs[] when processing uncertain inodes
Message-ID: <Yo+xl0gEWL3Kr+q0@magnolia>
References: <20220523043441.394700-1-chandan.babu@oracle.com>
 <20220523083410.1159518-1-chandan.babu@oracle.com>
 <Yovuf/JZiMkJzot6@magnolia>
 <20220523230813.GV1098723@dread.disaster.area>
 <87v8tsmncq.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8tsmncq.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 05:34:41PM +0530, Chandan Babu R wrote:
> On Tue, May 24, 2022 at 09:08:13 AM +1000, Dave Chinner wrote:
> > On Mon, May 23, 2022 at 01:28:47PM -0700, Darrick J. Wong wrote:
> >> On Mon, May 23, 2022 at 02:04:10PM +0530, Chandan Babu R wrote:
> >> > When processing an uncertain inode chunk record, if we lose 2 blocks worth of
> >> > inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
> >> > xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
> >> > inode as either free or used. However, before adding the new chunk record,
> >> > xfs_repair has to check for the existance of a conflicting record.
> >> > 
> >> > The existing code incorrectly checks for the conflicting record in
> >> > inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
> >> > record being processed was originally obtained from
> >> > inode_uncertain_tree_ptrs[agno].
> >> > 
> >> > This commit fixes the bug by changing xfs_repair to search
> >> > inode_tree_ptrs[agno] for conflicts.
> >> 
> >> Just out of curiosity -- how did you come across this bug?  I /think/ it
> >> looks reasonable, but want to know more context...
> >> 
> >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> > ---
> >> > Changelog:
> >> > V1 -> V1.1:
> >> >    1. Fix commit message.
> >> >    
> >> >  repair/dino_chunks.c | 3 +--
> >> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >> > 
> >> > diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> >> > index 11b0eb5f..80c52a43 100644
> >> > --- a/repair/dino_chunks.c
> >> > +++ b/repair/dino_chunks.c
> >> > @@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
> >> >  		/*
> >> >  		 * ok, put the record into the tree, if no conflict.
> >> >  		 */
> >> > -		if (find_uncertain_inode_rec(agno,
> >> > -				XFS_AGB_TO_AGINO(mp, start_agbno)))
> >> > +		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
> >> 
> >> ...because the big question I have is: why not check both the certain
> >> and the uncertain records for confliects?
> >
> > Yeah, that was my question, too.
> 
> I came across this issue while reading code in order to better understand
> xfs_repair.
> 
> The following steps illustrate how the code flows from phase 2 and 3 of
> xfs_repair.
> 
> During phase 2,
> 1. Scan inobt records.
> 2. For valid records, add corresponding entries to certain inode tree
>    (i.e. inode_tree_ptrs[agno]).
> 3. For suspect records (e.g. Inobt leaf blocks which have a CRC mismatch), add
>    entries to uncertain inode tree (i.e. inode_uncertain_tree_ptrs[agno]).
> 
> Uncertain inode chunk records are processed at the beginning of Phase 3
> (please refer to check_uncertain_aginodes()). We pick one inode chunk at a
> time from the uncertain inode tree and verify each inode's ondisk contents. If
> most of the chunk's inodes turn out to be valid, we would want to treat the
> chunk's inodes as certain i.e. move them over to the certain inode tree.
> 
> Existing code would check for the presence of the inode chunk in the uncertain
> inode tree and when such an entry is found, we skip further processing of the
> inode chunk. Since the inode chunk was obtained from the uncertain inode tree
> in the first place, this check succeeds and the code ended up ignoring
> uncertain inodes which were actually valid inodes.
> 
> I think checking uncertain inode tree for conflicts is a programming error. We
> should actually be checking only the certain inode tree for conflicts before
> moving the inode chunk to certain inode tree.

Oh, ok, so repair is walking the uncertain inode chunks to see if they
really correspond to inodes.  Having decided that the chunk is good, the
last little piece is to check that the uncertain chunk doesn't overlap
with any of the known-good chunks, and if /that/ passes, repair moves
the uncertain chunk to inode_tree_ptrs[]?  And therefore it makes no
sense at all to compare one uncertain chunk against the rest of the
uncertain chunks, because (a) that's where it just came from and (b) we
could discard any of the remaining uncertain chunks?

If the answers are yes and yes, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Though you might want to augment the commit message to include that last
sentence about why it doesn't make sense to check the uncertain ichunk
list, since that's where I tripped up. :/

> I wrote the script
> (https://gist.github.com/chandanr/5ad2da06a7863c2918ad793636537536) to
> illustrate the problem. This script create an inobt with two fully populated
> leaves. It then changes 2nd leaf's lsn value to cause a CRC check
> failure. This causes phase 2 of xfs_repair to add inodes in the 2nd leaf to
> uncertain inode tree.

Looks like a reasonably good candidate for an fstest :)

> Without the fix provided by the patch, phase 3 will skip converting inodes
> from the 2nd leaf into certain inodes and hence xfs_repair ends up trashing
> these inodes.

<nod>

--D

> >
> > WHile I'm here, Chandan, a small patch admin note: tools like b4
> > don't handle patch versions like "V1.1" properly.
> >
> > If you are replying in line with a new patch, just call it "V2" or
> > "V3" - the version of the entire patchset (in the [PATCH 0/N V2]
> > header) doesn't matter in this case, what matters is that it the
> > second version of the patch in this thread. Us humans are smart
> > enough to tell the difference between "series version" and "patch
> > within series version", and it turns out if you use the right
> > version formats the tools are smart enough, too. :)
> >
> > As such, b4 will automatically pick up the V2 patch as a newer
> > version of the patch in the current series rather than miss it
> > entirely because it doesn't understand the V1.1 version numbering
> > you've used...
> 
> Sure, I will use integers for patch version numbers from now onwards.
> 
> -- 
> chandan
