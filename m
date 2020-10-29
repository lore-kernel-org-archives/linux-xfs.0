Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AA8C4741F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED5320731
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T/StbgDY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ2VeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:34:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52272 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgJ2Vd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:33:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLTJnH143628
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 21:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Iv25StU2s0LPT8dGWridPKc77EZIZKTpR/8Uhol2xg4=;
 b=T/StbgDYCed2qn+HUGxQFp5e003ZWYYM6gx+lyEdEJ/q9NBISHIN7NppxxsXDYhSYf6y
 F0CbuORZB9PQ5fAXZX0mItNRlo9xWwayhRgvj+rkos30QRE6hoWkrByLGOXi5D6ommBD
 wZkcWFhBU1T3lGTJdbCiIc4WErB15oUjl/5gv2pMbw+tLAPXGSwhS69UqQIyo3pcTt1r
 BePtvh19bWwkEc6/3keThnfSr0UdKFfoSH+pn86ZI0n18Thi4kT16BRshAYtX0ifJHxB
 EQfYWlXMqznowqJLjLOoeqiOEUMZnGByaAL6rT8ziyHyweZnUaH/A84QqEGftBS0u6ms LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb7bay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 21:33:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLQB6g114392
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 21:31:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx60ywnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 21:31:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TLVv3a013611
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 21:31:57 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:31:56 -0700
Date:   Thu, 29 Oct 2020 14:31:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 2c334e12f957
Message-ID: <20201029213156.GH1061252@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=7 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=7
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290149
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

The new head of the for-next branch is commit:

2c334e12f957 xfs: set xefi_discard when creating a deferred agfl free log intent item

New Commits:

Darrick J. Wong (1):
      [2c334e12f957] xfs: set xefi_discard when creating a deferred agfl free log intent item


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c | 1 +
 fs/xfs/libxfs/xfs_bmap.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
