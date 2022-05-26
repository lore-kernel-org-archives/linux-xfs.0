Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EBDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 00:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345301AbiEZAL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 20:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345252AbiEZAL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 20:11:56 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A9D26391;
        Wed, 25 May 2022 17:11:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BD6DE52C19B;
        Thu, 26 May 2022 10:11:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nu16T-00GQ6f-3D; Thu, 26 May 2022 10:11:49 +1000
Date:   Thu, 26 May 2022 10:11:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <20220526001149.GW2306852@dread.disaster.area>
References: <Yo03mZ12X1nLGihK@magnolia>
 <20220524234426.GQ2306852@dread.disaster.area>
 <Yo1vCizXEK7+AkZi@magnolia>
 <20220525002413.GT2306852@dread.disaster.area>
 <Yo66ACF65ao6Akis@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo66ACF65ao6Akis@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628ec5c8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=zYDHDbXY25DnOZbWMJkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 04:21:36PM -0700, Darrick J. Wong wrote:
> On Wed, May 25, 2022 at 10:24:13AM +1000, Dave Chinner wrote:
> > On Tue, May 24, 2022 at 04:49:30PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 25, 2022 at 09:44:26AM +1000, Dave Chinner wrote:
> > > > On Tue, May 24, 2022 at 12:52:57PM -0700, Darrick J. Wong wrote:
> > > > > +# First we try various small filesystems and stripe sizes.
> > > > > +for M in `seq 298 302` `seq 490 520`; do
> > > > > +	for S in `seq 32 4 64`; do
> > > > > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
> > > > > +	done
> > > > > +done
> > > > > +
> > > > > +# log so large it pushes the root dir into AG 1
> > > > > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> > > 
> > > ...this particular check in mkfs only happens after we allocate the root
> > > directory, which an -N invocation doesn't do.
> > 
> > Ok, so for this test can we drop the -N? We don't need to do 30 IOs
> > and write 64MB logs for every config we test - I think there's ~35 *
> > 8 invocations of test_format in the loop above before we get here...
> > 
> > Also, why do we need a 6.3TB filesystem with 2.1GB AGs and a 2GB log
> > to trigger this? That means we have to write 2GB to disk, plus
> > ~20,000 write IOs for the AG headers and btree root blocks before we
> > get to the failure case, yes?
> > 
> > Why not just exercise the failure case with something like this:
> > 
> > # mkfs.xfs -d agcount=2,size=64M -l size=8180b,agnum=0 -d file,name=test.img
> > meta-data=test.img               isize=512    agcount=2, agsize=8192 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=1    bigtime=0 inobtcount=0
> > data     =                       bsize=4096   blocks=16384, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=8180, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > mkfs.xfs: root inode created in AG 1, not AG 0
> 
> Welll... a better reason for why this test can't do that -- one of my
> fixes also made mkfs reject -l size=XXX when XXX is not possible.

So you make other changes to mkfs that aren't yet upstream that
check whether the log causes the root inode to change position?
I mean, '-l size=8180b' results in a log that fits perfectly fine in
an empty AG, and so you must have added more checks to detect this
moves the root inode somehow?

> That said... -d agcount=3200,size=6366g -lagnum=0 -N seems to work?

On a new mkfs binary with those checks that you mention above?  If
so, it seems to me that those new checks trigger for this case, too,
before we write anything?

IOWs, this won't fail on older mkfs.xfs binaries that don't have
these new log size checks because we never get around to allocating
the root inode and checking it's location, right?  Yet what we
really want here is for it to fail on an old mkfs binary?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
