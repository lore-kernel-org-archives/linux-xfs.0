Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A8AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 23:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66FD64D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 23:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhA0XbN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:31:13 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:50298 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233243AbhA0Xa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 18:30:28 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 0EFB7108C00;
        Thu, 28 Jan 2021 10:29:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4uFq-003A3H-Fc; Thu, 28 Jan 2021 10:29:42 +1100
Date:   Thu, 28 Jan 2021 10:29:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3] xfs: set WQ_SYSFS on all workqueues in debug mode
Message-ID: <20210127232942.GM4662@dread.disaster.area>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799960.2173328.12558377173737512680.stgit@magnolia>
 <20210126050619.GT7698@magnolia>
 <20210127170306.GC1730140@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127170306.GC1730140@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=nvjG-RciOjDVOkIEdOEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 05:03:06PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 09:06:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When CONFIG_XFS_DEBUG=y, set WQ_SYSFS on all workqueues that we create
> > so that we (developers) have a means to monitor cpu affinity and whatnot
> > for background workers.  In the next patchset we'll expose knobs for
> > some of the workqueues publicly and document it, but not now.
> 
> I don't really think this is a very good idea.  If we want something like
> this it should be kernel-wide and coordinated with the workqueue 
> maintainer, but I'm a little doubtful about the use case.

I don't think it is particular useful kernel wide. If it was, the
maintainer wouldn't have introduced a per-workqueue flag for this
functionality.

The reality is that very few workqueues in the system can expand out
into running thousands of kworker threads like the XFS workqueues
often do. And, really, there's nothing useful a typical user can do
at this point with the workqueue knobs to "tune" the behaviour - the
visibility/control the workqueue sysfs knobs provide at this point
is really only useful to XFS developers running tests in controlled
conditions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
