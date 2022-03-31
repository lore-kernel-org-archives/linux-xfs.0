Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25841C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 21:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiCaVha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 17:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiCaVha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 17:37:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8454022FD80
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 14:35:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6E9D010E7351;
        Fri,  1 Apr 2022 08:35:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1na2SB-00CEv9-NZ; Fri, 01 Apr 2022 08:35:39 +1100
Date:   Fri, 1 Apr 2022 08:35:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215783] New: kernel NULL pointer dereference and general
 protection fault in fs/xfs/xfs_buf_item_recover.c:
 xlog_recover_do_reg_buffer() when mount a corrupted image
Message-ID: <20220331213539.GH1544202@dread.disaster.area>
References: <bug-215783-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-215783-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62461ead
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=dZt0fa9Cfv-EBOP55oEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 31, 2022 at 08:07:08PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215783
> - Overview 
> kernel NULL pointer dereference and general protection fault in
> fs/xfs/xfs_buf_item_recover.c:xlog_recover_do_reg_buffer() when mount a
> corrupted image, sometimes cause kernel hang
> 
> - Reproduce 
> tested on kernel 5.17.1, 5.15.32
> 
> $ mkdir mnt
> $ unzip tmp7.zip
> $ ./mount.sh xfs 7  ##NULL pointer derefence
> or
> $ sudo mount -t xfs tmp7.img mnt ##general protection fault
> 
> - Kernel dump

You've now raised 4 bugs that all look very similar and are quite
possibly all caused by the same corruption vector.
Please do some triage on the failure to identify the
source of the corruption that trigger this failure.

If you are going to run some scripted tool to randomly corrupt the
filesystem to find failures, then you have an ethical and moral
responsibility to do some of the work to narrow down and identify
the cause of the failure, not just throw them at someone to do all
the work.

You can automate this - track the corruptions you add to the
filesystem image, then when you have an image that reproduces a
problem, iterate over it removing corruptions until you have just
the minimum set of changes in the image that reproduce the issue.
Then you can cull all the images that trip over the same corruptions
and only report the actual corruption that causes the problem.

Then list those corruptions in the bug report so that we don't have
to do all this triage ourselves to weed out all the duplicates and
noise that all the random corruptions that don't cause crashes
induce.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
