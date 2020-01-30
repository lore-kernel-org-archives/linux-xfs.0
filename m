Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE93C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC7620658
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFAa7Iia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgA3SPB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:15:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgA3SPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:15:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIDoiV126000;
        Thu, 30 Jan 2020 18:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ae5dFRCzp00v23Dfkj30VaCoRhZLGY92LypEbvdj6xo=;
 b=VFAa7IiaXRtpV7+AbJt2sJEqqL5w+6ESs0S0EyKt8VOknR2Rwk4OXECEODc0vUsfShBN
 f40jUgf8YCo3K3xXJdmoEmKlde5N043HUV84z6g2R16xjgPwe+veV3yc4E6tKcZE1KoK
 Y5x3GhT1nqWpndVwvReWH66nMVLWjfJ+O7pKxJMP5TOlDF+lp0J7wqesE5fJmgZBPPpl
 RU0AjkXylKNmUmhFumlPGfqazoom3ZHzYEBl5PLrySJxvRICFoQKOyg9GayrZYjKHiI3
 LUTPfqH9VXg0xqTSQXYXTaRp15pribgu0ay0VnIzmoeoZNpRI1xKhIdRGEA+7+rnK3Ut qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xrd3unvn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:14:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIEWPe105850;
        Thu, 30 Jan 2020 18:14:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xuc30k88m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:14:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00UIDVed010922;
        Thu, 30 Jan 2020 18:13:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 10:13:31 -0800
Date:   Thu, 30 Jan 2020 10:13:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/8] libxfs: remove duplicate attr function declarations
Message-ID: <20200130181330.GY3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove these function declarations since they're in libxfs/xfs_attr.h
and are therefore redundant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_priv.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 03edf0d3..fe08f96b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -607,14 +607,6 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 }
 
 /* Keep static checkers quiet about nonstatic functions by exporting */
-int xfs_inode_hasattr(struct xfs_inode *ip);
-int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-                unsigned char **value, int *valuelenp, int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-                 unsigned char *value, int valuelen, int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
-
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
