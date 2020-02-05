Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0558C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B84F921927
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UhwepY8j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgBEAEV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:04:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBEAEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:04:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01503g7A080388;
        Wed, 5 Feb 2020 00:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=+fXfrXH0hYJPF/ShhkWHNS8Izk9UBD75zgcIU72zAS8=;
 b=UhwepY8jCG0jzCk8wx2h++/z20B/VtA4J/Ur//3kxKZ3ArCNMvKMCAJGwMbX98lKbJJr
 +0WfZAwMpELfSz8WFiivFKDuqi/p6IPbZyn97WbKAodNqs6eLPXS1N/p6i1/yBdnsqtI
 u7A2pTRSzeR8ikgLoFTneC+p+OYvOssvM9X5wFsuLOdMrJA/CPt1Ga9UZvGJjJrF+3NH
 3v0adnlkEgNxmvV3/r8E9XSUPTOwdp7YIl+/AwTpv5nSYi6vkRxXZjfFOCUk2xnO+h48
 K/Lyji7UpOyEOzTcT6vTh286D9kWwNwa1gIOSnz7JRqAapqbc5CCvfw0+R6cPZZsQEEt VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xyhkfg8hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:04:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwHev071690;
        Wed, 5 Feb 2020 00:02:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xyhmev5ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:18 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01502IIY022717;
        Wed, 5 Feb 2020 00:02:18 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:18 -0800
Subject: [PATCH 0/1] xfs: test xfs_scrub media scan
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:17 -0800
Message-ID: <158086093704.1990427.12233429264118879844.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Simple tests of the xfs_scrub media verifier that uses dm-error to
simulate disk errors and ensure that the reporting is accurate.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-media-error-reporting
