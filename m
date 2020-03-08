Return-Path: <SRS0=BAu2=4Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78562C10DCE
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 22:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9EB20684
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 22:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCHW0v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Mar 2020 18:26:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44258 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgCHW0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Mar 2020 18:26:51 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E88847E91A5;
        Mon,  9 Mar 2020 09:26:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jB4Ni-0004f3-Ku; Mon, 09 Mar 2020 09:26:46 +1100
Date:   Mon, 9 Mar 2020 09:26:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bart Brashers <bart.brashers@nyckelharpa.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mount before xfs_repair hangs
Message-ID: <20200308222646.GL10776@dread.disaster.area>
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=Px5Ng8mNUwVcmGlJVeQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 08, 2020 at 12:43:29PM -0700, Bart Brashers wrote:
> An update:
> 
> Mounting the degraded xfs filesystem still hangs, so I can't replay
> the journal, so I don't yet want to run xfs_repair.

echo w > /proc/sysrq-trigger

and dump demsg to find where it is hung. If it is not hung and is
instead stuck in a loop, use 'echo l > /proc/sysrq-trigger'.

> I can mount the degraded xfs filesystem like this:
> 
> $ mount -t xfs -o ro,norecovery,inode64,logdev=/dev/md/nvme2
> /dev/volgrp4TB/lvol4TB /export/lvol4TB/
> 
> If I do a "du" on the contents, I see 3822 files with either
> "Structure needs cleaning" or "No such file or directory".

TO be expected - you mounted an inconsistent filesystem image and
it's falling off the end of structures that are incomplete and
require recovery to make consistent.

> Is what I mounted what I would get if I used the xfs_repair -L option,
> and discarded the journal? Or would there be more corruption, e.g. to
> the directory structure?

Maybe. Maybe more, maybe less. Maybe.

> Some of the instances of "No such file or directory" are for files
> that are not in their correct directory - I can tell by the filetype
> and the directory name. Does that by itself imply directory
> corruption?

Maybe.

It also may imply log recovery has not been run and so things
like renames are not complete on disk, and recvoery would fix that.

But keep in mind your array had a triple disk failure, so there is
going to be -something- lost and not recoverable. That may well be
in the journal, at which point repair is your only option...

> At this point, can I do a backup, either using rsync or xfsdump or
> xfs_copy?

Do it any way you want.

> I have a separate RAID array on the same server where I
> could put the 7.8 TB of data, though the destination already has data
> on it - so I don't think xfs_copy is right. Is xfsdump to a directory
> faster/better than rsync? Or would it be best to use something like
> 
> $ tar cf - /export/lvol4TB/directory | (cd /export/lvol6TB/ ; tar xfp -)

Do it how ever you are confident the data gets copied reliably in
the face of filesystem traversal errors.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
