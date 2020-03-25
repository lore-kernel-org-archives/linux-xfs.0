Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F95C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA1520722
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCYBvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:51:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58674 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727189AbgCYBvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:51:32 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 428837EB6FA
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:51:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGvCa-0006IV-6K
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:51:28 +1100
Date:   Wed, 25 Mar 2020 12:51:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8] xfs: various fixes and cleanups
Message-ID: <20200325015128.GE10776@dread.disaster.area>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=bxfKLBYTOHBu_A5ka58A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:41:57PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> These are the fixes and cleanups that are part of the non-blocking
> inode reclaim series I've (slowly) been working on. These fixes and
> cleanups stand alone, many have already been reviewed, and getting
> them out of the non-blocking reclaim patchset makes that a much
> smaller and easier to digest set of patches.
> 
> The changes in this patchset are for:
> 
> - limiting the size of checkpoints that the CIL builds to reduce the
>   memory it pins and the latency of commits.
> - cleaning up the AIL item removal code so we can reduce the number
>   of tail LSN updates to prevent unnecessary thundering herd wakeups
> - account for reclaimable slab caches in XFS correctly
> - account for reclaimed pages from buffers correctly
> - avoiding log IO priority inversions
> - factoring the inode cluster deletion code to make it more readable
>   and easier to modify for the non-blocking inode reclaim mods.
> 
> Thoughts, comments and improvemnts welcome.

Oops, forgot to mention this is based on the for-next tree with
Christoph's xlog-ticket-cleanup.2 branch merged on top. You can pull
it from here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-fixes-cleanups-5.7

or browse:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/log/?h=xfs-fixes-cleanups-5.7

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
