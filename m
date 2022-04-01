Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A76C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 21:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346993AbiDAVwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 17:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345926AbiDAVwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 17:52:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69B19141FF5
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 14:50:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8EE19534247;
        Sat,  2 Apr 2022 08:50:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1naP9j-00CdWL-63; Sat, 02 Apr 2022 08:50:07 +1100
Date:   Sat, 2 Apr 2022 08:50:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Chris Down <chris@chrisdown.name>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220401215007.GM1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
 <20220330210219.GD1544202@dread.disaster.area>
 <YkW2E1qpsFgeyOxZ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkW2E1qpsFgeyOxZ@alley>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62477392
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=07d9gI8wAAAA:8 a=eJfxgxciAAAA:8
        a=7-415B0cAAAA:8 a=ps-HnodGsklsEsm3aY0A:9 a=CjuIK1q_8ugA:10
        a=e2CUPOnPG4QKp8I52DXD:22 a=xM9caqqi1sUkTy8OJ5Uh:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 31, 2022 at 04:09:23PM +0200, Petr Mladek wrote:
> On Thu 2022-03-31 08:02:19, Dave Chinner wrote:
> > On Wed, Mar 30, 2022 at 12:47:39PM -0400, Steven Rostedt wrote:
> > > On Wed, 30 Mar 2022 12:52:58 +0100
> > > Chris Down <chris@chrisdown.name> wrote:
> > > 
> > > > The policy, as with all debugfs APIs by default, is that it's completely 
> > > > unstable and there are no API stability guarantees whatsoever. That's why 
> > > > there's no extensive documentation for users: because this is a feature for 
> > > > kernel developers.
> > > > 
> > > > 0: https://lwn.net/Articles/309298/
> > > 
> > > That article you reference states the opposite of what you said. And I got
> > > burnt by it before. Because Linus stated, if it is available for users, it
> > > is an ABI.
> > > 
> > > From the article above:
> > > 
> > > "Linus put it this way:
> > > 
> > >    The fact that something is documented (whether correctly or not) has
> > >    absolutely _zero_ impact on anything at all. What makes something an ABI is
> > >    that it's useful and available. The only way something isn't an ABI is by
> > >    _explicitly_ making sure that it's not available even by mistake in a
> > >    stable form for binary use. Example: kernel internal data structures and
> > >    function calls. We make sure that you simply _cannot_ make a binary that
> > >    works across kernel versions. That is the only way for an ABI to not form."
> > > 
> > > IOW, files in debugfs are available for users, and if something is written
> > > that depends on it and it is useful, it becomes ABI.
> > 
> > Yup, that's exactly what happened with powertop and the tracepoints
> > it used and why I pointed to it as is the canonical example of
> > information exposed from within debugfs unintentionally becoming
> > stable KABI....
> 
> To be sure that we are on the same page.
> 
> Please, fix me if I am wrong. I am not that familiar with tracepoints.
> It is a rather complex feature. Each tracepoint has a name, arguments,
> fields, prints a message. I guess that the KABI aspects are:
> 
>     + name of the tracepoint
>     + situation when they are triggered
>     + names, type, and meaning of the parameters/fields
>     + format and meaning or the printed messages

These -aren't- things that make up the tracepoint KABI - this is the
-data- that the tracepoint infrastructure generates. This data
contains a *lot* of information about the internal implementation of
a subsystem. e.g. there are over 550 individual tracepoints in XFS
that span every single subsystem from IO paths to allocation to log
space reseverations.

> In compare, a potential KABI aspects of a particular printk format
> (message) are:
> 
>     + situation when it is printed
>     + format and meaning of the printed message

Again, I see this as the data being generated by the printk index,
not the KABI defined for ensuring access to the data doesn't change.

> They clearly have something in common. I guess that this causes the
> fear that the printk index feature might make convert a particular
> printk message into KABI.
> 
> Note that the above summary is not talking about debugfs at all.
> Is it really debugfs what made tracepoints considered a KABI?
> Are tracepoints usable without debugfs?

No, but....

A large number of the tracepoints in XFS come from Irix kernel
debugging infrastructure from the early/mid 1990s. Irix had a built
in kernel debugger (idb) and kernel crash dump tools that could also
run on a live kernel (icrash). XFS had code in it to add commands to
both of these tools to iterate the tracing events that were built
into the code.

