Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4D8C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 14:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiCaOLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiCaOLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 10:11:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985224BB9B
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 07:09:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4E57F1FCFD;
        Thu, 31 Mar 2022 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648735764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R4OHbjhHIyAeJ5v5g7/Rj+VwJsLyb4/wh0SynYnnndU=;
        b=qXCmuGvJs5+VRcl4xzqcqkKd7fwkV7almUAixRHuVAD5G6pRNEu7IRFKiEz5aDZzBzjJpp
        fP3arADt7ZfKqkjZ1dXJcPgV54YB1RlsHo/7Ohq7zM61HePTPyYgyhpV9Od4sWNuEiES7R
        QQ3K7pMAQd9Fmc7EiB2+PXZdxOzUIcw=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E5B6DA3B82;
        Thu, 31 Mar 2022 14:09:23 +0000 (UTC)
Date:   Thu, 31 Mar 2022 16:09:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Chris Down <chris@chrisdown.name>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkW2E1qpsFgeyOxZ@alley>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
 <20220330210219.GD1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330210219.GD1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 2022-03-31 08:02:19, Dave Chinner wrote:
> On Wed, Mar 30, 2022 at 12:47:39PM -0400, Steven Rostedt wrote:
> > On Wed, 30 Mar 2022 12:52:58 +0100
> > Chris Down <chris@chrisdown.name> wrote:
> > 
> > > The policy, as with all debugfs APIs by default, is that it's completely 
> > > unstable and there are no API stability guarantees whatsoever. That's why 
> > > there's no extensive documentation for users: because this is a feature for 
> > > kernel developers.
> > > 
> > > 0: https://lwn.net/Articles/309298/
> > 
> > That article you reference states the opposite of what you said. And I got
> > burnt by it before. Because Linus stated, if it is available for users, it
> > is an ABI.
> > 
> > From the article above:
> > 
> > "Linus put it this way:
> > 
> >    The fact that something is documented (whether correctly or not) has
> >    absolutely _zero_ impact on anything at all. What makes something an ABI is
> >    that it's useful and available. The only way something isn't an ABI is by
> >    _explicitly_ making sure that it's not available even by mistake in a
> >    stable form for binary use. Example: kernel internal data structures and
> >    function calls. We make sure that you simply _cannot_ make a binary that
> >    works across kernel versions. That is the only way for an ABI to not form."
> > 
> > IOW, files in debugfs are available for users, and if something is written
> > that depends on it and it is useful, it becomes ABI.
> 
> Yup, that's exactly what happened with powertop and the tracepoints
> it used and why I pointed to it as is the canonical example of
> information exposed from within debugfs unintentionally becoming
> stable KABI....

To be sure that we are on the same page.

Please, fix me if I am wrong. I am not that familiar with tracepoints.
It is a rather complex feature. Each tracepoint has a name, arguments,
fields, prints a message. I guess that the KABI aspects are:

    + name of the tracepoint
    + situation when they are triggered
    + names, type, and meaning of the parameters/fields
    + format and meaning or the printed messages

In compare, a potential KABI aspects of a particular printk format
(message) are:

    + situation when it is printed
    + format and meaning of the printed message

They clearly have something in common. I guess that this causes the
fear that the printk index feature might make convert a particular
printk message into KABI.


Note that the above summary is not talking about debugfs at all.
Is it really debugfs what made tracepoints considered a KABI?
Are tracepoints usable without debugfs?

It is clear that the debugfs interface might be KABI on its own.
There are many tools that use the interface to actually use
the tracepoints. A change in the interface might break the tools.
But it will be about the interface and not about the particular
tracepoints.

But I think that tracepoints are KABI even without the debugfs
interface. We could create 10 different interfaces for tracepoints
between the kernel and userspace. And all will break userspace
if the functionality of a tracepoint is modified.


I want to say. IMHO, it is is not debugfs what made KABI from
tracepoints. I think that tracepoints can be considered KABI on
its own. The tracepoints were created together with the debugfs
interface. They would not make any sense without each other.

This is not the case for printk() messages. They were always there.

The printk index is not an interface for using the messages.
It is like /proc/config.gz. The printk index describes what
pieces are available in the kernel.

IMHO, printk messages might already be considered KABI. There
are clearly monitors checking particular messages. The printk index
does not make any difference. Yes, it might be used to create a KABI
checker. But a KABI checker does not create the KABI. KABI
checkers exist only because something has already been considered
KABI before.

Or am I too naive or completely wrong, please?

Best Regards,
Petr
