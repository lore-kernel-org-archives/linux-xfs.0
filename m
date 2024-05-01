Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39561607B2;
	Wed,  1 May 2024 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588889; cv=none; b=HDIp70nn3QUHqLebL/7P6XyKqpmrj3ubzMA0ilFwF8NGYiln+FMuQJ1pgrI0l8/25zyWAG88jdNSy6tTOV/S6XA5zdrh7P5il2hJZOBxaLaS0pvlOZo7tmzkxSOpLSktsXwQZeb7kPIPMKBijL1eUGBLmHkB/gy3wpIdhiTdz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588889; c=relaxed/simple;
	bh=ysNmjINyLBn0gNnQIQ3FJJZn9si3F/5xhKSd/jFuiWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq9J06OUYn45WXo67Y8a+BT8hGvzHX3rTywTK/UTKSO69SDcwDSWEIMW8m6iBkAWy1D2ajQHRXUdMMvYlGBLz71htXvgyR3B6lrE702SSBuS+5L0St/KazYLclZPMfs9zPsi3VdAxbc5xNmafW24IiDSFh/6kfMP6qf8qGZ6/qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDKL+c3w; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDKL+c3w"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ed112c64beso6560973b3a.1;
        Wed, 01 May 2024 11:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588887; x=1715193687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoEF66zFbDm7CGOX39wytxdX/q2cnPexRd4aoa+aK2Q=;
        b=iDKL+c3wbXMDl2tXutnFHQ0mMGbJ5iSyyt/B+3or4X8znEuacKtrEH8JHa6QWTNrkm
         0QWbds6drKaH6zs6SiAKTVKymbG7P2lmkguUIyFgPHnO4Rg63iE3OWZLAdMxGcUOjinx
         2/nvJNo5lG5qNgfDBobdmWZgrLPoKNDPViVzBMKBeFdJQ9qIeCrXfDI1HnRBB9ST7jUp
         H2OcmUFsQn92oJrjw6qRI/m+6E9YTWWGoyMHlu7H34iP4YuuiOpHDIErFwNtbjg5reA0
         IDhA8PamPK7LTAgjFl9wF6xH5bisj/pW9GHIjVWpDvz8FsWNy26XiDTuDbWYCwRoWfJV
         KPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588887; x=1715193687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SoEF66zFbDm7CGOX39wytxdX/q2cnPexRd4aoa+aK2Q=;
        b=WeNs5MwJRVKzbQeeyewBnARjfA43hKJvzlFBfji6wJoF5Ci6Y37vHm7DKJM46VGb6e
         gXvTb+80F33hdDWLask9wQIxlQHn8CKl05BLfgdQnAeM42M47AvJdtVMPo5yJzM1LRKx
         u+CNi5Kym4WD2oUnTL4O2oJHSIeEk4qkfk1GJs23Dvs/1YM4ImH68x7115uEDkx3k9/S
         CBWk8IKNTOV0MXOfXSDZdIgGG6YAoKX+Dxhuhuu7j5JobLLyU6IyMuk9AnA5KAwY54j2
         V0BGZ700vSRtF4ofOTgVKhDIE1KWVAwcBXgqOuSo1Ti1z2VlE4mRoYIz/jeyHM8WKs+C
         Q5uA==
X-Gm-Message-State: AOJu0YyTSDGmXEYMvsvqCz5VT9u/Fbu4Ez+AU/IxPp8BCqtz9zZz3Hue
	oYveOAe8lS3SAGiUzFZ1DCFOOmAHf1uWFFwZCov6XEJ57+exNtVkJMb9QRta
X-Google-Smtp-Source: AGHT+IEbWhg/LMJcCHBdd3Nx99BQIGHc7nZor1r7OhlY8CYgs6wbBCFgIznm6CQmbb6OXaLaVA1kNw==
X-Received: by 2002:a05:6a20:f388:b0:1af:3a4b:db3e with SMTP id qr8-20020a056a20f38800b001af3a4bdb3emr3743117pzb.8.1714588887222;
        Wed, 01 May 2024 11:41:27 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:26 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 11/24] xfs: fix incorrect error-out in xfs_remove
Date: Wed,  1 May 2024 11:40:59 -0700
Message-ID: <20240501184112.3799035-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2653d53345bda90604f673bb211dd060a5a5c232 ]

Clean up resources if resetting the dotdot entry doesn't succeed.
Observed through code inspection.

Fixes: 5838d0356bb3 ("xfs: reset child dir '..' entry when unlinking child")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa303be11576..d354ea2b74f9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2479,7 +2479,7 @@ xfs_remove(
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
 					tp->t_mountp->m_sb.sb_rootino, 0);
 			if (error)
-				return error;
+				goto out_trans_cancel;
 		}
 	} else {
 		/*
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

