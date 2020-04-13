Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E33C2BA19
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 15:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F7F2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 15:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iex3hC/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgDMPlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 11:41:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbgDMPlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 11:41:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DFchdA156478;
        Mon, 13 Apr 2020 15:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YKvaG0DE+1nXR7zCQMvhonVBIR5cyKnjUknSFmbJBlo=;
 b=Iex3hC/zGEReR5Mn1UMH10jLCnPDQU6lMfEJXcHwwpKFgV6hjktCNIM8RUExjAi/ytC6
 8m6eUjIgJN5mBm5RXnEsv3znoTokcKNNR1J+sZWuUuMBSfV4S/lC57acf2cI1+Rg0kWP
 Km6VJ40tQNVx6FWz0hdA9vl8KzDqgWcJ/1xUbYxRJBe/ks+F7ZcS2SNq82NtTJmYHACM
 ZiHfbZ1Onka2HTz4z54ABfQCwWL3mc/sRHbOp4kJ2lWLNW5Dee6tE1NnvIrMZS+zjFgO
 PSE5Z4W9f2P69CICAxqqDYZPYIaq/obiCfJlJr6P9Nir/WCj9S9o0+9FGDeEhY81Eh3a 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30b5aqy89g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 15:39:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DFc0ht041546;
        Mon, 13 Apr 2020 15:39:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30bqpca5kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 15:39:54 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DFdp4V010172;
        Mon, 13 Apr 2020 15:39:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 08:39:51 -0700
Date:   Mon, 13 Apr 2020 08:39:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 0/6] xfs: some bugfixes and code cleanups for quota
Message-ID: <20200413153950.GR6742@magnolia>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=1 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 11, 2020 at 05:12:52PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Hi all,
> 
> This patchset include some bugfixes and code cleanups for
> qupta.

The series looks ok to me; thanks for bundling this up. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Changes for v2:
>  - put all the scattered patches into a single patchset.
>  - update the git version to fix the no function show problem.
> 
> Kaixu Xia (6):
>   xfs: trace quota allocations for all quota types
>   xfs: combine two if statements with same condition
>   xfs: reserve quota inode transaction space only when needed
>   xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
>   xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
>   xfs: simplify the flags setting in xfs_qm_scall_quotaon
> 
>  fs/xfs/xfs_ioctl.c       | 7 ++-----
>  fs/xfs/xfs_iops.c        | 5 -----
>  fs/xfs/xfs_qm.c          | 7 +++----
>  fs/xfs/xfs_qm_syscalls.c | 6 +++---
>  4 files changed, 8 insertions(+), 17 deletions(-)
> 
> -- 
> 2.20.0
> 
