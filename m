Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C73C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61AB619E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhCWWDQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 18:03:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53984 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233769AbhCWWCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 18:02:44 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5CA9A10465B1;
        Wed, 24 Mar 2021 09:02:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOp6l-005yrn-FE; Wed, 24 Mar 2021 09:02:39 +1100
Date:   Wed, 24 Mar 2021 09:02:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ralf =?iso-8859-1?Q?Gro=DF?= <ralf.gross+xfs@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: memory requirements for a 400TB fs with reflinks
Message-ID: <20210323220239.GG63242@dread.disaster.area>
References: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
 <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
 <20210322215039.GV63242@dread.disaster.area>
 <CANSSxyk0sKzTmUKitwsxvip-N+TdLmPDrHYFAL9TUDB7gs1Bsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANSSxyk0sKzTmUKitwsxvip-N+TdLmPDrHYFAL9TUDB7gs1Bsg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=8nJEP1OIZ-IA:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=ByG9n77nS2TrNZs5M-8A:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
        a=fCgQI5UlmZDRPDxm0A3o:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 10:39:27AM +0100, Ralf Groß wrote:
> Hi Dave,
> 
> > People are busy, and you posted on a weekend. Have some patience,
> > please.
> 
> I know, sorry for that.
> 
> > ....
> >
> > So there's no one answer - the amount of RAM xfs_repair might need
> > largely depends on what you are storing in the filesystem.
> 
> I just checked our existing backups repositories. The backup files are
> VMware image backup files, daily ones are smaller, weekly/GFS larger.
> But the are not millions of smaller files. For primary backup there
> are ~25.000 files in 68 TB of a 100 TB share, for a new repository
> with a 400 TB fs this would result in ~150.000 files. For the the
> secondary copy repository I see 3000 files in a 100 TB share. This
> would there result in ~200.000 files in a 700 TB repository. Is there
> any formula to calculate the memory requirement for a number of files?

Worse case static data indexing memory usage can be reported by
xfs_repair itself by abusing verbose reporting and memory limiting.
A 500TB filesystem with 50 million zero length files in it:

# xfs_repair -n -vvv -m 1 /dev/vdc
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - max_mem = 1024, icount = 51221120, imem = 200082, dblock = 134217727500, dmem = 65535999
Required memory for repair is greater that the maximum specified
with the -m option. Please increase it to at least 64244.
#

Says that worst case it is going to need "dmem = 65535999" to index
the space usage. That's 64GB of RAM. Inode based requirements are
"imem = 200082" another 200MB for indexing 50 million inodes. Of
course, there is the inodes themselves and all the other metadata
that need to be brought into RAM, but that is typically paged in and
out of the buffer cache that is not actually included in these
memory usage counts.

So for a 500GB filesystem with minimal metadata and large contiguous
files as you describe you're probably only going to need a few GB of
RAM to repair it. OF course, if things get broken, then you should
plan for worst case minimums as described by xfs_repair above...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
