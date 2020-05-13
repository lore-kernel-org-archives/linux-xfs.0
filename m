Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7225C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D361205ED
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akEUMFOK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbgEMRjH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 13:39:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732670AbgEMRjG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 13:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589391543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=npU5axqOkJJCCAF2N/4XQlsj9YAbnHXc/E2AQfjizHU=;
        b=akEUMFOKhUvuW1EvA406cxas6TcsGnBlJevn4jjUUXs8bNDPazEOc5u6dNhssGTWxCVi7P
        +IyWpTCbjHe2enkEGoqRfFm69QBXKBzo4KCXImscZ0Uk52dHRCZO4nkV9UEOg/cO5OEFsI
        D94He/WcjY9KusHLLNmKD09YPNrj7aI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-_3gNKB1eNfeI-lwDFIJZmA-1; Wed, 13 May 2020 13:39:01 -0400
X-MC-Unique: _3gNKB1eNfeI-lwDFIJZmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F31FA1902EB1
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 17:39:00 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB7CC707CC
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 17:39:00 +0000 (UTC)
Subject: [PATCH 2/2 V2] xfs: always return -ENOSPC on project quota
 reservation failure
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <535795f0-6eef-37d0-45de-f268e15a9b9f@redhat.com>
Date:   Wed, 13 May 2020 12:39:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS project quota treats project hierarchies as "mini filesysems" and
so rather than -EDQUOT, the intent is to return -ENOSPC when a quota
reservation fails, but this behavior is not consistent.

The only place we make a decision between -EDQUOT and -ENOSPC
returns based on quota type is in xfs_trans_dqresv().

This behavior is currently controlled by whether or not the
XFS_QMOPT_ENOSPC flag gets passed into the quota reservation.  However,
its use is not consistent; paths such as xfs_create() and xfs_symlink()
don't set the flag, so a reservation failure will return -EDQUOT for
project quota reservation failures rather than -ENOSPC for these sorts
of operations, even for project quota:

# mkdir mnt/project
# xfs_quota -x -c "project -s -p mnt/project 42" mnt
# xfs_quota -x -c 'limit -p isoft=2 ihard=3 42' mnt
# touch mnt/project/file{1,2,3}
touch: cannot touch ‘mnt/project/file3’: Disk quota exceeded

We can make this consistent by not requiring the flag to be set at the
top of the callchain; instead we can simply test whether we are
reserving a project quota with XFS_QM_ISPDQ in xfs_trans_dqresv and if
so, return -ENOSPC for that failure.  This removes the need for the
XFS_QMOPT_ENOSPC altogether and simplifies the code a fair bit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V2: Change title and changelog to clearly reflect the bug and behavior
change, which wasn't really identified as a bug and behavior change until
Brian carefully reviewed V1.  :)

No patch changes.

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b2113b17e53c..56d9dd787e7b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -100,7 +100,6 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
-#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c225691fad15..591779aa2fd0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1808,7 +1808,7 @@ xfs_qm_vop_chown_reserve(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		delblks;
-	unsigned int		blkflags, prjflags = 0;
+	unsigned int		blkflags;
 	struct xfs_dquot	*udq_unres = NULL;
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
@@ -1849,7 +1849,6 @@ xfs_qm_vop_chown_reserve(
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
 	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
-		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
 			ASSERT(ip->i_pdquot);
@@ -1859,8 +1858,7 @@ xfs_qm_vop_chown_reserve(
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1,
-				flags | blkflags | prjflags);
+				ip->i_d.di_nblocks, 1, flags | blkflags);
 	if (error)
 		return error;
 
@@ -1878,8 +1876,7 @@ xfs_qm_vop_chown_reserve(
 		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0,
-			    flags | blkflags | prjflags);
+			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
 			return error;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2c3557a80e69..2c07897a3c37 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -711,7 +711,7 @@ xfs_trans_dqresv(
 
 error_return:
 	xfs_dqunlock(dqp);
-	if (flags & XFS_QMOPT_ENOSPC)
+	if (XFS_QM_ISPDQ(dqp))
 		return -ENOSPC;
 	return -EDQUOT;
 }
@@ -751,15 +751,13 @@ xfs_trans_reserve_quota_bydquots(
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
 		if (error)
 			return error;
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
 		if (error)
 			goto unwind_usr;
 	}
@@ -804,16 +802,12 @@ xfs_trans_reserve_quota_nblks(
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
-	if (XFS_IS_PQUOTA_ON(mp))
-		flags |= XFS_QMOPT_ENOSPC;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_RTBLKS ||
-	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_BLKS);
+	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
+	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
 
 	/*
 	 * Reserve nblks against these dquots, with trans as the mediator.



