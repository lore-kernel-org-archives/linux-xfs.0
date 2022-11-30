Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8439EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 18:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiK3Stb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 13:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiK3StK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 13:49:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396972FA53
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 10:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B766B81CAE
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 18:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C21AC433B5;
        Wed, 30 Nov 2022 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669834146;
        bh=fctJFrbva2PbgVeqQYdqigeUcNOASEAJPam20filrqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lHbQBxRRgMTMxGWNrbg6QsMdDjAV+Zkton+fnZdbRB4QtRhGPBJbGy/k4iXrTjfzN
         eE5fwsgbL5MuvPt+Ucp91qoDQCz/PBKFqoc/sUUJN0HHUj4s5+v9st8ELXzyZLWrKZ
         DKyDiw3smLiH8Q/3ECbkSminXEybJFRgsqtaNt9Bgqs4JVjfd5vd3EHEmj5NupSnWC
         Ns7MtlOAr1uGnRPVWcNyex3JeinJgtVH2M+Jxbq+rxEy0GTUv3V5a+ucFSCn9Tc5zV
         oXVOcgUSUk1zfbg144ee27Dt83tFnMyfFEGtf5AckYGy7/5824g2HeAH1c2TRNpNvZ
         Ul554h4Slcweg==
Date:   Wed, 30 Nov 2022 10:49:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     =?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: estimate post-merge refcounts correctly
Message-ID: <Y4eloRsH7O0xBaWh@magnolia>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929675.3768925.10238207487640742011.stgit@magnolia>
 <4335f6d8-dc19-d258-325c-38353ab470a0@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4335f6d8-dc19-d258-325c-38353ab470a0@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 05:32:38PM +0800, Yang, Xiao/杨 晓 wrote:
> On 2022/11/30 6:01, Darrick J. Wong wrote:
> > From: Darrick J. Wong<djwong@kernel.org>
> > 
> > Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
> > metadata corruptions after being run.  Specifically, xfs_repair noticed
> > single-block refcount records that could be combined but had not been.
> Hi Darrick,
> 
> I am investigating the issue as well. Thanks a lot for your quick fix.
> I have confirmed that xfs/179 with the fix patch can works well in DAX mode.
> Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
> 
> > 
> > The root cause of this is improper MAXREFCOUNT edge case handling in
> > xfs_refcount_merge_extents.  When we're trying to find candidates for a
> > refcount btree record merge, we compute the refcount attribute of the
> > merged record, but we fail to account for the fact that once a record
> > hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence
> 
> One question:
> Is it reansonable/expected to pin rc_refcount forever when a record hits
> rc_refcount == MAXREFCOUNT?

In the ideal world we'd have a way for refcount_adjust to return early
if it hit a MAXREFCOUNT record, and stop the reflink operation right
there and then.

*Unfortunately* due to the way defer ops work, by the time we're walking
through the refcount btree, we've already committed to adding the entire
mapping.  There's no good way to back out once we start, since
transactions do not log undo items, only redo items.  Augmenting the log
to support undo items is a very big ask.

We could try to work around that by walking the refcount records
*before* committing log items, but that second walk will increase the
overhead for a fairly difficult to hit corner case.  We'd also need to
hold the AGF buffer lock from the start of the chain all the way until
we start the deferred refcount processing.  Or we'd need to add a
separate AG lock.

Even if we did all that, FICLONE* doesn't have any means to communicate
that a short reflink occurred.  copy_file_range does, but then it has
other weird warts, and cannot reflink more than 2^32 bytes in one go.

The simplest solution is to pin the extent if its refcount hits
MAXREFCOUNT, so that's what I went with. :/

--D

> > the computed refcount is wrong, and we fail to merge the extents.
> > 
> > Fix this by adjusting the merge predicates to compute the adjusted
> > refcount correctly.
> 
> Best Regards,
> Xiao Yang
