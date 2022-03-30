Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2680C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 15:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241848AbiC3PBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiC3PBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 11:01:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5B23148
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 07:59:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CDD8E1F38C;
        Wed, 30 Mar 2022 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648652395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wt1taWwkmR4Wc3ahE5vngjNbdLFF8KGeB79Ur5+cuew=;
        b=l4GUUrM9OtEZLSL3gEPEqay7FjWGE3bhhboBQLqivfBheIEv2rxzup8+RyBlhCReGxpwbp
        drYz/d34lR1KG3mdVM4jwx0Dx744Fkj8Ygzn/01oOS2WmEVWsjmnvy1jvJ1IMV4F4n7sf1
        yEFXtCt+pMjwkPY+A8GJFEqht4b2Iw4=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 72397A3BA9;
        Wed, 30 Mar 2022 14:59:55 +0000 (UTC)
Date:   Wed, 30 Mar 2022 16:59:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330145955.GB4384@pathway.suse.cz>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <20220330004649.GG27713@magnolia>
 <20220330012624.GC1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330012624.GC1544202@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 2022-03-30 12:26:24, Dave Chinner wrote:
> On Tue, Mar 29, 2022 at 05:46:49PM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 30, 2022 at 11:34:57AM +1100, Dave Chinner wrote:
> > > I see no statement anywhere about what this printk index ABI
> > > requires in terms of code stablility, format string maintenance and
> > > modification, etc. I've seen it referred to as "semi-stable" but
> > > there is no clear, easily accessible definition as to what that
> > > means for either kernel developers or userspace app developers that
> > > might want to use this information. There's zero information
> > > available about how userspace will use this information, too, so at
> > > this point I can't even guess what the policy for this new ABI
> > > actually is.
> > > 
> > > If this was discussed and a policy was created, then great. But it
> > > *hasn't been documented* for the rest of the world to be able to
> > > read and understand so they know how to deal safely with the
> > > information this ABI now provides. So, can you please explain what
> > > the rules are, and then please write some documentation for the
> > > kernel admin guide defining the user ABI for application writers and
> > > what guarantees the kernel provides them with about the contents of
> > > this ABI.
> > 
> > FWIW if you /did/ accept this for 5.19, I would suggest adding:
> > 
> > printk_index_subsys_emit("XFS log messages shall not be considered a stable kernel ABI as they can change at any time");
> > 
> > I base that largely on the evidence -- there's nothing saying that
> > catalogued strings are or are not a stable ABI.  That means it's up to
> > the subsystem or the maintainers or whoever to make a decision, and I
> 
> Yup, that's largely what I want clarified before we make a
> decision one way or another. There must have been some discussion
> and decisions on what the policy is before it was merged, but it's
> not easily findable.
> 
> And, IMO, instead of every single subsystem having to go through the
> same question and answer process as we are currently doing, I want
> that policy to be documented such that a simple "git grep
> printk_index_subsys_emit" search returns the file in the
> Documentation/ directory that explains all this. That makes
> everyone's lives a whole lot easier.

I understand this fear. It was my very first reaction on the printk
index feature as well.

Chris explained to me that it is exactly the opposite. I have tried to
summarize my undestanding in the following RFC patch. I could
send it separately for a proper review if you agree that
this is the right way to go.

I think that we will actually need to extend the section about
the subsystem specific prefix. It seems that Chris has another
opinion based on his real life experience with this feature.

Anyway, I send this draft now. It is getting late here. I hope
that it will answer some questions...

Here we go:

From 65a6fb3b9d183434ecdd96f286439696f868fa8e Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Wed, 30 Mar 2022 16:47:09 +0200
Subject: [RFC] printk/index: Printk index feature documentation

Document the printk index feature. The primary motivation is to
explain that it is not creating KABI from particular printk() calls.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/core-api/printk-index.rst | 139 ++++++++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 Documentation/core-api/printk-index.rst

