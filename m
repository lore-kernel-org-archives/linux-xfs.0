Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DF9C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 21:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5D361942
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 21:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFYV3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 17:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFYV3d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 17:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F331616EA;
        Fri, 25 Jun 2021 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624656431;
        bh=qzPMOHcBl1VL4GcrIewH2DHoCmyKWaNvEpAkrRuteMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1XlbU2/C+vvsK1hXTbeL6bIIpynvN950MmyBZwiqgE8xHiZrb8+Yj5bpl0rhFyyK
         EsaQleAZcsaSj5FvTjJW1MkR2EXK9c9WwFSN4Z/BhcfBAHHdA5xHZg8F/iMQsMYZ3/
         003GwiFVgEkrpHZ4FN4WUAgDnwuoaGlIoYm3ezhfIAKGfnmzAmEB+4MTBh1l/0lzBK
         o6pYPa0grfVVBJZFNN7FS5u3t+Uy2xvUfR/tDlBQjPYhGp6JyK248AYEPp3I4yLSUT
         NTvoeQeJLESQ8Jwd6iG982vd5cr9EsWjJOSVtHREWEwy+FpM398agWQddAJeWdqG6L
         AcejKHGNPHzmQ==
Date:   Fri, 25 Jun 2021 14:27:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ml Ml <mliebherr99@googlemail.com>, linux-xfs@vger.kernel.org
Subject: Re: XFS Mount need ages
Message-ID: <20210625212710.GF13784@locust>
References: <CANFxOjCAYYs7ck0wrnM1AD0pBKE74=4PcDj_k+gHGjDmmvZBzg@mail.gmail.com>
 <CANFxOjATBAnEJ=pZEjsdsbaY=ziGOo8b3fXL_otYRmDPQOi=_w@mail.gmail.com>
 <20210625211242.GC664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210625211242.GC664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 26, 2021 at 07:12:42AM +1000, Dave Chinner wrote:
> On Fri, Jun 25, 2021 at 02:05:29PM +0200, Ml Ml wrote:
> > After a loong time it mounted now. Here is some more info:
> > 
> > xfs_info /mnt/backup-cluster5
> > meta-data=/dev/rbd6              isize=512    agcount=65536, agsize=32768 blks
>                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=2147483648, imaxpct=25
> >          =                       sunit=16     swidth=16 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=2560, version=2
>                                                 ^^^^^^^^^^^
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > On Fri, Jun 25, 2021 at 12:49 PM Ml Ml <mliebherr99@googlemail.com> wrote:
> > >
> > > Hello List,
> > >
> > > i have a rbd block device with xfs on it. After resizing it (from 6TB
> > > to 8TB i think) the mount need hours to complete:
> > >
> > > I started the mount 15mins ago.:
> > >   mount -nv /dev/rbd6 /mnt/backup-cluster5
> > >
> > > ps:
> > > root      1143  0.2  0.0   8904  3088 pts/0    D+   12:17   0:03  |
> > >    \_ mount -nv /dev/rbd6 /mnt/backup-cluster5
> > >
> > >
> > > There is no timeout or ANY msg in dmesg until now.
> > >
> > > strace -p 1143  :  seems to do nothing.
> > > iotop --pid=1143: uses about 50KB/sec
> > >
> > > dd bs=1M count=2048 if=/dev/rbd6 of=/dev/null => gives me 50MB/sec
> > >
> > >
> > > Any idea what´s the problem here?
> 
> You started with a ~10GB sized filesystem (based on sunit, agsize
> and log size) and have grown it almost 3 orders of magnitude. This
> is way beyond recommendations - problems with fs layout tend to
> expose themselves before the filesystem has been grown by a factor
> of 10x, let alone ~1000x.
> 
> What I'd say is happening here is that if mount needed to iterate
> all the AGs for some reason (e.g. an unclean shutdown), and it now
> has to read all the AGF and AGI headers.  That's 130,000 IOs it now
> needs to do.  At 100 IOPS, that's going to take 1300 seconds - a bit
> over 20 minutes. And mount may have to do more than this (read AG
> btrees to count blocks), so it could be doing thousands of IOs per
> AG, which because of the sub-optimal layout, is multiplied by tens
> of thousands of times...

finobt=1 and no mention of inobtcount, which means it's going to mount
verrrry slowly as it walks the free inode btree in each AG to figure out
how much space to reserve for that index.

--D

> 
> Ceph RBDs ain't the fastest devices around, so this is very likely.
> 
> When you deploy a TB scale device, start with a TB-scale device, not
> a device that is <10GB. Starting with a TB scale device will give
> you TB-scale AGs, not 128MB sized AGs. Scanning a couple of dozen
> AGs takes very little time, scanning tens of thousands of tiny AGs
> takes a long time...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
