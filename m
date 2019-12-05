Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7B4C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF89524249
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KboZhs9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfLERR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:17:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLERR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 12:17:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5HDvms194549
        for <linux-xfs@vger.kernel.org>; Thu, 5 Dec 2019 17:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=6TvbV4TzBfDwbDMnOhYYiQ6uVDDJwQt29kMtHfriq9Q=;
 b=KboZhs9YqIh3irCg7XRthFAWoLco8mlLzszt61Ju2VGLkojc03f3UwJ45jL2nii7yUfR
 yR5fX3AQl9+Ac12tnZHUasjQ02JJWmRGZsbiOk00KtaNKFSsBHc3mOTtWCLEjOT9Evh7
 2jaUlNalK0aI0ZAz12cdV5/WzYfo05FqoKt+pKvv4JZ3czJxgg2FX6FW4LAlk12T+WH+
 1jV95qjUGUfe22Kquy0Qrx4IJVIG8xzBB/7afHtKsRNysewYrxDPGlWRPDlAKQTgo1sN
 6wlxZWs5tycPVuEYV58JM/nsLTuzg8Qps93QUNVXC8xQalWrkbHXepnhrTTcoYZO9prw LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuupry1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2019 17:17:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5HDknB046535
        for <linux-xfs@vger.kernel.org>; Thu, 5 Dec 2019 17:15:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wpp74fj7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2019 17:15:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB5HFrms023574
        for <linux-xfs@vger.kernel.org>; Thu, 5 Dec 2019 17:15:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 09:15:53 -0800
Date:   Thu, 5 Dec 2019 09:15:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 798a9cada469
Message-ID: <20191205171552.GD13260@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912050145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912050145
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

798a9cada469 xfs: fix mount failure crash on invalid iclog memory access

New Commits:

Brian Foster (1):
      [798a9cada469] xfs: fix mount failure crash on invalid iclog memory access

Omar Sandoval (2):
      [0c4da70c83d4] xfs: fix realtime file data space leak
      [69ffe5960df1] xfs: don't check for AG deadlock for realtime files in bunmapi


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c | 27 +++++++++++++++------------
 fs/xfs/xfs_log.c         |  2 ++
 2 files changed, 17 insertions(+), 12 deletions(-)