commit 8a2bc927ff399dff08d4242c8cec9cb33e31eac2
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Mon May 9 04:38:21 1994 +0000

    Add a bunch of tracing code for bmap btrees.

That used generic, built in kernel tracing infrastructure that the
Irix kernel and kernel debugger provided developers, and that was
back in 1994.

When XFS was ported to Linux, SGI also ported idb and icrash to
linux - idg became kdb, and icrash is waht we now know as "crash".
The XFS CVS tree carried kdb patches and all the interfacing code
to add the tracing output commands to kdb.

Then, eventually, tracepoints came along and we did a macro
conversion of the original XFS tracing code to the new tracepoint
infrastructure.

IOWs, the tracing events we export via tracepoints in XFS has a long
history of existence before the linux kernel tracepoint
infrastructure ever existed, hence the method of extracting the
tracing data from the kernel doesn't magically make the *tracing
data* part of the kernel ABI.

The tracepoint KABI covers the debugfs interface and file
formats/protocols - the thing that applications like trace-cmd,
perf, PCP, etc interface with to configure and extract tracepoint
data from the kernel. Those binaries need to work across multiple
kernel versions to be cause to control and extract tracepoint
-data-. The data itself can change from kernel to kernel without
those tools breaking, but the data format, the debugfs control
interfaces, etc must all remain unchaged (or at least backward
compatible).

> It is clear that the debugfs interface might be KABI on its own.
> There are many tools that use the interface to actually use
> the tracepoints. A change in the interface might break the tools.
> But it will be about the interface and not about the particular
> tracepoints.

Right. Here's the problem with powertop, from 2010:

https://lwn.net/Articles/442113/

It hard coded a dependency on a *specific set of data* that a
specific tracepoint exported, and so when that tracepoint changed
powertop then broke. The article discusses how this made the
tracepoint data part of the KABI, then read what I said about
that idea w.r.t. XFS:

https://lwn.net/Articles/442340/

Now compare that situation to the concerns I raised about the printk
index.

That is, I'm concerned that the -data- that is exported through this
new printk indexing KABI in debugfs will get retconned as KABI.
That's the same concerns I raised with tracepoints way back then and
history has shown that I was right. i.e. that tracepoint -data-
should never be considered part of the KABI. I don't want to have to
spend the next 10 years making the same arguments about the XFS
printk index *data* not being KABI as we had with tracepoint data.

> But I think that tracepoints are KABI even without the debugfs
> interface. We could create 10 different interfaces for tracepoints
> between the kernel and userspace. And all will break userspace
> if the functionality of a tracepoint is modified.

Yes, the -control interface- is covered by KABI. However, the -data-
that is extracted through that control interface is not covered by
KABI - we can and do change that at will and give no guarantees
about the consistency or stability of the data from kernel to
kernel.

The printk index has the same concerns - the debugfs interface has
to conform to KABI rules, otherwise we break applications. The
-data- that it exposes, OTOH, is tightly tied to internal
implementation details and so must not be tied to KABI. It must be
allowed to chagne at will and applications need to consider it to be
unstable from kernel to kernel and use it appropriately.

> I want to say. IMHO, it is is not debugfs what made KABI from
> tracepoints. I think that tracepoints can be considered KABI on
> its own. The tracepoints were created together with the debugfs
> interface. They would not make any sense without each other.
> 
> This is not the case for printk() messages. They were always there.

So was the internal XFS tracing infrastructure and trace events. :)

> The printk index is not an interface for using the messages.
> It is like /proc/config.gz. The printk index describes what
> pieces are available in the kernel.
>
> IMHO, printk messages might already be considered KABI. There
> are clearly monitors checking particular messages. The printk index
> does not make any difference. Yes, it might be used to create a KABI
> checker. But a KABI checker does not create the KABI. KABI
> checkers exist only because something has already been considered
> KABI before.

AFAIA, printk messages have never been part of the KABI. Anyone who
writes a log scraper knows that messages can and do change over time
and that's their problem to deal with. As kernel developers we give
-zero- regard to KABI when writing, modifying or removing log
messages. That is how it should be, and this directly indicates that
the printk index -data- is not KABI, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
