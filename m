Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36151 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726570AbeIMNlU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Sep 2018 09:41:20 -0400
Date: Thu, 13 Sep 2018 18:32:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/119: fix too small log size error
Message-ID: <20180913083250.GA16550@dastard>
References: <20180912110404.32673-1-zlang@redhat.com>
 <20180912131509.GA17817@desktop>
 <20180912152507.GF8382@dhcp-12-152.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912152507.GF8382@dhcp-12-152.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 12, 2018 at 11:25:08PM +0800, Zorro Lang wrote:
> On Wed, Sep 12, 2018 at 09:15:09PM +0800, Eryu Guan wrote:
> > On Wed, Sep 12, 2018 at 07:04:04PM +0800, Zorro Lang wrote:
> > > xfs/119 fails on 4k hard sector size device if reflink (with/without
> > > rmapbt) is enabled:
> > > 
> > >   # mkfs.xfs -f -m reflink=1,rmapbt=0 -l version=2,size=2560b,su=64k /dev/sdf
> > >   log size 2560 blocks too small, minimum size is 2688 blocks
> > >   # mkfs.xfs -f -m reflink=1,rmapbt=1 -l version=2,size=2560b,su=64k /dev/sdf
> > >   log size 2560 blocks too small, minimum size is 4368 blocks
> > > 
> > > So remove log size parameter and run mkfs.xfs again if it fails.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > > 
> > > I saw Dave changed the log size once in commit:
> > >   d0a3cc5a xfs/104: log size too small for 4k sector drives
> > > 
> > > But it's still not enough after we have reflink feature now. I don't
> > > know why this case need "-l version=2,size=2560b,su=64k",
> > > if someone learns about this case, please tell me how to change this
> > > case properly. If the log size parameter is not necessary, I'd like
> > > to remove it.
> > 
> > I guess we still need the log size param, as the test is testing
> > "freeze/thaws on a small log fs", please see commit 3ebdf78c16cb ("Test
> > out pv#942130 where the unmount rec is not ungranting log space. Merge
> > of master-melb:xfs-cmds:23759a by kenmcd."), but we don't have much
> > background information from that ancient commit log..
> 
> Yeah, I can't understand the pv#942130 meaning, and can't find it by Google.
> Does anyone know the background, then tell me if it must use the minimum
> log size?

s/pv/bz/

i.e. PV was the SGI internal bug tracking system. You'll never find
it in google.

The issue with that test was exercising was a log space leak caused
by unmount records not correctly reserving/releasing log space.
Freezzing the filesystem writes an unmount record, and hence when
filesystems were repeatedly frozen (e.g. for snapshots or backups)
they'd eventually leak enough log space to hang.

With a 10MB log, 100 iterations of the freeze/unfreeze loop leaked
enough log space that the test would hang. If you're going to
increase the log size, you need to increase the number of iterations
appropriately.

(The amount of almost entirely useless crap that has stuck inside my
head over the years never ceases to amaze me!)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
