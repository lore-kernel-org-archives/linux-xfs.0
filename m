Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E9BC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A1E206A1
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fCnffGxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgKISRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:39 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55560 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKISRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IAMoU121308;
        Mon, 9 Nov 2020 18:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=87d0l/cKuFEfAqt7tJNl3N7zcHPEHzbnh0rM1/oiGNs=;
 b=fCnffGxwTt4egDRtcYe3/eNF98zVrOdfukGMLWjLGYRMm3DbrFcGA9LA9XNv70cT1rcY
 CsK4aKs8bMhPtFZ52qQyCeKksFL5mSV1Moigo0TG5wm/RpZjcMvVfBoMEFy4LgpoMW9h
 ij2LYH5pbDqoT68znRr994Pt37rCOyHsSQMLk2osb2X/LQYsgKFaISBQSQvJW6F80FcL
 /DODSN1snFWGf3E7FcusODiWdHYAFZAW3esfscUyaaVEpGJuxNICRZC6QJyOUI9D60y4
 bOu+RVVIfKuLlsVgb9oXTZwMz4SWmDZbpeJslqNyx3p5t0n7AOg78EHRuz2EpMhEIKR0 MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3aqn96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IAnmu157227;
        Mon, 9 Nov 2020 18:17:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5fy1hgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:35 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IHYQo027175;
        Mon, 9 Nov 2020 18:17:34 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:33 -0800
Subject: [PATCH 0/4] xfs: fix various scrub problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:33 -0800
Message-ID: <160494585293.772802.13326482733013279072.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While continuing my assessment of the online fsck code, I observed
various other minor problems in the online scrub code.  The most serious
of the bugs involves the extent reference count checker, which
incorrectly counts the number of rmaps it loads into the shared-extent
record stack, and results in scrub being unable to detect off-by-one
errors in the reference count.

The three patches after that tighten the checking around the mininum
number of records in a btree block; flags for rmap records; and
validating that a null entry in the leaf bestfree block actually
correspond to a hole in the directory data segment.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fixes-5.10
---
 fs/xfs/scrub/bmap.c     |    8 ++++----
 fs/xfs/scrub/btree.c    |   45 +++++++++++++++++++++++++++------------------
 fs/xfs/scrub/dir.c      |   27 ++++++++++++++++++++-------
 fs/xfs/scrub/refcount.c |    8 +++-----
 4 files changed, 54 insertions(+), 34 deletions(-)

