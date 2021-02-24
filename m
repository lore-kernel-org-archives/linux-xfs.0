Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAA2C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16E4564F08
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhBXWEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:04:30 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:34709 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233084AbhBXWEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:04:30 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 60CC3E6AD71;
        Thu, 25 Feb 2021 09:03:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF2G3-002loy-QL; Thu, 25 Feb 2021 09:03:47 +1100
Date:   Thu, 25 Feb 2021 09:03:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210224220347.GD4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
 <20210224211337.GW7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224211337.GW7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=3GfhneSUMP7fGsKlOVwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 01:13:37PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 07:05:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> > guarantee the ordering requirements the journal has w.r.t. metadata
> > writeback. THe two ordering constraints are:
> > 
> > 1. we cannot overwrite metadata in the journal until we guarantee
> > that the dirty metadata has been written back in place and is
> > stable.
> > 
> > 2. we cannot write back dirty metadata until it has been written to
> > the journal and guaranteed to be stable (and hence recoverable) in
> > the journal.
> > 
> > The ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> > causes the journal IO to issue a cache flush and wait for it to
> > complete before issuing the write IO to the journal. Hence all
> > completed metadata IO is guaranteed to be stable before the journal
> > overwrites the old metadata.
> > 
> > The ordering guarantees of #2 are provided by the REQ_FUA, which
> > ensures the journal writes do not complete until they are on stable
> > storage. Hence by the time the last journal IO in a checkpoint
> > completes, we know that the entire checkpoint is on stable storage
> > and we can unpin the dirty metadata and allow it to be written back.

....

> If I've gotten this right so far, patch 4 introduces the ability to
> flush the data device while we get ready to overwrite parts of the log.

Yes.

> This patch makes it so that writing a commit (or unmount) record to an
> iclog causes that iclog write to be issued (to the log device) with at
> least FUA set, and possibly PREFLUSH if we've written out more than one
> iclog since the last commit?

Yes.

> IOWs, the data device flush is now asynchronous with CIL processing and
> we've ripped out all the cache flushes and FUA writes for iclogs except
> for the last one in a chain, which should maintain data integrity
> requirements 1 and 2?

Yes.

> If that's correct,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

Dave.
-- 
Dave Chinner
david@fromorbit.com
