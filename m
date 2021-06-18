Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D975C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3008D61284
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhFRWa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:30:56 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34270 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230268AbhFRWaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 18:30:55 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 0C99B108D6F;
        Sat, 19 Jun 2021 08:28:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1luMyf-00ELWX-F2; Sat, 19 Jun 2021 08:28:41 +1000
Date:   Sat, 19 Jun 2021 08:28:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <20210618222841.GK664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <20210617234308.GH664593@dread.disaster.area>
 <YMyav1+JiSlQbDFH@bfoster>
 <YMyltwuBKbfnIUvw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyltwuBKbfnIUvw@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=d2ABaUSJPsto1J3maXoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 02:55:03PM +0100, Christoph Hellwig wrote:
> On Fri, Jun 18, 2021 at 09:08:15AM -0400, Brian Foster wrote:
> > Also FYI, earlier iterations of generic/475 triggered a couple instances
> > of the following assert failure before things broke down more severely:
> > 
> >  XFS: Assertion failed: *log_offset + *len <= iclog->ic_size || iclog->ic_state == XLOG_STATE_WANT_SYNC, file: fs/xfs/xfs_log.c, line: 2115
> 
> As you mentioned the placement of this exact assert in my cleanups
> series:  after looking at a right place to move it, I'm really not sure
> this assert makes much sense in this form.

It actually makes perfect sense when you look at the iclog state
transitions in xlog_state_get_iclog_space() w.r.t. the length that
is passed to it.

> xlog_write_single is always entered first by xlog_write, so we also
> get here for something that later gets handled by xlog_write_partial.
> Which means it could be way bigger than the current iclog, and I see no
> reason why that iclog would have to be XLOG_STATE_WANT_SYNC.

Yup, completely intentional and if len is larger than can fit in the
iclog we are writing into, the iclog *must* be in
XLOG_STATE_WANT_SYNC.

 That is, if the length requested in xlog_state_get_iclog_space()
fits entirely in the iclog that is returned, _get_space() will
increment the offset of the iclog to exclusively reserve that amount
of space for the write we are going to do. It then leaves the state
as ACTIVE so another process can then also reserve some/all of the
remaining unused space in the iclog. Hence here in
xlog_write_single() we will have *log_offset + *len <=
iclog->ic_size and ic_state = ACTIVE as true for a write that fits
entirely in the iclog.

If _get_space() finds that the len is larger than will fit in the
iclog, it will reserve the entire remaining space in the iclog for the current caller
by switching out the iclog and moving the state to
XLOG_STATE_WANT_SYNC. This means no other caller to _get_space() will
be able to reserve space in this iclog because the state is no
longer ACTIVE.

IOWs, if  *log_offset + *len > iclog->ic_size, then _get_space()
*must* have set the state of the iclog to _WANT_SYNC so that the
owner of the iclog has exclusive use of the space in the iclog from
*log_offset all the way to the end of the iclog. The overlap beyond
the end of this iclog will be handled by the xlog_write_partial(),
and it will release this iclog and get a new one to continue the
write.

Long story short, the assert is valid, but asynchronous shutdown
changing ic_state without having references to the iclogs or caring
about how they are being used is turning out to be a massive Charlie
Foxtrot right now...

Cheers,

Dave.
> 

-- 
Dave Chinner
david@fromorbit.com
