Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084817D3E8
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579554; cv=none; b=b4JuxDcxSPsZLjkkeKnyoWGjnU3Kcyj6aNhL3T88mJnC5YOXeGoQ1+lBLad/60kRHRBrlTTB0aKLdPjDe/NZaxkptcB9F80OSY9/AlP0VJvn53ed8T2CYXYGXxvBad5RFSWmfrxkUUsTV7CDYTfDNG0M0naH0mT3H05Zlde64V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579554; c=relaxed/simple;
	bh=ainyHKqvx4hz+JUOuiT7wb8jqDetr5DJodT75t43LEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+RLVxVWvx3+MpkJZt2BU3cC3e4i6OABH3CBDTWinBYSkaG56lgheGXKc+AV651pIMQkmTJeY+zfxhJtSPlQZjK4K2BN4rUdvSug9QkvqkNvCv+CIhCDo4UOKzovllh+q4OorG8wq2VNNTWh9gZ5ogYgD8fYHbd9xvYVOzEmK7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnwBhmmZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnwBhmmZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnayIRcnO+BLkFSf8mMKfcvWg3b9lp7LMZpsgNsP/Hk=;
	b=BnwBhmmZwZAmV75rkWUI0Abxy+oDcLlouyqc9eFgPI0GkB4FIaflEdq9dZWofxBmhHypIm
	VtKlCTA1Wz+H4yiPgF8kV3/e6o+HZm8ifQnWFoFOhmB92yWFpzy0cp6jiIs4zQlDF1nfGc
	43rIIBJqPozpXAz0uTTzLNIaBO2zxaI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-cg_SUp_CPhm5av12WotoBw-1; Mon, 04 Mar 2024 14:12:30 -0500
X-MC-Unique: cg_SUp_CPhm5av12WotoBw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a45095f33fdso185621366b.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579549; x=1710184349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnayIRcnO+BLkFSf8mMKfcvWg3b9lp7LMZpsgNsP/Hk=;
        b=mDR7dcDBqECAwR/Ry4zQRJoBrPR9fh7y5ZGvhBn62JMco2l3oc8QkEhrS3RdTYEqsw
         IU+MlhKlmn/lr70JkGlmFr29S2LMYyRiwkmjqSLRn9b3BgzHFEcXvCdtMb+sT7w5jM8I
         9ynSCOTy3Xx/2OGEaTGsZ1JiV2TYgmGNxUuY044fc6nlmeLEqqHOBMoUhDJlg33eMQmo
         4mXuxhSde8D08+LZ4qXvDecqPJtKY3Lh/KtdsNEWY7tOz3px1962pkV28/pj6KNhdD/K
         CJMq3b8rYByTY71NcQmrE6h06FS9awICZA2SYPKPxtJ8pKdRpPz3w1CuEvByXAhZJWZG
         G+JA==
X-Forwarded-Encrypted: i=1; AJvYcCWnqshNLXA436jJ8GAX/HvSUtW2pXil6jLZVPp1IW06DNNblrmzS4FvDW7IgA+sDfM6TkGlTHfOV8PIc9HNPnMFM0uZScz2iJFH
X-Gm-Message-State: AOJu0Yzl25zsDhQjTwUYIZzhYYgXXZH+YTSX4StcbYuZ7PXrDxDDIreW
	MWjv6Bx5JJMnHAPSiVN9z5ZEv89f/PHA4T7OLkmSyIl80Rn9vVYqs07Mnm+8FkST0lm3Xtc0KM9
	ZhitFHqng+xCyW4R/RQ+ovBgH6Rgj7Wro2d+L3QnkJJzeXAWXwZpQsjaO
X-Received: by 2002:a17:906:7208:b0:a44:9483:33c1 with SMTP id m8-20020a170906720800b00a44948333c1mr456036ejk.20.1709579549308;
        Mon, 04 Mar 2024 11:12:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcYNlt0SssUPUet24VLhIXGVpQ6Iw9w2GBXoiAHp+EpILcEydERBdpC9LANmhbgh5kqSORHw==
X-Received: by 2002:a17:906:7208:b0:a44:9483:33c1 with SMTP id m8-20020a170906720800b00a44948333c1mr455998ejk.20.1709579548848;
        Mon, 04 Mar 2024 11:12:28 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:28 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 20/24] xfs: disable direct read path for fs-verity files
Date: Mon,  4 Mar 2024 20:10:43 +0100
Message-ID: <20240304191046.157464-22-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 17404c2e7e31..af3201075066 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -281,7 +281,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -334,10 +335,18 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared (see
+		 * generic_file_read_iter())
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-- 
2.42.0

