Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC151C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 23:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79DA6206D6
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 23:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKOXnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 18:43:39 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52037 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727083AbfKOXnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 18:43:39 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9EF2E43FE82;
        Sat, 16 Nov 2019 10:43:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iVlFV-0007F7-RV; Sat, 16 Nov 2019 10:43:33 +1100
Date:   Sat, 16 Nov 2019 10:43:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Andrew Carr <andrewlanecarr@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
Message-ID: <20191115234333.GP4614@dread.disaster.area>
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=XHgNo8fARR8IOoOJVyMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 01:52:57PM -0600, Eric Sandeen wrote:
> On 11/15/19 1:11 PM, Andrew Carr wrote:
> > Hello,
> > 
> > This list has recommended enabling stack traces to determine the root
> > cause of issues with XFS deadlocks occurring in Centos 7.7
> > (3.10.0-1062).
> > 
> > Based on what was recommended by Eric Sandeen, we have tried updating
> > the following files to generate XFS stack traces:
> > 
> > # echo 11 > /proc/sys/fs/xfs/error_level
> > 
> > And
> > 
> > # echo 3 > /proc/sys/fs/xfs/error_level
> > 
> > But no stack traces are printed to dmesg.  I was thinking of
> > re-compiling the kernel with debug flags enabled.  Do you think this
> > is necessary?

dmesg -n 7 will remove all filters on the console/dmesg output - if
you've utrned this down in the past you may not be seeing messages
of the error level XFS is using...

Did you check syslog - that should have all the unfiltered messages
in it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
