Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9590BCA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 18:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BD8120740
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 18:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="asCv7EQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgELSdl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 14:33:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELSdk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 14:33:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIX4tx072733;
        Tue, 12 May 2020 18:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=V2XVUnM2qYVH5SrxtNDj/C2J2WydHTQr3Vlu/4Fa18s=;
 b=asCv7EQa3fKLyJliodmoEFwNU7w+Al2A8NZwk4QI6xgJOPHYPV+8+u7ADwkbryr8JML6
 spn2FcBCKl9wY0rxLeLUYLR8Rpfb21EBNA8uzejUQoK9WK1IZqwSRIzMH2IJ8n+OjtrM
 +dSt5tlJjF7K5PH5SVOh0ijw7GtKEhq9PVNxS8rEHlQsnhkolTilBvyOhjJ8jCWUvb33
 63gGxLRT3CQClhvB1ajOfGNR6FfmkkFV6gvyOaEYY3FmOO8ANYLsxX6dA6dofXVaeZC6
 7BxKE7oG4p0qIll/9DRR4tIflySFEIyeRSHWukm2XJNqvrVfyu/u6m7aqMqOzi8Q9Ue5 xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwg2k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 18:33:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIWVwS154225;
        Tue, 12 May 2020 18:33:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3100yn9dqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 18:33:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CIXaL7010613;
        Tue, 12 May 2020 18:33:36 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 11:33:36 -0700
Subject: [PATCH 0/2] xfs_repair: check quota counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 May 2020 11:33:34 -0700
Message-ID: <158930841417.1920396.3792994124679376951.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

One of the larger gaps between xfs_check and xfs_repair is that repair
doesn't have the ability to check quota counters against the filesystem
contents.  This series adds that checking ability to repair pass7, which
should suffice to drop xfs_check in fstests.  It also means that repair
no longer forces a quotacheck on the next mount even if the quota counts
were correct.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck
