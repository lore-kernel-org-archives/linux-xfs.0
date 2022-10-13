Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59400C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJMWtP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJMWtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:49:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECDDD1EC44
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:49:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3D0898AD681;
        Fri, 14 Oct 2022 09:49:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj70p-001eeG-S7; Fri, 14 Oct 2022 09:49:11 +1100
Date:   Fri, 14 Oct 2022 09:49:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't return -EFSCORRUPTED from repair when
 resources cannot be grabbed
Message-ID: <20221013224911.GH3600936@dread.disaster.area>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479567.1083393.7668585289114718845.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473479567.1083393.7668585289114718845.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=634895e9
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AF91rER8l4VAJK1NqVQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we tried to repair something but the repair failed with -EDEADLOCK or
> -EAGAIN, that means that the repair function couldn't grab some resource

Nothing should fail with EAGAIN by this point?

> it needed and wants us to try again.  If we try again (with TRY_HARDER)
> but still can't do it, exit back to userspace, since xfs_scrub_metadata
> requires xrep_attempt to return -EAGAIN.

-EDEADLOCK, not -EAGAIN?

Confused.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
