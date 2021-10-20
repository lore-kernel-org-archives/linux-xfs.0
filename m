Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F90C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 22:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE097611CC
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 22:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhJTWTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:19:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55062 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTWTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 18:19:01 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id EACA58D8FB;
        Thu, 21 Oct 2021 09:16:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mdJt4-008ZgD-U1; Thu, 21 Oct 2021 09:16:42 +1100
Date:   Thu, 21 Oct 2021 09:16:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 214767] New: xfs seems to hang due to race condition? maybe
 related to (gratuitous) thaw.
Message-ID: <20211020221642.GA2361455@dread.disaster.area>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6170954d
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=Y7pbzP1Hdpi20SMr:21 a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=4jsdeo0mP5zgtitmewIA:9 a=CjuIK1q_8ugA:10
        a=W4iUb41TIiNtaFHdFdN3:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 20, 2021 at 07:36:07AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> [656898.034261] Call Trace:
> [656898.034538]  __schedule+0x271/0x860
> [656898.034881]  schedule+0x46/0xb0
> [656898.035226]  xfs_log_commit_cil+0x6a4/0x800 [xfs]

This looks like it is stuck on the hard throttle. Which means this
is the likely fix:

19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
