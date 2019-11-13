Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0782C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 20:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70EAE206E6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 20:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKMUlC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 15:41:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36433 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbfKMUlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 15:41:01 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5BEBA7EA0D8;
        Thu, 14 Nov 2019 07:40:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUzRh-0007Cq-GQ; Thu, 14 Nov 2019 07:40:57 +1100
Date:   Thu, 14 Nov 2019 07:40:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191113204057.GV4614@dread.disaster.area>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area>
 <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia>
 <CAK8P3a2+AhLj+eAJVmKZ_V82Xgdb87vv8o01CzYQ=MCNA5bU-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2+AhLj+eAJVmKZ_V82Xgdb87vv8o01CzYQ=MCNA5bU-A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=fvAVoxjuEcSe2doRA1gA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 02:20:44PM +0100, Arnd Bergmann wrote:
> On Wed, Nov 13, 2019 at 5:59 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Wed, Nov 13, 2019 at 06:42:09AM +0200, Amir Goldstein wrote:
> > > [CC:Arnd,Deepa]
> > > On Wed, Nov 13, 2019 at 5:56 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > >
> > > > On Wed, Nov 13, 2019 at 08:11:53AM +1100, Dave Chinner wrote:
> > > > > On Tue, Nov 12, 2019 at 06:00:19AM +0200, Amir Goldstein wrote:
> > > > > > On Tue, Nov 12, 2019 at 12:35 AM Darrick J. Wong
> > > > > > <darrick.wong@oracle.com> wrote:
> > > >
> > >
> > > I didn't get why you dropped the di_pad idea (Arnd's and Dave's patches).
> > > Is it to save the pad for another rainy day?
> >
> > Something like that.  Someone /else/ can worry about the y2486 problem.
> >
> > <duck>
> >
> > Practically speaking I'd almost rather drop the precision in order to
> > extend the seconds range, since timestamp updates are only precise to
> > HZ anyway.
> 
> I think there would be noticeable overhead from anything that requires
> a 64-bit division to update a timestamp, or to read it into an in-memory
> inode, especially on 32-bit architectures.

Comapred to actually allocating the inode, initialising it, etc?
The cost of a division is noise and, as such, is completely
irrelevant. It's classic premature micro-optimisation of CPU usage
without any regard for the context in which the division might
occur.

Seriously, XFS is not a filesystem for small, poorly performing 32
bit CPUs. It's a filesystem for 64 bit servers with hundreds of
CPUs, terabytes of memory and storage capable of millions of IOPs.
All I care about is that it /works/ on tiny systems and doesn't
corrupt filesystems - we've already made so many compromises in
terms of algorithmic scalability and memory usage that XFS
performance does not scale down effectively to tiny machines and
tiny filesystems.

IOWs, if you have a slow, poorly implemented 32 bit CPU with limited
RAM and storage capability, then XFS is not the filesystem for your
hardware. And in that context, the cost of a 64bit integer division
is largely irrelevant to us.

> I think the reason why separate seconds/nanoseconds are easy is that
> this is what both the in-kernel and user space interface are based around.

That's also largely irrelevant to what we store on disk. We store
lots of stuff in encoded data structures because it's more space
efficient to do so. We trade off CPU time for space efficiency
-everywhere- in the XFS filesystem, because CPU is far cheaper than
the RAM to store it and cheaper than moving information to/from disk.

> We clearly don't use the precision, but anything else is more expensive
> at runtime.

It's noise in runtime CPU profiles. It's far more important for the
filesystem on-disk format to be sane, scalable, maintainable and
repairable than it is to save a CPU cycle or two in a path
that is several thousand CPU instructions long already....

> > > Is there any core xfs developer that was going to tackle this?
> > >
> > > I'm here, so if you need my help moving things forward let me know.
> >
> > I wrote a trivial garbage version this afternoon, will have something
> > more polished tomorrow.  None of this is 5.6 material, we have time.
> 
> I think from a user perspective, it would be the nicest to just add the

The *user* does not see or know anything to do with what is on disk,
nor does the kernel code outside the disk->memory translation
functions. What the users passes to/from the kernel is irrelevant
when discussing how we store something on disk. Indeed, what the
kernel passes to the filesystem is largely irrelevant, too :)

> the existing behavior: setting a timestamp after 2038 using utimensat()
> silently wraps the seconds back to the regular epoch. With the
> extension patch, you get the correct results as long as the inode was
> both written and read on a new enough kernel, while all pre-5.4
> kernels produce the same incorrect data that they always have.

Feature bits prevent the new format being read on old kernels.
We can't allow an old kernel to parse an structure that it will
present to the user incorrectly because it was written by a more
recent kernel. Changing timestamp formats means old kernels can no
longer mount that filesystem, and that goes for your changes as well
- an old kernel will silently mishandle a >2038 date, and may even
detect it as corruption because we expect padding to be zero on
unused on-disk fields. Worse, older kernels will overwrite the new
epoch fields with zeros when the inode is re-written, destroying
the >y2038 timestamp information that is in that padding.

IOWs, old kernels do not preserve stuff written into on-disk
strucutre padding - the expect it to be zero and will write zeros
there whenever the structure is written to disk. That means these
epoch based y2038k format changes are not forwards or backwards
compatible - you can't interchange the filesystem between kernels
that do/don't support y2038k timestamps and expect it to works
correctly - feature bits are needed to prevent the timestamps from
being mis-interpretted or silently corrupted.

That means it's a one-way conversion. Hence if the old format
wrapped back to <1970, then new value written to disk will encode
that <1970 date to disk *in the new format*. Nothing gets lost or
changed in the process, and it's clear that an old kernel cannot
mangle it because it can no longer mount the filesystem that holds
new format timestamps....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
