Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A88C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 00:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiC3Agp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 20:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiC3Ago (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 20:36:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAC1B182AC4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 17:35:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EA44610E531D;
        Wed, 30 Mar 2022 11:34:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZMIb-00BUrN-LB; Wed, 30 Mar 2022 11:34:57 +1100
Date:   Wed, 30 Mar 2022 11:34:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330003457.GB1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkMKyN9w0S8VFJRk@alley>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6243a5b4
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=Ot3N2O21AAAA:8 a=7-415B0cAAAA:8
        a=o51Xjc9eAmUZ8Jt7508A:9 a=CjuIK1q_8ugA:10 a=-F6LaNPAekqF0pxxGpLN:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Petr,

On Tue, Mar 29, 2022 at 03:34:00PM +0200, Petr Mladek wrote:
> On Fri 2022-03-25 10:19:46, Jonathan Lassoff wrote:
> > In order for end users to quickly react to new issues that come up in
> > production, it is proving useful to leverage the printk indexing system.
> > This printk index enables kernel developers to use calls to printk()
> > with changeable ad-hoc format strings, while still enabling end users
> > to detect changes from release to release.
> > 
> > So that detailed XFS messages are captures by this printk index, this
> > patch wraps the xfs_<level> and xfs_alert_tag functions.
> > 
> > Signed-off-by: Jonathan Lassoff <jof@thejof.com>
> 
> > --- a/fs/xfs/xfs_message.h
> > +++ b/fs/xfs/xfs_message.h
> > @@ -6,34 +6,45 @@
> >  
> >  struct xfs_mount;
> >  
> > +#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
> > +({								\
> > +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
> 
> I would probably use "%sXFS: " for the first parameter as
> a compromise here.

If you really want to be pedantic, the correct format string would
be "%sXFS (%s):" because of the reasons you state below -  mp &&
mp->m_super is almost -always- present, so almost all messages are
going to be emitted in the the (%s) form....

But that makes me wonder - if the format string doesn't apparently
need to be an exact match to what is actually output by the kernel,
then how is this information supposed to be used?

And so....

> It affects how the printk formats are shown in debugfs. With the
> current patch I see in /sys/kernel/debug/printk/index/vmlinux:
> 
> <4> fs/xfs/libxfs/xfs_ag.c:877 xfs_ag_shrink_space "%sXFS%s: Error %d reserving per-AG metadata reserve pool."
> <1> fs/xfs/libxfs/xfs_ag.c:151 xfs_initialize_perag_data "%sXFS%s: AGF corruption. Please run xfs_repair."
> <4> fs/xfs/libxfs/xfs_alloc.c:2429 xfs_agfl_reset "%sXFS%s: WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. Please unmount and run xfs_repair."
> <4> fs/xfs/libxfs/xfs_alloc.c:262 xfs_alloc_get_rec "%sXFS%s: start block 0x%x block count 0x%x"
> <4> fs/xfs/libxfs/xfs_alloc.c:260 xfs_alloc_get_rec "%sXFS%s: %s Freespace BTree record corruption in AG %d detected!"
> <1> fs/xfs/libxfs/xfs_attr_remote.c:304 xfs_attr_rmtval_copyout "%sXFS%s: remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)"
> <4> fs/xfs/libxfs/xfs_bmap.c:1129 xfs_iread_bmbt_block "%sXFS%s: corrupt dinode %llu, (btree extents)."

... onto the implications of explicitly exposing source code
directly to userspace via a kernel ABI.

I ask, because user/kernel ABIs are usually fixed and we are not
allowed to change them in a way that might break userspace. What
happens when one of these format messages gets moved? What if the
file, function and line of code all change, but the format string
stays the same? What about duplicate format strings in different
files/functions?

Exactly how is this supposed to be used by userspace? Given that you
are exposing both the file and the line of the file that the format
string belongs to, does this mean we can no longer actually move
this format string to any other location in the source code?

IOWs, I cannot find anything that documents the implications of
directly exposing the *raw source code* to userspace though a sysfs
file on either developers or userspace applications.  Exposing
anything through a sysfs file usually comes with constraints and
guarantees and just because it is in /sys/kernel/debug means we can
waive ABI constraints: I'll refer you to the canonical example of
tracepoints vs powertop.

With tracepoints in mind, XFS has an explicit policy that
tracepoints do not form part of the user ABI because they expose the
internal implementation directly to userspace. Hence if you use XFS
tracepoints for any purpose, you get to keep all the broken bits
when we change/add/remove tracepoints as part of our normal
development.

However, for information we explicitly expose via files in proc and
sysfs (and via ioctls, for that matter), we have to provide explicit
ABI guarantees, and that means we cannot remove or change the format
or content of those files in ways that would cause userspace parsers
and applications to break. If we are removing a proc/sysfs file, we
have an explicit deprecation process that takes years to run so that
userspace has time to notice that removal will be occurring and be
updated not to depend on it by the time we remove it.

I see no statement anywhere about what this printk index ABI
requires in terms of code stablility, format string maintenance and
modification, etc. I've seen it referred to as "semi-stable" but
there is no clear, easily accessible definition as to what that
means for either kernel developers or userspace app developers that
might want to use this information. There's zero information
available about how userspace will use this information, too, so at
this point I can't even guess what the policy for this new ABI
actually is.

If this was discussed and a policy was created, then great. But it
*hasn't been documented* for the rest of the world to be able to
read and understand so they know how to deal safely with the
information this ABI now provides. So, can you please explain what
the rules are, and then please write some documentation for the
kernel admin guide defining the user ABI for application writers and
what guarantees the kernel provides them with about the contents of
this ABI.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
