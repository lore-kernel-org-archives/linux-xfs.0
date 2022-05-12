Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704D5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 20:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbiELUyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 16:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiELUyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 16:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D98F644C4
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 13:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0687FB80AEA
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 20:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD796C34100;
        Thu, 12 May 2022 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652388853;
        bh=YRWgnZCm3xsBGPFklTF7LHQle6FJ2YNHQaSEUgADE1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e15kP8tllAvr7DtcxRPWRNYPEn4jjHHJTW7+0SLUMEsfkaAnRhg311nShrujCKxif
         7vQlnzx/kJVJVB/yxxzSaHCQIam5W+f/lVFurnvBIrMFS5CsPh4d9AyuI7jI6vzhZf
         WzA3ME7/xeqciSZCaeFhjLIVPCpCW+BpArkQH5oW8ExCXy5t+FvfKcaw/iN9HnwKPr
         sdOP7qSonU59kvkNmNBcJcadBeABuK1ej2AFmTOu3UmgBUly+yJYp2ciHey0vyI96Y
         OQ840exWKu+bxazNZfiUENUzwfoDmsGB7dqF5fDGLhZpVBf3bZ4t1OiHNE5dt2msdx
         9QnvxxqyQgTkQ==
Date:   Thu, 12 May 2022 13:54:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: improve checking of existing rmap and
 refcount btrees
Message-ID: <20220512205413.GI27195@magnolia>
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675706.248791.4099817268523543427.stgit@magnolia>
 <8f1a6bf5-ad9a-7bbe-c038-2b9a7ba58a69@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f1a6bf5-ad9a-7bbe-c038-2b9a7ba58a69@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 12, 2022 at 02:39:13PM -0500, Eric Sandeen wrote:
> On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a few deficiencies in the xfs_repair functions that check the
> > existing reverse mapping and reference count btrees.  First of all, we
> > don't report corruption or IO errors if we can't read the ondisk
> > metadata.  Second, we don't consistently warn if we cannot allocate
> > memory to perform the check.
> 
> Well, the caller used to report those, right? i.e.
> 
>         error = check_refcounts(wq->wq_ctx, agno);
>         if (error)
>                 do_error(
> _("%s while checking reference counts"),
>                          strerror(-error));
> 
> So I think this patch is just changing from reporting strerror(-error)
> when these things return, to hand-crafted error messages in the functions
> that get called?
> 
> AFAICT this patch changes
> 
> "Cannot allocate memory while checking reverse-mappings"
> to
> "Not enough memory to check reverse mappings"
> 
> etc.
> 
> Granted, strerror(EFSCORRUPTED) isn't very pretty, and your messages are
> probably more clear. But I just wanted to be sure I'm not missing something;
> I think every error is actually reported today, and this is just changing
> the error messages.

Yep, that's correct.  I guess I should have (re)written the commit
message like this:

"When we're checking the rmap and refcount btrees, push error reporting
down to the exact locations of failures so that the user sees both a
message specific to the failure that occurred and what repair was doing
at the time.  This also removes quite a bit of return code handling,
since all the errors were fatal anyway."

--D

> Thanks,
> -Eric
> 
