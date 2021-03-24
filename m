Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A96DC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 02:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF67619F3
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 02:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhCXCIP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 22:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhCXCIM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 22:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB96B619FB;
        Wed, 24 Mar 2021 02:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616551691;
        bh=5RrpgDTSFEcTmdL7hnSP0wuQudQnSBWs15uXi1XO53A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jyYf1RYWO3E0rn59fXR8eGUBULRNN1Is/HUjqIyNkXF03gf2iKLRmZfJI9FaTeZ7D
         GXLrJKl9jVa0uqaKad/OIRM9qsiyCAyqyHzBQHC2WXJ3TmXahyS/0WbcNLZ/HIPPb4
         AhZ7R181f388AUmevGB0ur7LaKChq7bjrVswWiE14ncX6QcLTjXgN0isJBxxq138l6
         6ztsAsPbcDgDqw8SyYkjSfv7CwM6Jns+BPu9g5KLHoOCZdZ+sBAoIQPr8wtgEO5fCx
         cgzwnZ3VBj5Z2XqwaYeh5pNKi6PAA7GqlVIHSmyZC4ytCTdxdmiiSUMmV5h7VRL7gV
         5+uhAUPw8OZIA==
Date:   Tue, 23 Mar 2021 19:08:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] repair: Phase 6 performance improvements
Message-ID: <20210324020810.GP22100@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013845.GA1431129@xiangao.remote.csb>
 <20210319182221.GU22100@magnolia>
 <20210320020931.GA1608555@xiangao.remote.csb>
 <20210324012655.GA2245176@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324012655.GA2245176@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:26:55AM +0800, Gao Xiang wrote:
> Hi Dave and Darrick,
> 
> On Sat, Mar 20, 2021 at 10:09:31AM +0800, Gao Xiang wrote:
> > On Fri, Mar 19, 2021 at 11:22:21AM -0700, Darrick J. Wong wrote:
> > > On Fri, Mar 19, 2021 at 09:38:45AM +0800, Gao Xiang wrote:
> > > > On Fri, Mar 19, 2021 at 12:33:48PM +1100, Dave Chinner wrote:
> > > > > Hi folks,
> > > > > 
> > > > > This is largely a repost of my current code so that Xiang can take
> > > > > over and finish it off. It applies against 5.11.0 and the
> > > > > performance numbers are still valid. I can't remember how much of
> > > > > the review comments I addressed from the first time I posted it, so
> > > > > the changelog is poor....
> > > > 
> > > > Yeah, I will catch what's missing (now looking the previous review),
> > > > and follow up then...
> > > 
> > > :)
> > > 
> > > While you're revising the patches, you might as well convert:
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > into:
> > > 
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > because Exchange is so awful for inline replies that I don't use that
> > > email address anymore.
> > 
> > Yeah, I'm just starting sorting out all previous opinions
> > and patches diff. Will update in the next version.
> > 
> 
> Sorry for bothering... After reading the previous discussion for a while,
> I'm fine with the trivial cleanups. Yet, it seems that there are mainly 2
> remaining open discussions unsolved yet...
> 
> 1 is magic number 1000,
> https://lore.kernel.org/r/20201029172045.GP1061252@magnolia
> 
> while I also don't have better ideas of this (and have no idea why queue
> depth 1000 is optimal compared with other configurations), so it'd be better
> to get your thoughts about this in advance (e.g. just leave it as-is, or...
> plus, I don't have such test setting with such many cpus)
> 
> 2 is the hash size modificiation,
> https://lore.kernel.org/r/20201029162922.GM1061252@magnolia/
> 
> it seems previously hash entires are limited to 64k, and this patch relaxes
> such limitation, but for huge directories I'm not sure the hash table
> utilization but from the previous commit message it seems the extra memory
> usage can be ignored.
> 
> Anyway, I'm fine with just leave them as-is if agreed on these.

FWIW I didn't have any specific objections to either magic number, I
simply wanted to know where they came from and why. :)

--D

> Thanks,
> Gao Xiang
> 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > --D
> > > 
> > > > Thanks,
> > > > Gao Xiang
> > > > 
> > > 
> 
