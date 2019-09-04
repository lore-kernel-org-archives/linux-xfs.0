Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D672DC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE3E022CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DUeimlzW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfIDEh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDEh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aUPH040438;
        Wed, 4 Sep 2019 04:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TZ/nr00KxUvyUvY2Gx6ZLubYK8APHkzshAY5ZuYdA9M=;
 b=DUeimlzWnrhr5qalsi76GQxBf8tGQ/4MYnwrz2H8xJUKeXBVCxlRwgVTjpiFCom5vsQH
 O+vE2uE32WlLjoCqcrUdynmSIEpvyfnD7KgsO6kg2lxu5eGEhBOECf4aUnlI4hqNVJrK
 5YWIb6/L9PbUNsqqDRTHMXFfHgDJjp36gqLR2cKRiPrWyFghDMND4iKc+UN1AYbIpnVW
 pi08Gc2bVa+bbYi5t7s+O7xPp+uc+kA4mCPLG2zlk2fCeb8+9eO8uBq+NB/fitDcxm7Y
 oVq1x7lgLlfI/I7m5Rk1p2Gga9mgsB2ajNg7mFfFRp5CU4jLNpnsfyP0Q01g7DZmi9B2 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut6d1r07w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XEhq055491;
        Wed, 4 Sep 2019 04:34:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2us5phmrde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:34:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844Yjf4029682;
        Wed, 4 Sep 2019 04:34:45 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:34:45 -0700
Subject: [PATCH v3 0/8] libxfrog: wrap version ioctl calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:34:43 -0700
Message-ID: <156757168368.1836891.15043200811666785244.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series introduces into libfrog some wrapper functions for the XFS
geometry, bulkstat, and inumbers ioctls, then converts the tools to use
the new wrappers.  This is intended to smooth the transition to the new
v5 ioctls that were introduced in kernel 5.3 by providing standard
fallback code to the old ioctls on old kernels.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libfrog-refactor
