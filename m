Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3594EC11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 12:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E36F61919
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 12:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhF3MIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 08:08:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48354 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbhF3MIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 08:08:06 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 318BF1FE79;
        Wed, 30 Jun 2021 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625054736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/k459D83dqEBaY9eVSzKip+FmzUX8gzpSpVVytyhG4=;
        b=eIEBb7gEQPHY6YfiEq0LRY2mB6zcXszr5m324zcFMxb+5I3XEksWKVCXCC3vCTkJidEchM
        TStrsqir+uxpYPfb0jbCuXsoOsEpK06SkWWJ2eW+z2gQJSkqZ5EywKDlpLtPGLMR4Cctg0
        noy1HCiqsrG80dFtzlO/B/h0+3hD8vI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id ED62DA3B8A;
        Wed, 30 Jun 2021 12:05:35 +0000 (UTC)
Date:   Wed, 30 Jun 2021 14:05:35 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <YNxeD2W32x8wJ/87@dhcp22.suse.cz>
References: <20210630061431.1750745-1-david@fromorbit.com>
 <20210630061431.1750745-2-david@fromorbit.com>
 <20210630100455.GI3840@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630100455.GI3840@techsingularity.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 30-06-21 11:04:55, Mel Gorman wrote:
[...]
> I didn't do a full audit to determine what fallout, if any, there is
> to ultimately passing __GFP_NOFAIL to kvmalloc although kvmalloc_node
> explicitly notes that __GFP_NOFAIL is not supported. Adding Michal Hocko
> to the cc to see if he remembers why __GFP_NOFAIL was problematic.

This is because there are allocations in the vmalloc path which do not
get the full gfp context. E.g. page table allocations. This could be
likely handled somewhere at the vmalloc layer and retry but I do not
remember anybody would be really requesting the support.
-- 
Michal Hocko
SUSE Labs
