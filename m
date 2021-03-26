Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C25C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 04:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6486197C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 04:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhCZEVe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 00:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCZEVW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 00:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34C726197C;
        Fri, 26 Mar 2021 04:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616732481;
        bh=yX7XPDZdKr1lQhAdPmMKLIP11n5P0D32hdsvz9tHU+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQdPs3ev+3Pn01TB+goL79P5YsG0N1vHgGQ3wY8sg3x6z/7xprTeggHSxzmw76Cgs
         AS4nMW/9bRqSNRGX/v6QwBTg87xp9yaWoo0NMXvb2wjbpkCa0/jKPhN3MW7rGi8X+6
         SXk6P8dwvgqbiccFmajsIuBVrblnc2hiPBsN6fo87YcGibv7/JgVR5AcaIZ7V5PhMq
         AuICR4Qh9b3nd4+Odmrs09Lv0TrebnvXnBVNd7MYWDLhXEwUeINxFpzBHtJGuNq8a8
         zQ1tb0XVR1Bu9KiKdR2MjjH73PFDRGjNIzgqSfcVO9t0LTLYYEDlbDNNgNmF/wPj0r
         L3J/FmTzCbpvw==
Date:   Thu, 25 Mar 2021 21:21:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent
 error tag enabled
Message-ID: <20210326042117.GS4090233@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-14-chandanrlinux@gmail.com>
 <20210322185413.GH1670408@magnolia>
 <877dlyqw0k.fsf@garuda>
 <8735wir242.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735wir242.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 09:35:33AM +0530, Chandan Babu R wrote:
> On 23 Mar 2021 at 10:58, Chandan Babu R wrote:
> > On 23 Mar 2021 at 00:24, Darrick J. Wong wrote:
> >> On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
> >>> This commit adds a stress test that executes fsstress with
> >>> bmap_alloc_minlen_extent error tag enabled.
> >>
> >> Continuing along the theme of watching the magic smoke come out when dir
> >> block size > fs block size, I also observed the following assertion when
> >> running this test:
> 
> Apart from "xfs_dir2_shrink_inode only calls xfs_bunmapi once" bug, I
> noticed that scrub has detected metadata inconsistency,
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 debian-guest 5.12.0-rc4-chandan #30 SMP Thu Mar 25 11:00:08 IST 2021
> MKFS_OPTIONS  -- -f -b size=1k -m rmapbt=0,reflink=0 -n size=64k /dev/vdc2
> MOUNT_OPTIONS -- /dev/vdc2 /mnt/scratch
> 
> xfs/538 43s ... _check_xfs_filesystem: filesystem on /dev/vdc2 failed scrub
> (see /root/repos/xfstests-dev/results//xfs/538.full for details)
> 
> Ran: xfs/538
> Failures: xfs/538
> Failed 1 of 1 tests
> 
> I will work on fixing this one as well.

Yeah, I noticed that too.  There are two bugs -- the first one is that
the "Block directories only have a single block at offset 0" check in
xchk_directory_blocks is wrong -- they can have a single *dir* block at
offset 0.  The correct check is (I think):

	if (is_block && got.br_startoff >= args.geo->fsbcount) {
		xchk_fblock_set_corrupt(...);
		break;
	}

The second problem is ... somewhere in the bmbt scrubber.  It looks like
there's a file with a data fork in btree format; the data fork has a
single child block; and there are few enough key/ptrs in that child
block that it /could/ fit in the root.  For some reason the btree code
didn't promote it, however.  Seeing as nobody's touched that code
lately, that probably means that scrub is wrong, but OTOH that /does/
seem like a waste of a block.

But, that's as far as I've gotten on that second one and it's late.
Thanks for taking a look! :)

--D

> -- 
> chandan
