Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138F3C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D7221848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jbYgLTGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfJIQtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:49:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731416AbfJIQtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:49:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjfnn003589
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dfBMulgGiXetD3+vyjJft3SGyfo4qvKQmEw1t1I9mfU=;
 b=jbYgLTGUCyB4wJRXVzRdivzJwhEswYX/1dJd7v+M2CtZ9M8hf10I+8dCQDhwBVOV9OQj
 ORV4zTFXWUPCCW0McpKNrCsUYfSr5VYvDQ+Lk/6ZrQQRr5+BSipbQYYjyFdgiDYTR8TT
 u0gv4251Faq+MANaAC9l7KXBFwDlNWLhuNoe7gvVxgAry4MbxVVgpzjQKSpnNMYgSdsX
 3P1C/mvw+0k35Q7mq4PPvD2pqkETHeq9DpQ9Oxm9ZjNErjhHPyP/olYTGcEG9sHTQkKn
 jo/sIm1LEpQWZYzECXOWTYhV+9XgRUPltvfZyRNG4dEFb6RvUW9U2YsFOgtSMkWsqbZV tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qnyv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZRL174362
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vhhsmx1dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GneAL016501
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:40 -0700
Subject: [PATCH 1/2] xfs: add a repair revalidation function pointer
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:39 -0700
Message-ID: <157063977906.2913625.11610063964985485066.stgit@magnolia>
In-Reply-To: <157063977277.2913625.2221058732448775822.stgit@magnolia>
References: <157063977277.2913625.2221058732448775822.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow repair functions to set a separate function pointer to validate
the metadata that they've rebuilt.  This prevents us from exiting from a
repair function that rebuilds both A and B without checking that both A
and B can pass a scrub test.  We'll need this for the free space and
inode btree repair strategies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |    5 ++++-
 fs/xfs/scrub/scrub.h |    8 ++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 15c8c5f3f688..0f0b64d7164b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -495,7 +495,10 @@ xfs_scrub_metadata(
 		goto out_teardown;
 
 	/* Scrub for errors. */
-	error = sc.ops->scrub(&sc);
+	if ((sc.flags & XREP_ALREADY_FIXED) && sc.ops->repair_eval != NULL)
+		error = sc.ops->repair_eval(&sc);
+	else
+		error = sc.ops->scrub(&sc);
 	if (!(sc.flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
 		/*
 		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ad1ceb44a628..94a30637a127 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -27,6 +27,14 @@ struct xchk_meta_ops {
 	/* Repair or optimize the metadata. */
 	int		(*repair)(struct xfs_scrub *);
 
+	/*
+	 * Re-scrub the metadata we repaired, in case there's extra work that
+	 * we need to do to check our repair work.  If this is NULL, we'll use
+	 * the ->scrub function pointer, assuming that the regular scrub is
+	 * sufficient.
+	 */
+	int		(*repair_eval)(struct xfs_scrub *sc);
+
 	/* Decide if we even have this piece of metadata. */
 	bool		(*has)(struct xfs_sb *);
 

