Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1F7C43331
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 22:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA22206DF
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 22:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKIWcn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Nov 2019 17:32:43 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45815 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbfKIWcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 17:32:43 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E41167E97AB;
        Sun, 10 Nov 2019 09:32:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iTZHa-0007Yl-2M; Sun, 10 Nov 2019 09:32:38 +1100
Date:   Sun, 10 Nov 2019 09:32:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191109223238.GH4614@dread.disaster.area>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319672136.834699.13051359836285578031.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=42OlywUh9MvGueQRwoUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the last of the open coded corruption check and report idioms to
> use the XFS_IS_CORRUPT macro.

hmmm.

> +	if (XFS_IS_CORRUPT(mp,
> +	    ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {

This pattern is weird. It looks like there are two separate logic
statements to the if() condition, when in fact the second line is
part of the XFS_IS_CORRUPT() macro.

It just looks wrong to me, especially when everything other
multi-line macro is indented based on the indenting of the macro
parameters....

Yes, in this case it looks a bit strange, too:

	if (XFS_IS_CORRUPT(mp,
			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {

but there is no mistaking it for separate logic statements.

I kinda value being able to glance at the indent levels to see
separate logic elements....

> -		if (unlikely(
> -		       be32_to_cpu(sib_info->back) != last_blkno ||
> -		       sib_info->magic != dead_info->magic)) {
> -			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
> -					 XFS_ERRLEVEL_LOW, mp);
> +		if (XFS_IS_CORRUPT(mp,
> +		    be32_to_cpu(sib_info->back) != last_blkno ||
> +		    sib_info->magic != dead_info->magic)) {
>  			error = -EFSCORRUPTED;
>  			goto done;
>  		}

This is kind of what I mean - is it two or three  logic statments
here? No, it's actually one, but it has two nested checks...

There's a few other list this that are somewhat non-obvious as to
the logic...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
