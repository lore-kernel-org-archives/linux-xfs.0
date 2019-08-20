Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1829CC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 08:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDED023A63
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 08:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfHTIIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 04:08:52 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38874 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfHTIIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 04:08:52 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9B19B43CE46;
        Tue, 20 Aug 2019 18:08:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzzB8-00047R-16; Tue, 20 Aug 2019 18:07:42 +1000
Date:   Tue, 20 Aug 2019 18:07:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820080741.GE1119@dread.disaster.area>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=JTlLAF_9MGvJ6H0C_tMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 02:45:36PM +0800, kaixuxia wrote:
> On 2019/8/19 23:13, Brian Foster wrote:
> > 	/* error checks before we dirty the transaction */
> > 	if (!target_ip && !spaceres) {
> > 		error = xfs_dir_canenter();
> > 		...
> > 	} else if (S_ISDIR() && !(empty || nlink > 2))
> > 		error = -EEXIST;
> > 		...
> > 	}
> > 
> > 	if (wip) {
> > 		...
> > 		xfs_iunlink_remove();
> > 	}
> > 
> > 	if (!target_ip) {
> > 		xfs_dir_create();
> > 		...
> > 	} else {
> > 		xfs_dir_replace();
> > 		...
> > 	}
> > 
> > ... but that may not be any cleaner..? It could also be done as a
> > followup cleanup patch as well.
> 
> Yep, it is cleaner that making the whole check before the transaction
> becomes dirty, just return the error code if check failed and
> the filesystem is clean.

*nod*

> Dave gave another solution in the other subthread that using
> XFS_DIR3_FT_WHT, it's a bit more work for this bug, include
> refactoring the xfs_rename() and xfs_lookup(), not sure whether
> it's worth the complex changes for this bug.

It's not necessary to fix the bug, but it's somethign we should
be looking to do because it makes whiteout handling a lot more
efficient - it's just dirent modifications at that point, no inodes
are necessary.

This is how I always intended to handle whiteouts - it's just
another thing on the "we need to fix" list....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
