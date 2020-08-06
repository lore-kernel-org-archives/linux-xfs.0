Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC8DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25E822D06
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jx8yPjar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHFTdz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:33:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgHFTdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 15:33:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076FDKla152834;
        Thu, 6 Aug 2020 15:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1AolOzPIOMQfffxKB/08KHsr7Q43v8tlBZ0VC1SgVt0=;
 b=Jx8yPjarhGqYqBChfic+cjx/BI/ITyQWMId9lGoivE/0I7swJiFhYUNxa0WEUbMWt/v/
 Z1S3CkmvxQWeVAElcXL9Jsf42P34si+clZMrb87bA7oVBZVJ/3vg5EgocSfzkryra2gP
 Ai+jJhSR0TPgOudRPLlGaNPI8EsjO51252JYAntus0KSTK5GANtYIt0yHqx2tmU4reYY
 QrJq4G8+gM1/Y7yh02eMb3tqIPlFwhqGb3N7tvfZhI3p0l7XNDCz1kRurw2w8N8aOybY
 wxKcCdKOEIRPQxXmdmask8dYuICptSbXEbvifLmlSmILL6EqzYqEJKknDX8CBRxt2gjD kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32r6gwukgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 15:15:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076FD0oh121832;
        Thu, 6 Aug 2020 15:13:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32pdnwmrks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 15:13:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076FDWUG023250;
        Thu, 6 Aug 2020 15:13:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 08:13:32 -0700
Date:   Thu, 6 Aug 2020 08:13:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eiichi Tsukata <devel@etsukata.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
Message-ID: <20200806151331.GD6107@magnolia>
References: <20200806150527.2283029-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806150527.2283029-1-devel@etsukata.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 clxscore=1011 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 07, 2020 at 12:05:27AM +0900, Eiichi Tsukata wrote:
> If xfs_sysfs_init is called with parent_kobj == NULL, UBSAN
> shows the following warning:

This needs to be sent to the xfs mailing list, per get_maintainers.pl.

--D

>   UBSAN: null-ptr-deref in ./fs/xfs/xfs_sysfs.h:37:23
>   member access within null pointer of type 'struct xfs_kobj'
>   Call Trace:
>    dump_stack+0x10e/0x195
>    ubsan_type_mismatch_common+0x241/0x280
>    __ubsan_handle_type_mismatch_v1+0x32/0x40
>    init_xfs_fs+0x12b/0x28f
>    do_one_initcall+0xdd/0x1d0
>    do_initcall_level+0x151/0x1b6
>    do_initcalls+0x50/0x8f
>    do_basic_setup+0x29/0x2b
>    kernel_init_freeable+0x19f/0x20b
>    kernel_init+0x11/0x1e0
>    ret_from_fork+0x22/0x30
> 
> Fix it by checking parent_kobj before the code accesses its member.
> 
> Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
> ---
>  fs/xfs/xfs_sysfs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> index e9f810fc6731..aad67dc4ab5b 100644
> --- a/fs/xfs/xfs_sysfs.h
> +++ b/fs/xfs/xfs_sysfs.h
> @@ -32,9 +32,9 @@ xfs_sysfs_init(
>  	struct xfs_kobj		*parent_kobj,
>  	const char		*name)
>  {
> +	struct kobject *parent = parent_kobj ? &parent_kobj->kobject : NULL;
>  	init_completion(&kobj->complete);
> -	return kobject_init_and_add(&kobj->kobject, ktype,
> -				    &parent_kobj->kobject, "%s", name);
> +	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
>  }
>  
>  static inline void
> -- 
> 2.26.2
> 
