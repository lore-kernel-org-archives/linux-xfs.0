Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGaLnk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 07:43:40 -0400
Date: Wed, 31 Jul 2019 07:43:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs/122: mask wonky ioctls
Message-ID: <20190731114337.GE34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394160665.1850833.14349327556274532970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394160665.1850833.14349327556274532970.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 23, 2019 at 09:13:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't check the structure size of the inogrp/bstat/fsop_bulkreq
> structures because they're incorrectly padded.  When we remove the
> old typdefs the old filter stops working.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/122 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 89a39a23..64b63cb1 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -148,12 +148,15 @@ xfs_growfs_data_t
>  xfs_growfs_rt_t
>  xfs_bstime_t
>  xfs_bstat_t
> +struct xfs_bstat
>  xfs_fsop_bulkreq_t
> +struct xfs_fsop_bulkreq
>  xfs_icsb_cnts_t
>  xfs_icdinode_t
>  xfs_ictimestamp_t
>  xfs_inobt_rec_incore_t
>  xfs_inogrp_t
> +struct xfs_inogrp
>  xfs_fid2_t
>  xfs_fsop_handlereq_t
>  xfs_fsop_setdm_handlereq_t
> 
