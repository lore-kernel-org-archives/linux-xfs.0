Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC9AC3F68F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 04:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4EF520718
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 04:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rHiG/ZkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfLXEnM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:43:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfLXEnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Dec 2019 23:43:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBO4d4jI156994;
        Tue, 24 Dec 2019 04:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=DKi4to1MVZe1YpH9d1l8F7X2EwiMx8YF/f/W0quWnK4=;
 b=rHiG/ZkG6z/fuH4OIfQj3CIy17Q+gIwjhMDqxfnq0htjjWWfq/2Eru7aTJ8UKOTthoL3
 4HF+T9YbDeaEnjE8olPDbjtfAiCJMnfwNhPoO0/YAxtDveTvAXjJu9p8NOEw7oGdjEhW
 xkosjG6yE6Iy8jv55hwWXOW8dlk1GJAQiCbgWrKOvkSv0rNiRxGIlcNfX2E46mgbD+dE
 EbGcgvWJYNWRejqsQJwWkFpkM9QOK4VoqNg3Pmylx+4Q4pLXtWuQZP5Bx9S3pzjQOsLf
 WfC214gv8j0hfQ3mV2RAVPwRs71gZfAGHtkTetZpFYfXfGARdDLryHAxnIUBXrCoDzDS Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x1c1qss6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 04:43:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBO4dA4v003061;
        Tue, 24 Dec 2019 04:41:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x37tdg4qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 04:41:09 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBO4f8nU028193;
        Tue, 24 Dec 2019 04:41:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Dec 2019 20:41:07 -0800
Date:   Mon, 23 Dec 2019 20:41:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCH] fsx: fix range overlap check
Message-ID: <20191224044106.GB7479@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On 32-bit systems, the offsets are 'unsigned long' (32-bit) which means
that we must cast the explicitly to unsigned long long before feeding
them to llabs.  Without the type conversion we fail to sign-extend the
llabs parameter, try to make a copy/clone/dedupe call with overlapping
ranges, and fsx aborts and the test fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 06d08e4e..00001117 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1911,6 +1911,14 @@ read_op(struct log_entry *log_entry)
 	return 0;
 }
 
+static inline bool
+range_overlaps(
+	unsigned long	off0,
+	unsigned long	off1,
+	unsigned long	size)
+{
+	return llabs((unsigned long long)off1 - off0) < size;
+}
 
 int
 test(void)
@@ -1993,7 +2001,7 @@ test(void)
 			offset2 = random();
 			TRIM_OFF(offset2, maxfilelen);
 			offset2 = offset2 & ~(block_size - 1);
-		} while (llabs(offset2 - offset) < size ||
+		} while (range_overlaps(offset, offset2, size) ||
 			 offset2 + size > maxfilelen);
 		break;
 	case OP_DEDUPE_RANGE:
@@ -2011,7 +2019,7 @@ test(void)
 				offset2 = random();
 				TRIM_OFF(offset2, file_size);
 				offset2 = offset2 & ~(block_size - 1);
-			} while (llabs(offset2 - offset) < size ||
+			} while (range_overlaps(offset, offset2, size) ||
 				 offset2 + size > file_size);
 			break;
 		}
@@ -2024,7 +2032,7 @@ test(void)
 			offset2 = random();
 			TRIM_OFF(offset2, maxfilelen);
 			offset2 -= offset2 % writebdy;
-		} while (llabs(offset2 - offset) < size ||
+		} while (range_overlaps(offset, offset2, size) ||
 			 offset2 + size > maxfilelen);
 		break;
 	}
