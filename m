Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3F2C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D822B20719
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCXXol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 19:44:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58863 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbgCXXol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 19:44:41 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 368227EB12E;
        Wed, 25 Mar 2020 10:44:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGtDq-0005ZU-5V; Wed, 25 Mar 2020 10:44:38 +1100
Date:   Wed, 25 Mar 2020 10:44:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_io: set exitcode on failure appropriately
Message-ID: <20200324234438.GD10776@dread.disaster.area>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-6-david@fromorbit.com>
 <ca7c97de-f3ea-2bbb-98b6-26f8da1fca0c@sandeen.net>
 <20200324231255.GZ10776@dread.disaster.area>
 <20200324232401.GT29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324232401.GT29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=4e34b6Gni3NOzRK8PJQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 04:24:01PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 25, 2020 at 10:12:55AM +1100, Dave Chinner wrote:
> > On Tue, Mar 24, 2020 at 03:57:26PM -0500, Eric Sandeen wrote:
> > > On 3/23/20 7:19 PM, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Many operations don't set the exitcode when they fail, resulting
> > > > in xfs_io exiting with a zero (no failure) exit code despite the
> > > > command failing and returning an error. The command return code is
> > > > really a boolean to tell the libxcmd command loop whether to
> > > > continue processing or not, while exitcode is the actual xfs_io exit
> > > > code returned to the parent on exit.
> > > > 
> > > > This patchset just makes the code do the right thing. It's not the
> > > > nicest code, but it's a start at producing correct behaviour.
> > > > 
> > > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > 
> > > I wonder if there somewhere we could formally document these conventions...
> > > 
> > > Like maybe at least near the "exitcode" global declaration?
> > 
> > I really think we need to rework the way we do the error handling
> > in the command line parsing for these utilities. One of the things I
> > found in doing this is that most of the code does return error codes
> > to the main function, only then to drop it on the floor and turn it
> > into "exitcode = 1; return 0;" pair.
> > 
> > So I'm pondering how to make this much simpler - returning error
> > codes from the command functions would be a much better idea,
> > then have a command flag to indicate whether we continue on error or
> > terminate.
> > 
> > That moves all the exit code handling out of the commands and
> > provides consistent error handling for all commands and
> > infrastructure - 0 = success, failure returns negative errno - and
> > so should enable much more reliable and consistent error handling
> > across all the utilities....
> 
> It seems reasonable to me, though I wonder how fstests will react to
> that.  Then again, a lot of xfs_io error handling seems to be done via
> grep so maybe it wouldn't be that bad. :)

Pretty much. I don't think it will have much impact at all. This
patch hasn't caused any new failures in my fstests runs at all, so I
don't think further work to simplify this functionality will cause
new problems, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
