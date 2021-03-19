Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01EBC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD36A61988
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhCSSWw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhCSSWW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 14:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4859E6195E;
        Fri, 19 Mar 2021 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616178142;
        bh=LRuy3exuxDSQe9ajCxG3S9lx54Va9ARQ7+WohyUfORc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DhptkVg6yiOWrPE8vVt0idDnmtBY2gYIx683FooSc/K+mmNUmblWq7D2dVFKcLYck
         aRBdUuU5zRAzFFnxxeKaViQb2DVj9oegB8unZIqLW5MFihs12/Fb4ncxVv6k6qz4ds
         4tFX5ythm6Cp7yRCMqPYUijKBKHfLnZhON+Y8TUYxrsxx11lOmRrB0jeMLOvjI3a/5
         PtkggJlaB7T3fxoOdrEoHSV07PgrNBvFtLymm0cOPhigjjKEyc+xsg04lvzCINZHKl
         ZP67g79sXK6FiZ5s0RdZqSmfn8cmXbINDIQDNd5/o299cQdEo/sNdEBK4PrWaOGHbh
         SfvjC8lkkdX/A==
Date:   Fri, 19 Mar 2021 11:22:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] repair: Phase 6 performance improvements
Message-ID: <20210319182221.GU22100@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013845.GA1431129@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319013845.GA1431129@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 09:38:45AM +0800, Gao Xiang wrote:
> On Fri, Mar 19, 2021 at 12:33:48PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is largely a repost of my current code so that Xiang can take
> > over and finish it off. It applies against 5.11.0 and the
> > performance numbers are still valid. I can't remember how much of
> > the review comments I addressed from the first time I posted it, so
> > the changelog is poor....
> 
> Yeah, I will catch what's missing (now looking the previous review),
> and follow up then...

:)

While you're revising the patches, you might as well convert:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

into:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

because Exchange is so awful for inline replies that I don't use that
email address anymore.

--D

> Thanks,
> Gao Xiang
> 
