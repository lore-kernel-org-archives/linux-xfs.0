Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E71C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 21:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376623AbiAXVTh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 16:19:37 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48584 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1448642AbiAXVNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 16:13:34 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CE29E62C64A;
        Tue, 25 Jan 2022 08:13:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nC6eX-003mxR-NP; Tue, 25 Jan 2022 08:13:29 +1100
Date:   Tue, 25 Jan 2022 08:13:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: CFQ or BFQ scheduler and XFS
Message-ID: <20220124211329.GM59729@dread.disaster.area>
References: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
 <20220123225201.GK59729@dread.disaster.area>
 <cc75ce7be96964eb1b95783b3fb16158@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc75ce7be96964eb1b95783b3fb16158@assyoma.it>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61ef167c
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=iOdoAmxXnQiorFT5hPoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 24, 2022 at 08:55:38AM +0100, Gionatan Danti wrote:
> Il 2022-01-23 23:52 Dave Chinner ha scritto:
> > CFQ doesn't understand that IO from different threads/tasks are
> > related and so it cannot account for/control multi-threaded IO
> > workloads.  Given that XFS's journal IO is inherently a
> > multi-threaded IO workload, CFQ IO accounting and throttling simply
> > does not work properly with XFS or any other filesystem that
> > decouples IO from the user task context that requires the IO to be
> > done on it's behalf.
> 
> Hi Dave,
> ah, so it forces all threads under the same time slice? I thought it was
> thread aware...

No, the opposite. e.g. thread A does IO and then runs fsync(), which
needs to force the log, that triggers CIL push work which runs in a
different thread B.  Thread A blocks waiting for the CIL push,
thread B runs immediately.  Thread B then issues log IO, but the IO
from thread B is queued by CFQ because thread A's timeslice hasn't
expired. Hence log force is delayed until thread A's timeslice
expires, even though it is being done on behalf of thread A and
thread A is blocked until the IO from Thread B is scheduled and
completed.

> Is it the same even for BFQ?

No idea - I use noop for everything these days because IO schedulers
often cause more problems than they solve on SSDs, sparse virtual
machine images, thinly provisioned storage, etc....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
