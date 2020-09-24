Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5C1C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBED9238A1
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GK0unm4Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgIXR1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:27:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgIXR1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:27:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHJmPv007865;
        Thu, 24 Sep 2020 17:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=R7whcWu0FA80AFjaRsamP6ZMAKpsqJYQIJEjihbuE0o=;
 b=GK0unm4YPEAh9RB57UNI1zjiat2DPjoZ8lVmXpTw0z70G1jAr7rvJAlv1O+w7JHPzQcq
 INiSLt1+ieQv5r5MENdvY5DUxjm5wAZE6Zi7TOx6OpE1VCqS45zhRB53XeRdD7NXux79
 tul87Qofm4x+AHZYJsmrk4gmmD3s6h9aTSRx7LxurnfaAcgHfRb/UMLNkRNMFHu1DsC/
 oXuB042L9sm734e/4MYIpw+4zZIzJrxiSzGelLas8KckQrZFgq1IVbBOz/pBkDxRcePd
 eacphwYI2UHPzejk79J1aGijv1jYmBWSbFzm3rnVgJmJYuF8VM4HvghQn48s9fwl96VI Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33qcpu6hwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 17:27:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHQUiq021493;
        Thu, 24 Sep 2020 17:27:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurwfsmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 17:27:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OHRgiJ002864;
        Thu, 24 Sep 2020 17:27:42 GMT
Received: from localhost (/10.159.232.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 10:27:42 -0700
Date:   Thu, 24 Sep 2020 10:27:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove deprecated sysctl options
Message-ID: <20200924172741.GH7955@magnolia>
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924170747.65876-3-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 07:07:47PM +0200, Pavel Reichl wrote:
> These optionr were for Irix compatibility, probably for clustered XFS
> clients in a heterogenous cluster which contained both Irix & Linux
> machines, so that behavior would be consistent. That doesn't exist anymore
> and it's no longer needed.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  Documentation/admin-guide/xfs.rst |  3 ++-
>  fs/xfs/xfs_sysctl.c               | 36 +++++++++++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 413f68efccc0..208e17810459 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -333,7 +333,8 @@ The following sysctls are available for the XFS filesystem:
>  Deprecated Sysctls
>  ==================
>  
> -None at present.
> +fs.xfs.irix_sgid_inherit
> +fs.xfs.irix_symlink_mode

When will these be removed from sysctl?

>  Removed Sysctls
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index 021ef96d0542..fac9de7ee6d0 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -50,13 +50,45 @@ xfs_panic_mask_proc_handler(
>  }
>  #endif /* CONFIG_PROC_FS */
>  
> +STATIC int
> +xfs_deprecate_irix_sgid_inherit_proc_handler(
> +	struct ctl_table	*ctl,
> +	int			write,
> +	void			*buffer,
> +	size_t			*lenp,
> +	loff_t			*ppos)
> +{
> +	if (write) {
> +		printk_once(KERN_WARNING
> +				"XFS: " "%s sysctl option is deprecated.\n",
> +				ctl->procname);
> +	}
> +	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> +}
> +
> +STATIC int
> +xfs_deprecate_irix_symlink_mode_proc_handler(
> +	struct ctl_table	*ctl,
> +	int			write,
> +	void			*buffer,
> +	size_t			*lenp,
> +	loff_t			*ppos)
> +{
> +	if (write) {
> +		printk_once(KERN_WARNING
> +				"XFS: " "%s sysctl option is deprecated.\n",
> +				ctl->procname);
> +	}
> +	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> +}
> +
>  static struct ctl_table xfs_table[] = {
>  	{
>  		.procname	= "irix_sgid_inherit",
>  		.data		= &xfs_params.sgid_inherit.val,

Same comments as the last patch regarding a sysctl that spits out
deprecation warnings but continues to actually change xfs' behavior...

--D

>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> +		.proc_handler	= xfs_deprecate_irix_sgid_inherit_proc_handler,
>  		.extra1		= &xfs_params.sgid_inherit.min,
>  		.extra2		= &xfs_params.sgid_inherit.max
>  	},
> @@ -65,7 +97,7 @@ static struct ctl_table xfs_table[] = {
>  		.data		= &xfs_params.symlink_mode.val,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> +		.proc_handler	= xfs_deprecate_irix_symlink_mode_proc_handler,
>  		.extra1		= &xfs_params.symlink_mode.min,
>  		.extra2		= &xfs_params.symlink_mode.max
>  	},
> -- 
> 2.26.2
> 
