Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3301C432C3
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 23:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B0B9223C8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 23:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgL1Wz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Dec 2020 17:55:56 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33122 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729604AbgL1WHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Dec 2020 17:07:10 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id B58DE9BD8;
        Tue, 29 Dec 2020 09:06:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ku0ek-000i2E-GY; Tue, 29 Dec 2020 09:06:22 +1100
Date:   Tue, 29 Dec 2020 09:06:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Extreme fragmentation ho!
Message-ID: <20201228220622.GA164134@dread.disaster.area>
References: <20201221215453.GA1886598@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221215453.GA1886598@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=Cl9GS8SSFwKT9TAkjrQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 22, 2020 at 08:54:53AM +1100, Chris Dunlop wrote:
> Hi,
> 
> I have a 2T file fragmented into 841891 randomly placed extents. It takes
> 4-6 minutes (depending on what else the filesystem is doing) to delete the
> file. This is causing a timeout in the application doing the removal, and
> hilarity ensues.

~3,000 extents/s being removed, with reflink+rmap mods being made for
every extent. Seems a little slow compared to what I typically see,
but...

> The fragmentation is the result of reflinking bits and bobs from other files
> into the subject file, so it's probably unavoidable.
> 
> The file is sitting on XFS on LV on a raid6 comprising 6 x 5400 RPM HDD:

... probably not that unreasonable for pretty much the slowest
storage configuration you can possibly come up with for small,
metadata write intensive workloads.

> # xfs_info /home
> meta-data=/dev/mapper/vg00-home  isize=512    agcount=32, agsize=244184192 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1
> data     =                       bsize=4096   blocks=7813893120, imaxpct=5
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I'm guessing the time taken to remove is not unreasonable given the speed of
> the underlying storage and the amount of metadata involved. Does my guess
> seem correct?

Yup.

> I'd like to do some experimentation with a facsimile of this file, e.g.  try
> the remove on different storage subsystems, and/or with a external fast
> journal etc., to see how they compare.

I think you'll find a limit at ~20,000 extents/s, regardless of your
storage subsystem. Once you take away IO latency, it's basically
single threaded and CPU bound so performance is largely dependent
on how fast your CPUs are. IOWs, the moment you move to SSDs, it
will be CPU bound and still take a minute or two to remove all the
extents....

> What is the easiest way to recreate a similarly (or even better,
> identically) fragmented file?

Just script xfs_io to reflink random bits and bobs from other files
into a larger file?

> One way would be to use xfs_metadump / xfs_mdrestore to create an entire
> copy of the original filesystem, but I'd really prefer not taking the
> original fs offline for the time required. I also don't have the space to
> restore the whole fs but perhaps using lvmthin can address the restore
> issue, at the cost of a slight(?) performance impact due to the extra layer.

Easiest, most space efficient way is to mdrestore to a file (ends up
sparse, containing only metadata), mount it via loopback.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
