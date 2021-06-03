Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96495C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDED613F0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 01:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhFCBKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:10:54 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:36696 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhFCBKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 21:10:54 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 881C31AFE70;
        Thu,  3 Jun 2021 11:08:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lobqU-008Iko-Oh; Thu, 03 Jun 2021 11:08:26 +1000
Date:   Thu, 3 Jun 2021 11:08:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/15] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210603010826.GF664593@dread.disaster.area>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
 <162267273023.2375284.13883230665214658106.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162267273023.2375284.13883230665214658106.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Zy3VchpQufV7Sbrq0WAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 03:25:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Disentangle the dqrele_all inode grab code from the "generic" inode walk
> grabbing code, and and use the opportunity to document why the dqrele
> grab function does what it does.  Since xfs_inode_walk_ag_grab is now
> only used for blockgc, rename it to reflect that.
> 
> Ultimately, there will be four reasons to perform a walk of incore
> inodes: quotaoff dquote releasing (dqrele), garbage collection of
> speculative preallocations (blockgc), reclamation of incore inodes
> (reclaim), and deferred inactivation (inodegc).  Each of these four have
> their own slightly different criteria for deciding if they want to
> handle an inode, so it makes more sense to have four cohesive igrab
> functions than one confusing parameteric grab function like we do now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 66 insertions(+), 5 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
