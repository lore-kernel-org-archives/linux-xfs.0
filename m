Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCFAC4363C
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11AE12145D
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KkURcHHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgJHEAm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:00:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgJHEAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:00:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983nuhh143425;
        Thu, 8 Oct 2020 04:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CaHIUi+hl/cri1p4rJsPKlqKt5XpWVzuRGi4YlY0Szw=;
 b=KkURcHHVWW/P2dy2IrnolEu6GD3m1T+c+6m75UHiHBPDxSm41CH+NO24pxlpoXsX5Rzz
 p6xRxrxoHDRpbj+p6nPFVCyeVpTzu6jGbxK8tBAzvqHFKTTcBh/VeXxtuOfPQj7drXxX
 FDwPxGcoM2eu7rn39O7wqgRXj7fwOGhG7TC3ik81mMw1AAeTnZK2ZEbZfXcmInBrlj+O
 lBXOtzfJU9y2oAtLeArRMoMczH6R31CpNfo2bOFSvgPot3QU7Q8oSSgQcVRTSKwn/Ug7
 X+K9mHUhCKV6skEOLKJNHVEFVj2UbBL+Y0AXbnrJBL3LlBtI5vpZkQDC97pceHh+oKU/ IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxn58sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 04:00:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983is0J142483;
        Thu, 8 Oct 2020 03:58:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410k0fheh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:58:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0983wZ3D015641;
        Thu, 8 Oct 2020 03:58:35 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:58:35 -0700
Date:   Wed, 7 Oct 2020 20:58:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libhandle: fix potential unterminated string problem
Message-ID: <20201008035834.GB6535@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

gcc 10.2 complains about the strncpy call here, since it's possible that
the source string is so long that the fspath inside the fdhash structure
will end up without a null terminator.  Work around strncpy braindamage
yet again by forcing the string to be terminated properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
Unless this is supposed to be a memcpy?  But it doesn't look like it.
---
 libhandle/handle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index eb099f43791e..5c1686b3968d 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -107,7 +107,8 @@ path_to_fshandle(
 		}
 
 		fdhp->fsfd = fd;
-		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath));
+		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath) - 1);
+		fdhp->fspath[sizeof(fdhp->fspath) - 1] = 0;
 		memcpy(fdhp->fsh, *fshanp, FSIDSIZE);
 
 		fdhp->fnxt = fdhash_head;
