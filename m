Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C23CC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6241A21852
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ovQnNEsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfIPQYc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:24:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbfIPQYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 12:24:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGE1B1169498;
        Mon, 16 Sep 2019 16:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=k9NcswRbpkEx65WdmZMOY+HhJ+vYsf6dCnkcouzvq40=;
 b=ovQnNEsFt44SdJs3DB2o6vMhz7eEId5eozrTD8cVdJ6+13ynDmW7uYg/pfuvlcpRgb2R
 Iljn92GpNSUzditbkqAT+S1axQ8lsLlW/bYwxJO+c2OsWqwPIhY1IAClhxxepSvnPIhb
 tFLGOS+JV5U6IKA4WdAjUywLzAC27ACLgnnNh3LgNw3eAMr8WDvrqwa4rAEZ7q7Z/Bq+
 6Vo1pvy3/pVKMCmGJrLaGg+yNJlbo+cD4qWd0A1hkvP1v7EYam79beQqeSM+CtX45KeC
 wNqFWfYH9sbLdz9oFvQs+k6qsb48I8NRurXJiSVPHP7qN5pN0oH4rovVLNaz4wibe7om hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v2bx2rvdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:24:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGCvaJ083355;
        Mon, 16 Sep 2019 16:24:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v0qhprrds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:24:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GGOAwx032288;
        Mon, 16 Sep 2019 16:24:10 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 09:24:09 -0700
Date:   Mon, 16 Sep 2019 09:24:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     sandeen@redhat.com, billodo@redhat.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] xfs: include QUOTA, FATAL ASSERT build options in
 XFS_BUILD_OPTIONS
Message-ID: <20190916162406.GY2229799@magnolia>
References: <1567751206-128735-1-git-send-email-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567751206-128735-1-git-send-email-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 02:26:46PM +0800, yu kuai wrote:
> In commit d03a2f1b9fa8 ("xfs: include WARN, REPAIR build options in
> XFS_BUILD_OPTIONS"), Eric pointed out that the XFS_BUILD_OPTIONS string,
> shown at module init time and in modinfo output, does not currently
> include all available build options. So, he added in CONFIG_XFS_WARN and
> CONFIG_XFS_REPAIR. However, this is not enough, add in CONFIG_XFS_QUOTA
> and CONFIG_XFS_ASSERT_FATAL. 
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_super.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 763e43d..b552cf6 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -11,9 +11,11 @@
>  #ifdef CONFIG_XFS_QUOTA
>  extern int xfs_qm_init(void);
>  extern void xfs_qm_exit(void);
> +# define XFS_QUOTA_STRING	"quota, "
>  #else
>  # define xfs_qm_init()	(0)
>  # define xfs_qm_exit()	do { } while (0)
> +# define XFS_QUOTA_STRING
>  #endif
>  
>  #ifdef CONFIG_XFS_POSIX_ACL
> @@ -50,6 +52,12 @@ extern void xfs_qm_exit(void);
>  # define XFS_WARN_STRING
>  #endif
>  
> +#ifdef CONFIG_XFS_ASSERT_FATAL
> +# define XFS_ASSERT_FATAL_STRING	"fatal assert, "

/me wonders if the space here will screw up any scripts that try to
parse the logging string, but OTOH that seems pretty questionable to me.

Also, whatever happened to adding a sysfs file so that scripts (ok let's
be honest, xfstests) could programmatically figure out the capabilities
of the running xfs module?

--D

> +#else
> +# define XFS_ASSERT_FATAL_STRING
> +#endif
> +
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -63,6 +71,8 @@ extern void xfs_qm_exit(void);
>  				XFS_SCRUB_STRING \
>  				XFS_REPAIR_STRING \
>  				XFS_WARN_STRING \
> +				XFS_QUOTA_STRING \
> +				XFS_ASSERT_FATAL_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> -- 
> 2.7.4
> 
