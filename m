Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEA0C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5093F215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EWEyJQzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCKAsM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:48:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAsL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:48:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0e1j2086455
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ejn0JqOX2YqEmv8uOMm6P7v7Uo3hEojZq+IwLL3a4Jk=;
 b=EWEyJQzZcRrQS+czjsMK37y9X11Pg/8cUmRW0RfcZFjVDsMqCpTrjUfWFlqWLp75RQC6
 9o1yuXqMbm+HqPUFPDT0dcjamWsXwFq8XUxKKrVSQDhRcoMxymqVZIlQsmxtSPwqrMiN
 qJoYRkX133NY0x4COr1ZwiCT5yeJpZ+ZNssZBJIeDzoSgkDpj+To0EUlACoQx8dzDDYS
 vnvTAUrqso/l6Nm17xO/7u49FnkMmyYU2+dH5nyM7SPXqXoP4h7BPNmG2YuFCLndAmql
 iKombQIGu7AFsHCjsJCTwdwssHQVhWXhbWGTp0sU9nY+PUNv3OUgj4aTcklOtakfeII+ lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v63sd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0m9fx102872
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yp8pv5fw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0m8V2010182
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:48:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:48:08 -0700
Subject: [PATCH 1/3] xfs: mark dir corrupt when lookup-by-hash fails
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:48:07 -0700
Message-ID: <158388768745.939608.14435846701438875494.stgit@magnolia>
In-Reply-To: <158388768123.939608.12366470947594416375.stgit@magnolia>
References: <158388768123.939608.12366470947594416375.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=793 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=851
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_dir_actor, we attempt to validate the directory hash structures
by performing a directory entry lookup by (hashed) name.  If the lookup
returns ENOENT, that means that the hash information is corrupt.  The
_process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 266da4e4bde6..ef7cc8e101ab 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -155,6 +155,9 @@ xchk_dir_actor(
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	/* ENOENT means the hash lookup failed and the dir is corrupt */
+	if (error == -ENOENT)
+		error = -EFSCORRUPTED;
 	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;

