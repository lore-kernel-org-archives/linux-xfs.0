Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE57CC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD022186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qcLLBy9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfHZV3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKg162597;
        Mon, 26 Aug 2019 21:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=DwKfP2NPXWz0TRYb+ZLV4zBBOsPZKHQXhRf2foCp9Gg=;
 b=qcLLBy9LihT3h2oP1wfLIYLiW7VrY41N0r1Ynr/oVCmlyUya/H+aeMFCrb7w8fBtvs/p
 hbw/DpsKFlSjZyTSHeV6lxjfTQrIdoNpqftpZKT1MGrP+e/NRFwviSOtJreII6Xtf66f
 sbDxQjxKnohMxK8vegVyiNeUcl4fT+jhmfy7Cvmk2Z8WilNd0EKNftAEEmAkD4ipOsym
 aZ+XNPtbz/BaIm1kc5u+3CgN179+XpIhysAdIItazpbBfqC0JXMXClACzAuCzOmZ/t7k
 qYOcXeAH0usgqDeSxxhCDphcFMl26y1x83c2yH3zv24Xfc1eaYf8Md+mw5QND9m//56t 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t825b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIII0169921;
        Mon, 26 Aug 2019 21:29:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2umj2787be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTqZe028988;
        Mon, 26 Aug 2019 21:29:52 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:52 -0700
Subject: [PATCH 00/11] xfs_scrub: fix IO error detection during media verify
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:51 -0700
Message-ID: <156685499099.2841898.18430382226915450537.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The existing scrub media scan code (phase 6) has a lot of problems
dealing with errors.  It treats runtime errors (e.g. ENOMEM) as disk
errors, it fails to handle short reads properly, it reports entire
extents as failed when the read returns EIO instead of single-stepping
filesystem blocks to find the bad ones, and there's no good way to test
that it works.

This series fixes each of those problems and adds a couple of debugging
knobs so that we can simulate disk errors and short reads to make sure
that the media scan code actually detects media errors correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-detection
