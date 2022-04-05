Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C05C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 15:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiDEPEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 11:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbiDENym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 09:54:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F5CBD2F7
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 05:56:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B645A1F390;
        Tue,  5 Apr 2022 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649163359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SkNJx2Zz/6czn3S2t62HK4z7SqAzGkYuFV8XkGnNVs8=;
        b=b92RT9ZSqfeVjJpyhw4iaKewh6drj464cUeqZh0GMriI+rCGV/vBptzKt/84OgqT9FzE7p
        okTxCP5ZLIlYchwKyvvpi+Ua5eAEaIjUbjUKuhQ1qZ8vLCG4gXMlYpJsS5F5R/8fDiQWpN
        IrXw3MCLcr5MZudXy/q3jr/80bWJwDQ=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 43868A3B87;
        Tue,  5 Apr 2022 12:55:59 +0000 (UTC)
Date:   Tue, 5 Apr 2022 14:55:58 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chris Down <chris@chrisdown.name>,
        Dave Chinner <david@fromorbit.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <Ykw8Xtam5b46stou@alley>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <20220330004649.GG27713@magnolia>
 <20220330012624.GC1544202@dread.disaster.area>
 <20220330145955.GB4384@pathway.suse.cz>
 <YkRyOKZ+hJYysKrR@chrisdown.name>
 <20220331150618.GM27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331150618.GM27690@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 2022-03-31 08:06:18, Darrick J. Wong wrote:
> On Wed, Mar 30, 2022 at 04:07:36PM +0100, Chris Down wrote:
> > Petr Mladek writes:
> > > Subject: [RFC] printk/index: Printk index feature documentation
> > > 
> > > Document the printk index feature. The primary motivation is to
> > > explain that it is not creating KABI from particular printk() calls.
> > > 
> > > --- /dev/null
> > > +++ b/Documentation/core-api/printk-index.rst
> > > @@ -0,0 +1,139 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +============
> > > +Printk index
> > > +============
> > > +
> > > +There are many ways how to control the state of the system. One important
> 
> I would say this is monitoring the state of the system more than it's
> controlling it.
> 
> > > +source of information is the system log. It provides a lot of information,
> > > +including more or less important warnings and error messages.
> > > +
> > > +The system log can be monitored by some tool. It is especially useful
> > > +when there are many monitored systems. Such tools try to filter out
> > > +less important messages or known problems. They might also trigger
> > > +some action when a particular message appears.
> 
> TBH I thought the bigger promise of the printk index is the ability to
> find where in the source code a message might have come from.

I personally use "git grep" to find a given message in the sources.
IMHO, it is much easier than going via printk index.

I could imagine that people might use the printk index when they do
not have the full git repo. But it should not be the main purpose
of this interface. IMHO, it would not be worth it. "grep -R" or
google does similar job.

Or maybe I miss some particular use case.

> I would like to see the problem statement part of this doc develop
> further.  What do you think about reworking the above paragraph like so?
> 
> "Often it is useful for developers and support specialists to be able to
> trace a kernel log message back to its exact position in source code.
> Moreover, there are monitoring tools that filter and take action based
> on messages logged.  For both of these use cases, it would be helpful to
> provide an index of all possible printk format strings for the running
> kernel."

I did not use this paragraph in the end. But I reworked the text a bit.


> > > +
> > > +The kernel messages are evolving together with the code. They are
> > > +not KABI and never will be!
> 
> Ok.  You might want to make it explicit here that the format of the
> debugfs file itself shouldn't change, unlike the file/line/formatspecificer
> *contents* of those files.

I rather made it more explicit that the particular messages are not
KABI.

The stability of the interface is kind of political issue. It depends
if there are any tools using it. I will do my best to keep it stable
as long as I am printk maintainer. But I do not want to promise it at the
moment. The interface is still pretty young and there are just first
users playing with it.


> > > +It is a huge challenge for maintaining the system log monitors. It requires
> > > +knowing what messages were udpated and why. Finding these changes in
> 
> s/udpated/updated/
> 
> > > +the sources would require non-trivial parsers. Also it would require
> > > +matching the sources with the binary kernel which is not always trivial.
> > > +Various changes might be backported. Various kernel versions might be used
> > > +on different monitored systems.
> > > +
> > > +This is where the printk index feature might become useful. It provides
> > > +a dump of printk formats used all over the source code used for the kernel
> > > +and modules on the running system. It is accessible at runtime via debugfs.
> > > +
> > > +
> > > +User interface
> > > +==============
> > > +
> > > +The index of printk formats is split into separate files for
> > > +for vmlinux and loaded modules, for example::
> > > +
> > > +   /sys/kernel/debug/printk/index/vmlinux
> > > +   /sys/kernel/debug/printk/index/ext4
> > > +   /sys/kernel/debug/printk/index/scsi_mod
> 
> If ext4 is built into the kernel (and not as a module), does its format
> strings end up in index/vmlinux or index/ext4?

It will be in vmlinux when the module is built-in. I mentioned this in v1.

> > > +
> > > +The content is inspired by the dynamic debug interface and looks like::
> > > +

Thanks a lot for the valuable feedback and suggestions. I used most of
them, see
https://lore.kernel.org/r/20220405114829.31837-1-pmladek@suse.com

Best Regards,
Petr
