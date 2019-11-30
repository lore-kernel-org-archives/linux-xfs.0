Return-Path: <SRS0=J6xf=ZW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58DAC432C0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 20:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8C02075A
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 20:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfK3U27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 15:28:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36600 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfK3U27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 15:28:59 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 330783A208F;
        Sun,  1 Dec 2019 07:28:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ib9ML-000559-TI; Sun, 01 Dec 2019 07:28:53 +1100
Date:   Sun, 1 Dec 2019 07:28:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, Alex Lyakas <alex@zadara.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191130202853.GA2695@dread.disaster.area>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
 <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster>
 <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net>
 <20191127141929.GA20585@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127141929.GA20585@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=gqpMpNOyIz7mH3ll0X4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 27, 2019 at 06:19:29AM -0800, Christoph Hellwig wrote:
> Can we all take a little step back and think about the implications
> of the original patch from Alex?  Because I think there is very little.
> And updated sunit/swidth is just a little performance optimization,
> and anyone who really cares about changing that after the fact can
> trivially add those to fstab.
> 
> So I think something like his original patch plus a message during
> mount that the new values are not persisted should be perfectly fine.

Well, the original purpose of the mount options was to persist a new
sunit/swidth to the superblock...

Let's ignore the fact that it was a result of a CXFS client mount
bug trashing the existing sunit/swidth values, and instead focus on
the fact we've been telling people for years that you "only need to
set these once after a RAID reshape" and so we have a lot of users
out there expecting it to persist the new values...

I don't think we can just redefine the documented and expected
behaviour of a mount option like this.

With that in mind, the xfs(5) man page explicitly states this:

	The sunit and swidth parameters specified must be compatible
	with the existing filesystem alignment characteristics.  In
	general,  that  means  the  only  valid changes to sunit are
	increasing it by a power-of-2 multiple. Valid swidth values
	are any integer multiple of a valid sunit value.

Note the comment about changes to sunit? What is being done here -
halving the sunit from 64 to 32 blocks is invalid, documented as
invalid, but the kernel does not enforce this. We should fix the
kernel code to enforce the alignment rules that the mount option
is documented to require.

If we want to change the alignment characteristics after mkfs, then
use su=1,sw=1 as the initial values, then the first mount can use
the options to change it to whatever is present after mkfs has run.

Filesystems on storage that has dynamically changeable geometry
probably shouldn't be using fixed physical alignment in the first
place, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
