Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68982C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3810B208CB
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfH3Fxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:53:52 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38067 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbfH3Fxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:53:52 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 84F1243E734;
        Fri, 30 Aug 2019 15:53:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Zr1-0003sM-No; Fri, 30 Aug 2019 15:53:47 +1000
Date:   Fri, 30 Aug 2019 15:53:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] man: document the new allocation group geometry
 ioctl
Message-ID: <20190830055347.GH1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633310832.1215978.10494838202211430225.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633310832.1215978.10494838202211430225.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=wgbTJw98zncoFVSZEW4A:9
        a=52F5GSg9kLhhqdzO:21 a=D3X0CihU_UGg4pSe:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:31:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Document the new ioctl to describe an allocation group's geometry.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_ag_geometry.2 |   74 ++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3                |    6 +++
>  2 files changed, 80 insertions(+)
>  create mode 100644 man/man2/ioctl_xfs_ag_geometry.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_ag_geometry.2 b/man/man2/ioctl_xfs_ag_geometry.2
> new file mode 100644
> index 00000000..5dfe0d08
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_ag_geometry.2
> @@ -0,0 +1,74 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-AG-GEOMETRY 2 2019-04-11 "XFS"
> +.SH NAME
> +ioctl_xfs_ag_geometry \- query XFS allocation group geometry information
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_AG_GEOMETRY, struct xfs_ag_geometry *" arg );
> +.SH DESCRIPTION
> +This XFS ioctl retrieves the geometry information for a given allocation group.
> +The geometry information is conveyed in a structure of the following form:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_ag_geometry {
> +	uint32_t  ag_number;
> +	uint32_t  ag_length;
> +	uint32_t  ag_freeblks;
> +	uint32_t  ag_icount;
> +	uint32_t  ag_ifree;
> +	uint32_t  ag_sick;
> +	uint32_t  ag_checked;
> +	uint32_t  ag_reserved32;
> +	uint64_t  ag_reserved[12];

Where's the flags field for feature versioning? Please don't tell me
we merged an ioctl structure without a flags or version field in
it...

> +};
> +.fi
> +.in
> +.TP
> +.I ag_number
> +The number of allocation group that the caller wishes to learn about.

"the index of"....

"The number of" is easily confused with a quantity....

Is this an input or an output?

> +.TP
> +.I ag_length
> +Length of the allocation group, in units of filesystem blocks.

The length of the AG is returned in this field, in units....

Same for the rest...

> +.TP
> +.I ag_freeblks
> +Number of free blocks in the allocation group, in units of filesystem blocks.
> +.TP
> +.I ag_icount
> +Number of inode records allocated in this allocation group.
> +.TP
> +.I ag_ifree
> +Number of unused inode records (of the space allocated) in this allocation
> +group.
> +.TP
> +.IR ag_reserved " and " ag_reserved32
> +Will be set to zero.

It would be better to say "all reserved feilds will be set to zero
on return" so that we don't have to change this every time we rev
the structure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
