Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4076AC2BB85
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 09:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252C22076A
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 09:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437357AbgDNJGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 05:06:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44866 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437356AbgDNJGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Apr 2020 05:06:33 -0400
Received: from dread.disaster.area (pa49-180-167-53.pa.nsw.optusnet.com.au [49.180.167.53])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BD42158C655;
        Tue, 14 Apr 2020 19:06:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jOHWT-0000BX-Nq; Tue, 14 Apr 2020 19:06:25 +1000
Date:   Tue, 14 Apr 2020 19:06:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move inode flush to a workqueue
Message-ID: <20200414090625.GW24067@dread.disaster.area>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
 <158674021749.3253017.16036198065081499968.stgit@magnolia>
 <20200413123109.GB57285@bfoster>
 <20200414003121.GD6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414003121.GD6742@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=2xmR08VVv0jSFCMMkhec0Q==:117 a=2xmR08VVv0jSFCMMkhec0Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=7xklDLai8h8mgGp_7uIA:9
        a=CjuIK1q_8ugA:10 a=XTfQIuIyIrcA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 13, 2020 at 05:31:21PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 13, 2020 at 08:31:09AM -0400, Brian Foster wrote:
> > On Sun, Apr 12, 2020 at 06:10:17PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Move the inode dirty data flushing to a workqueue so that multiple
> > > threads can take advantage of a single thread's flush work.  The
> > > ratelimiting technique was not successful, because threads that skipped
> > > the inode flush scan due to ratelimiting would ENOSPC early and
> > > apparently now there are complaints about that.  So make everyone wait.
> > > 
> > > Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Seems reasonable in general, but do we really want to to dump a longish
> > running filesystem sync to the system workqueue? It looks like there are
> > a lot of existing users so I can't really tell if there are major
> > restrictions or not, but it seems risk of disruption is higher than
> > necessary if we dump one or more full fs syncs to it..
> 
> Hmm, I guess I should look at the other flush_work user (the CIL) to see
> if there's any potential for conflicts.  IIRC the system workqueue will
> spawn more threads if someone blocks too long, but maybe we ought to
> use system_long_wq for these kinds of things...

Why isn't this being put on the mp->m_sync_workqueue?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
