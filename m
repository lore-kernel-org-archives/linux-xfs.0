Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FB1C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62B2E22D6D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D0rJeaQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHTUVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:21:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTUVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:21:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKJREl158453;
        Tue, 20 Aug 2019 20:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=JWSsNiMqbfth2CA2CEGIDEUk9LPYb02ZmrIlFr0lpAY=;
 b=D0rJeaQuyCzmWDmhQFeen05isrRMpAAOG36VLwDA/8ZHINdEScSWe9OWewgbJFc+lqVQ
 X0LbiKFDd1/U7taHZeKXk7EwiK359q+loG+GbOCYbVq7F5KD5GESHAYLmfWCpDk3XvZf
 dBm5vAuIYN2zyn6xXVI91pfA3ESjwp2Kj8mBD5XmGfLjxEQNsj/6XrNP4zwf4pY9IW8I
 81eCcnHXjQyB2WjdxNYYvOGXmgjPMV9KflZRydi+R4WTUywyGPVqnwz+j47W2u5M+/0K
 CYwoXVyDUQ5/Qln5nnJzlKcfKfkw8orPSO9WtPK4S1VNttfFnXjVfQqxBOhm1oi83jN1 FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7qrxbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIaRn134947;
        Tue, 20 Aug 2019 20:21:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ug1g9ra3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:20 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKLJSd028566;
        Tue, 20 Aug 2019 20:21:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:21:19 -0700
Subject: [PATCH 0/1] xfsdump: clean up typedef usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:21:18 -0700
Message-ID: <156633247851.1207676.6729479783498588132.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=551
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=614 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series removes old xfs typedef usage from xfsdump.  No functional
changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
