Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3848ACA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011682190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kVS7CTNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfKCWXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:23:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfKCWXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:23:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MLMmB084444
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=dJZn+N9c3zvM3u3NtrXscKJiyGDXjxhRm36dVpX2iyg=;
 b=kVS7CTNNRhiN4MiLGnAox8sEJGIfapTOnwm151G+6KlL6MwU+tsw6FT/igRtCzVvPYY1
 vwGyKqqrLEiEQO79pbaVQjltpbHSTJt83m4HIy6m/ZRJOOVwkxsde5aTTMImUXNeCDfp
 NoS7+BaXOg7CF4sMnOCiUuWcgQENOwbrchzHw1IkSnpY4nfDEzafTqEr/5eR1RL/qFfR
 8cB+mpIe880+Xar/NGpmzQgr0SrxkYZzLou6kBWMjOGmTG8X144A8Ix4z2Y8m3neRhgd
 WVzo5x5l0PI75veJUE5DKc9pH59c4NB5mtXPdqdjWwJc78EiB6O/ws2WDJ8zSJTujy9v Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tm5xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:23:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MNKMq072792
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w1k8tmsc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:23:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MNjgE016138
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:23:44 -0800
Subject: [PATCH 0/3] xfs: tidy up corruption reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:23:43 -0800
Message-ID: <157281982341.4150947.10288936972373805803.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=991
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030233
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Linus requested that I audit the XFS code base to make sure that we
always log something to dmesg when returning EFSCORRUPTED or EFSBADCRC
to userspace.  These patches are the results of that audit.

The first three patches start by refactoring a few helper methods so
that in the third patch we always report something to dmesg whenever we
decide to return EFSCORRUPTED.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-corruption
