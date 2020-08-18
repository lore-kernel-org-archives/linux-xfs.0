Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DD0C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9564E20738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZM3UuYkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHRNbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbgHRNbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 09:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597757482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=EAkAeg7WXeQriGDxQFsJ4KfcntTE16/7Palg1n0fHEY=;
        b=ZM3UuYkrKcdgE7GWbOkzVYoQiGhxb4fNWFX+8XDbUGcABOXMzrtGY27ivpfYXytRlCdrg/
        LatEDIBHk7edVoMxhrPgda06ybWj7zSPKdxPlsneDN3ZPsH4LN3zENLLb4Yarx217PUDvg
        KA91XSyB0qkQrbyvE8hNLtZrcG7Ftkg=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-q6VAjNmcNP6BDRC1PB02Xg-1; Tue, 18 Aug 2020 09:31:21 -0400
X-MC-Unique: q6VAjNmcNP6BDRC1PB02Xg-1
Received: by mail-pf1-f197.google.com with SMTP id y11so12965419pfq.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EAkAeg7WXeQriGDxQFsJ4KfcntTE16/7Palg1n0fHEY=;
        b=UwdCWQ0xS9fPf/omYrBzS0ZZbuJ7lvga8BW4+fCCfQ4q01s2h80q2S+pUI7wWmy0qo
         CdLRc+yximaQOdTOdTJk4n2HRyHF38O6KcQCLsWHve0CnWQr2Czh1vX7zEedvKtURD1W
         7bkngNYWgV+G1xYrOpPWihw+6xVbPcE5bM+qFRT6atLMdCDIJXr0aK+IR43p2R6QQQI8
         PXWOMXF58Dgw3TbDs0H67yyMasniJhYzmeG53n3pQT2MTI8gfLgpwUWJYTE2XdrwkrgT
         FDNIip+wC/t018+Zs4l0bwjGJZjVsG1Vr/YZWKzANUBDgsoIc+20O/ZIeVAPHsboCLOF
         QDeQ==
X-Gm-Message-State: AOAM531JpnQEENfADuQZhLGmLn4zsIS/Iky9EdwXdzQcmfomTB/eagGq
        56292kF5DymzkPrfjwPgb/kb2EyUCNjXcwN2+UyhiqXsCAZ1qYSdgfPgC+tCZ13OgLt8WNZlPZM
        jCav176rJhhffPNbnblGa
X-Received: by 2002:a62:1a49:: with SMTP id a70mr15771059pfa.297.1597757479618;
        Tue, 18 Aug 2020 06:31:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYuheNfVOsmCA8w/GIVoLiamq9GC47Urw0wPw5+RxtV8r2zwqdaYKfOdcoAeM/Qfmpe8Z+GA==
X-Received: by 2002:a62:1a49:: with SMTP id a70mr15771033pfa.297.1597757479322;
        Tue, 18 Aug 2020 06:31:19 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5sm24563099pfq.146.2020.08.18.06.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 06:31:18 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v4 3/3] xfs: insert unlinked inodes from tail
Date:   Tue, 18 Aug 2020 21:30:15 +0800
Message-Id: <20200818133015.25398-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200818133015.25398-1-hsiangkao@redhat.com>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, AGI buffer is always touched since xfs_iunlink()
adds unlinked inodes from head unconditionally, but since we
have the only one unlinked list now and if we insert unlinked
inodes from tail instead and there're more than 1 inode, AGI
buffer could be untouched.

With this change, it shows that only 938 of 10000 operations
modifies the head of unlinked list with the following workload:
 seq 1 10000 | xargs touch
 find . | xargs -n3 -P100 rm

