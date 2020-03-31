Return-Path: <SRS0=FhJw=5Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02DBC2D0EE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 22:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABCA208E0
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 22:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbgCaWN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 18:13:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54175 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731255AbgCaWN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 18:13:27 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 89CFF7EA612;
        Wed,  1 Apr 2020 09:13:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jJP8O-00058z-H4; Wed, 01 Apr 2020 09:13:24 +1100
Date:   Wed, 1 Apr 2020 09:13:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Qian Cai <cai@lca.pw>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: xfs metadata corruption since 30 March
Message-ID: <20200331221324.GZ10776@dread.disaster.area>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=7DPh_joMaso9liLfkDcA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 31, 2020 at 05:57:24PM -0400, Qian Cai wrote:
> Ever since two days ago, linux-next starts to trigger xfs metadata corruption
> during compilation workloads on both powerpc and arm64,

Is this on an existing filesystem, or a new filesystem?

> I suspect it could be one of those commits,
> 
> https://lore.kernel.org/linux-xfs/20200328182533.GM29339@magnolia/
> 
> Especially, those commits that would mark corruption more aggressively?
> 
>       [8d57c21600a5] xfs: add a function to deal with corrupt buffers post-verifiers
>       [e83cf875d67a] xfs: xfs_buf_corruption_error should take __this_address
>       [ce99494c9699] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
>       [1cb5deb5bc09] xfs: don't ever return a stale pointer from __xfs_dir3_free_read
>       [6fb5aac73310] xfs: check owner of dir3 free blocks
>       [a10c21ed5d52] xfs: check owner of dir3 data blocks
>       [1b2c1a63b678] xfs: check owner of dir3 blocks
>       [2e107cf869ee] xfs: mark dir corrupt when lookup-by-hash fails
>       [806d3909a57e] xfs: mark extended attr corrupt when lookup-by-hash fails

Doubt it - they only add extra detection code and these:

> [29331.182313][  T665] XFS (dm-2): Metadata corruption detected at xfs_inode_buf_verify+0x2b8/0x350 [xfs], xfs_inode block 0xa9b97900 xfs_inode_buf_verify
> xfs_inode_buf_verify at fs/xfs/libxfs/xfs_inode_buf.c:101
> [29331.182373][  T665] XFS (dm-2): Unmount and run xfs_repair
> [29331.182386][  T665] XFS (dm-2): First 128 bytes of corrupted metadata buffer:
> [29331.182402][  T665] 00000000: 2f 2a 20 53 50 44 58 2d 4c 69 63 65 6e 73 65 2d  /* SPDX-License-
> [29331.182426][  T665] 00000010: 49 64 65 6e 74 69 66 69 65 72 3a 20 47 50 4c 2d  Identifier: GPL-

Would get caught by the existing  verifiers as they aren't valid
metadata at all.

Basically, you are getting file data where there should be inode
metadata. First thing to do is fix the existing corruptions with
xfs_repair - please post the entire output so we can see what was
corruption and what it fixed.

Then if the problem is still reproducable, I suspect you are going
to have to bisect it. i.e. run test, get corruption, mark bisect
bad, run xfs_repair or mkfs to fix mess, install new kernel, run
test again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
