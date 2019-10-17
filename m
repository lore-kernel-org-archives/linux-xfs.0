Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89477FA372A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 09:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69274214E0
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 09:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439582AbfJQJ6L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 05:58:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50538 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393881AbfJQJ6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 05:58:10 -0400
Received: from dread.disaster.area (pa49-181-198-88.pa.nsw.optusnet.com.au [49.181.198.88])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D5F1243E5F1;
        Thu, 17 Oct 2019 20:58:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iL2Xl-000622-0E; Thu, 17 Oct 2019 20:58:05 +1100
Date:   Thu, 17 Oct 2019 20:58:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     =?iso-8859-1?Q?=22Marc_Sch=F6nefeld=22?= <marc.schoenefeld@gmx.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Re: Sanity check for m_ialloc_blks in libxfs_mount()
Message-ID: <20191017095804.GL16973@dread.disaster.area>
References: <trinity-0da2b218-4863-4722-86f8-702d39a9f882-1571295381809@3c-app-gmx-bs26>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-0da2b218-4863-4722-86f8-702d39a9f882-1571295381809@3c-app-gmx-bs26>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=ocld+OpnWJCUTqzFQA3oTA==:117 a=ocld+OpnWJCUTqzFQA3oTA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=3oNBbgyL5Baj1lQHxwMA:9 a=nB4qUZYVcwngDOR-:21
        a=yVLkn_vBY3MJZUO3:21 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 08:56:21AM +0200, "Marc Schönefeld" wrote:
> Hi Dave, [resent due to smtp error] 

It got rejected because you sent a HTML-only email to the list.

> thanks for the help, now using the for-next branch, there is still an Arithmetic exception, however somewhere else:

Also, while on list-etiquette, can you please wrap your comments at
72 columns, and please try not to top post as it makes it really hard
to keep the discussion context straight.

> Program received signal SIGFPE, Arithmetic exception.
> xfs_ialloc_setup_geometry (mp=mp@entry=0x6a5e60 <xmount>) at xfs_ialloc.c:2792
> 2792 do_div(icount, igeo->ialloc_blks);

So, same as last time, there's a discrepancy between two fields
in the superblock: sbp->sb_inopblock and sbp->sb_inopblog.

Basically, the inodes per block is smaller than the log2 value of
the number of inodes per block. which implies that sb_inopblog is
greater than 7, unless you've configured the filesystem with a block
size > 4kB.

It also implies that this verifier check:

	(sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)

has also passed, which means either sb_blocklog (the filesystem
block size) and/or the sb_inodelog (inode size) values have also
been tweaked in a way for this test to pass, but to still ahve an
a mismatch betwen sb_inopblock and sb_inopblog.

But we also have a check:

	sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize)

which checks taht the number of inodes per block matches the
filesystem block size and the inode size configured, and:

	sbp->sb_blocksize != (1 << sbp->sb_blocklog)

and
	sbp->sb_inodesize != (1 << sbp->sb_inodelog)

which validate the log2 values match the byte based values.

So I can't see how it got to this code with such a mismatch unless
xfs_db actually ignored it.  And without all the output from xfs_db,
I don't know what errors it has detected and ignored. Hence, when
reporting a problem, can you please include the full output from the
program that has failed, including the command line used to invoke
it?

Further, knowing what the filesystem geometry is supposed to be
tells me an awful lot, too, which is why I asked this last time:

> I'm guessing that you are fuzzing filesystem images and the issue is
> that the inode geometry values in the superblock have been fuzzed to
> be incorrect? What fuzzer are you using to generate the image, and
> what's the mkfs.xfs output that was used to create the base image
> that was then fuzzed?

Because then I know what the values are supposed to be before I look
at the fuzzed image and can clearly tell waht has been manipulated
by the fuzzer.

Also, keep in mind that xfs_db is a diagnostic tool for developers -
it's not a user tool. We use it for digging around in corrupt
structures and hence it often reports then ignores corruption iti
detects so it can display the corrupt structure to the user. i.e.
it's a tool intended to what it is asked to do regardless of the
fact it might not be able to handle the result cleanly.

Hence I'm not sure there is a huge value in actually fuzz testing
xfs_db. It's certainly not at all interesting from a security point
of view...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
