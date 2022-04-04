Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06574C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Apr 2022 01:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355804AbiDDBmc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 21:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDBmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 21:42:32 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99D683A700
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 18:40:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DD07510E555B;
        Mon,  4 Apr 2022 11:40:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbBhp-00DUAe-F4; Mon, 04 Apr 2022 11:40:33 +1000
Date:   Mon, 4 Apr 2022 11:40:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v4 1/2] Simplify XFS logging methods.
Message-ID: <20220404014033.GQ1544202@dread.disaster.area>
References: <d51e0e0ffc7709010f601ab3c910056379479143.1648690634.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51e0e0ffc7709010f601ab3c910056379479143.1648690634.git.jof@thejof.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624a4c94
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=Ot3N2O21AAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=SySkh_P8Cz7nAsVyaqEA:9 a=CjuIK1q_8ugA:10
        a=-F6LaNPAekqF0pxxGpLN:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 06:38:05PM -0700, Jonathan Lassoff wrote:
> Rather than have a constructor to define many nearly-identical
> functions, use preprocessor macros to pass down a kernel logging level
> to a common function.
> 
> Signed-off-by: Jonathan Lassoff <jof@thejof.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Looks good, minor nit below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> -#ifdef DEBUG
> -define_xfs_printk_level(xfs_debug, KERN_DEBUG);
> -#endif
> +void
> +xfs_printk_level(
> +	const char *kern_level,
> +	const struct xfs_mount *mp,
> +	const char *fmt, ...)

Whitespace still not quite right. I'll clean that up myself up on
merge, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
