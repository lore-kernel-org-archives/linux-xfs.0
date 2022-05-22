Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CA1C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 22:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiEVWyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 18:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiEVWyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 18:54:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0413837BC1
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:54:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AB0175354F3;
        Mon, 23 May 2022 08:54:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nsuSa-00FCvQ-2W; Mon, 23 May 2022 08:54:04 +1000
Date:   Mon, 23 May 2022 08:54:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] xfs: warn about LARP once per day
Message-ID: <20220522225404.GN1098723@dread.disaster.area>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323331075.78886.2887944532927333265.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165323331075.78886.2887944532927333265.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628abf0e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=YgBVtrzqigrfmJdh27sA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 22, 2022 at 08:28:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since LARP is an experimental debug-only feature, we should try to warn
> about it being in use once per day, not once per reboot.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9dc748abdf33..edd077e055d5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3910,8 +3910,8 @@ xfs_attr_use_log_assist(
>  	if (error)
>  		goto drop_incompat;
>  
> -	xfs_warn_once(mp,
> -"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> +	xfs_warn_daily(mp,
> + "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");

I think even this is wrong. We need this to warn once per *mount*
like we do with all other experimental features, not once or once
per day.  i.e. we could have 10 filesystems mounted and only one of
them will warn that EXPERIMENTAL features are in use.

We really need all filesystems that use an experimental feature to
warn about the use of said feature, not just a single filesystem.
That will make this consistent with the way we warn once (and once
only) at mount time about EXPERIMENTAL features that are enabled at
mount time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
