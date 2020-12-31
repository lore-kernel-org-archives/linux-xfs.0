Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17022C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0CF62076E
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgLaWtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:49:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgLaWtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:49:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMietH147315;
        Thu, 31 Dec 2020 22:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CnbPPDQpyBfv0SJeHYsqdedPcUMOCsgalffWdlVa3AM=;
 b=ky8Jv23BbrTxrLlq9dcbI4LKpcoUEnk1CHnaPpANG0eUs0RV5AIZ3yrAlN8tJUln5sVY
 UqBzEVV3WAgvTvWVQWFKOIjTr1oqKOj7fIchYyErUKXzTfXMPDXf0l7cAtR3tQZ2GAIn
 ZUMZme5mK0oYaLfX6Ah7R3xdoN1GFR+FVuKQykxO1iiz2GjILKFL6VziAzrY9ZBrjigu
 29NMZbid5hobI90l3f/3YPl4MvyJwU7/Gj6Gn6Fn9+nEiS6/SnKmhjkVB4f893MoQAkc
 fcOMfFzWQqo5Lnu1XlsVWKKUNc7L2yLokHSWbQoRTh1CnqyQSX6AY/C+X4I+VwHrzKLy dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35phm1jt52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:48:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkH08153960;
        Thu, 31 Dec 2020 22:48:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35pexukuvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:48:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMmNWd020055;
        Thu, 31 Dec 2020 22:48:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:48:23 -0800
Subject: [PATCHSET 00/15] xfstests: improve xfs fuzzing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:48:22 -0800
Message-ID: <160945490209.2837457.7334080041771264256.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a ton of improvements to the XFS fuzzing code in this update.
We start by disabling by default two parts of the fuzz testing that
don't lead to predictable golden output: fuzzing with the 'random' verb,
and fuzzing the 'LSN' field.

Next, we refactor the inner fuzzing loop so that each of the four repair
strategies are broken out into separate functions, as well as the
post-repair attempts to modify the filesystem.

The next five patches after that modify each of the functions that we
split out in the previous patches to make what those functions do much
more clear.  We also revise the strategies a bit so that they more
accurately reflect the intended usage patterns of the repair programs.

Next, we strengthen other parts of the fuzzing -- we make the
post-repair modification exercises a bit more strenuous, add an
evaluation of xfs_check vs. xfs_repair, and make it possible to check
the xfs health reporting system.

Finally, we improve the array handling of the xfs fuzz tests so that we
actually know about array indices as a first class concept, instead of
the current mucking around we do with regular expressions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzzer-improvements
---
 common/fuzzy  |  461 +++++++++++++++++++++++++++++++++++++++++++--------------
 common/xfs    |   38 +++++
 tests/xfs/357 |    2 
 3 files changed, 386 insertions(+), 115 deletions(-)

