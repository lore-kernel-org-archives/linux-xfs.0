Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2F9C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 05:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiF0FKr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 01:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiF0FKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 01:10:46 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6FB5DC3
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:10:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C23C35ECD37;
        Mon, 27 Jun 2022 15:10:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5h1G-00BYWN-B3; Mon, 27 Jun 2022 15:10:42 +1000
Date:   Mon, 27 Jun 2022 15:10:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: don't hold xattr leaf buffers across
 transaction rolls
Message-ID: <20220627051042.GC227878@dread.disaster.area>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628103862.4040423.16112028158389764844.stgit@magnolia>
 <20220627012355.GA227878@dread.disaster.area>
 <YrkoLNBbF4KEJIah@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrkoLNBbF4KEJIah@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b93bd5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=kPI5W1eks8WD7zXRwrIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 26, 2022 at 08:46:52PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 27, 2022 at 11:23:55AM +1000, Dave Chinner wrote:
> > On Sun, Jun 26, 2022 at 03:03:58PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Now that we've established (again!) that empty xattr leaf buffers are
> > > ok, we no longer need to bhold them to transactions when we're creating
> > > new leaf blocks.  Get rid of the entire mechanism, which should simplify
> > > the xattr code quite a bit.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Why?
> 
> The original justification for using bhold here was to prevent the AIL
> from trying to write the empty leaf block into the fs during the brief
> time that we release the buffer lock.  The reason for /that/ was to
> prevent recovery from tripping over the empty ondisk block.

Ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
