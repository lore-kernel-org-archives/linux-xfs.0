Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B43BCA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47DA32190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JpcS8qvY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfKCWYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfKCWYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOlT4073306
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=IjEAmKlMGFuMeXKqymVgtNjQsj+j2MQ/o9xGyEqfBkA=;
 b=JpcS8qvY32dBlX1n++KfT+3144+FDof84xRqM45gD6sk644aByDkrbPOXvAJi4kW/9VR
 2IbyrYtTjNoiWS/GlsVcIDBsvVlVVhY/jCGyO4uEWhZbtZb/UlHaSiFj0H9O5kCgOpOR
 Vc2kuezme2IUPomXzA1vEJ5SsCX2wmeR3g8VveCovpwVDh1iHDy58y2mVFH6scHyCKvM
 WeQ2cK9sxG4wJNU1jKMfWI72ugH+DmKiRBxbCx7WVieF8pqNLUEFZTTNH2sgt1+U3AmG
 Ed1wjbnsgcDE3l8gPWmHgsvK49BWTPQ8kER9oY1hPEUBFJwrEG+3Skb7WoLRev1aJp34 kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpm48b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOA6c071491
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w1ka8e70s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:47 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MOkn9032224
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 22:24:46 +0000
Subject: [PATCH 00/10] xfs: report corruption to the health trackers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:45 -0800
Message-ID: <157281988489.4152102.1632857939932700344.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=638
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=715 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In a previous series we performed a lot of cleanups to the metadata
corruption detection code in XFS.  Now add the ability to report these
problems to the health tracking system so that administrators can gather
reports on live filesystems, and (in the future) to enable more targeted
scanning of metadata.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
