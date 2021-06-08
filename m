Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8026EC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 01:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 602306109F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFHBLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:11:45 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:51985 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhFHBLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 21:11:44 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D77FD681CF;
        Tue,  8 Jun 2021 11:09:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqQFN-00ACpP-0L; Tue, 08 Jun 2021 11:09:37 +1000
Date:   Tue, 8 Jun 2021 11:09:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/9] xfs: expose sysfs knob to control inode inactivation
 delay
Message-ID: <20210608010936.GH664593@dread.disaster.area>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310471037.3465262.10128421878961173112.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162310471037.3465262.10128421878961173112.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=_dopgC6E3wgjgoefsLwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 03:25:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Allow administrators to control the length that we defer inode
> inactivation.  By default we'll set the delay to 2 seconds, as an
> arbitrary choice between allowing for some batching of a deltree
> operation, and not letting too many inodes pile up in memory.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  Documentation/admin-guide/xfs.rst |    7 +++++++
>  fs/xfs/xfs_globals.c              |    3 +++
>  fs/xfs/xfs_icache.c               |    3 ++-
>  fs/xfs/xfs_linux.h                |    1 +
>  fs/xfs/xfs_sysctl.c               |    9 +++++++++
>  fs/xfs/xfs_sysctl.h               |    1 +
>  6 files changed, 23 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index f9b109bfc6a6..9dd62b155fda 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -277,6 +277,13 @@ The following sysctls are available for the XFS filesystem:
>  	references and returns timed-out AGs back to the free stream
>  	pool.
>  
> +  fs.xfs.inode_gc_delay
> +	(Units: centiseconds   Min: 0  Default: 1  Max: 360000)
> +	The amount of time to delay cleanup work that happens after a file is
> +	closed by all programs.  This involves clearing speculative
> +	preallocations from linked files and freeing unlinked files.  A higher
> +	value here increases batching at a risk of background work storms.

Can we make new timers use a sane unit of time like milliseconds?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
