Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618D0C2BBD5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2680823A79
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbgLRHaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58104 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732889AbgLRHaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7K4sr122338
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dG6AOM+chetuBZIFc8pMd/fBoO3g52XeNvqJn2yQCDw=;
 b=SL8+1tkat1u326vlps5f2O0Pv+kpr7zWhooFHGuKftmJZ5+od/Ka59LT9nkXEDCp2gJZ
 u4Jg9xIeZIAtMHO0vQKdT7jDcRj83J9kmoI4Bp5kmCZijvonqU++OWU1wiA7WcqBPTZP
 DKiOeZMa0Ts59CnoZc8UQDdhhEGUz/20dmyfc+aY/3zM5kbdfGtuYaOEepMu3hjy2L6L
 d9jDHweEGRl0VWiwlEMorC+WQq1aEBfrgL9jKOYJVj+YgBujW/3Dr2eIJ4DC2ZBk1yM/
 pDbeLukYROo6GQFDU5vDYUt2BkvcFDcfy6eszWBKpklZrZ16K0CN24iUAQ2Ylmz2Zy2j bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntmgyak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LLkB044447
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7eryv1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7TO1w022280
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:24 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:24 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 08/15] xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
Date:   Fri, 18 Dec 2020 00:29:10 -0700
Message-Id: <20201218072917.16805-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Because xattrs can be over a page in size, we need to handle possible
krealloc errors to avoid warnings

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f3130..295a5c6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
+	if (ptr == NULL)
+		return -ENOMEM;
+
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
-- 
2.7.4

