Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07939C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA31820870
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCXXF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 19:05:26 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35837 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbgCXXF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 19:05:26 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2C78D7EAC8F;
        Wed, 25 Mar 2020 10:05:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGsbp-0005Jk-B8; Wed, 25 Mar 2020 10:05:21 +1100
Date:   Wed, 25 Mar 2020 10:05:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_io: set exitcode on failure appropriately
Message-ID: <20200324230521.GY10776@dread.disaster.area>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-6-david@fromorbit.com>
 <20200324204758.GQ29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324204758.GQ29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=8mwtxrNtB69LJj5Lz0IA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 01:47:58PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 24, 2020 at 11:19:28AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Many operations don't set the exitcode when they fail, resulting
> > in xfs_io exiting with a zero (no failure) exit code despite the
> > command failing and returning an error. The command return code is
> > really a boolean to tell the libxcmd command loop whether to
> > continue processing or not, while exitcode is the actual xfs_io exit
> > code returned to the parent on exit.
> > 
> > This patchset just makes the code do the right thing. It's not the
> > nicest code, but it's a start at producing correct behaviour.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> 
> Looks fine to me, but we're also going to need to audit db, quota, and
> spaceman too, right?

Most likely, but I haven't looked that far - this was more a
reaction to people noting that xfs_io doesn't do the right thing so
exit code could not be relied on in fstests...

The others? Not so critical, I think. But I'll have a look...

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
