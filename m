Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C4617C2
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2024 04:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KOBCefAO"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5cf2d73a183so3200161a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 20:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705379591; x=1705984391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6WNUp1/DjnvVzfvivzJg8DmhsB2nd7b9pfjk6wURg5E=;
        b=KOBCefAOM8BRvSI082VUmn4vsXw1yYdnmI6RC45HDMjnSoZuX76yGTm2BYEd0pkT1g
         8WX2Yea0giCKLUw7a8bspSH6dOfIKiMFHyNvjES/GOEHwO989uodPP81brjtI68zISsE
         SuYktQjkP7Mjmg9Pw/CZBNSCnLQ0eAPEQpnLmQMR2eCKpNOtUErs9CjP4EZHvTCGJefb
         cPa7hAPRlJUGaZwBWg/ypX60ZGyXzXPVdQC1piQTc+Q8uXGbCy35lQb5GWHN201xUQlS
         8+Wrk7WvJ/uxyGWYER/vS0GP28Uz+hXCqk8zi31um0h3ZKgCj7VuDpyPlUmMDRuYAGLc
         VnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705379591; x=1705984391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6WNUp1/DjnvVzfvivzJg8DmhsB2nd7b9pfjk6wURg5E=;
        b=QF1dotdpOVAtGl2aNhTmcmUM4yXrdB9YNKvZznKZmXxP8EZnNvLWYXYqHrL6WNq1tw
         Iwo8k9goeheyOEc6cGD1LDFsPV+M0Q3qIrzRiJGt3mqJuenxeWnTtNrZvwFc1heyZzf+
         ujJuZmsaiiFHqmnV37AwN+1S2vUKlGfrU3xz/FWHiJAkn8q9YzPtWEcJc2TMjF8fBgYD
         oaiSFZTcZg0HmW/0N3PMMH9TmjED7hMATgQyy49uB9XNo5ob0Ic5msacbEK4+Q/GAMpI
         0wJ8zZMxT+3mpHwyfpmTGOtfSWsIEDYf1A+M0aJ8+EAClbZsrArd2hej4fNvtOnVUKeW
         eHqw==
X-Gm-Message-State: AOJu0YyqLOsbAtsJ/NcVjfHkXF37vTqVTU11C5XXlaQpH+QWWemtigE6
	us7GrJvsKB6pINq6qF89UnT/7ZAZ0Aj166G60a6z1NNrfzU=
X-Google-Smtp-Source: AGHT+IEmqmVWFxR5BXXb+fa/cC3DtecBnT7Wgk++4GWz6TWXdMosUp4ge9ZC2S3sRNovJCmyvfg02w==
X-Received: by 2002:a17:90b:1982:b0:28c:9b85:fd87 with SMTP id mv2-20020a17090b198200b0028c9b85fd87mr11277959pjb.19.1705379591105;
        Mon, 15 Jan 2024 20:33:11 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id dj6-20020a17090ad2c600b0028dd3ac24a6sm11733289pjb.9.2024.01.15.20.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 20:33:10 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPb8N-00AzcQ-2l;
	Tue, 16 Jan 2024 15:33:07 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPb8N-00000003kSh-1GoE;
	Tue, 16 Jan 2024 15:33:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH] xfs: read only mounts with fsopen mount API are busted
Date: Tue, 16 Jan 2024 15:33:07 +1100
Message-ID: <20240116043307.893574-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Recently xfs/513 started failing on my test machines testing "-o
ro,norecovery" mount options. This was being emitted in dmesg:

[ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.

Turns out, readonly mounts with the fsopen()/fsconfig() mount API
have been busted since day zero. It's only taken 5 years for debian
unstable to start using this "new" mount API, and shortly after this
I noticed xfs/513 had started to fail as per above.

The syscall trace is:

fsopen("xfs", FSOPEN_CLOEXEC)           = 3
mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
.....
fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
close(3)                                = 0

Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
what threw out the error.

During mount instantiation, we call xfs_fs_validate_params() which
does:

        /* No recovery flag requires a read-only mount */
        if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
                xfs_warn(mp, "no-recovery mounts must be read-only.");
                return -EINVAL;
        }

and xfs_is_readonly() checks internal mount flags for read only
state. This state is set in xfs_init_fs_context() from the
context superblock flag state:

        /*
         * Copy binary VFS mount flags we are interested in.
         */
        if (fc->sb_flags & SB_RDONLY)
                set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);

With the old mount API, all of the VFS specific superblock flags
had already been parsed and set before xfs_init_fs_context() is
called, so this all works fine.

However, in the brave new fsopen/fsconfig world,
xfs_init_fs_context() is called from fsopen() context, before any
VFS superblock have been set or parsed. Hence if we use fsopen(),
the internal XFS readonly state is *never set*. Hence anything that
depends on xfs_is_readonly() actually returning true for read only
mounts is broken if fsopen() has been used to mount the filesystem.

Fix this by moving this internal state initialisation to
xfs_fs_fill_super() before we attempt to validate the parameters
that have been set prior to the FSCONFIG_CMD_CREATE call being made.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Fixes: 73e5fff98b64 ("xfs: switch to use the new mount-api")
cc: stable@vger.kernel.org
---
 fs/xfs/xfs_super.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 96cb00e94551..0506632b5cf2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1508,6 +1508,18 @@ xfs_fs_fill_super(
 
 	mp->m_super = sb;
 
+	/*
+	 * Copy VFS mount flags from the context now that all parameter parsing
+	 * is guaranteed to have been completed by either the old mount API or
+	 * the newer fsopen/fsconfig API.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_features |= XFS_FEAT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_features |= XFS_FEAT_WSYNC;
+
 	error = xfs_fs_validate_params(mp);
 	if (error)
 		return error;
@@ -1977,6 +1989,11 @@ static const struct fs_context_operations xfs_context_ops = {
 	.free        = xfs_fs_free,
 };
 
+/*
+ * WARNING: do not initialise any parameters in this function that depend on
+ * mount option parsing having already been performed as this can be called from
+ * fsopen() before any parameters have been set.
+ */
 static int xfs_init_fs_context(
 	struct fs_context	*fc)
 {
@@ -2008,16 +2025,6 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (fc->sb_flags & SB_RDONLY)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-	if (fc->sb_flags & SB_DIRSYNC)
-		mp->m_features |= XFS_FEAT_DIRSYNC;
-	if (fc->sb_flags & SB_SYNCHRONOUS)
-		mp->m_features |= XFS_FEAT_WSYNC;
-
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 
-- 
2.43.0

