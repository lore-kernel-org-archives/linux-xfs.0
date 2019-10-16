Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A29ECE599
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 20:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858D721835
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 20:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437130AbfJPU3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:29:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34146 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728881AbfJPU3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 16:29:05 -0400
Received: from dread.disaster.area (pa49-181-198-88.pa.nsw.optusnet.com.au [49.181.198.88])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C67EA43E9FD;
        Thu, 17 Oct 2019 07:29:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iKpul-00017O-7K; Thu, 17 Oct 2019 07:28:59 +1100
Date:   Thu, 17 Oct 2019 07:28:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     =?iso-8859-1?Q?=22Marc_Sch=F6nefeld=22?= <marc.schoenefeld@gmx.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Sanity check for m_ialloc_blks in libxfs_mount()
Message-ID: <20191016202859.GI16973@dread.disaster.area>
References: <trinity-92785614-c99b-4de9-98e8-71be71c0df0d-1571252931141@3c-app-gmx-bs59>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-92785614-c99b-4de9-98e8-71be71c0df0d-1571252931141@3c-app-gmx-bs59>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=ocld+OpnWJCUTqzFQA3oTA==:117 a=ocld+OpnWJCUTqzFQA3oTA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=XobE76Q3jBoA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=5xOlfOR4AAAA:8 a=7-415B0cAAAA:8
        a=nGdYznVvUrD5B_u1YPsA:9 a=wPNLvfGTeEIA:10 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 09:08:51PM +0200, "Marc Schönefeld" wrote:
> Hi all, 
> 
> it looks like there is a sanity check missing for the divisor
> (m_ialloc_blks) in line 664 of xfsprogs-5.2.1/libxfs/init.c: 
> Program received signal SIGFPE, Arithmetic exception.
> 
> 0x0000000000427ddf in libxfs_mount (mp=mp@entry=0x6a2de0 <xmount>, sb=sb@entry=0x6a2de0 <xmount>, dev=18446744073709551615, 
>     logdev=<optimized out>, rtdev=<optimized out>, flags=flags@entry=1) at init.c:663
> 
> which is 
> 
>     663                 mp->m_maxicount = XFS_FSB_TO_INO(mp,
>     664                                 (mp->m_maxicount / mp->m_ialloc_blks) *
>     665                                  mp->m_ialloc_blks);

That's code is gone now. The current calculation in the dev tree is
quite different thanks to:

commit 3a05ab227ebd5982f910f752692c87005c7b3ad3
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Wed Aug 28 12:08:08 2019 -0400

    xfs: refactor inode geometry setup routines
    
    Source kernel commit: 494dba7b276e12bc3f6ff2b9b584b6e9f693af45
    
    Migrate all of the inode geometry setup code from xfs_mount.c into a
    single libxfs function that we can share with xfsprogs.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

And so it doesn't have a divide-by-zero vector in it anymore. 

So it's probably best that you update your source tree to the latest
for-next and retest. It's almost always a good idea to test against
the latest dev tree, that way you aren't finding bugs we've already
found and fixed...

> In case it would be required I have a reproducer file for this,
> which I can share via pm. The bug is reachable from user input via
> the "xfs_db -c _cmd_ _xfsfile_" command.   

I'm guessing that you are fuzzing filesystem images and the issue is
that the inode geometry values in the superblock have been fuzzed to
be incorrect?  What fuzzer are you using to generate the image, and
what's the mkfs.xfs output that was used to create the base image
that was then fuzzed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
