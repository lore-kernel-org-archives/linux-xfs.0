Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F32CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 15:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiCaPIN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 11:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbiCaPII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 11:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8901020E975
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 08:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0C4F61A9F
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 15:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF0CC340ED;
        Thu, 31 Mar 2022 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648739179;
        bh=xm9+dpTJnIqzshdIPbeMh0qqLwclb60BAENrhIUPrqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aomjLQSar0nrVQpLIXEoenzwgxI6RonrdCLfTFp3dixc9LP+o0RuPaBwPet38whAP
         Ej3j47JAxsxZxN3k337S3wtG3tlhhBAOv+me1kDjRPT1+/tJvM2Qh37thX69g16d5e
         B3Xuy5upGVNUwnJKuAjN9OOtexccyG8kPu06jMR9GGKnfu8eDXpgLVKax1ymwG7npO
         VR1+IV6rJjD1mlzhwzcCkvio2uwd3JCp45ZiDDxi3l9ngtsvwLNS3rbuNM0FdlUfdQ
         6FQd7p4JSo+yfv6DwW+peuZRVrcC5Q0lB3rTrLyq7Uz7zfGWpTeXHjxm5ox1EJcctb
         BKkrV6xb6QJmQ==
Date:   Thu, 31 Mar 2022 08:06:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chris Down <chris@chrisdown.name>
Cc:     Petr Mladek <pmladek@suse.com>, Dave Chinner <david@fromorbit.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220331150618.GM27690@magnolia>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <20220330004649.GG27713@magnolia>
 <20220330012624.GC1544202@dread.disaster.area>
 <20220330145955.GB4384@pathway.suse.cz>
 <YkRyOKZ+hJYysKrR@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkRyOKZ+hJYysKrR@chrisdown.name>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 04:07:36PM +0100, Chris Down wrote:
> Petr Mladek writes:
> > I understand this fear. It was my very first reaction on the printk
> > index feature as well.
> > 
> > Chris explained to me that it is exactly the opposite. I have tried to
> > summarize my undestanding in the following RFC patch. I could
> > send it separately for a proper review if you agree that
> > this is the right way to go.
> > 
> > I think that we will actually need to extend the section about
> > the subsystem specific prefix. It seems that Chris has another
> > opinion based on his real life experience with this feature.
> 
> Wow, thanks for writing this up! This looks great to me, feel free to send
> it as a real patch and I will happily add my Reviewed-by.
> 
> My general opinion is that debugfs files don't mandate user-facing
> documentation since they are by their very nature kernel developer features,
> but you're right that it would reduce confusion here to have something
> written to reference for people who want to add printk index entries, so
> this makes sense.
> 
> > Anyway, I send this draft now. It is getting late here. I hope
> > that it will answer some questions...
> > 
> > Here we go:
> > 
> > From 65a6fb3b9d183434ecdd96f286439696f868fa8e Mon Sep 17 00:00:00 2001
> > From: Petr Mladek <pmladek@suse.com>
> > Date: Wed, 30 Mar 2022 16:47:09 +0200
> > Subject: [RFC] printk/index: Printk index feature documentation
> > 
> > Document the printk index feature. The primary motivation is to
> > explain that it is not creating KABI from particular printk() calls.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > ---
> > Documentation/core-api/printk-index.rst | 139 ++++++++++++++++++++++++
> > 1 file changed, 139 insertions(+)
> > create mode 100644 Documentation/core-api/printk-index.rst
> > 
> > diff --git a/Documentation/core-api/printk-index.rst b/Documentation/core-api/printk-index.rst
> > new file mode 100644
> > index 000000000000..b5f759e97a6a
> > --- /dev/null
> > +++ b/Documentation/core-api/printk-index.rst
> > @@ -0,0 +1,139 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +============
> > +Printk index
> > +============
> > +
> > +There are many ways how to control the state of the system. One important

I would say this is monitoring the state of the system more than it's
controlling it.

> > +source of information is the system log. It provides a lot of information,
> > +including more or less important warnings and error messages.
> > +
> > +The system log can be monitored by some tool. It is especially useful
> > +when there are many monitored systems. Such tools try to filter out
> > +less important messages or known problems. They might also trigger
> > +some action when a particular message appears.

TBH I thought the bigger promise of the printk index is the ability to
find where in the source code a message might have come from.

I would like to see the problem statement part of this doc develop
further.  What do you think about reworking the above paragraph like so?

"Often it is useful for developers and support specialists to be able to
trace a kernel log message back to its exact position in source code.
Moreover, there are monitoring tools that filter and take action based
on messages logged.  For both of these use cases, it would be helpful to
provide an index of all possible printk format strings for the running
kernel."

> > +
> > +The kernel messages are evolving together with the code. They are
> > +not KABI and never will be!

Ok.  You might want to make it explicit here that the format of the
debugfs file itself shouldn't change, unlike the file/line/formatspecificer
*contents* of those files.

> > +It is a huge challenge for maintaining the system log monitors. It requires
> > +knowing what messages were udpated and why. Finding these changes in

s/udpated/updated/

