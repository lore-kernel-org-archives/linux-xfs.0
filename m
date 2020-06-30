Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B659C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492492068F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UnXLQhBF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgF3RVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:21:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390230AbgF3RVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:21:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHIRZo011618
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 17:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=6RTsiK43eDMR/eZw/0/0Tlb8+G5gN1DtuFiQPdTJtWI=;
 b=UnXLQhBF3AK4CAXVgQU2GWXUwNtYug4vajy1PNmAYDXdwKNHUaC4vT2kaX51hrl3cYBT
 ThfigxM8ChaqYYADt2Qe5vNfIMY8kVXXhDzNahehOefv7SSOlOzSM2MYzHnJ6yQ4i5O8
 ID5uv08PMVrcjpgCbzupUUFOgyAwz2dsUnpFCg1TdulOHTPUkpt4u10Pdl6bIyJp5rSJ
 tboVwGDIoWLzn6LN6/6SVfJky3PxrCweVwys6ORMUblyFD3OCOxd5qpItW2C1yaISOF2
 IqvGgDY5WKT/m5gqf7oUJ9ewxuNa2vYDsrxKO6CG9OI373jl3RnxSW8ftM1UoLt449oX Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1dtr9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 17:21:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHE09i045197
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 17:21:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1x3uhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 17:21:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UHKxgR020039
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 17:21:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:20:59 +0000
Date:   Tue, 30 Jun 2020 10:20:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c7f87f3984cf
Message-ID: <20200630172058.GX7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=7
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=7 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

c7f87f3984cf xfs: fix use-after-free on CIL context on shutdown

New Commits:

Dave Chinner (1):
      [c7f87f3984cf] xfs: fix use-after-free on CIL context on shutdown


Code Diffstat:

 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)
