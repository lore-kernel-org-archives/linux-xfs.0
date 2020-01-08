Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBBDC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D156120705
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:23:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PjnEQeuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgAHEXK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:23:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHEXK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:23:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JL7i035747
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=0oz9By7nK7Gu/oQrqLjXsTZHbIbznmUlti1VPPJ7zVA=;
 b=PjnEQeuUAl6luH4cn5ZCTAMT0peIt1Fw0y0YhvQ56e9PV1NV1cEnGhj46LZx5CluxAYd
 Hrchybgh3RLCthtNVhpM0YUx9/i3zqDb77ECOT046w/ciHEM4yy2GNrI5jQJYLcNrPPO
 JD1vN3mkWgdOJwSrGQbuwMZD0rAzU1UH8JAQF3rweRpmWdsigkmmVMqFLmzFI26WDk8B
 lmZdwWpavIHOLR2hpkLAS+ccbJkDTcZ219hEGf3fhV0V57XAI72Wz+ptRCAx29NBzrlM
 6ol142dNicKRkx6TYKjnAiPdm2tK6WuLHvmVhRuxNbzYwGzzOpm9v854zNFmfNaNLmaa jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqscwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:23:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JHtH075716
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:21:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xcjvep60g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:21:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0084L7XJ004489
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:21:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:21:07 -0800
Date:   Tue, 7 Jan 2020 20:21:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5a57c05b56b6
Message-ID: <20200108042105.GB5552@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
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
the next update.  Christoph's attr stuff is still going through
xfstests.

The new head of the for-next branch is commit:

5a57c05b56b6 xfs: remove shadow variable in xfs_btree_lshift

New Commits:

Arnd Bergmann (2):
      [3b62f000c86a] xfs: rename compat_time_t to old_time32_t
      [b8a0880a37e2] xfs: quota: move to time64_t interfaces

Eric Sandeen (1):
      [5a57c05b56b6] xfs: remove shadow variable in xfs_btree_lshift


Code Diffstat:

 fs/xfs/libxfs/xfs_btree.c | 2 --
 fs/xfs/xfs_dquot.c        | 6 +++---
 fs/xfs/xfs_ioctl32.c      | 2 +-
 fs/xfs/xfs_ioctl32.h      | 2 +-
 fs/xfs/xfs_qm.h           | 6 +++---
 fs/xfs/xfs_quotaops.c     | 6 +++---
 fs/xfs/xfs_trans_dquot.c  | 8 +++++---
 7 files changed, 16 insertions(+), 16 deletions(-)
