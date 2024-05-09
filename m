Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8448615ECD5
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267725; cv=none; b=eY89L8/gQjrDBGuiVaEM7OiIIzD/A6O4ODQYqSI3MtTZ6BTmIF2XgNVnLf8BxrxAt+/c98ROJWS1R5GVC0KmfbFvT+81ApmG1C0ABJbWYBQ4lhTGXRALip5ISnYLZ8msQts7kgGJOKt2vkquDDi7dH38lwzjdGiCIQwe5T1PVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267725; c=relaxed/simple;
	bh=wGabgN3ViS3LXGqK8MnV4GfVAMac01Bfl0X3YtuibEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjMlsODy+5rTOCOno5s6oazowMsjQ+RDF1/owooA/T7dz4UffjFRFF9jEyOspLTWjyxxUV8srKquncY3eDlcxLpuujQNPLAJmfyeAPOh0kSRPmwb1uwhibqLeKRxWhfmqqPEPvekHx4YawB7GIyEescV0ivSLJbGBkkPemYuyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YrbCoI9I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrbCoI9I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e4X6nrV5BTjLlYzfcEyH6Yfdvhy00a+8JJmOec3j+c=;
	b=YrbCoI9ImmdCPNvvfdbnsDEZmoxMNS56th3k0A5vgYSwImkJz4y8B+J+hrzbiU5b1I9NPn
	1C6h/yRdFE1tGRkDmtoUU41svjAHCQqF2EwkwoMpugM34kh+j065WAhMop7mHr9UUx1FEL
	I9PBfCPwZh2IxrQG3zBFaNYFIeNOuiE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-P0O4wKwFMUuU7yYtqbxHRA-1; Thu, 09 May 2024 11:15:17 -0400
X-MC-Unique: P0O4wKwFMUuU7yYtqbxHRA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59a0014904so56760466b.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267717; x=1715872517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0e4X6nrV5BTjLlYzfcEyH6Yfdvhy00a+8JJmOec3j+c=;
        b=atHimgo7XpYcx7ogSM84HezT6UuuqA2qkHVhfQWblurDCUXq94KaM7gvsrsJd83dZc
         cqJsZmEoqTQ1ogH9R+LoyepjgScab4WeuFfha2jyu1v+2SMHFIvyiFgXMX0xZRQ7sANr
         XYouxxuk+okOLpBVcTJTAsrewfO2+aYtGnXnoi7NA4E9g9PuAlD9WywqaLc6c6lL00nb
         B3YKhC4XBkAHGgAsomFv1Nf/5BQA2VhBRWG6utpgGwdzzrwDYWLPtO8oCDh/f3ESkLmT
         i19nWPy+i5V2xp82nqSApNrjxlFIGD4vd10VIUjFY3ED8aT1AsqgOt/jLs+c0LOTB61H
         bmvg==
X-Forwarded-Encrypted: i=1; AJvYcCWxBA2V+SIOaJwIy4bxZs1Wor9OxJYCT2CS1qPp97usZAUc1Z/p9I3QurruOjCsSjwAhDNIR59ONpQSTTMdQGUM2uMgf6pax083
X-Gm-Message-State: AOJu0YyJFaO8Z2M94GP5aTE4BKx77SRGkbv5WzxQP8aYbdCBGnydJt7s
	2XA0ltY+lSGl52xtI8hVZPAft6Tj/1yA2/ihVK/InnRSq7mF3JfUvy/nWBQ425jGcZTPWisQX7E
	Qbojppuxm9XGHh/HLW0qEDkkcRw3Xukery/FReTm5VIuSeVaGcBwVHci5
X-Received: by 2002:a17:906:5017:b0:a59:aa69:9794 with SMTP id a640c23a62f3a-a59fb94d56fmr353853666b.18.1715267716512;
        Thu, 09 May 2024 08:15:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+xUZ3ZGPToiQTnNEgrEyiek4dg5ec3coG1773rz+tUoLYHjA19/LQvzfB5EZwFn5YJfJSNQ==
X-Received: by 2002:a17:906:5017:b0:a59:aa69:9794 with SMTP id a640c23a62f3a-a59fb94d56fmr353851766b.18.1715267716021;
        Thu, 09 May 2024 08:15:16 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01785sm82035866b.164.2024.05.09.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:15:15 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 3/4] xfs: allow setting xattrs on special files