diff --git a/Documentation/core-api/printk-index.rst b/Documentation/core-api/printk-index.rst
new file mode 100644
index 000000000000..b5f759e97a6a
--- /dev/null
+++ b/Documentation/core-api/printk-index.rst
@@ -0,0 +1,139 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Printk index
+============
+
+There are many ways how to control the state of the system. One important
+source of information is the system log. It provides a lot of information,
+including more or less important warnings and error messages.
+
+The system log can be monitored by some tool. It is especially useful
+when there are many monitored systems. Such tools try to filter out
+less important messages or known problems. They might also trigger
+some action when a particular message appears.
+
+The kernel messages are evolving together with the code. They are
+not KABI and never will be!
+
+It is a huge challenge for maintaining the system log monitors. It requires
+knowing what messages were udpated and why. Finding these changes in
+the sources would require non-trivial parsers. Also it would require
+matching the sources with the binary kernel which is not always trivial.
+Various changes might be backported. Various kernel versions might be used
+on different monitored systems.
+
+This is where the printk index feature might become useful. It provides
+a dump of printk formats used all over the source code used for the kernel
+and modules on the running system. It is accessible at runtime via debugfs.
+
+
+User interface
+==============
+
+The index of printk formats is split into separate files for
+for vmlinux and loaded modules, for example::
+
+   /sys/kernel/debug/printk/index/vmlinux
+   /sys/kernel/debug/printk/index/ext4
+   /sys/kernel/debug/printk/index/scsi_mod
+
+The content is inspired by the dynamic debug interface and looks like::
+
+   $> head -1 /sys/kernel/debug/printk/index/vmlinux; shuf -n 5 vmlinux
+   # <level[,flags]> filename:line function "format"
+   <5> block/blk-settings.c:661 disk_stack_limits "%s: Warning: Device %s is misaligned\n"
+   <4> kernel/trace/trace.c:8296 trace_create_file "Could not create tracefs '%s' entry\n"
+   <6> arch/x86/kernel/hpet.c:144 _hpet_print_config "hpet: %s(%d):\n"
+   <6> init/do_mounts.c:605 prepare_namespace "Waiting for root device %s...\n"
+   <6> drivers/acpi/osl.c:1410 acpi_no_auto_serialize_setup "ACPI: auto-serialization disabled\n"
+
+, where the meaning is::
+
+   - level: log level
+   - flags: optional flags: currently only 'c' for KERN_CONT
+   - filename:line: source filename and line number of the related
+	printk() call. Note that there are many wrappers, for example,
+	pr_warn(), pr_warn_once(), dev_warn().
+   - function: function name where the printk() call is used.
+   - format: format string
+
+The extra information makes it a bit harder to find differences
+between various kernels. Especially the line number might change
+very often. On the other hand, it helps a lot to confirm that
+it is the same string or find the commit that is responsible
+for eventual changes.
+
+
+printk() as a KABI
+==================
+
+Many developers are afraid that exporting all these implementation
+details into the user space will transform particular printk() calls
+into KABI.
+
+But it is exactly the opposite. printk() calls must _not_ be KABI.
+And the printk index helps user space tools to deal with this.
+
+It is similar to the dynamic debug interface. It shows what debugging
+strings might be enabled. But it does not create ABI from them.
+
+Or it is similar to <debugfs>/tracing/available_filter_functions.
+It provides a list of functions that can be traced. But it does
+not create KABI from the function names. It would prevent any
+further development.
+
+
+Subsystem specific printk wrappers
+==================================
+
+The printk index is generated using extra metadata that are stored in
+a dedicated .elf section ".printk_index". It is achieved using macro
+wrappers doing __printk_index_emit() together with the real printk()
+call. The same technique is used also for the metadata used by
+the dynamic debug feature.
+
+The metadata are stored for a particular message only when it is printed
+using these special wrappers. It is implemented for the commonly
+used printk() calls, including, for example, pr_warn(), or pr_once().
+
+It needs additional changes for variaous subsystem specific wrappers that
+call the original printk() via a common helper function. These needs
+they own wrappers adding __printk_index_emit().
+
+Only few subsystem specific wrappers have been updated so far,
+for example, dev_printk(). Only the generic string from the common
+helper function appears in the printk index for others.
+
+
+Subsystem specific prefix
+=========================
+
+The macro pr_fmt() macro allows to define a prefix that is printed
+before the string generated by the related printk() calls.
+
+Subsystem specific wrappers usually add even more complicated
+prefixes.
+
+These prefixes can be stored into the printk index metadata
+by an optional parameter of __printk_index_emit(). The debugfs
+interface might then show the printk formats including these prefixes.
+For example, drivers/acpi/osl.c contains::
+
+  #define pr_fmt(fmt) "ACPI: OSL: " fmt
+
+  static int __init acpi_no_auto_serialize_setup(char *str)
+  {
+	acpi_gbl_auto_serialize_methods = FALSE;
+	pr_info("Auto-serialization disabled\n");
+
+	return 1;
+  }
+
+I results into printk index entry::
+
+  <6> drivers/acpi/osl.c:1410 acpi_no_auto_serialize_setup "ACPI: auto-serialization disabled\n"
+
+It helps matching messages from the real log with printk index.
+Then the source file name, line number, and function name can
+be used to match the string with the source code.
-- 
2.34.1

