Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8165CC3F2CE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62FCF207FD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgCDVjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 16:39:00 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33733 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728482AbgCDVi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 16:38:59 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 535F77E9F7E;
        Thu,  5 Mar 2020 08:38:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9bjC-0004O9-Gr; Thu, 05 Mar 2020 08:38:54 +1100
Date:   Thu, 5 Mar 2020 08:38:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: merge unmount record write iclog cleanup.
Message-ID: <20200304213854.GB10776@dread.disaster.area>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-10-david@fromorbit.com>
 <20200304155332.GG17565@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304155332.GG17565@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=wo4UJyXDnP8gnJ-Y_IkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 07:53:32AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2020 at 06:53:59PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The unmount iclog handling is duplicated in both
> > xfs_log_unmount_write() and xfs_log_write_unmount_record(). We only
> > need one copy of it in xfs_log_unmount_write() because that is the
> > only function that calls xfs_log_write_unmount_record().
> 
> The copy in xfs_log_unmount_write actually is dead code.  It only
> is called in the XLOG_FORCED_SHUTDOWN case, in which case all iclogs
> are marked as STATE_IOERROR, and thus xlog_state_release_iclog is
> a no-op.  I really need to send the series out to clean this up
> ASAP..

Well, this patch pretty much solves that "dead code" problem in that
it now handles already shut down, error in unmount record write and
successful unmount record write now. i.e. we run the same code in
all cases now, so you'll only need to fix the IOERROR handling in
one place :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
