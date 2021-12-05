Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55806C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 21:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhLEVON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 16:14:13 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53761 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239101AbhLEVOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 16:14:12 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DD12F8686CA;
        Mon,  6 Dec 2021 08:10:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mtymO-00H9cy-Fd; Mon, 06 Dec 2021 08:10:40 +1100
Date:   Mon, 6 Dec 2021 08:10:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, 1000974@bugs.debian.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Thomas Goirand <zigo@debian.org>,
        Giovanni Mascellani <gio@debian.org>,
        xfslibs-dev@packages.debian.org, xfs <linux-xfs@vger.kernel.org>,
        gustavoars@kernel.org, keescook@chromium.org
Subject: Re: Bug#1000974: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the
 drainbamaged fallthrough macro from xfslibs
Message-ID: <20211205211040.GH449541@dread.disaster.area>
References: <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
 <20211205174951.GQ8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205174951.GQ8467@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61ad2ad3
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=xNf9USuDAAAA:8
        a=cm27Pg_UAAAA:8 a=mDV3o1hIAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=c3vKcX8GL7GHeQn_U0YA:9 a=CjuIK1q_8ugA:10 a=ppDDjHLidN0A:10
        a=AjGcO6oz07-iQ99wixmX:22 a=SEwjQc04WA-l_NiBhQ7s:22
        a=xmb-EsYY8bH0VWELuYED:22 a=_FVE-zBwftR9WsbkzFJk:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 05, 2021 at 09:49:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in mid-2021, Kees and Gustavo rammed into the kernel a bunch of
> static checker "improvements" that redefined '/* fallthrough */'
> comments for switch statements as a macro that virtualizes either that
> same comment, a do-while loop, or a compiler __attribute__.  This was
> necessary to work around the poor decision-making of the clang, gcc, and
> C language standard authors, who collectively came up with four mutually
> incompatible ways to document a lack of branching in a code flow.
> 
> Having received ZERO HELP porting this to userspace, Eric and I
> foolishly dumped that crap into linux.h, which was a poor decision
> because we keep forgetting that linux.h is exported as a userspace
> header.  This has now caused downstream regressions in Debian[1] and
> will probably cause more problems in the other distros.
> 
> Move it to platform_defs.h since that's not shipped publicly and leave a
> warning to anyone else who dare modify linux.h.
> 
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1000974
> 
> Fixes: df9c7d8d ("xfs: Fix fall-through warnings for Clang")
> Cc: 1000974@bugs.debian.org, gustavoars@kernel.org, keescook@chromium.org
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/linux.h            |   20 ++------------------
>  include/platform_defs.h.in |   21 +++++++++++++++++++++
>  2 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 24650228..054117aa 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -360,24 +360,8 @@ fsmap_advance(
>  #endif /* HAVE_MAP_SYNC */
>  
>  /*
> - * Add the pseudo keyword 'fallthrough' so case statement blocks
> - * must end with any of these keywords:
> - *   break;
> - *   fallthrough;
> - *   continue;
> - *   goto <label>;
> - *   return [expression];
> - *
> - *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
> + * Reminder: anything added to this file will be compiled into downstream
> + * userspace projects!

This comment belongs at the top of the file before all the includes,
not at the end of it. Otherwise looks ok for a quick fix.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

But I have to wonder - why is this file even exported to userspace?
It's mostly the xfsprogs source build wrapper stuff for linux -
there's no public API in it except for xfsctl()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
