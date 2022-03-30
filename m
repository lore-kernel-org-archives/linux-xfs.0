Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D7BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 16:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344057AbiC3Qtd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349026AbiC3Qtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 12:49:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486BB279722
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 09:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A10B81D7D
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 16:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86345C340EC;
        Wed, 30 Mar 2022 16:47:41 +0000 (UTC)
Date:   Wed, 30 Mar 2022 12:47:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Chris Down <chris@chrisdown.name>
Cc:     Dave Chinner <david@fromorbit.com>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330124739.70edca36@gandalf.local.home>
In-Reply-To: <YkREmrfoTcqOYbma@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
        <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
        <YkMKyN9w0S8VFJRk@alley>
        <20220330003457.GB1544202@dread.disaster.area>
        <YkREmrfoTcqOYbma@chrisdown.name>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 30 Mar 2022 12:52:58 +0100
Chris Down <chris@chrisdown.name> wrote:

> The policy, as with all debugfs APIs by default, is that it's completely 
> unstable and there are no API stability guarantees whatsoever. That's why 
> there's no extensive documentation for users: because this is a feature for 
> kernel developers.
> 
> 0: https://lwn.net/Articles/309298/

That article you reference states the opposite of what you said. And I got
burnt by it before. Because Linus stated, if it is available for users, it
is an ABI.

From the article above:

"Linus put it this way:

   The fact that something is documented (whether correctly or not) has
   absolutely _zero_ impact on anything at all. What makes something an ABI is
   that it's useful and available. The only way something isn't an ABI is by
   _explicitly_ making sure that it's not available even by mistake in a
   stable form for binary use. Example: kernel internal data structures and
   function calls. We make sure that you simply _cannot_ make a binary that
   works across kernel versions. That is the only way for an ABI to not form."

IOW, files in debugfs are available for users, and if something is written
that depends on it and it is useful, it becomes ABI. The way I fixed my
issue was to go and send patches to all the users that depended on the ABI,
taking away the dependency, and then I was able to update debugfs.

-- Steve

