Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B986C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 03:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiAMDrP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 22:47:15 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44213 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232272AbiAMDrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 22:47:14 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 90D1362C0E0;
        Thu, 13 Jan 2022 14:47:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n7r4y-00Ee7R-0b; Thu, 13 Jan 2022 14:47:12 +1100
Date:   Thu, 13 Jan 2022 14:47:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
Message-ID: <20220113034712.GD3290465@dread.disaster.area>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
 <164194336605.3069025.17152203611076954599.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164194336605.3069025.17152203611076954599.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61dfa0c1
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Wb0oWCF6pdWcZF2cXSgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 03:22:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> According to the glibc compat header for Irix 4, these ioctls originated
> in April 1991 as a (somewhat clunky) way to preallocate space at the end
> of a file on an EFS filesystem.  XFS, which was released in Irix 5.3 in
> December 1993, picked up these ioctls to maintain compatibility and they
> were ported to Linux in the early 2000s.
> 
> Recently it was pointed out to me they still lurk in the kernel, even
> though the Linux fallocate syscall supplanted the functionality a long
> time ago.  fstests doesn't seem to include any real functional or stress
> tests for these ioctls, which means that the code quality is ... very
> questionable.  Most notably, it was a stale disk block exposure vector
> for 21 years and nobody noticed or complained.  As mature programmers
> say, "If you're not testing it, it's broken."
> 
> Given all that, let's withdraw these ioctls from the XFS userspace API.
> Normally we'd set a long deprecation process, but I estimate that there
> aren't any real users, so let's trigger a warning in dmesg and return
> -ENOTTY.
> 
> See: CVE-2021-4155
> 
> Augments: 983d8e60f508 ("xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
