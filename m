Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FD9C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D013721721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfH3FpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:45:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33857 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbfH3FpD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:45:03 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6BE2F43F1C0;
        Fri, 30 Aug 2019 15:45:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3ZiV-0003rC-NI; Fri, 30 Aug 2019 15:44:59 +1000
Date:   Fri, 30 Aug 2019 15:44:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] man: document the new v5 fs geometry ioctl
 structures
Message-ID: <20190830054459.GF1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633309613.1215978.13281783388020912868.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633309613.1215978.13281783388020912868.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=Xpwlrd5vp8h4VoAwVxMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:31:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Amend the fs geometry ioctl documentation to cover the new v5 structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libfrog/fsgeom.c                   |    4 ++++
>  man/man2/ioctl_xfs_fsop_geometry.2 |    8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 06e4e663..159738c5 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -88,6 +88,10 @@ xfrog_geometry(
>  	if (!ret)
>  		return 0;
>  
> +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V4, fsgeo);
> +	if (!ret)
> +		return 0;
> +
>  	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
>  }

This hunk is in the previous patch.

>  
> diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
> index 68e3387d..365bda8b 100644
> --- a/man/man2/ioctl_xfs_fsop_geometry.2
> +++ b/man/man2/ioctl_xfs_fsop_geometry.2
> @@ -12,6 +12,8 @@ ioctl_xfs_fsop_geometry \- report XFS filesystem layout and features
>  .PP
>  .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geom*" arg );
>  .br
> +.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
> +.br
>  .BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
>  .SH DESCRIPTION
>  Report the details of an XFS filesystem layout, features, and other descriptive items.
> @@ -43,6 +45,9 @@ struct xfs_fsop_geom {
>  	/* struct xfs_fsop_geom_v1 stops here. */
>  
>  	__u32         logsunit;
> +	/* struct xfs_fsop_geom_v4 stops here. */
> +
> +	__u64         reserved[18];
>  };
>  .fi
>  .in

And this looks like a stray, too.

The man page changes look fine, though :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
