Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF026383B2
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168562; cv=none; b=OKaJPmxrhYG7xyWZ3KaxGUtGowWOzgKSnqcAf6U9DKYKP+KA4FJAwth8jaT3BzJY2hPL6zsdaAP1vq+rvBIX/2lBUIPUPjtp5TpBcTN+rMb0oCOFYzVDQUv7mcYr3b0rH8hf3JopLYTDcpe1UQwgkUcSO71KV6ikXbdG2RM9lgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168562; c=relaxed/simple;
	bh=9fo0QuzGJVcMgJplU17wiC/1RrlZ/HJjMY84QOii2Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7Nt5E6I4PRblDvz/rAm8gcsPoFOQa2hBoSyIRADtbzwXzJwM9DTLFCPfwq6yL8OY/so3YTiQ0tAktwgi0PQx6VYsp+X5IKaoWM9vxZeHTCH/G5C6UZDXolXQjQhFtL4WBoc/9tY5yVvlNt4IKoUZM/pekBPfQjt0IKk8qusoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PlGd+um2; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PlGd+um2"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e9451d8b71so23623235ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168560; x=1714773360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jiioweh5N51NsKHBPZ9ZmL/TJNNNyVsMEPm2nRc65SQ=;
        b=PlGd+um2ta5pHe8jErtNrT+mEYYf9SkJTX/pAbxLecv2H4MZpyuaMDeddD8MaAgnXA
         V5m+7r/xFx9awi4nlYr5T38fEZU/mCHl8Kcnv1niCY9+8vs2ko0e54OGq33tF8BT7w0H
         1dquE/tpVnZmW8JbW8I7cLZu54H1YqenJr89SA6qM+XoUEtQmEOZERKB6lzyRJ6T4EI5
         rsJh5ipF8lN+L8rfXUOkynloSZ2TduR0X3nuRoXRTpHMb3ouMeGWK7izCb8CEYKhxIqV
         /ugqZ6URBOUb58Icra8/LoqLEssn9g7MIizezbeXEQmTVp6Y0fi+v7lxSx1VoBW0QtOj
         TiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168560; x=1714773360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jiioweh5N51NsKHBPZ9ZmL/TJNNNyVsMEPm2nRc65SQ=;
        b=vzV6h6QUr/Tj3rirSLIXs8aBcsOuIvUOnDmsjdx7ZoAORRdX0GNx/XTAwBON5N4cV+
         nihuLsyJPFgc40FrhFWMKywkhM6E/vFeQj7x8zuLjVOnVHILWbbZOSd8z1+2+T5T6GA4
         XcGGxMg8jqsDjRAnIR/JnewvJSTuOh1GrBG/n7HlBAGyRqHT0Q99Fmgp7qXIhdfalqZf
         10DdUs1z7apzyNGOVBYnec1Xvvh39EaxV5MrEhZfG820W310WYTRkeIDD1lIHEnUkCuG
         2aVnxVI1cmLqnWSGNn4B1dteBTJa4JST+jNN6K3toPz2ZhAklO6R6N3PeQfnKQLyjdC6
         +J5A==
X-Gm-Message-State: AOJu0Yxcbj2kx+7qdzFWVnIxJzA5RDeB3Vrcrgz6ZNAvdMkFE9EIJhxe
	Sl+47lw7tJgRKmoaZ4rx7d4MUKCWtlQ3qkmAaa494O3g2LGpbvBBMzrLdDXL
X-Google-Smtp-Source: AGHT+IEksw2j8U5UTDwU489aygsMj7SRrw8E0GwkmofYz7MVdZJIMguhQC065E7DOvnT0LbP5g4lGQ==
X-Received: by 2002:a17:902:7086:b0:1e3:ca5a:2d9a with SMTP id z6-20020a170902708600b001e3ca5a2d9amr3725106plk.53.1714168560067;
        Fri, 26 Apr 2024 14:56:00 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:59 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 11/24] xfs: fix incorrect error-out in xfs_remove
Date: Fri, 26 Apr 2024 14:54:58 -0700
Message-ID: <20240426215512.2673806-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

