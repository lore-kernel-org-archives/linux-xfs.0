Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FFCC48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Jun 2021 22:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAFA56113E
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Jun 2021 22:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhFTWZr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Jun 2021 18:25:47 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:56978 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhFTWZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Jun 2021 18:25:46 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 89CF3682E0;
        Mon, 21 Jun 2021 08:23:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lv5qc-00F628-Kr; Mon, 21 Jun 2021 08:23:22 +1000
Date:   Mon, 21 Jun 2021 08:23:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: fix type mismatches in the inode reclaim
 functions
Message-ID: <20210620222322.GP664593@dread.disaster.area>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404243951.2377241.4625544936148599795.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162404243951.2377241.4625544936148599795.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 11:53:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's currently unlikely that we will ever end up with more than 4
> billion inodes waiting for reclamation, but the fs object code uses long
> int for object counts and we're certainly capable of generating that
> many.  Instead of truncating the internal counters, widen them and
> report the object counts correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
