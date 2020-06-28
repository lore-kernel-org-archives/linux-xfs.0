Return-Path: <SRS0=afpP=AJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B24EC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Jun 2020 12:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819DC20772
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Jun 2020 12:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgF1MGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Jun 2020 08:06:11 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:33475 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgF1MGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jun 2020 08:06:11 -0400
Received: from storm.broadband (unknown [84.65.51.147])
        (Authenticated sender: edwin@etorok.net)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 12BCA100005;
        Sun, 28 Jun 2020 12:06:08 +0000 (UTC)
Message-ID: <69dc29c4d0f3e80b4a8c8dfc559cbdd5ebce1428.camel@etorok.net>
Subject: Re: [PATCH v2 0/9] xfs: reflink cleanups
From:   Edwin =?ISO-8859-1?Q?T=F6r=F6k?= <edwin@etorok.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 28 Jun 2020 13:06:08 +0100
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2020-06-24 at 18:17 -0700, Darrick J. Wong wrote:
> Mr. Torok: Could you try applying these patches to a recent kernel to
> see if they fix the fs crash problems you were seeing with
> duperemove,
> please?

Hi,

Thanks for the fix.

I've tested commit e812e6bd89dc6489ca924756635fb81855091700 (reflink-
cleanups_2020-06-24) with my original test, and duperemove has now
finished successfully:

[...]
Comparison of extent info shows a net change in shared extents of:
237116676

There were some hung tasks reported in dmesg, but they recovered
eventually:
[32142.324709] INFO: task pool:5190 blocked for more than 120 seconds.
[32504.821571] INFO: task pool:5191 blocked for more than 120 seconds.
[32625.653640] INFO: task pool:5191 blocked for more than 241 seconds.
[32746.485671] INFO: task pool:5191 blocked for more than 362 seconds.
[32867.318072] INFO: task pool:5191 blocked for more than 483 seconds.
[34196.472677] INFO: task pool:5180 blocked for more than 120 seconds.
[34317.304542] INFO: task pool:5180 blocked for more than 241 seconds.
[34317.304627] INFO: task pool:5195 blocked for more than 120 seconds.
[34438.136740] INFO: task pool:5180 blocked for more than 362 seconds.
[34438.136816] INFO: task pool:5195 blocked for more than 241 seconds.

The blocked tasks were alternating between these 2 stacktraces:
[32142.324715] Call Trace:
[32142.324721]  __schedule+0x2d3/0x770
[32142.324722]  schedule+0x55/0xc0
[32142.324724]  rwsem_down_read_slowpath+0x16c/0x4a0
[32142.324726]  ? __wake_up_common_lock+0x8a/0xc0
[32142.324750]  ? xfs_vn_fiemap+0x32/0x80 [xfs]
[32142.324752]  down_read+0x85/0xa0
[32142.324769]  xfs_ilock+0x8a/0x100 [xfs]
[32142.324784]  xfs_vn_fiemap+0x32/0x80 [xfs]
[32142.324785]  do_vfs_ioctl+0xef/0x680
[32142.324787]  ksys_ioctl+0x73/0xd0
[32142.324788]  __x64_sys_ioctl+0x1a/0x20
[32142.324789]  do_syscall_64+0x49/0xc0
[32142.324790]  entry_SYSCALL_64_after_hwframe+0x44/0xa

[32504.821577] Call Trace:
[32504.821583]  __schedule+0x2d3/0x770
[32504.821584]  schedule+0x55/0xc0
[32504.821587]  rwsem_down_write_slowpath+0x244/0x4d0
[32504.821588]  down_write+0x41/0x50
[32504.821610]  xfs_ilock2_io_mmap+0xc8/0x230 [xfs]
[32504.821628]  ? xfs_reflink_remap_blocks+0x11f/0x2a0 [xfs]
[32504.821643]  xfs_reflink_remap_prep+0x51/0x1f0 [xfs]
[32504.821660]  xfs_file_remap_range+0xbe/0x2f0 [xfs]
[32504.821662]  ? security_capable+0x3d/0x60
[32504.821664]  vfs_dedupe_file_range_one+0x12d/0x150
[32504.821665]  vfs_dedupe_file_range+0x156/0x1e0
[32504.821666]  do_vfs_ioctl+0x4a6/0x680
[32504.821667]  ksys_ioctl+0x73/0xd0
[32504.821668]  __x64_sys_ioctl+0x1a/0x20
[32504.821669]  do_syscall_64+0x49/0xc0
[32504.821670]  entry_SYSCALL_64_after_hwframe+0x44/0xa

Looking at /proc/$(pidof duperemove)/fd it had ~80 files open at one
point, which causes a lot of seeking on a HDD if it was trying to
dedupe them all at once so I'm not too worried about these hung tasks.

Running an xfs_repair after the duperemove finished showed no errors.

> 
> v2: various cleanups suggested by Brian Foster
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!

To be safe I've created an LVM snapshot before trying it.

Best regards,
--Edwin

