Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C655C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 01:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiF0BX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 21:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiF0BX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 21:23:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3DC12AE8
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 18:23:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9978010E7724;
        Mon, 27 Jun 2022 11:23:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5dTn-00BUbw-TX; Mon, 27 Jun 2022 11:23:55 +1000
Date:   Mon, 27 Jun 2022 11:23:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: don't hold xattr leaf buffers across
 transaction rolls
Message-ID: <20220627012355.GA227878@dread.disaster.area>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628103862.4040423.16112028158389764844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165628103862.4040423.16112028158389764844.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b906ad
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=4zptTJxZ3b0G4nKm050A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 26, 2022 at 03:03:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've established (again!) that empty xattr leaf buffers are
> ok, we no longer need to bhold them to transactions when we're creating
> new leaf blocks.  Get rid of the entire mechanism, which should simplify
> the xattr code quite a bit.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Why?

This code isn't there for correctness - it's just a way of
avoiding needing to look up and lock the buffer immediately after we
just created it and had a reference to it. This is a valid use of 
xfs_trans_bhold(), so I'm not convinced that removing it makes the
code better. Simpler, yes, but not necessarily better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
