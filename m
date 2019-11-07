Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DB2FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE862077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B3WioIZK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbfKGDCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732732AbfKGDCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA730IUB050201;
        Thu, 7 Nov 2019 03:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Hrr18oiVrR1MV8FuibTsPTXSSPAF9jrlODpuXC8DdqA=;
 b=B3WioIZKILbYt/dkTIxW1RcTCCA39hL/6v5vhz7+1SRuu4EoYyzBgk2XGVCp+HoxQIEw
 Dq6vPIdt03nisCzwa2Um4Q933eg+mgLQ/QYWJ5mIdfWc1VioKCknxCgmcsrqTOXMDPV/
 EfU91gz05wasogKZ+j9+5oRgRhMiiNrkeTLAgdKVT3pRd0GZ0vfypS3WdS+Mf8jF5egn
 yOpRcJwaOxy/U9u+aREh0XHuloQ1Pve+zV9xxj/qhud7E+NY1IsUtov6tLy5G0lxReSE
 T8+0mXQzsTamPLt4UYXyFXYzSE6Jdd9bI1r69ssxVj82DkrJqdEDlMsQI8cDy8vY1oQ3 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w130b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:02:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wjI9106583;
        Thu, 7 Nov 2019 03:02:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wg12xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:02:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA732H0Z028718;
        Thu, 7 Nov 2019 03:02:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:17 -0800
Subject: [PATCH 4/4] xfs: convert EIO to EFSCORRUPTED when log contents are
 invalid
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 06 Nov 2019 19:02:15 -0800
Message-ID: <157309573590.45542.17137773028975239453.stgit@magnolia>
In-Reply-To: <157309570855.45542.14663613458519550414.stgit@magnolia>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert EIO to EFSCORRUPTED in the logging code when we can determine
that the log contents are invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |    4 ++--
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_log_recover.c   |   30 +++++++++++++++---------------
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 5 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 26c87fd9ac9f..243e5e0f82a3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,7 +456,7 @@ xfs_bui_recover(
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -490,7 +490,7 @@ xfs_bui_recover(
 		 */
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a6f6acc8fbb7..a05a1074e8f8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -625,7 +625,7 @@ xfs_efi_recover(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7a5d668a9dff..0f2ec16f769d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -466,7 +466,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out;
 		}
 
@@ -1345,7 +1345,7 @@ xlog_find_tail(
 		return error;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -3151,7 +3151,7 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
@@ -3232,12 +3232,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -3264,7 +3264,7 @@ xlog_recover_dquot_pass2(
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -4011,7 +4011,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4059,7 +4059,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4180,7 +4180,7 @@ xlog_recover_add_to_cont_trans(
 		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		xlog_recover_add_item(&trans->r_itemq);
@@ -4236,13 +4236,13 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		/*
@@ -4278,7 +4278,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -4382,7 +4382,7 @@ xlog_recovery_process_trans(
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		break;
 	}
 	if (error || freeit)
@@ -4462,7 +4462,7 @@ xlog_recover_process_ophdr(
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -4472,7 +4472,7 @@ xlog_recover_process_ophdr(
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
 		WARN_ON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 576f59fe370e..d5708d40ad87 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -497,7 +497,7 @@ xfs_cui_recover(
 			 */
 			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 			xfs_cui_release(cuip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1d72e4b3ebf1..02f84d9a511c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -541,7 +541,7 @@ xfs_rui_recover(
 			 */
 			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 			xfs_rui_release(ruip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 

