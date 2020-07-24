Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51F6C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 01:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B748720737
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 01:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGXBmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 21:42:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34708 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726284AbgGXBmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 21:42:50 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5249F821B95;
        Fri, 24 Jul 2020 11:42:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jymjV-00029C-Pl; Fri, 24 Jul 2020 11:42:45 +1000
Date:   Fri, 24 Jul 2020 11:42:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: Refactor xfs_da_state_alloc() helper
Message-ID: <20200724014245.GL2005@dread.disaster.area>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-6-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-6-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=y-lx89I1iLSea_fqdQAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:18AM +0200, Carlos Maiolino wrote:
> Every call to xfs_da_state_alloc() also requires setting up state->args
> and state->mp
> 
> Change xfs_da_state_alloc() to receive an xfs_da_args_t as argument and
> return a xfs_da_state_t with both args and mp already set.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V3:
> 		- Originally this patch removed xfs_da_state_alloc(),
> 		  per hch's suggestion, instead of removing, it has been
> 		  refactored, to also set state->{args,mp} which removes
> 		  a few lines of code.
> 
>  fs/xfs/libxfs/xfs_attr.c      | 17 +++++------------
>  fs/xfs/libxfs/xfs_da_btree.c  |  8 ++++++--
>  fs/xfs/libxfs/xfs_da_btree.h  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c | 17 +++++------------
>  fs/xfs/scrub/dabtree.c        |  4 +---
>  5 files changed, 18 insertions(+), 30 deletions(-)

With the typedefs fixed,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
