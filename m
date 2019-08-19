Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB20CC3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 16:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC1E92070B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 16:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wi2AF9IS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfHSQrp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:47:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60024 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfHSQrp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 12:47:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JGiWlT076784
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 16:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=IbmFQJhqyoruh+gMmww2CZ+kHY29RVl7DxsPM/M6xPY=;
 b=Wi2AF9ISSfYbOvD62JF6tslZOlGVMoiq0g1pEE1Qu7fIr4t3VNnJbSh2OLGZd01f1SrO
 6bqna+QrKtKobLM1W8HcaxcPk4DbtwYRj4uXFW8HeHpYl3aBXHQu/m1vDGC9GJIRTkHP
 kqQfhR0IGZdhAOOm+6jFxweuKYSoLP13lYjsFaAn91OAjTDYTBeaQQwk3czPiBIUEy0M
 IzjH67CWGgZvlYxt7oLIRgdQ0v/RIPXAVMVwrsrLDCilUSyuxUF+vJUu097tdfAtU3jr
 bR5kdhCXj80ou/h6L0Ww8D6dkOnR11FYpNIpMElekS/p1sXCD4fbgvXcp/KyjWecI31v IA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90t8tqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 16:47:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JGiT11117841
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 16:47:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ufwgc4pdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 16:47:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7JGlgt4010774
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 16:47:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 09:47:42 -0700
Date:   Mon, 19 Aug 2019 09:47:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5d888b481e6a
Message-ID: <20190819164741.GA1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190177
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

5d888b481e6a xfs: fix reflink source file racing with directio writes

New Commits:

Christoph Hellwig (2):
      [314e01a6d7dd] xfs: fall back to native ioctls for unhandled compat ones
      [4529e6d7a6ab] xfs: compat_ioctl: use compat_ptr()

Darrick J. Wong (2):
      [edc58dd0123b] vfs: fix page locking deadlocks when deduping files
      [5d888b481e6a] xfs: fix reflink source file racing with directio writes


Code Diffstat:

 fs/read_write.c      | 49 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ioctl32.c | 56 +++-------------------------------------------
 fs/xfs/xfs_reflink.c | 63 ++++++++++++++++++++++++++++++----------------------
 3 files changed, 81 insertions(+), 87 deletions(-)
