Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095BFC4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1AB320791
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qRfZK+Ec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIWQb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:31:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:31:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGSi45034691;
        Wed, 23 Sep 2020 16:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AcuBmEp/lCORT2FLlgYysslJEuWHljnU/dCmd+MJJuo=;
 b=qRfZK+Ec8j2UdSfhU4QKKY/lVIsMkI8fd7EuwufXdFf504lG5VXv2cGnKlqAVi/6Xaka
 mLJ1g1p8OCkR24kjsPHh+2ZqxGFYgnPg6qMYcZXdVaRPuaCkWfPV8QssUiBBrPNEGKIp
 ljfqPGY4aL2cCuUZOlpyHLl4mAT5bWt6YzI8pSomUsqFKwnEUfVGZcGeaCCBgtWWTvS4
 2XQ9t0DYXs1uZw/eZC17S7UH3Rz1Ex8MrvzxobVt9zZ3EuDcfB9iCVO5P7a/qb4IpEP0
 wCpVA7E/QYlACvSF5UHM0UsrsLsa3u3v5zvNolN/75WWraS6orli/j8BA4zrkscBQFge 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnukky9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:30:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGKNm5031341;
        Wed, 23 Sep 2020 16:28:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33nujpt2mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:28:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NGStom025508;
        Wed, 23 Sep 2020 16:28:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:28:54 -0700
Date:   Wed, 23 Sep 2020 09:28:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v3 0/7] xfs: random fixes and code cleanup
Message-ID: <20200923162853.GR7955@magnolia>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=3 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 02:59:11PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Hi all,
> 
> This patchset include random fixes and code cleanups, and there are no
> connections among these patches. In order to make it easier to track,
> I bundle them up and put all the scattered patches into a single patchset.
> 
> Changes for v3:
>  -move the log intent/intent-done items detection helpers
>   to xfs_trans.h.
>  -fix the overly long line.
> 

Applied, thanks.

--D

> Changes for v2: 
>  -detect intent-done items by their item ops.
>  -update the commit messages.
>  -code cleanup for xfs_attr_leaf_entsize_{remote,local}.
> 
> Kaixu Xia (7):
>   xfs: remove the unused SYNCHRONIZE macro
>   xfs: use the existing type definition for di_projid
>   xfs: remove the unnecessary xfs_dqid_t type cast
>   xfs: do the assert for all the log done items in xfs_trans_cancel
>   xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
>   xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
>   xfs: fix some comments
> 
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 --
>  fs/xfs/libxfs/xfs_da_format.h   | 12 ++++++------
>  fs/xfs/libxfs/xfs_inode_buf.h   |  2 +-
>  fs/xfs/xfs_dquot.c              |  4 ++--
>  fs/xfs/xfs_linux.h              |  1 -
>  fs/xfs/xfs_log_recover.c        |  7 -------
>  fs/xfs/xfs_qm.c                 |  2 +-
>  fs/xfs/xfs_trans.c              |  2 +-
>  fs/xfs/xfs_trans.h              | 16 ++++++++++++++++
>  9 files changed, 27 insertions(+), 21 deletions(-)
> 
> -- 
> 2.20.0
> 
