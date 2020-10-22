Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A58C388F2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 03:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7F42225D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 03:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zPcVHGpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895503AbgJVDlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 23:41:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895501AbgJVDlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Oct 2020 23:41:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M3SjP3001577
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 03:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=dLag7wwFfzrkC7nlZSmiBoFzkJi7GjtdhFnDdjWjLcc=;
 b=zPcVHGpw5HzdOaqAFgA0jGAXq/z2gksIU1WbkumQM6Hoj/opgR7a7A2bexweLqwrsoBO
 +9H+JiNF46vSoN1KPMF2B1KhQZdX7+QHrvIPuUefZFUhX7PaW/2hyW3jW3TxZuspMkh5
 01M5eeWSVlJ0u1earSORDY15VqbANgHe9/2JqVIKOvl7pjGYzS29woED8jN3DPxeKjV+
 87atjtx7ty0UNZ74et/PDKwVVVWoxZ+ECLRA52eSZr8199ZCu3f3JbXQlQIyvVQCNxj6
 9DYQRzg1tFO4C87uYuyqUeBNOT+lHiHBXrK76ZL3VmRRXJBDQq6jhNum3Nq8pxhLPJUh sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrput1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 03:40:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M3P1j6028046
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 03:40:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348ahya78x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 03:40:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M3even022114
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 03:40:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 20:40:57 -0700
Date:   Wed, 21 Oct 2020 20:40:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 2e76f188fd90
Message-ID: <20201022034056.GB2572850@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220021
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

These are just a couple of fixes for -rc1, nothing special, other than I
noticed that the "fix fallocate functions" patch was calling the wrong
rounding functions (roundup can handle arbitrary divisors, round_up
can't) so I just fixed that on the way in.

The new head of the for-next branch is commit:

2e76f188fd90 xfs: cancel intents immediately if process_intents fails

New Commits:

Darrick J. Wong (2):
      [25219dbfa734] xfs: fix fallocate functions when rtextsize is larger than 1
      [2e76f188fd90] xfs: cancel intents immediately if process_intents fails


Code Diffstat:

 fs/xfs/xfs_bmap_util.c   | 18 +++++-------------
 fs/xfs/xfs_file.c        | 40 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_linux.h       |  6 ++++++
 fs/xfs/xfs_log_recover.c |  8 ++++++++
 4 files changed, 54 insertions(+), 18 deletions(-)
