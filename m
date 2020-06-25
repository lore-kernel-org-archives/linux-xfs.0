Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7342BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E9C20706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DVHFIhMe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388987AbgFYBTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:19:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388928AbgFYBTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:19:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P190w4063568;
        Thu, 25 Jun 2020 01:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mP2ZCt6ovTbTgKz8CH7v6m07Bku5fb2FnOzNYfP4mU0=;
 b=DVHFIhMeHMDXcF861dM8cJVWSX9LPeuzCzgpVwkUb/jkjsQkllYhbXG4x3LW9Uaoi8JQ
 wxtmiDhuTkF++/ClAYYHXvJ42M0q+dvr4+ZnsVTSZb2h7vidcnk4fDwrVqItUZUlqIvR
 k7mN/YAa9KkAx4t+KbBzT+TRwFnWbKxogELGL1njAW5wNn/NEH8gEzdQdqG66Mo/wmff
 AqfcIEeojaUlucFXfmgi+FJ+06wOBOxkEUCn6jbAlOv2J8snY26NAGXcrub7OJP2GBe1
 7JylV3y/lUWe5OS5uK4kCFxlkuNmuK0ylS9aDj+WXBf1TTCZU8BSlISSRJiWjun50U3P Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uustnvvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:19:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P19RUd011535;
        Thu, 25 Jun 2020 01:17:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31uurrnnn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:17:47 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1Hexh009616;
        Thu, 25 Jun 2020 01:17:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:17:40 +0000
Subject: [PATCH v2 0/9] xfs: reflink cleanups
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:17:39 -0700
Message-ID: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a few patches cleaning up some problems with reflink.  The
first patch is the largest -- it reorganizes the remapping loop so that
instead of running one transaction for each extent in the source file
regardless of what's in the destination file, we look at both files to
find the longest extent we can swap in one go, and run a transaction for
just that piece.  This fixes a problem of running out of block
reservation when the filesystem is very fragmented.

The second patch fixes some goofiness in the reflink prep function, and
the third patch moves the "lock two inodes" code into xfs_inode.c since
none of that is related to reflink.

Mr. Torok: Could you try applying these patches to a recent kernel to
see if they fix the fs crash problems you were seeing with duperemove,
please?

v2: various cleanups suggested by Brian Foster

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-cleanups
---
 fs/xfs/libxfs/xfs_bmap.h     |   21 ++-
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 
 fs/xfs/xfs_file.c            |    4 
 fs/xfs/xfs_inode.c           |   93 +++++++++++
 fs/xfs/xfs_inode.h           |    3 
 fs/xfs/xfs_reflink.c         |  352 +++++++++++++++++++-----------------------
 fs/xfs/xfs_reflink.h         |    2 
 fs/xfs/xfs_trace.h           |   52 ------
 8 files changed, 275 insertions(+), 254 deletions(-)

