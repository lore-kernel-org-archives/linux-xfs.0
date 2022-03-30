Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B98C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349338AbiC3Rlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349343AbiC3Rll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42E5E9CB7
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81DE6B81D85
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 17:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB9BC340EC;
        Wed, 30 Mar 2022 17:39:52 +0000 (UTC)
Date:   Wed, 30 Mar 2022 13:39:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Chris Down <chris@chrisdown.name>
Cc:     Dave Chinner <david@fromorbit.com>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330133950.6ed0ead6@gandalf.local.home>
In-Reply-To: <YkSOyC+vEMVSDsdU@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
        <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
        <YkMKyN9w0S8VFJRk@alley>
        <20220330003457.GB1544202@dread.disaster.area>
        <YkREmrfoTcqOYbma@chrisdown.name>
        <20220330124739.70edca36@gandalf.local.home>
        <YkSOyC+vEMVSDsdU@chrisdown.name>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 30 Mar 2022 18:09:28 +0100
Chris Down <chris@chrisdown.name> wrote:

> Steven Rostedt writes:
> >On Wed, 30 Mar 2022 12:52:58 +0100
> >Chris Down <chris@chrisdown.name> wrote:
> >  
> >> The policy, as with all debugfs APIs by default, is that it's completely
> >> unstable and there are no API stability guarantees whatsoever. That's why
> >> there's no extensive documentation for users: because this is a feature for
> >> kernel developers.
> >>
> >> 0: https://lwn.net/Articles/309298/  
> >
> >That article you reference states the opposite of what you said. And I got
> >burnt by it before. Because Linus stated, if it is available for users, it
> >is an ABI.  
> 
> Hmm, even in 2011 after that article there were discussions about debugfs 
> explicitly being the "wild west"[0], no? I heard the same during LSFMM 
> discussions during recent years as well. Although I confess that I am not 
> frequently in discussions about debugfs so I don't really know where the 
> majority opinion is nowadays.

There isn't a majority opinion on this. There's only one opinion, and
that's Linus's ;-)

-- Steve


> 
> Either way, as discussed the contents wouldn't be the ABI (as with my 
> /proc/self/smaps allusion), the file format would be, so it wouldn't imply that 
> printk() calls themselves or their locations become an ABI.
> 
> 0: https://lwn.net/Articles/429321/

