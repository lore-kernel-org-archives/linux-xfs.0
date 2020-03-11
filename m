Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88397C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442A1215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yywRgLzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCKAsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:48:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAsR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:48:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0fbpF112420
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Aqz/1rUF1W88AxKw5Dw6zpvZcxgBBLX6fXoQ0owaC4k=;
 b=yywRgLzuz+F7rjbAy45X5SVLUM1p0TPDfEx2cpRCPeEzATAEeb15jGFjTNiLjgqxdmKQ
 a53RqkKAjjV97Pf94wD5b3Wn4oDtrQ1cYWq1v2XCkZFjh4yIN8IlbZKe9s0oA3WlFaYA
 HHoQTRtfL78H1BxOx7iGbAIXzu88lwd9anMOTSo63lfWXMXUNIRJPE2vp+qr438RCioj
 KKr8jg0fJ+iG38/NWt9CUEgAze2BcGxki5KLItsXVpGvUb1z9aC666OWzLPULqWV5wXe
 GX6ICrJhq8pwCjt1wC65oe9a/wOIN27ke0wYYBcOiFPxy8Wxv8XP8tAgSWplYO5Lw8Bi sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31ugq6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0lngL029343
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yp8rnncy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:16 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0mFSA010198
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:48:14 -0700
Subject: [PATCH 2/3] xfs: mark extended attr corrupt when lookup-by-hash
 fails
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:48:13 -0700
Message-ID: <158388769356.939608.4585090255151116523.stgit@magnolia>
In-Reply-To: <158388768123.939608.12366470947594416375.stgit@magnolia>
References: <158388768123.939608.12366470947594416375.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=810 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=867 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_xattr_listent, we attempt to validate the extended attribute
hash structures by performing a attr lookup by (hashed) name.  If the
lookup returns ENODATA, that means that the hash information is corrupt.
The _process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..941c09bafb35 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -163,6 +163,9 @@ xchk_xattr_listent(
 	args.valuelen = valuelen;
 
 	error = xfs_attr_get_ilocked(context->dp, &args);
+	/* ENODATA means the hash lookup failed and the attr is bad */
+	if (error == -ENODATA)
+		error = -EFSCORRUPTED;
 	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
 			&error))
 		goto fail_xref;

