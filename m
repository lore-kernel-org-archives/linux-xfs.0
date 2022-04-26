Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D50BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 04:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243916AbiDZE3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243980AbiDZE3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 00:29:01 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 712704CD5C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 21:25:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 95DF710E5E4A;
        Tue, 26 Apr 2022 14:25:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njClt-004cZi-EJ; Tue, 26 Apr 2022 14:25:53 +1000
Date:   Tue, 26 Apr 2022 14:25:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: reduce the absurdly large log reservations
Message-ID: <20220426042553.GM1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688838.383881.2386659608282052005.stgit@magnolia>
 <20220422225152.GD1544202@dread.disaster.area>
 <20220425234749.GO17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425234749.GO17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62677452
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Gdh7IfEhCqW9WE8Ig00A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 04:47:49PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 23, 2022 at 08:51:52AM +1000, Dave Chinner wrote:
> > On Thu, Apr 14, 2022 at 03:54:48PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Back in the early days of reflink and rmap development I set the
> > > transaction reservation sizes to be overly generous for rmap+reflink
> > > filesystems, and a little under-generous for rmap-only filesystems.
> > > 
> > > Since we don't need *eight* transaction rolls to handle three new log
> > > intent items, decrease the logcounts to what we actually need, and amend
> > > the shadow reservation computation function to reflect what we used to
> > > do so that the minimum log size doesn't change.
> > 
> > Yup, this will make a huge difference to the number of transactions
> > we can have in flight on reflink/rmap enabled filesystems.
> > 
> > Mostly looks good, some comments about code and comments below.
....
> > > -	/* Put everything back the way it was.  This goes at the end. */
> > > -	mp->m_rmap_maxlevels = rmap_maxlevels;
> > > +	/* Add one logcount for BUI items that appear with rmap or reflink. */
> > > +	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
> > > +		resp->tr_itruncate.tr_logcount++;
> > > +		resp->tr_write.tr_logcount++;
> > > +		resp->tr_qm_dqalloc.tr_logcount++;
> > > +	}
> > > +
> > > +	/* Add one logcount for refcount intent items. */
> > > +	if (xfs_has_reflink(mp)) {
> > > +		resp->tr_itruncate.tr_logcount++;
> > > +		resp->tr_write.tr_logcount++;
> > > +		resp->tr_qm_dqalloc.tr_logcount++;
> > > +	}
> > > +
> > > +	/* Add one logcount for rmap intent items. */
> > > +	if (xfs_has_rmapbt(mp)) {
> > > +		resp->tr_itruncate.tr_logcount++;
> > > +		resp->tr_write.tr_logcount++;
> > > +		resp->tr_qm_dqalloc.tr_logcount++;
> > > +	}
> > 
> > This would be much more concisely written as
> > 
> > 	count = 0;
> > 	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
> > 		count = 2;
> > 		if (xfs_has_reflink(mp) && xfs_has_rmapbt(mp))
> > 			count++;
> > 	}
> > 
> > 	resp->tr_itruncate.tr_logcount += count;
> > 	resp->tr_write.tr_logcount += count;
> > 	resp->tr_qm_dqalloc.tr_logcount += count;
> 
> I think I'd rather do:
> 
> 	/*
> 	 * Add one logcount for BUI items that appear with rmap or reflink,
> 	 * one logcount for refcount intent items, and one logcount for rmap
> 	 * intent items.
> 	 */
> 	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp))
> 		logcount_adj++;
> 	if (xfs_has_reflink(mp))
> 		logcount_adj++;
> 	if (xfs_has_rmapbt(mp))
> 		logcount_adj++;
> 
> 	resp->tr_itruncate.tr_logcount += logcount_adj;
> 	resp->tr_write.tr_logcount += logcount_adj;
> 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
> 
> If you don't mind?

Sure, that's just as good.

--Dave.
-- 
Dave Chinner
david@fromorbit.com
