Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D439C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7970F2166E
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qa5nmNgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgBCR7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728278AbgBCR7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kb1ZKLe1vwyJjKT/TOSZp+t3g+vXgBPuwBJOmIPkxp8=;
        b=Qa5nmNglZt7IDKCplgGy2QJAvW91K0SrIqm+zIiQWVZo4Jg+nYCNVsRrUK9iAlVsvfXyEp
        alsp0jRClEizwkxS+eMW6NAz5TJenLF4eQ2dTdXvbSXE7Nql6lIDyMVjAz8YJ/HX5+2Z61
        JODL2VkM0ZIu3R2Dw751pQhB0O4buks=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-gj8kyoaqNAScHe-dhwMS8Q-1; Mon, 03 Feb 2020 12:59:00 -0500
X-MC-Unique: gj8kyoaqNAScHe-dhwMS8Q-1
Received: by mail-wr1-f70.google.com with SMTP id u8so7667093wrp.10
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:58:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kb1ZKLe1vwyJjKT/TOSZp+t3g+vXgBPuwBJOmIPkxp8=;
        b=W6xIGU/s+qBhqndFIy7562HIvq2d1rtvdeEksOmlv8Aogk2/Z+HiRCn7rca5ZYg1Am
         FNIjxCEK/2kveedzwTI+FKdjiH95mPbxQavlskQZbgS+aDwXppPFesoypfBfjzyP0vz8
         YsBgJvNAQJ3H1dVwH/WuazT9gcYRTT4XLw+k5MM8bFAjJqjIHXjIqOX4IhPIIxs00VBQ
         lIIhIAQSD9uf1/C01JLWEbWMCXpEhFVs7B2364sHMP6Xww24tAdT+u97cIsGkje3kq76
         r1ujbkyx+EWy0q9wRRgP0nLWYLOiR+n8Y2ck+QG2zb7orxDZap6TYllFadQN9LPTMrMy
         eiUA==
X-Gm-Message-State: APjAAAVbfR+9yvrFGoLTZxZvXLTo+iojZVU7bcsZDX0tojQxW7JBdGO5
        EBqatACoWBFkvuXMnIQ8rLmWsfJ3R5E0o+6TL6ChAj7Em8o4dqcpCU55n9ef8GFmsrTHH1YIGvx
        BaqeNF7TvO9pcyfrOLAdT
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr226687wmi.71.1580752738855;
        Mon, 03 Feb 2020 09:58:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxVXX6//tzX7ic1lo9f4H6+QiuVELOF2ibRaypY6n37KJCqLWonHjNDIweqqqP+J3Hf7RNaqQ==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr226661wmi.71.1580752738674;
        Mon, 03 Feb 2020 09:58:58 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:58:58 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 1/7] xfs: Add xfs_is_{i,io,mmap}locked functions
Date:   Mon,  3 Feb 2020 18:58:44 +0100
Message-Id: <20200203175850.171689-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203175850.171689-1-preichl@redhat.com>
References: <20200203175850.171689-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add xfs_is_ilocked(), xfs_is_iolocked() and xfs_is_mmaplocked()

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |  3 +++
 2 files changed, 56 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..80874c80df6d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -372,6 +372,59 @@ xfs_isilocked(
 	ASSERT(0);
 	return 0;
 }
+
+static inline bool
+__xfs_is_ilocked(
+	struct rw_semaphore	*rwsem,
+	bool			shared,
+	bool			excl)
+{
+	bool locked = false;
+
+	if (!rwsem_is_locked(rwsem))
+		return false;
+
+	if (!debug_locks)
+		return true;
+
+	if (shared)
+		locked = lockdep_is_held_type(rwsem, 0);
+
+	if (excl)
+		locked |= lockdep_is_held_type(rwsem, 1);
+
+	return locked;
+}
+
+bool
+xfs_is_ilocked(
+	struct xfs_inode	*ip,
+	int			lock_flags)
+{
+	return __xfs_is_ilocked(&ip->i_lock.mr_lock,
+			(lock_flags & XFS_ILOCK_SHARED),
+			(lock_flags & XFS_ILOCK_EXCL));
+}
+
+bool
+xfs_is_mmaplocked(
+	struct xfs_inode	*ip,
+	int			lock_flags)
+{
+	return __xfs_is_ilocked(&ip->i_mmaplock.mr_lock,
+			(lock_flags & XFS_MMAPLOCK_SHARED),
+			(lock_flags & XFS_MMAPLOCK_EXCL));
+}
+
+bool
+xfs_is_iolocked(
+	struct xfs_inode	*ip,
+	int			lock_flags)
+{
+	return __xfs_is_ilocked(&VFS_I(ip)->i_rwsem,
+			(lock_flags & XFS_IOLOCK_SHARED),
+			(lock_flags & XFS_IOLOCK_EXCL));
+}
 #endif
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..6ba575f35c1f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -417,6 +417,9 @@ int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_is_ilocked(struct xfs_inode *, int);
+bool		xfs_is_mmaplocked(struct xfs_inode *, int);
+bool		xfs_is_iolocked(struct xfs_inode *, int);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.24.1

