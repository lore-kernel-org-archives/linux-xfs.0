Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0F2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 01:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiEKBO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 21:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiEKBOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:14:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11330227B40
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:14:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8F37810E6605;
        Wed, 11 May 2022 11:14:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noawE-00AVKA-95; Wed, 11 May 2022 11:14:50 +1000
Date:   Wed, 11 May 2022 11:14:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/18] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
Message-ID: <20220511011450.GB1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-18-david@fromorbit.com>
 <20220510235347.GV27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510235347.GV27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627b0e0c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=zJPKGTXYwHS9u7470LgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 04:53:47PM -0700, Darrick J. Wong wrote:
> On Mon, May 09, 2022 at 10:41:37AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We can't use the same algorithm for replacing an existing attribute
> > when logging attributes. The existing algorithm is essentially:
> > 
> > 1. create new attr w/ INCOMPLETE
> > 2. atomically flip INCOMPLETE flags between old + new attribute
> > 3. remove old attr which is marked w/ INCOMPLETE
> > 
> > This algorithm guarantees that we see either the old or new
> > attribute, and if we fail after the atomic flag flip, we don't have
> > to recover the removal of the old attr because we never see
> > INCOMPLETE attributes in lookups.
> > 
> > For logged attributes, however, this does not work. The logged
> > attribute intents do not track the work that has been done as the
> > transaction rolls, and hence the only recovery mechanism we have is
> > "run the replace operation from scratch".
> > 
> > This is further exacerbated by the attempt to avoid needing the
> > INCOMPLETE flag to create an atomic swap. This means we can create
> > a second active attribute of the same name before we remove the
> > original. If we fail at any point after the create but before the
> > removal has completed, we end up with duplicate attributes in
> > the attr btree and recovery only tries to replace one of them.
> > 
> > There are several other failure modes where we can leave partially
> > allocated remote attributes that expose stale data, partially free
> > remote attributes that enable UAF based stale data exposure, etc.
> > 
> > TO fix this, we need a different algorithm for replace operations
> > when LARP is enabled. Luckily, it's not that complex if we take the
> > right first step. That is, the first thing we log is the attri
> > intent with the new name/value pair and mark the old attr as
> > INCOMPLETE in the same transaction.
> > 
> > From there, we then remove the old attr and keep relogging the
> > new name/value in the intent, such that we always know that we have
> > to create the new attr in recovery. Once the old attr is removed,
> > we then run a normal ATTR_CREATE operation relogging the intent as
> > we go. If the new attr is local, then it gets created in a single
> > atomic transaction that also logs the final intent done. If the new
> > attr is remote, the we set INCOMPLETE on the new attr while we
> > allocate and set the remote value, and then we clear the INCOMPLETE
> > flag at in the last transaction taht logs the final intent done.
> > 
> > If we fail at any point in this algorithm, log recovery will always
> > see the same state on disk: the new name/value in the intent, and
> > either an INCOMPLETE attr or no attr in the attr btree. If we find
> > an INCOMPLETE attr, we run the full replace starting with removing
> > the INCOMPLETE attr. If we don't find it, then we simply create the
> > new attr.
> 
> ...assuming that the INCOMPLETE attr is preserved until we're completely
> done unmapping the rmtval blocks, right?

Yes, it is preserved - the INCOMPLETE flag is held in
the name entry and that's not removed until after the rmtval blocks
have been fully removed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
