Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A9DC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 14:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiGHOR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 10:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiGHORz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 10:17:55 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E992D2FFFF
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 07:17:53 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4D6C078EC;
        Fri,  8 Jul 2022 09:17:41 -0500 (CDT)
Message-ID: <7a609923-4174-de01-d097-edb4b983d939@sandeen.net>
Date:   Fri, 8 Jul 2022 09:17:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     Christopher Pereira <kripper@imatronix.cl>,
        linux-xfs@vger.kernel.org
References: <09b4cbd7-c258-e39c-1f04-1edcc8ccf899@imatronix.cl>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [bug report] xfs corruption - XFS_WANT_CORRUPTED_RETURN
In-Reply-To: <09b4cbd7-c258-e39c-1f04-1edcc8ccf899@imatronix.cl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/8/22 2:45 AM, Christopher Pereira wrote:
> Hi,
> 
> I've been using XFS for many years on many qemu-kvm VMs without problems.
> I do daily qcow2 snapshots and today I noticed that a snaphot I took on Jun  1 2022 has a corrupted XFS root partition and doesn't boot any more (on another VM instance).
> The snapshot I took the day before is clean.
> The VM is still running since May 11 2022, has not been rebooted and didn't crash which is the reason I'm reporting this issue.
> This is a production VM with sensible data.
> 
> The kernel logged this error multiple times between 00:00:21 and 00:03:31 on Jun 1:
> 
> Jun  1 00:00:21 *** kernel: XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at line 337 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0230e5b>] xfs_error_report+0x3b/0x40 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>] ? xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01ee684>] xfs_alloc_fixup_trees+0x2c4/0x370 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f0588>] xfs_alloc_ag_vextent_near+0x658/0xa60 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f120d>] xfs_alloc_ag_vextent+0xcd/0x110 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa01f1f89>] xfs_alloc_vextent+0x429/0x5e0 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa020237f>] xfs_bmap_btalloc+0x3af/0x710 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa02026ee>] xfs_bmap_alloc+0xe/0x10 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0203148>] xfs_bmapi_write+0x4d8/0xa90 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa023bd1b>] xfs_iomap_write_allocate+0x14b/0x350 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0226dc6>] xfs_map_blocks+0x1c6/0x230 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0227fe3>] xfs_vm_writepage+0x193/0x5d0 [xfs]
> Jun  1 00:00:22 *** kernel: [<ffffffffa0227993>] xfs_vm_writepages+0x43/0x50 [xfs]
> Jun  1 00:00:22 *** kernel: XFS (dm-0): page discard on page ffffea000cf60200, inode 0xc52bf7f, offset 0.
> 
> I'm running this (outdated) software:
> 
> - uname -a:
>     Linux *** 3.10.0-327.22.2.el7.x86_64 #1 SMP Thu Jun 23 17:05:11 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Hi Christopherr -

So that's a RHEL7.2 kernel, first released in 2016 or so - so quite old as
you say, and also a vendor kernel you'll really need to talk to the vendor
about, vs. upstream, for any detailed debugging or support.

That said ...

        /*
         * Look up the record in the by-size tree if necessary.
         */
        if (flags & XFSA_FIXUP_CNT_OK) {
#ifdef DEBUG
                if ((error = xfs_alloc_get_rec(cnt_cur, &nfbno1, &nflen1, &i)))
                        return error;
                XFS_WANT_CORRUPTED_RETURN(mp,
                        i == 1 && nfbno1 == fbno && nflen1 == flen);
#endif
        } else {
                if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
                        return error;
                XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
        }

so I think that means this is a corrupted btree. I'm not remembering any bugs
related to this but again, it's pretty old code.

> 
> - modinfo xfs
>     filename: /lib/modules/3.10.0-327.22.2.el7.x86_64/kernel/fs/xfs/xfs.ko
>     license:        GPL
>     description:    SGI XFS with ACLs, security attributes, no debug enabled
>     author:         Silicon Graphics, Inc.
>     alias:          fs-xfs
>     rhelversion:    7.2
>     srcversion:     5F736B32E75482D75F98583
>     depends:        libcrc32c
>     intree:         Y
>     vermagic:       3.10.0-327.22.2.el7.x86_64 SMP mod_unload modversions
>     signer:         CentOS Linux kernel signing key

Ok, so CentOS not RHEL, but still not something the upstream developer community
can do a whole lot with.

>     sig_key: A9:80:1A:61:B3:68:60:1C:40:EB:DB:D5:DF:D1:F3:A7:70:07:BF:A4
>     sig_hashalgo:   sha256
> 
> 1) Is there any known issue with this xfs version?
> 
> 2) How may I help you to trace this bug.
> I could provide my WhatsApp number privately for direct communication.
> 
> Should I try a xfs_repair and post the logs here or via pastebin?

Since you have a snapshot, that's perfectly safe; I would make another snapshot,
and run repair on it and see how that goes. Hopefully it will resolve your issue,
which seems to be a one-off in your case.

It might be a good idea to use a more recent xfs_repair than the one in
RHEL7.2 for this.

-Eric

> BTW: I'm a experienced developer and sysadmin, but have no experience regarding the XFS  driver.
> 
> 
