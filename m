Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EDDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 21:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhLHVhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 16:37:16 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52520 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234396AbhLHVhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 16:37:16 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1D10A86B206;
        Thu,  9 Dec 2021 08:33:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mv4ZI-000kRx-0M; Thu, 09 Dec 2021 08:33:40 +1100
Date:   Thu, 9 Dec 2021 08:33:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Subject: Re: VMs getting into stuck states since kernel ~5.13
Message-ID: <20211208213339.GM449541@dread.disaster.area>
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61b124b6
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=nt1UNTH2AAAA:8
        a=7-415B0cAAAA:8 a=pACB8zbwR2vHINvUsHsA:9 a=CjuIK1q_8ugA:10
        a=1jnEqRSf4vEA:10 a=7AW3Uk2BEroXwU7YnAE8:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 08, 2021 at 01:54:02PM -0500, Chris Murphy wrote:
> Hi,
> 
> I'm trying to help progress a kernel regression hitting Fedora
> infrastructure in which dozens of VMs run concurrently to execute QA
> testing. The problem doesn't happen immediately, but all the VM's get
> stuck and then any new process also gets stuck, so extracting
> information from the system has been difficult and there's not a lot
> to go on, but this is what I've got so far.
> 
> Systems (Fedora openQA worker hosts) on kernel 5.12.12+ wind up in a
> state where forking does not work correctly, breaking most things
> https://bugzilla.redhat.com/show_bug.cgi?id=2009585
> 
> In that bug some items of interest ...
> 
> This megaraid_sas trace. The hang hasn't happened at this point
> though, so it may not be related at all or it might be an instigator.
> https://bugzilla.redhat.com/show_bug.cgi?id=2009585#c31

That's indicative of a bio handling bug somewhere in the storage
stack, likely the MD RAID layer...

> Once there is a hang, we have these traces from reducing the time for
> the kernel to report blocked tasks. Much of the messages I'm told from
> kvm/qemu folks are pretty ordinary/expected locks. But the XFS
> portions might give a clue what's going on?
> 
> 5.15-rc7
> https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840941

So you have processes waiting on both journal IO completion,
(xlog_wait_on_iclog()) and data IO completion
(wait_on_page_writeback()).

> 5.15+
> https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840939

And same here, except it is folio_wait_writeback() in this one.

They are all waiting for the storage to complete IOs.

> So I can imagine the VM's are stuck because XFS is stuck. And XFS is
> stuck because something in the block layer or megaraid driver is
> stuck, but I don't know that for certain.

Looking at the traces, I'd say IO is really slow, but not stuck.
`iostat -dxm 5` output for a few minutes will tell you if IO is
actually making progress or not.

Can you please provide the hardware configuration for these machines
and iostat output before we go any further here?

https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
