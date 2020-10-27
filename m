Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869BFC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CBE021D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P6Wbh/FD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444475AbgJ0TCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410146AbgJ0TCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIt3Yf108039;
        Tue, 27 Oct 2020 19:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tTDd1rLWZY7euiQu4y0gxwc0ULrd9rOjVu7TkA1ceJI=;
 b=P6Wbh/FDSFBTe2tFetEieXLoKQw1P6rzNSNk+zZjAg1TYAx3XsdKjZI5ZBNtxAEQz0uF
 CgWzAO1Im4vqIDdL3oV3Sgo3/tw1UCvl2yDdtghdV35KFTAq+1GJBnVQ5uJjCpVqSLHV
 Im8NbICjX5ac3aDTe3SSYcQ4xfk4iAShh0vmmKPjVFPquHrGOOuAlECDolngQ8DbsmI8
 qctgFv+fPL7deYxZ/WtCoav5/TWKi3BoMsHT6Jjlr/j5Z5A0V2w0koHmOVAjDOOayvlv
 uN/rfHlG4KMLDJHpZwAY36jLIYTnwPhY81sYNakHe/qqkFMv2ro1mQvHdI2FoWgAVnlu kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kuurj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2V2132924;
        Tue, 27 Oct 2020 19:02:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5xg85v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2G6e001115;
        Tue, 27 Oct 2020 19:02:16 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:15 -0700
Subject: [PATCH 7/9] xfs/030: hide the btree levels check errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:15 -0700
Message-ID: <160382533506.1202316.2655281450906651514.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Newer versions of xfsprogs now complain if the rmap and refcount btree
levels are insane, so hide that error from the golden output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/repair |    1 +
 tests/xfs/030 |    1 +
 2 files changed, 2 insertions(+)


diff --git a/common/repair b/common/repair
index 6668dd51..0ae7464e 100644
--- a/common/repair
+++ b/common/repair
@@ -45,6 +45,7 @@ s/(bad length -{0,1}\d+ for ag. 0, should be) (\d+)/\1 LENGTH/;
 s/(bad length # -{0,1}\d+ for ag. 0, should be) (\d+)/\1 LENGTH/;
 s/(bad agbno) (\d+)/\1 AGBNO/g;
 s/(max =) (\d+)/\1 MAX/g;
+s/(bad levels) (\d+) (for [a-z]* root, agno) (\d+)/\1 LEVELS \3 AGNO/;
 # for root inos
 s/(on inode) (\d+)/\1 INO/g;
 s/(imap claims a free inode) (\d+)/\1 INO/;
diff --git a/tests/xfs/030 b/tests/xfs/030
index b6590913..04440f9c 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -45,6 +45,7 @@ _check_ag()
 			    -e '/^agf has bad CRC/d' \
 			    -e '/^agi has bad CRC/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
+			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'
 	done
 }

