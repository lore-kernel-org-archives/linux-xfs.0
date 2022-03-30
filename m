Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28C8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 00:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiC3Asj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 20:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiC3Asi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 20:48:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681CA182D80
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 17:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3FFEB8197B
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 00:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F55C2BBE4;
        Wed, 30 Mar 2022 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648601210;
        bh=OM8dd4DcbuixROFbv+9l/shB4m92XjiIC3qVrbm98KE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sSBC398Xi60YvFlllimThcQ9kiBdWGb+vatNSKFnq+Sesh7rFRBdAjI1pyR8lEC/E
         rqRRnrH7Jpf8Tv+vs2zvbpG+Uv9PsKfiTO7o7FLoCai7D5C47SuR2oNYraWZ4G/2G0
         yWXWJWbhxc06TtL8LE1pV8ek9Fx+4SwdoHvaOuraP/U12ZXgSH0TFjgyEn+ANPHEiz
         NUi4b0Ehsx/lIJExy1xqBDougJrBMXM0/Yw4dZVmkC8lFY4cvfRNNW/IpRmaztzfiC
         R18mVf/NwzyPn7fovBpNYHtvI2wj+0JAWWcyumXiU2ULMftJScSoSpJthQohYkVN4F
         ltbQ3L2XxoObQ==
Date:   Tue, 29 Mar 2022 17:46:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Petr Mladek <pmladek@suse.com>, Jonathan Lassoff <jof@thejof.com>,
        linux-xfs@vger.kernel.org, Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330004649.GG27713@magnolia>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330003457.GB1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 11:34:57AM +1100, Dave Chinner wrote:
> Hi Petr,
> 
> On Tue, Mar 29, 2022 at 03:34:00PM +0200, Petr Mladek wrote:
> > On Fri 2022-03-25 10:19:46, Jonathan Lassoff wrote:
> > > In order for end users to quickly react to new issues that come up in
> > > production, it is proving useful to leverage the printk indexing system.
> > > This printk index enables kernel developers to use calls to printk()
> > > with changeable ad-hoc format strings, while still enabling end users
> > > to detect changes from release to release.
> > > 
> > > So that detailed XFS messages are captures by this printk index, this
> > > patch wraps the xfs_<level> and xfs_alert_tag functions.
> > > 
> > > Signed-off-by: Jonathan Lassoff <jof@thejof.com>
> > 
> > > --- a/fs/xfs/xfs_message.h
> > > +++ b/fs/xfs/xfs_message.h
> > > @@ -6,34 +6,45 @@
> > >  
> > >  struct xfs_mount;
> > >  
> > > +#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
> > > +({								\
> > > +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
> > 
> > I would probably use "%sXFS: " for the first parameter as
> > a compromise here.
> 
> If you really want to be pedantic, the correct format string would
> be "%sXFS (%s):" because of the reasons you state below -  mp &&
> mp->m_super is almost -always- present, so almost all messages are
> going to be emitted in the the (%s) form....
> 
> But that makes me wonder - if the format string doesn't apparently
> need to be an exact match to what is actually output by the kernel,
> then how is this information supposed to be used?
> 
> And so....
> 
> > It affects how the printk formats are shown in debugfs. With the
> > current patch I see in /sys/kernel/debug/printk/index/vmlinux:
> > 
> > <4> fs/xfs/libxfs/xfs_ag.c:877 xfs_ag_shrink_space "%sXFS%s: Error %d reserving per-AG metadata reserve pool."
> > <1> fs/xfs/libxfs/xfs_ag.c:151 xfs_initialize_perag_data "%sXFS%s: AGF corruption. Please run xfs_repair."
> > <4> fs/xfs/libxfs/xfs_alloc.c:2429 xfs_agfl_reset "%sXFS%s: WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. Please unmount and run xfs_repair."
> > <4> fs/xfs/libxfs/xfs_alloc.c:262 xfs_alloc_get_rec "%sXFS%s: start block 0x%x block count 0x%x"
> > <4> fs/xfs/libxfs/xfs_alloc.c:260 xfs_alloc_get_rec "%sXFS%s: %s Freespace BTree record corruption in AG %d detected!"
> > <1> fs/xfs/libxfs/xfs_attr_remote.c:304 xfs_attr_rmtval_copyout "%sXFS%s: remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)"
> > <4> fs/xfs/libxfs/xfs_bmap.c:1129 xfs_iread_bmbt_block "%sXFS%s: corrupt dinode %llu, (btree extents)."
> 
> ... onto the implications of explicitly exposing source code
> directly to userspace via a kernel ABI.
> 
> I ask, because user/kernel ABIs are usually fixed and we are not
> allowed to change them in a way that might break userspace. What
> happens when one of these format messages gets moved? What if the
> file, function and line of code all change, but the format string
> stays the same? What about duplicate format strings in different
> files/functions?
> 
> Exactly how is this supposed to be used by userspace? Given that you
> are exposing both the file and the line of the file that the format
> string belongs to, does this mean we can no longer actually move
> this format string to any other location in the source code?
> 
> IOWs, I cannot find anything that documents the implications of
> directly exposing the *raw source code* to userspace though a sysfs
> file on either developers or userspace applications.  Exposing
> anything through a sysfs file usually comes with constraints and
> guarantees and just because it is in /sys/kernel/debug means we can
> waive ABI constraints: I'll refer you to the canonical example of
> tracepoints vs powertop.
> 
> With tracepoints in mind, XFS has an explicit policy that
> tracepoints do not form part of the user ABI because they expose the
> internal implementation directly to userspace. Hence if you use XFS
> tracepoints for any purpose, you get to keep all the broken bits
> when we change/add/remove tracepoints as part of our normal
> development.
> 
> However, for information we explicitly expose via files in proc and
> sysfs (and via ioctls, for that matter), we have to provide explicit
> ABI guarantees, and that means we cannot remove or change the format
> or content of those files in ways that would cause userspace parsers
> and applications to break. If we are removing a proc/sysfs file, we
> have an explicit deprecation process that takes years to run so that
> userspace has time to notice that removal will be occurring and be
> updated not to depend on it by the time we remove it.
> 
> I see no statement anywhere about what this printk index ABI
> requires in terms of code stablility, format string maintenance and
> modification, etc. I've seen it referred to as "semi-stable" but
> there is no clear, easily accessible definition as to what that
> means for either kernel developers or userspace app developers that
> might want to use this information. There's zero information
> available about how userspace will use this information, too, so at
> this point I can't even guess what the policy for this new ABI
> actually is.
> 
> If this was discussed and a policy was created, then great. But it
> *hasn't been documented* for the rest of the world to be able to
> read and understand so they know how to deal safely with the
> information this ABI now provides. So, can you please explain what
> the rules are, and then please write some documentation for the
> kernel admin guide defining the user ABI for application writers and
> what guarantees the kernel provides them with about the contents of
> this ABI.

FWIW if you /did/ accept this for 5.19, I would suggest adding:

printk_index_subsys_emit("XFS log messages shall not be considered a stable kernel ABI as they can change at any time");

I base that largely on the evidence -- there's nothing saying that
catalogued strings are or are not a stable ABI.  That means it's up to
the subsystem or the maintainers or whoever to make a decision, and I
would decide that while some people somewhere might benefit from having
the message catalogue over not having it (e.g. i18n), someone would have
to show a /very/ strong case for letting XFS get powertop'd.

Granted I won't be the maintainer after Sunday and this isn't 5.18
material, so I suppose the ball is in your court. ;)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
