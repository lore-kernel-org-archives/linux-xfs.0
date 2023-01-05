Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CD0C3DA7A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 19:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbjAET6e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Jan 2023 14:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbjAET62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 14:58:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A2817424
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 11:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 531B961C30
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 19:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E6DC433D2;
        Thu,  5 Jan 2023 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672948702;
        bh=i+HWLJHIkb5lYELbvrafk63MYfbgkWV8fyMFVbny55M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QktGMC1Omkm1Tf3uk/EiWsM4lAP/ebVKB5653DAB5rQmF2Q3hdOSyyuQeUm1BjDK0
         FZCHfiw6d+NqT/Qq+//byEg1S0NoB9T8z3m0+UkoaJaLQOSUMp5YQNylui+eXfpbXx
         ETA1Rgy/dLwGrJx2rTyAcR40KPxU1ITbyvNWhhHvzUgyP4yiw9klSuAo+NduZO8gTa
         BDiFD96Iz8Pkk2kh+jJsVIuvzJsxYd3TF+RwJwhcXHnitvgFJLQSlbGNFFYZluWbUB
         bMtrY7Ri4zYzl12C10wJDQZJyb9zHhprO7ckUkyQXmt9I8Wa+XdK/gE4exKORvIzUY
         GQMYY4Y38KW9Q==
Date:   Thu, 5 Jan 2023 11:58:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix extent busy updating
Message-ID: <Y7cr3sxUmWZXwdXK@magnolia>
References: <20230103193217.4941-1-wen.gang.wang@oracle.com>
 <Y7WoStJT4ImufLct@magnolia>
 <3C662595-F2C9-47B0-B4FD-1C4F3F10A4E1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3C662595-F2C9-47B0-B4FD-1C4F3F10A4E1@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 04, 2023 at 05:41:15PM +0000, Wengang Wang wrote:
> Darrick,
> 
> > On Jan 4, 2023, at 8:24 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Tue, Jan 03, 2023 at 11:32:17AM -0800, Wengang Wang wrote:
> >> In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
> >> extent busy, the relavent length has to be modified accordingly.
> >> 
> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> fs/xfs/xfs_extent_busy.c | 1 +
> >> 1 file changed, 1 insertion(+)
> >> 
> >> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> >> index ad22a003f959..f3d328e4a440 100644
> >> --- a/fs/xfs/xfs_extent_busy.c
> >> +++ b/fs/xfs/xfs_extent_busy.c
> >> @@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
> >> 		 *
> >> 		 */
> >> 		busyp->bno = fend;
> >> +		busyp->length = bend - fend;
> > 
> > Looks correct to me, but how did you find this?
> 
> I was working with a UEK5 XFS bug where busy blocks (contained in
> extent busy) are allocated to regular files unexpectedly.  When I was
> trying to fix that problem (still reuse busy blocks for directories),
> the problem here is exposed.
> 
> 
> >  Is there some sort of
> > test case we could attach to this?
> 
> Hm.. I can only reproduce this with my patch. Well, the idea is that,
> for example,
> 
> 1) we have an extent busy in the busy tree:    (bno=100, len=200)
> 2) allocate blocks for directories from above extent busy (multiple times)
> 3) after the allocations, above extent busy finally becomes  (bno=300, len=200)  though it should become (bno=300, len=0) and should be removed from the busy tree.
> 4) the block 300 (in that AG) is used as metadata (directory blocks containing dir entries) and then that block is freed
> 5) insert the new extent busy (bno=300, len=1) to the busy tree,
> in function xfs_extent_busy_insert():
> 
>  61         while (*rbp) {
>  62                 parent = *rbp;
>  63                 busyp = rb_entry(parent, struct xfs_extent_busy, rb_node);
>  64
>  65                 if (new->bno < busyp->bno) {
>  66                         rbp = &(*rbp)->rb_left;
>  67                         ASSERT(new->bno + new->length <= busyp->bno);
>  68                 } else if (new->bno > busyp->bno) {
>  69                         rbp = &(*rbp)->rb_right;
>  70                         ASSERT(bno >= busyp->bno + busyp->length);
>  71                 } else {
>  72                         ASSERT(0);
>  73                 }
>  74         }
> 
> Note that node (bno=300, len=200) already exists in the tree, the code
> hits line 72, the “else” case, and enters infinite loop.

Hm.  I /think/ it would be possible but fairly difficult to write an
fstest -- you'd have to create a storage with a very slow DISCARD
command, mount the fs with -o discard, fill the fs, free all the blocks,
make a large directory structure, and then rmdir the directory.  Those
last three steps would have to happen before the discards finish.

Uh... do you think that's worth the effort?  I don't think the kernel
even has a dm driver to simulate a device with only slow discards.

In the meantime,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> thanks,
> wengang
> 
> > 
> > --D
> > 
> >> 	} else if (bbno < fbno) {
> >> 		/*
> >> 		 * Case 8:
> >> -- 
> >> 2.21.0 (Apple Git-122.2)
> >> 
> 
