Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A52EC352A4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 01:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C28A20708
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 01:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgBKBPo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 20:15:44 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45031 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgBKBPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 20:15:44 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B0FAC7EB800;
        Tue, 11 Feb 2020 12:15:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j1K9K-0004Rr-QP; Tue, 11 Feb 2020 12:15:38 +1100
Date:   Tue, 11 Feb 2020 12:15:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, renxudong1@huawei.com,
        "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Questions about XFS abnormal img mount test
Message-ID: <20200211011538.GC10776@dread.disaster.area>
References: <ea7db6e3-8a3a-a66d-710c-4854c4e5126c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea7db6e3-8a3a-a66d-710c-4854c4e5126c@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=zAA4-JresYOlhW89uf8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 10, 2020 at 11:02:08AM +0800, zhengbin (A) wrote:
> ### question
> We recently used fuzz(hydra) to test 4.19 stable XFS and automatically generate tmp.img (XFS v5 format, but some metadata is wrong)

So you create impossible situations in the on-disk format, then
recalculate the CRC to make appear valid to the filesystem?

> Test as follows:
> mount tmp.img tmpdir
> cp file tmpdir
> sync  --> stuck
> 
> ### cause analysis
> This is because tmp.img (only 1 AG) has some problems. Using xfs_repair detect information as follows:

Please use at least 2 AGs for your fuzzer images. There's no point
in testing single AG filesystems because:
	a) they are not supported
	b) there is no redundant information in the filesysetm to
	   be able to detect a vast range of potential corruptions.

> agf_freeblks 0, counted 3224 in ag 0
> agf_longest 536874136, counted 3224 in ag 0 
> sb_fdblocks 613, counted 3228

So the AGF verifier is missing these checks:

a) agf_longest < agf_freeblks
b) agf_freeblks < sb_dblocks / sb_agcount
c) agf_freeblks < sb_fdblocks

and probably some other things as well. Can you please add these
checks to xfs_agf_verify() (and any other obvious bounds tests that
are missing) and submit the patch for inclusion?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
