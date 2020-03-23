Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6806C1975A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 03:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DDE32073E
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 03:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qYS2PxG6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgCWD2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:28:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWD2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Mar 2020 23:28:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02N3SAdL109073;
        Mon, 23 Mar 2020 03:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C3HCibalQ2QQqKaarND9UVrPOwFJ5hM19yIxqwBkFFM=;
 b=qYS2PxG6H+qPD3jW7ECNUCp4KV6+X9bTYvGD6Gf9aclwyIm3CQrvKyEI8upeUAcJ/rGc
 MUzJPO2rT3v67njE1RHzKjbYwh3h7GJQk5fpckmHPm9vKIcvCnobrPYt9fQyTunf1BJy
 l3zgYYXkHjEHDXZcqrqF55cEoDfazkf5Ux4K/CmgrUmRQFYlJZHBzK1qaw2uUt8Smi7Q
 QY+sJjrvMbskUoH55YrWxzoUG+s9SOq6dOU7LkFXKpfB94K95IgnIvbMv67A3UZEo3un
 ySItKT6abGpW61jAR6/Kz2WNQcCTt9ECWBMNbrHiXR9e/QyVxDpuF96+kyvNXh3cMCz2 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8abs7q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 03:28:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02N3RWsa123957;
        Mon, 23 Mar 2020 03:28:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ywvdb635j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 03:28:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02N3S9bV025827;
        Mon, 23 Mar 2020 03:28:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 20:28:09 -0700
Date:   Sun, 22 Mar 2020 20:28:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
Message-ID: <20200323032809.GA29339@magnolia>
References: <20200320210317.1071747-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320210317.1071747-1-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=688 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=753
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 10:03:13PM +0100, Pavel Reichl wrote:
> Remove some wrappers that we have in XFS around the read-write semaphore
> locks.
> 
> The goal of this cleanup is to remove mrlock_t structure and its mr*()
> wrapper functions and replace it with native rw_semaphore type and its
> native calls.

Hmmm, there's something funny about this patchset that causes my fstests
vm to explode with isilocked assertions everywhere... I'll look more
tomorrow (it's still the weekend here) but figured I should tell you
sooner than later.

--D

> Pavel Reichl (4):
>   xfs: Refactor xfs_isilocked()
>   xfs: clean up whitespace in xfs_isilocked() calls
>   xfs: xfs_isilocked() can only check a single lock type
>   xfs: replace mrlock_t with rw_semaphores
> 
>  fs/xfs/libxfs/xfs_bmap.c |   8 +--
>  fs/xfs/mrlock.h          |  78 -----------------------------
>  fs/xfs/xfs_file.c        |   3 +-
>  fs/xfs/xfs_inode.c       | 104 ++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_inode.h       |  25 ++++++----
>  fs/xfs/xfs_iops.c        |   4 +-
>  fs/xfs/xfs_linux.h       |   2 +-
>  fs/xfs/xfs_qm.c          |   2 +-
>  fs/xfs/xfs_super.c       |   6 +--
>  9 files changed, 98 insertions(+), 134 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> -- 
> 2.25.1
> 