Note that xfs_iunlink_insert_lock() is slightly different from
xfs_iunlink_remove_lock() due to whiteout path, refer to inlined
comments for more details.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c | 99 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f32a1172b5cd..0add263d21a8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1975,30 +1975,88 @@ xfs_iunlink_update_bucket(
 
 static int
 xfs_iunlink_insert_inode(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*nip;
-	xfs_agino_t		next_agino = NULLAGINO;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 
-	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
-					struct xfs_inode, i_unlink);
-	if (nip) {
+	if (!list_empty(&pag->pag_ici_unlink_list)) {
+		struct xfs_inode	*pip;
 
 		/*
-		 * There is already another inode in the bucket, so point this
-		 * inode to the current head of the list.
+		 * There is already another inode in the bucket, so point
+		 * the last inode to this inode.
 		 */
-		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
-		xfs_iunlink_log(tp, ip, NULLAGINO, next_agino);
+		pip = list_last_entry(&pag->pag_ici_unlink_list,
+				struct xfs_inode, i_unlink);
+		xfs_iunlink_log(tp, pip, NULLAGINO, agino);
+		return 0;
 	}
 
+	ASSERT(agibp);
 	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
+	return xfs_iunlink_update_bucket(tp, agno, agibp, NULLAGINO, agino);
+}
+
+/*
+ * Lock the perag and take AGI lock if agi_unlinked is touched as well
+ * for xfs_iunlink_insert_inode(). As for the details of locking order,
+ * refer to the comments of xfs_iunlink_remove_lock().
+ */
+static struct xfs_perag *
+xfs_iunlink_insert_lock(
+	xfs_agino_t		agno,
+	struct xfs_trans        *tp,
+	struct xfs_inode	*ip,
+	struct xfs_buf		**agibpp)
+{
+	struct xfs_mount        *mp = tp->t_mountp;
+	bool			locked = true;
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(mp, agno);
+	/* paired with smp_store_release() in xfs_iunlink_unlock() */
+	if (smp_load_acquire(&pag->pag_iunlink_trans) == tp) {
+		/*
+		 * if pag_iunlink_trans is the current trans, we're
+		 * in the current process context, so it's safe here.
+		 */
+		ASSERT(mutex_is_locked(&pag->pag_iunlink_mutex));
+		/*
+		 * slightly different from xfs_iunlink_remove_lock(),
+		 * the path of xfs_iunlink_remove() and then xfs_iunlink()
+		 * on the same AG needs to be considered (e.g. whiteout
+		 * rename), so lock AGI first in xfs_iunlink_remove(),
+		 * and recursively get AGI safely below.
+		 */
+		if (!list_empty(&pag->pag_ici_unlink_list))
+			goto out;
+	} else {
+		mutex_lock(&pag->pag_iunlink_mutex);
+		if (!list_empty(&pag->pag_ici_unlink_list))
+			goto out;
+		mutex_unlock(&pag->pag_iunlink_mutex);
+		locked = false;
+	}
+
+	/* and see comments in xfs_iunlink_remove_lock() on locking order */
+	error = xfs_read_agi(mp, tp, agno, agibpp);
+	if (error) {
+		xfs_perag_put(pag);
+		return ERR_PTR(error);
+	}
+
+	if (!locked)
+		mutex_lock(&pag->pag_iunlink_mutex);
+out:
+	WRITE_ONCE(pag->pag_iunlink_trans, tp);
+	++pag->pag_iunlink_refcnt;
+	return pag;
 }
 
 void
@@ -2026,7 +2084,7 @@ xfs_iunlink(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*agibp;
+	struct xfs_buf		*agibp = NULL;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	int			error;
 	struct xfs_perag	*pag;
@@ -2035,18 +2093,9 @@ xfs_iunlink(
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
-
-	/* XXX: will be shortly removed instead in the next commit. */
-	pag = xfs_perag_get(mp, agno);
-	/* paired with smp_store_release() in xfs_iunlink_unlock() */
-	if (smp_load_acquire(&pag->pag_iunlink_trans) != tp)
-		mutex_lock(&pag->pag_iunlink_mutex);
-	WRITE_ONCE(pag->pag_iunlink_trans, tp);
-	++pag->pag_iunlink_refcnt;
+	pag = xfs_iunlink_insert_lock(agno, tp, ip, &agibp);
+	if (IS_ERR(pag))
+		return PTR_ERR(pag);
 
 	/*
 	 * Insert the inode into the on disk unlinked list, and if that
@@ -2054,9 +2103,9 @@ xfs_iunlink(
 	 * order so that the modifications required to the on disk list are not
 	 * impacted by already having this inode in the list.
 	 */
-	error = xfs_iunlink_insert_inode(tp, agibp, ip);
+	error = xfs_iunlink_insert_inode(pag, tp, agibp, ip);
 	if (!error)
-		list_add(&ip->i_unlink, &agibp->b_pag->pag_ici_unlink_list);
+		list_add_tail(&ip->i_unlink, &pag->pag_ici_unlink_list);
 
 	xfs_iunlink_unlock(pag);
 	return error;
-- 
2.18.1

