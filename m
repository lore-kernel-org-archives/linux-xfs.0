Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 13:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiC2Nfq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 09:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC2Nfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 09:35:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B56F1F626
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 06:34:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 307601FD1A;
        Tue, 29 Mar 2022 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648560841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+GYt7xPaELKBg414nLg+UrZvt3m79h/wj9KWlRLlTw=;
        b=ua4ZzyPW9kCy3dnccff261TlgJ8ZVsie+tHQktDJonHXdzjBclOzg5R3g4Fj6wBa2qw8i3
        HluM9zjTSI9RyGzljD/HBEJ4+3VUQD2bSbhsPrDo+XLhss9yTalIzLMOnueAJqvj1gUog6
        bm6k1QSUW4pWe1qoXYSTngB1WmFF88U=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E76F4A3B82;
        Tue, 29 Mar 2022 13:34:00 +0000 (UTC)
Date:   Tue, 29 Mar 2022 15:34:00 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Jonathan Lassoff <jof@thejof.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkMKyN9w0S8VFJRk@alley>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 2022-03-25 10:19:46, Jonathan Lassoff wrote:
> In order for end users to quickly react to new issues that come up in
> production, it is proving useful to leverage the printk indexing system.
> This printk index enables kernel developers to use calls to printk()
> with changeable ad-hoc format strings, while still enabling end users
> to detect changes from release to release.
> 
> So that detailed XFS messages are captures by this printk index, this
> patch wraps the xfs_<level> and xfs_alert_tag functions.
> 
> Signed-off-by: Jonathan Lassoff <jof@thejof.com>

> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,34 +6,45 @@
>  
>  struct xfs_mount;
>  
> +#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
> +({								\
> +	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\

I would probably use "%sXFS: " for the first parameter as
a compromise here.

It affects how the printk formats are shown in debugfs. With the
current patch I see in /sys/kernel/debug/printk/index/vmlinux:

<4> fs/xfs/libxfs/xfs_ag.c:877 xfs_ag_shrink_space "%sXFS%s: Error %d reserving per-AG metadata reserve pool."
<1> fs/xfs/libxfs/xfs_ag.c:151 xfs_initialize_perag_data "%sXFS%s: AGF corruption. Please run xfs_repair."
<4> fs/xfs/libxfs/xfs_alloc.c:2429 xfs_agfl_reset "%sXFS%s: WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. Please unmount and run xfs_repair."
<4> fs/xfs/libxfs/xfs_alloc.c:262 xfs_alloc_get_rec "%sXFS%s: start block 0x%x block count 0x%x"
<4> fs/xfs/libxfs/xfs_alloc.c:260 xfs_alloc_get_rec "%sXFS%s: %s Freespace BTree record corruption in AG %d detected!"
<1> fs/xfs/libxfs/xfs_attr_remote.c:304 xfs_attr_rmtval_copyout "%sXFS%s: remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)"
<4> fs/xfs/libxfs/xfs_bmap.c:1129 xfs_iread_bmbt_block "%sXFS%s: corrupt dinode %llu, (btree extents)."

In reality, the prefix is chosen in __xfs_printk() at runtime:

	+ "%sXFS (%s): "	when mp->m_super is defined
	+ "%sXFS: "		otherwise

It means that "%sXFS: " is not perfect but it looks closer to reality
than "%sXFS%s: ".


Otherwise, the patch looks good to me. Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
