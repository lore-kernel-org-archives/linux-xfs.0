Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147B0C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2AC320850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfHZXI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 19:08:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55441 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbfHZXI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 19:08:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F0E3543CE02;
        Tue, 27 Aug 2019 09:08:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2O6X-0000kX-Uy; Tue, 27 Aug 2019 09:08:53 +1000
Date:   Tue, 27 Aug 2019 09:08:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: bmap scrub should only scrub records once
Message-ID: <20190826230853.GM1119@dread.disaster.area>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685612978.2853532.15764464511279169366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685612978.2853532.15764464511279169366.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=qD_N5lyKwP6NAXjSXdEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:48:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode block mapping scrub function does more work for btree format
> extent maps than is absolutely necessary -- first it will walk the bmbt
> and check all the entries, and then it will load the incore tree and
> check every entry in that tree, possibly for a second time.
> 
> Simplify the code and decrease check runtime by separating the two
> responsibilities.  The bmbt walk will make sure the incore extent
> mappings are loaded, check the shape of the bmap btree (via xchk_btree)
> and check that every bmbt record has a corresponding incore extent map;
> and the incore extent map walk takes all the responsibility for checking
> the mapping records and cross referencing them with other AG metadata.
> 
> This enables us to clean up some messy parameter handling and reduce
> redundant code.  Rename a few functions to make the split of
> responsibilities clearer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
