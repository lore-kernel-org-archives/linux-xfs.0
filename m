Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4D3C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA99120735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q9Hq8Yzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEIQeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:34:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgEIQeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:34:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVrm196495;
        Sat, 9 May 2020 16:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Fdf52R4FgDG8+87NbjhQUrm6qxcxC2rdXAbHCCmuCDI=;
 b=q9Hq8YzfII5rbdtb+1XNYbcWCkKUxEAAT5X1/llbvOHYyjH+jrOKzU6p6jjKO7LCYzs/
 Ngkb+IvRbXuJKR6B2k2U0liK/h3NM9ZDmFlR9boU3nMjsQ17ag70awBJIf+aem8OqSX+
 FkV6J3FnrtvMbrOIaWuRODehaH/NzmF7ld9gvA/PY5T9+E9lIV800TF3kv4slq+WdIXh
 JkiWeAfYkwlFXrkcR5qjP/M/dhNTb8c3XDbwMYxVXwaLmdfqk4LgThD7fxY0GhW91Ped
 rbi3AB1+WnY4P8tB0ENodUq5Xh7A+Yf+yPXUCnAoukTMiSLhzMMV4EtraSUXFC6X75xR ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30wmfm157k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:34:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GWUNc117316;
        Sat, 9 May 2020 16:32:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wwwpnk5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GVWgU020810;
        Sat, 9 May 2020 16:31:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:32 -0700
Subject: [PATCH 15/16] xfs_repair: complain about extents in unknown state
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:32 -0700
Message-ID: <158904189253.982941.5576924652917825655.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=2 malwarescore=0 mlxlogscore=996 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During phase 4, if we find any extents that are unaccounted for, report
the entire extent, not just the first block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index a43413c7..191b4842 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -315,8 +315,8 @@ phase4(xfs_mount_t *mp)
 			case XR_E_BAD_STATE:
 			default:
 				do_warn(
-				_("unknown block state, ag %d, block %d\n"),
-					i, j);
+				_("unknown block state, ag %d, blocks %u-%u\n"),
+					i, j, j + blen - 1);
 				/* fall through .. */
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:

