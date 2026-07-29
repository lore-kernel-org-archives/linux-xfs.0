Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5D4D90A0
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353406; cv=none; b=JNtEgsnELCUnJyQPapFHuNEqnlv4f2NjHaanecN7StAqX0ui17RS6pOxTm63d4rLxJ2Zz0peH+O4VDys/C+88U/NKkQws/abUDGBD6VWIifxkrTn1kIYM8uRXYQnHbGNrAt015sEyST/8CTTHxTRSkSuqW2yfrUc3lV7yO4/b34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353406; c=relaxed/simple;
	bh=eTTI/PP8TlFuiw7HBsZdYR992ywKL53F2wQRaQu8auE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed9mtK7GbRZPAammySclwFThwEm4vphVIt53dqVhx3oN4Vw5S6g5FKgQNqfpExyMayWGZnMat/N1Rx8XnUTPwIuxfhwFvNDp/WDXrnpi0noRyg7+PoVmvFeIOItikK1qYCGXIEfZCtMRd5i5h1NTq7SiLa+sqYq46bkc10a46n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U18nWUYb; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U18nWUYb"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so1336329a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353395; x=1785958195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xvyJmjxv+UstHEEWN5Iv1WD4WgvujXDPuFN5qiQtGjw=;
        b=U18nWUYbcIJG421MdAGB+3ZdW2B1QoWvD1ffnj7uye+VGPwmT10F/GF8XsEVFUTRkz
         vRG438jR0OxiXzwHmiXoMCN/rR4C4f8ATA5abqe9uMXT5Ez+VmZRJ6eKJhrOpwb4iLqs
         Y66w56N+nBAR8sY1C8IaDgWpe3EgwakS+jb/NinMXVP9aBEVvMZBZKWmcY5PFO2lDfx0
         oeOPxLMi/Os9POfiBc7RcOE0MgRwoLDEIFxkwHMJofhNLSUzD+ZSlcAq8pyql1Zy/5AI
         PCDlP5djEL9Z7Xhnum5ieIYmQSXRwrK9NL9lw9L9I542AOi8vSWmf4tJMtEHQ8bFq5Qz
         U3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353395; x=1785958195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xvyJmjxv+UstHEEWN5Iv1WD4WgvujXDPuFN5qiQtGjw=;
        b=WbWMk0N0S5GmPft1NkLDsgomVzJVCivye5Z5YwTX1HsvtLqzEki7oIrbgVx4Y0shW0
         kgOf4AKBEw67BNnonZruavdZmZo3fjNDed9Njtya96+lFVgPIruVGCDPig5Ej95d2h/s
         8er2fAXvBnwO6HfGu5dd9I51NJGhAeiSqlNa/3dDQHioYBTt8WVbT/KpDiOIMbuBiJpK
         wCvYmxG3fNb23HMcqfd+JdE7b6PP9cFuxCPEksIdLit9v1f4BAoz17hxrh5sQm5cIg0L
         jcBrc911Go5ch0go06axAMJ1VLU4pCqPEuOwrEjIMR6F4ZjdB0Xa1vUZDkppSLWI7RaB
         7S9A==
X-Forwarded-Encrypted: i=1; AHgh+RoR1piogk4gTVXbS2qAIhn4ATELjj8L5udlQ6eNCB0avOL7v0upvWwk+GC0TK71kizd7YFj87zwbyU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6LfPMfoD3hhUeiJfXjg/ERJnIbR71j8t1k1u/qE/G6CbvM/85
	t5kL2SfW8OYM8WSf1beeAshxZVecGanvyBsb/CLCPNRnqL+q9IAW2I30
X-Gm-Gg: AR+sD10e+FAjqra/XwRy9i8H1KRo5PrDC4dg/vuZe6PqgBIzaekmFM1SSrYNmJT2wbv
	lxiQkXfsqxTeEyCFvi6YTu6gAOvELNztt3ZDHQ64pbpoAGtca7QkLRBtqf8VUXUev6krfE5sx5N
	Tio3kd19eRhHqdN70z+GUd0+1zIYQsv5XPZzzJJgxRu9CpF+nLsv8tMTwtyqleHJqJTI7D1nGXh
	K/zt01pJH4pZZ88OfbSbHovzz2MEDi+UFVnc2xMMFD39aJcYcln0k6oWKxMjgUiXIBfjBfTwfvZ
	I8ldfGRU9JkyczCblhvowF1tfuyprZKsamnKJPukVsZ2T0F/SKQ3IPzth5bDrS8DxpqYn4ySM21
	jOkgCvAUAxvk07f4QuNfIt7oThTjtWreQ4xe5bJuC5J5ogrIKJ/LPedRO7UtC6E0N5R6MzHlWAV
	jIlEzJxwI94AyVxTmL5bNP4RWayNPO3gr1r+S0EJQQKQ4ojgaXxLWDrVvcgxAntk3GE41kSQC8t
	l25/dOTsS/RFOOa636CwGRm13umd0sLaFsLlTBZ
X-Received: by 2002:a17:90b:4d0a:b0:38e:a555:8fc3 with SMTP id 98e67ed59e1d1-38f995cac74mr145121a91.41.1785353395487;
        Wed, 29 Jul 2026 12:29:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f292be7sm1756034a91.12.2026.07.29.12.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 04/22] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
Date: Wed, 29 Jul 2026 12:27:19 -0700
Message-ID: <20260729192737.3190206-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

For non-blocking iocbs we should avoid blocking allocation where
possible, so switch to a GFP_NOWAIT allocation here.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 36c976cf0848..5c28124b9f02 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 		struct iomap_iter *iomi)
 {
+	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
 	struct iomap_dio_simple *sr;
 	unsigned int alignment;
 	struct bio *bio;
@@ -1015,7 +1016,11 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio = bio_alloc_bioset(iomi->iomap.bdev,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
-			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
+			       REQ_OP_READ, gfp, &iomap_dio_simple_pool);
+	if (!bio) {
+		ret = -EAGAIN;
+		goto out_dio_end;
+	}
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
 	sr->dio_flags = 0;
-- 
2.52.0

