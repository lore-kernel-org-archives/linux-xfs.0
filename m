Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CD2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 00:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbiC3AGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 20:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiC3AGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 20:06:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D2DE3FBE3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 17:05:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1CE9C10E52D8;
        Wed, 30 Mar 2022 11:05:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZLpd-00BULv-EH; Wed, 30 Mar 2022 11:05:01 +1100
Date:   Wed, 30 Mar 2022 11:05:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330000501.GA1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62439eaf
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=Ot3N2O21AAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=YB4sxjVFwzVqbsjthxQA:9 a=CjuIK1q_8ugA:10
        a=-F6LaNPAekqF0pxxGpLN:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 25, 2022 at 10:19:46AM -0700, Jonathan Lassoff wrote:
> In order for end users to quickly react to new issues that come up in
> production, it is proving useful to leverage the printk indexing system.
> This printk index enables kernel developers to use calls to printk()
> with changeable ad-hoc format strings, while still enabling end users
> to detect changes from release to release.
> 
> So that detailed XFS messages are captures by this printk index, this
> patch wraps the xfs_<level> and xfs_alert_tag functions.
> 
> Signed-off-by: Jonathan Lassoff <jof@thejof.com>

Looks good. Minor whitespace/ordering nit below....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 2f609800e806..6f9a1b67c4d7 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,34 +6,45 @@
>  
>  struct xfs_mount;
>  
> +#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
> +({								\
> +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
> +	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
> +})
>  extern __printf(3, 4)
>  void xfs_printk_level(
>  	const char *kern_level,
>  	const struct xfs_mount *mp,
>  	const char *fmt, ...);
>  #define xfs_emerg(mp, fmt, ...) \
> -	xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)

Empty lines, again. Also, put the xfs_printk_index_wrap() after
the function prototype so it groups with the macros that use it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
