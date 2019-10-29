Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C16CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED5420659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AKJWdaiC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfJ2Xc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:32:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50552 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:32:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNUwLm011736
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ONcC9dnCES+UIAVaR5qB65oJY6U9lPs6BKWC/TeEqfg=;
 b=AKJWdaiC0my9CUgMGiNebq6Wh+o2r3ZFdNGVrlUPk9hDFVmJcdoDj+/aQwI+Iltn2l8Z
 UgIl6iTjV29XBqkCV6Cpz+3HRADWaA59TkH84HX3gf7i8SFl1eJCFNWYlN/hejX4usko
 y+H1D6ucsx3KQkvQ5QyJBqT1B6JRwEf6hAmmO7zIm3ZjAbl0ELwJ4ZJ2X3/CgPWFNq5y
 Xyp55oYLX1ZzGk9GMDh8OMEbXPHgZ0Jhg1WIiRh/tHzsUx5YV6585uhSzGf+wilbZ5BY
 LU0c1auHVthy2Ue9bdjcnrS7782uA5ByeZpdnIEW8mWEVNuzcasrkp60xRc5VG51jAGK 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhfgb2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:32:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRkKe069154
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vxwhuvey1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNUrnT006955
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:53 -0700
Subject: [PATCH v2 0/5] xfs: rework online repair incore bitmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:52 -0700
Message-ID: <157239185264.1267044.16039786238721573306.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=699
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=781 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
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
