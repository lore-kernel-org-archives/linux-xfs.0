Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912E4C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 21:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3FE619A9
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 21:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCVVvH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 17:51:07 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38161 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCVVuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 17:50:52 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 3127863C1F;
        Tue, 23 Mar 2021 08:50:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOSRb-005b09-Gm; Tue, 23 Mar 2021 08:50:39 +1100
Date:   Tue, 23 Mar 2021 08:50:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ralf =?iso-8859-1?Q?Gro=DF?= <ralf.gross+xfs@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: memory requirements for a 400TB fs with reflinks
Message-ID: <20210322215039.GV63242@dread.disaster.area>
References: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
 <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=8nJEP1OIZ-IA:10 a=dESyimp9J3IA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=m5aNOxJfd4GQ2X_wVs8A:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 05:50:55PM +0100, Ralf Groﬂ wrote:
> No advice or rule of thumb regarding needed memory for xfs_repair?

People are busy, and you posted on a weekend. Have some patience,
please.

> Am Sa., 20. M‰rz 2021 um 19:01 Uhr schrieb Ralf Groﬂ <ralf.gross+xfs@gmail.com>:
> >
> > Hi,
> >
> > I plan to deploy a couple of Linux (RHEL 8.x) server as Veeam backup
> > repositories. Base for this might be high density server with 58 x
> > 16TB disks, 2x  RAID 60, each with its own raid controller and 28
> > disks. So each RAID 6 has 14 disks, + 2 globale spare.
> >
> > I wonder what memory requirement such a server would have, is there
> > any special requirement regarding reflinks? I remember that xfs_repair
> > has been a problem in the past, but my experience with this is from 10
> > years ago. Currently I plan to use 192GB RAM, this would be perfect as
> > it utilizes 6 memory channels and 16GB DIMMs are not so expensive.

Filesystem capacity doesn't massively affect repair memory usage
these days.

The amount of metadata and the type of it certainly does, though. I
recently saw a 14TB filesystem require 240GB of RAM to repair
because, as a hardlink based backup farm, it had hundreds of
millions of directories, inodes and hardlinks in it.  Resolving all
those directories and hardlinks took 3 weeks and 240GB of RAM....

I've seen other broken backup server filesystems of similar size
that have had close on 500GB of metadata in them, and repair needs
to index and cross-reference all that metadata. Hence memory demands
can be massive, even in today's terms....

Unfortunately, I haven't seen a broken filesystem containing
extensive production use of reflink at that scale, so I can't really
say what difference that will make to memory usage at this point in
time.

So there's no one answer - the amount of RAM xfs_repair might need
largely depends on what you are storing in the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
