Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F07C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C30020737
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qrrsgOal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgGBPiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:38:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGBPiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:38:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FLdpu070249;
        Thu, 2 Jul 2020 15:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CaD/18FUoAK/V+7VYdyqD0ZFemBs6Gf6YYhpmNvPLRE=;
 b=qrrsgOal0zE0jzj40916Q3I+yRysVpP7QGCsm0Q7O/I52QHSgEOcovoVWGR8wCQ8E6x8
 o3ZST+FJZ5MkStHLy1XbdjCWDgHUO9+5FVfAokVwzYF4FbuZqUn5pKNdKDyDSnweqMqd
 Gy1HTw30LvvBe9LwXexNHud10Kga/eizysqOik2xCZRhBcUfLXJ/3p7tof7Nj7f1i2tJ
 TPlE0YWHg3Mv9YzvbbZxPSzT1+9H1rnqyVvtOFBP1mKhO/fylwQghYsYXMbSAmRcI1Fm
 Um1xKdVB/JWVoQJhK7rDoc/lD4hifmyDHtv9wbwT0AJalQo/Vt5YlHo/NsTk5TxuWdxI Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbydd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:38:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062FN5iZ033209;
        Thu, 2 Jul 2020 15:38:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg19ke1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:38:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 062Fc2Rb009708;
        Thu, 2 Jul 2020 15:38:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:38:02 +0000
Date:   Thu, 2 Jul 2020 08:38:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove useless definitions in xfs_linux.h
Message-ID: <20200702153801.GC7606@magnolia>
References: <1593011328-10258-1-git-send-email-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593011328-10258-1-git-send-email-laoar.shao@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 11:08:48AM -0400, Yafang Shao wrote:
> Remove current_pid(), current_test_flags() and
> current_clear_flags_nested(), because they are useless.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Looks ok, will put in tree...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_linux.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 9f70d2f..ab737fe 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -102,12 +102,8 @@
>  #define xfs_cowb_secs		xfs_params.cowb_timer.val
>  
>  #define current_cpu()		(raw_smp_processor_id())
> -#define current_pid()		(current->pid)
> -#define current_test_flags(f)	(current->flags & (f))
>  #define current_set_flags_nested(sp, f)		\
>  		(*(sp) = current->flags, current->flags |= (f))
> -#define current_clear_flags_nested(sp, f)	\
> -		(*(sp) = current->flags, current->flags &= ~(f))
>  #define current_restore_flags_nested(sp, f)	\
>  		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
>  
> -- 
> 1.8.3.1
> 
