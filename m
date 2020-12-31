Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918A9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64005206E4
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLaWnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60712 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgLaWnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMctX5143531
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P3q/WAuazD6/PP+2NMkEeLKfRywFFYH8hFkeHceY0uA=;
 b=v5HHEPvD0+riz4xl+HKk4N+XSZuKc+RA2w1ThEx+yFSck72+KpGIQ+B0Cf3vlOKN/5d0
 zB8qcaQBKNB6xu9EzHCf/zgJ1MWZxql1hlabqR6rZ4lojTLu8LbcYd3WxLxwEZY0MkMr
 8vp1/HkE8TjRrIDngtdmMm03ITJHRgmLiBne2iT+X8gWVLlYfEBRwb6GF4XYIQnTObrA
 6q7SUIf3GUMPP7gVy70FiaFlXgm1TP4lqa+1bJukBZBSNPNqGTi+ULD9QUPiogxaAjWF
 4N6Vyy/VNrRgzs49yXAUuVQreNJFE4VPZhwiyWdun/0mM6cgdU9Bec2Fu+3xIzPXx3hV gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35phm1jt1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe7b4015210
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35perpncxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMggEr017957
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:42 -0800
Subject: [PATCHSET v2 0/3] xfs: rework online repair incore bitmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:41 -0800
Message-ID: <160945456154.2828537.13019290713470028201.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we make some changes to the incore bitmap code: First,
we shorten the prefix to 'xbitmap'.  Then, we rework some utility
functions for later use by online repair and clarify how the walk
functions are supposed to be used.

Finally, we use all these new pieces to convert the incore bitmap to use
an interval tree instead of linked lists.  This lifts the limitation
that callers had to be careful not to set a range that was already set;
and gets us ready for the btree rebuilder functions needing to be able
to set bits in a bitmap and generate maximal contiguous extents for the
set ranges.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-bitmap-rework
---
 fs/xfs/scrub/agheader_repair.c |   77 +++++----
 fs/xfs/scrub/bitmap.c          |  348 +++++++++++++++++++++++-----------------
 fs/xfs/scrub/bitmap.h          |   35 ++--
 fs/xfs/scrub/repair.c          |   60 ++++---
 4 files changed, 297 insertions(+), 223 deletions(-)

