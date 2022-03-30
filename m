Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14677C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 21:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiC3VEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 17:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiC3VEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 17:04:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E062942EF4
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 14:02:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B1C325341AB;
        Thu, 31 Mar 2022 08:02:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZfSN-00Bpo5-2A; Thu, 31 Mar 2022 08:02:19 +1100
Date:   Thu, 31 Mar 2022 08:02:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Chris Down <chris@chrisdown.name>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330210219.GD1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330124739.70edca36@gandalf.local.home>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6244c55e
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8
        a=mMpGT428DGEWo3aVKB0A:9 a=CjuIK1q_8ugA:10 a=e2CUPOnPG4QKp8I52DXD:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:47:39PM -0400, Steven Rostedt wrote:
> On Wed, 30 Mar 2022 12:52:58 +0100
> Chris Down <chris@chrisdown.name> wrote:
> 
> > The policy, as with all debugfs APIs by default, is that it's completely 
> > unstable and there are no API stability guarantees whatsoever. That's why 
> > there's no extensive documentation for users: because this is a feature for 
> > kernel developers.
> > 
> > 0: https://lwn.net/Articles/309298/
> 
> That article you reference states the opposite of what you said. And I got
> burnt by it before. Because Linus stated, if it is available for users, it
> is an ABI.
> 
> From the article above:
> 
> "Linus put it this way:
> 
>    The fact that something is documented (whether correctly or not) has
>    absolutely _zero_ impact on anything at all. What makes something an ABI is
>    that it's useful and available. The only way something isn't an ABI is by
>    _explicitly_ making sure that it's not available even by mistake in a
>    stable form for binary use. Example: kernel internal data structures and
>    function calls. We make sure that you simply _cannot_ make a binary that
>    works across kernel versions. That is the only way for an ABI to not form."
> 
> IOW, files in debugfs are available for users, and if something is written
> that depends on it and it is useful, it becomes ABI.

Yup, that's exactly what happened with powertop and the tracepoints
it used and why I pointed to it as is the canonical example of
information exposed from within debugfs unintentionally becoming
stable KABI....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
