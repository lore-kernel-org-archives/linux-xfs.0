Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6DDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6969561108
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhJNUSf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhJNUSf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DE360E0B;
        Thu, 14 Oct 2021 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242589;
        bh=LHjP6zGjLkHbaliXostr3rCb6Vzu4WlXqpstxVuFxcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmTf/IOZScYtdiqW0QDOQTjfAdwDcgsiHEL7nqfVel1fkfU5UmocevTfICj0WYqLv
         cvQZo1QHADjFqPQPxGazDTIxcQX2eEh7+epZ6OokqXxx1gChNFRitA/hjhe8p+dkwC
         EnZHFigRTcWsqvK7cj9yc79ODSCka+bN8iumYj2lRV3U4OJfv40SwEv8iFftbIa2cz
         eApsexNQPd15lMV/c6ScCreI789c2+Y6A8NvTbyoY0cdCI4HooYy537mw89FK42MEc
         sVq6B9oC7MHddquymOub/iLXhw4jwkRTxZfkmDzmtmM677jbxXKj2ZhVPVUUdmC223
         ioxtIA4KNsEhQ==
Date:   Thu, 14 Oct 2021 13:16:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] xfs: fix perag iteration raciness
Message-ID: <20211014201629.GL24307@magnolia>
References: <20211014175902.1519172-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014175902.1519172-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:58:58PM -0400, Brian Foster wrote:
> v3:
> - Code style, Fixes: and RvB: tags.
> v2: https://lore.kernel.org/linux-xfs/20211012165203.1354826-1-bfoster@redhat.com/
> - Factoring and patch granularity.
> v1: https://lore.kernel.org/linux-xfs/20211007125053.1096868-1-bfoster@redhat.com/

Applied, thanks!

--D

> 
> Brian Foster (4):
>   xfs: fold perag loop iteration logic into helper function
>   xfs: rename the next_agno perag iteration variable
>   xfs: terminate perag iteration reliably on agcount
>   xfs: fix perag reference leak on iteration race with growfs
> 
>  fs/xfs/libxfs/xfs_ag.h | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> -- 
> 2.31.1
> 