> > +the sources would require non-trivial parsers. Also it would require
> > +matching the sources with the binary kernel which is not always trivial.
> > +Various changes might be backported. Various kernel versions might be used
> > +on different monitored systems.
> > +
> > +This is where the printk index feature might become useful. It provides
> > +a dump of printk formats used all over the source code used for the kernel
> > +and modules on the running system. It is accessible at runtime via debugfs.
> > +
> > +
> > +User interface
> > +==============
> > +
> > +The index of printk formats is split into separate files for
> > +for vmlinux and loaded modules, for example::
> > +
> > +   /sys/kernel/debug/printk/index/vmlinux
> > +   /sys/kernel/debug/printk/index/ext4
> > +   /sys/kernel/debug/printk/index/scsi_mod

If ext4 is built into the kernel (and not as a module), does its format
strings end up in index/vmlinux or index/ext4?

> > +
> > +The content is inspired by the dynamic debug interface and looks like::
> > +
> > +   $> head -1 /sys/kernel/debug/printk/index/vmlinux; shuf -n 5 vmlinux
> > +   # <level[,flags]> filename:line function "format"
> > +   <5> block/blk-settings.c:661 disk_stack_limits "%s: Warning: Device %s is misaligned\n"
> > +   <4> kernel/trace/trace.c:8296 trace_create_file "Could not create tracefs '%s' entry\n"
> > +   <6> arch/x86/kernel/hpet.c:144 _hpet_print_config "hpet: %s(%d):\n"
> > +   <6> init/do_mounts.c:605 prepare_namespace "Waiting for root device %s...\n"
> > +   <6> drivers/acpi/osl.c:1410 acpi_no_auto_serialize_setup "ACPI: auto-serialization disabled\n"
> > +
> > +, where the meaning is::
> > +
> > +   - level: log level
> > +   - flags: optional flags: currently only 'c' for KERN_CONT
> > +   - filename:line: source filename and line number of the related
> > +	printk() call. Note that there are many wrappers, for example,
> > +	pr_warn(), pr_warn_once(), dev_warn().
> > +   - function: function name where the printk() call is used.
> > +   - format: format string
> > +
> > +The extra information makes it a bit harder to find differences
> > +between various kernels. Especially the line number might change
> > +very often. On the other hand, it helps a lot to confirm that
> > +it is the same string or find the commit that is responsible
> > +for eventual changes.
> > +
> > +
> > +printk() as a KABI

You might just call this "printk() is not a stable KABI".

> > +==================
> > +
> > +Many developers are afraid that exporting all these implementation
> > +details into the user space will transform particular printk() calls
> > +into KABI.
> > +
> > +But it is exactly the opposite. printk() calls must _not_ be KABI.
> > +And the printk index helps user space tools to deal with this.
> > +
> > +It is similar to the dynamic debug interface. It shows what debugging
> > +strings might be enabled. But it does not create ABI from them.
> > +
> > +Or it is similar to <debugfs>/tracing/available_filter_functions.

"It is also similar to..."

> > +It provides a list of functions that can be traced. But it does
> > +not create KABI from the function names. It would prevent any
> > +further development.
> > +
> > +
> > +Subsystem specific printk wrappers
> > +==================================
> > +
> > +The printk index is generated using extra metadata that are stored in
> > +a dedicated .elf section ".printk_index". It is achieved using macro
> > +wrappers doing __printk_index_emit() together with the real printk()
> > +call. The same technique is used also for the metadata used by
> > +the dynamic debug feature.
> > +
> > +The metadata are stored for a particular message only when it is printed
> > +using these special wrappers. It is implemented for the commonly
> > +used printk() calls, including, for example, pr_warn(), or pr_once().
> > +
> > +It needs additional changes for variaous subsystem specific wrappers that

"Additional changes are necessary for various subsystem specific
wrappers..."

> > +call the original printk() via a common helper function. These needs
> > +they own wrappers adding __printk_index_emit().

"These need their own wrappers..."

> > +
> > +Only few subsystem specific wrappers have been updated so far,
> > +for example, dev_printk(). Only the generic string from the common
> > +helper function appears in the printk index for others.
> > +
> > +
> > +Subsystem specific prefix
> > +=========================
> > +
> > +The macro pr_fmt() macro allows to define a prefix that is printed
> > +before the string generated by the related printk() calls.
> > +
> > +Subsystem specific wrappers usually add even more complicated
> > +prefixes.
> > +
> > +These prefixes can be stored into the printk index metadata
> > +by an optional parameter of __printk_index_emit(). The debugfs
> > +interface might then show the printk formats including these prefixes.
> > +For example, drivers/acpi/osl.c contains::
> > +
> > +  #define pr_fmt(fmt) "ACPI: OSL: " fmt
> > +
> > +  static int __init acpi_no_auto_serialize_setup(char *str)
> > +  {
> > +	acpi_gbl_auto_serialize_methods = FALSE;
> > +	pr_info("Auto-serialization disabled\n");
> > +
> > +	return 1;
> > +  }
> > +
> > +I results into printk index entry::

"This results in the following printk index entry::"

> > +
> > +  <6> drivers/acpi/osl.c:1410 acpi_no_auto_serialize_setup "ACPI: auto-serialization disabled\n"
> > +
> > +It helps matching messages from the real log with printk index.
> > +Then the source file name, line number, and function name can
> > +be used to match the string with the source code.

--D

> > -- 
> > 2.34.1