Date: Thu,  9 May 2024 17:14:59 +0200
Message-ID: <20240509151459.3622910-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240509151459.3622910-2-aalbersh@redhat.com>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As XFS didn't have ioctls for special files setting an inode
extended attributes was rejected for them in xfs_fileattr_set().
Same applies for reading.

With XFS's project quota directories this is necessary. When project
is setup, xfs_quota opens and calls FS_IOC_SETFSXATTR on every inode
in the directory. However, special files are skipped due to open()
returning a special inode for them. So, they don't even get to this
check.

The further patch introduces XFS_IOC_SETFSXATTRAT which will call
xfs_fileattr_set/get() on a special file. This patch add handling of
setting xflags and project ID for special files.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 96 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0117188f302..515c9b4b862d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -459,9 +459,6 @@ xfs_fileattr_get(
 {
 	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 
-	if (d_is_special(dentry))
-		return -ENOTTY;
-
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -721,6 +718,97 @@ xfs_ioctl_setattr_check_projid(
 	return 0;
 }
 
+static int
+xfs_fileattr_spec_set(
+	struct mnt_idmap	*idmap,
+	struct dentry		*dentry,
+	struct fileattr		*fa)
+{
+	struct xfs_inode *ip = XFS_I(d_inode(dentry));
+	struct xfs_mount *mp = ip->i_mount;
+	struct xfs_trans *tp;
+	struct xfs_dquot *pdqp = NULL;
+	struct xfs_dquot *olddquot = NULL;
+	int error;
+
+	if (!fa->fsx_valid)
+		return -EOPNOTSUPP;
+
+	if (fa->fsx_extsize ||
+	    fa->fsx_nextents ||
+	    fa->fsx_cowextsize)
+		return -EOPNOTSUPP;
+
+	error = xfs_ioctl_setattr_check_projid(ip, fa);
+	if (error)
+		return error;
+
+	/*
+	 * If disk quotas is on, we make sure that the dquots do exist on disk,
+	 * before we start any other transactions. Trying to do this later
+	 * is messy. We don't care to take a readlock to look at the ids
+	 * in inode here, because we can't hold it across the trans_reserve.
+	 * If the IDs do change before we take the ilock, we're covered
+	 * because the i_*dquot fields will get updated anyway.
+	 */
+	if (fa->fsx_valid && XFS_IS_QUOTA_ON(mp)) {
+		error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
+					   VFS_I(ip)->i_gid, fa->fsx_projid,
+					   XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
+		if (error)
+			return error;
+	}
+
+	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
+	if (IS_ERR(tp)) {
+		error = PTR_ERR(tp);
+		goto error_free_dquots;
+	}
+
+	error = xfs_ioctl_setattr_xflags(tp, ip, fa);
+	if (error)
+		goto error_trans_cancel;
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.  CAP_FSETID
+	 * overrides the following restrictions:
+	 *
+	 * The set-user-ID and set-group-ID bits of a file will be cleared upon
+	 * successful return from chown()
+	 */
+
+	if ((VFS_I(ip)->i_mode & (S_ISUID | S_ISGID)) &&
+	    !capable_wrt_inode_uidgid(idmap, VFS_I(ip), CAP_FSETID))
+		VFS_I(ip)->i_mode &= ~(S_ISUID | S_ISGID);
+
+	/* Change the ownerships and register project quota modifications */
+	if (ip->i_projid != fa->fsx_projid) {
+		if (XFS_IS_PQUOTA_ON(mp)) {
+			olddquot =
+				xfs_qm_vop_chown(tp, ip, &ip->i_pdquot, pdqp);
+		}
+		ip->i_projid = fa->fsx_projid;
+	}
+
+	error = xfs_trans_commit(tp);
+
+	/*
+	 * Release any dquot(s) the inode had kept before chown.
+	 */
+	xfs_qm_dqrele(olddquot);
+	xfs_qm_dqrele(pdqp);
+
+	return error;
+
+error_trans_cancel:
+	xfs_trans_cancel(tp);
+error_free_dquots:
+	xfs_qm_dqrele(pdqp);
+	return error;
+
+	return 0;
+}
+
 int
 xfs_fileattr_set(
 	struct mnt_idmap	*idmap,
@@ -737,7 +825,7 @@ xfs_fileattr_set(
 	trace_xfs_ioctl_setattr(ip);
 
 	if (d_is_special(dentry))
-		return -ENOTTY;
+		return xfs_fileattr_spec_set(idmap, dentry, fa);
 
 	if (!fa->fsx_valid) {
 		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
-- 
2.42.0

