Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE55C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 08:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiGYIbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 04:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiGYIa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 04:30:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC01D13FB4
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 01:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C1FB80DFE
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 08:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D6CC341C7;
        Mon, 25 Jul 2022 08:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658737838;
        bh=p/Yjb34fajtEQX2U/Nde4F+rB5zzd8Np95mf9xRGj/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaA1uBxGayMGQfBeFsgrklkn7ZnueUp8GJlnyHsY8nEYrRNFXm6MS+Glns5pH6L9W
         LfAeKSBzHzKlwq40dTpVxQQjCLt7YZbJFbKjKZXzlApE/GCo+rmlza+HvvcW5/pF9M
         8EtQdU50lIdTKAGyHbo+re4kHC9DtwNWLBu3aApU701NDjiyy9D2MgYnp8PxafIi8W
         6qWuje/C/Z5YKQOoND0cTHIlmQgZ0NnjH029BXgLIklLJmLecixYjOs1x0xhQa+PYK
         Ogeq6ANxo4mCSwG3gUNOo25csSS2gIdjnNxVBGXFu2DXNJBVSs1Z+0nKLQ4YKhwd6P
         hsLZ8tiy00wmA==
Date:   Mon, 25 Jul 2022 10:30:33 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Christopher Pereira <kripper@imatronix.cl>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS fs corruption - XFS_WANT_CORRUPTED_RETURN
Message-ID: <20220725083033.ijgleo372w3qhvi4@orion>
References: <425nj-mu3U3DyFC8vGfBiXjlAIM7BhKEu15RjL6pDHUa0NVM3CWjfjnT3HQ7U24NpNOzPxzbozYHf87W6tg8gw==@protonmail.internalid>
 <ca9d19d4-01f8-6435-f536-d87371dcbbde@imatronix.cl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca9d19d4-01f8-6435-f536-d87371dcbbde@imatronix.cl>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2022 at 12:23:36PM -0400, Christopher Pereira wrote:
> Hi,
> 
> I've been using XFS for many years on many qemu-kvm VMs without problems.
> I do daily qcow2 snapshots and today I noticed that a snaphot I took on
> Jun  1 2022 has a corrupted XFS root partition and doesn't boot any more
> (on another VM instance).
> The snapshot I took the day before is clean.
> The VM is still running since May 11 2022, has not been rebooted and
> didn't crash which is the reason I'm reporting this issue.
> This is a production VM with sensible data.
> 
> The kernel logged this error multiple times between 00:00:21 and
> 00:03:31 on Jun 1:
> 
> Jun  1 00:00:21 *** kernel: XFS (dm-0): Internal error
> XFS_WANT_CORRUPTED_RETURN at line 337 of file
> fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_alloc_ag_vextent_near+0x658/0xa60
> [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0230e5b>]
> xfs_error_report+0x3b/0x40 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>] ?
> xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01ee684>]
> xfs_alloc_fixup_trees+0x2c4/0x370 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>]
> xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f120d>]
> xfs_alloc_ag_vextent+0xcd/0x110 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f1f89>]
> xfs_alloc_vextent+0x429/0x5e0 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa020237f>]
> xfs_bmap_btalloc+0x3af/0x710 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa02026ee>] xfs_bmap_alloc+0xe/0x10
> [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0203148>]
> xfs_bmapi_write+0x4d8/0xa90 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa023bd1b>]
> xfs_iomap_write_allocate+0x14b/0x350 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0226dc6>]
> xfs_map_blocks+0x1c6/0x230 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0227fe3>]
> xfs_vm_writepage+0x193/0x5d0 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0227993>]
> xfs_vm_writepages+0x43/0x50 [xfs]
> Jun  1 00:00:22 *** kernel: XFS (dm-0): page discard on page
> ffffea000cf60200, inode 0xc52bf7f, offset 0.
> 
> I'm running this (outdated) software:
> 
> - uname -a:
>      Linux *** 3.10.0-327.22.2.el7.x86_64 #1 SMP Thu Jun 23 17:05:11 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux

> 1) Is there any known issue with this xfs version?
> 
> 2) How may I help you to trace this bug.
> I could provide my WhatsApp number privately for direct communication.
> 
> Should I try a xfs_repair and post the logs here or via pastebin?
> 
> BTW: I'm a experienced developer and sysadmin, but have no experience
> regarding the XFS  driver.

It seems like you are stepping into a corrupted btree, maybe try to xfs_repair
it and see if it fixes the problem. I can't tell you anything about known bugs,
you're using a (very) outdated kernel, so it's hard to say anything about bugs
here, you need to check this with the distribution directly. Maybe it will lit
a lamp on somebody's else mind, but it's unlikely you'll get much from here with
your current environment. If you repair the fs, and run into it again using
upstream code, it's another story, but by now, your best shot is run xfs_repair
on it and fix the corrupted tree.

You can use a more recent xfs_repair too without updating the kernel.

Cheers.

-- 
Carlos Maiolino
