Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9577AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0CB206DD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHTWOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 18:14:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59336 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728283AbfHTWOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 18:14:48 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2466C43D7C3;
        Wed, 21 Aug 2019 08:14:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0CNl-00014Y-Jd; Wed, 21 Aug 2019 08:13:37 +1000
Date:   Wed, 21 Aug 2019 08:13:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820221337.GH1119@dread.disaster.area>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
 <20190820080741.GE1119@dread.disaster.area>
 <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
 <20190820105101.GA14307@bfoster>
 <20190820112304.GF1119@dread.disaster.area>
 <20190820122300.GB14307@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820122300.GB14307@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=fj9TDP3gWvWqASHTkgkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 08:23:00AM -0400, Brian Foster wrote:
> On Tue, Aug 20, 2019 at 09:23:04PM +1000, Dave Chinner wrote:
> > On Tue, Aug 20, 2019 at 06:51:01AM -0400, Brian Foster wrote:
> > > On Tue, Aug 20, 2019 at 04:53:22PM +0800, kaixuxia wrote:
> > > FWIW if we do take that approach, then IMO it's worth reconsidering the
> > > 1-2 liner I originally proposed to fix the locking. It's slightly hacky,
> > > but really all three options are hacky in slightly different ways. The
> > > flipside is it's trivial to implement, review and backport and now would
> > > be removed shortly thereafter when we replace the on-disk whiteout with
> > > the in-core fake whiteout thing. Just my .02 though..
> > 
> > We've got to keep the existing whiteout method around for,
> > essentially, forever, because we have to support kernels that don't
> > do in-memory translations of DT_WHT to a magic chardev inode and
> > vice versa (i.e. via mknod). IOWs, we'll need a feature bit to
> > indicate that we actually have DT_WHT based whiteouts on disk.
> > 
> 
> I'm not quite following (probably just because I'm not terribly familiar
> with the use case). If current kernels know how to fake up whiteout
> inodes in memory based on a dentry, why do we need to continue to create
> new on-disk whiteout inodes just because a filesystem might already have
> such inodes on disk?

We don't, unless there's a chance the filesystem will be booted
again on an older kernel. So it's a one-way conversion: once we
start using DT_WHT based whiteouts, there is no going back.

> Wouldn't the old format whiteouts just continue to
> work as expected without any extra handling?

Yes, but that's not the problem. It's forwards compatibility that
matters here.  i.e. upgrade a kernel, something doesn't work, roll
back to older kernel. Everything should work if the feature set on
the filesystem is unchanged, even though the filesystem was used
with a newer kernel.

If the newer kernel has done something on disk that the older kernel
does not understand (e.g. using DT_WHT based whiteouts), then the
newer kernel must mark the filesystem with a feature bit to prevent
the older kernel from doing the wrong thing with the format it
doesn't exect to see. Mis-parsing a whiteout and not applying it
correctly is a stale data exposure security bug, so we have to be
careful here.

Existing kernels don't know how to take a DT_WHT whiteout and fake
up a magical chardev inode. Hence DT_WHT whiteouts will not work
correctly on current kernels, even though we have DT_WHT in the dir
ftype feature (and hence available on both v4 and v5 filesystems).
i.e. the issue here is the VFS has defined the on-disk whiteout
format, and we want the on-disk storage from chardev inodes to
DT_WHT. Hence we need a feature bit because we are changing the
method of storing whiteouts on disk, even though we
-technically- aren't changing the _XFS_ on-disk format.

Think of it as though DT_WHT support doesn't exist in XFS, and now
we are going to add it...

> I can see needing a feature bit to restrict a filesystem from being used
> on an unsupported, older kernel, but is there a reason we wouldn't just
> enable that by default anyways?

Rule #1: Never enable new on-disk feature bits by default

:)

Yes, in future we can decide to automatically enable the feature bit
in the kernel code, but that's not something we can do until kernel
support for the DT_WHT based whiteouts is already widespread as it's
not a backwards compatible change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
