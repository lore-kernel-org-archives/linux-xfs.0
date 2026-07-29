Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0561E4ADD8C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353425; cv=none; b=dqsngnvadUeIseU8ioSzicC4YnbHSQGExibIanuJ2OCEehOanrEfZV1Z3Xtx8CtLstwxYtGW0ieWoIN2QpfQv2Kw5dIJ9Tv8nI6cZWAgG5C3gRa8XsxKdu/3v0m9/uxubJBfu2erVsSvmyURYHQDlD+dZTLdpW200CT9gY2Xttg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353425; c=relaxed/simple;
	bh=rUAOU3IydJmQYweh2Ff4mzFaQjYgFYXBQUGY5Kg74Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lolAFRlzK5BDsAhLaRpjYg6wXTA2gMFr8KkUfm4LfMEDZJKj9rrC/3DrEf9n8umNc+YmpIAXVqBRQiMHC/SdQbxoShmrMaBvWFOpwlvYhhAuND+I62uJytj6GZ7wv8zUd2MasSMfzclBSCFxyfeYdtYfRTVA76yLsPC4849sYmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A43P+/w2; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A43P+/w2"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e08baf860so1468887a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353415; x=1785958215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4S5rDCc1of8MfqKGvH0/SP90Wdz9xuZW0t7RbrAbJlA=;
        b=A43P+/w2rt3EdLoTBu9r0U6/ZtYtTM0jFo5JmtuE0Na/3Fc2SKxX11R3fEGqlL4AD0
         +p3Q4/5VVPZ3PLhubEb8Vn9rwQIHQM+heceypLlnJQwgI4H6s46cir3R3rc8MFRFG+RV
         bl8IbIi3lc5xIg3Xv5t3Ve4szR+WAiCmJFjAiLvp9hHVzE8gkly320J+1oJzqstFvMQu
         zMwIq0SRyal4cYSCvTStTiLn0cmUV4jenHNoi7ne0V4wl/85xIDTWv32Eb1E3IRevvns
         FlxIE6cBIRdDfBAmuz547HPcZNtIIGIWmIpkWK+7ePILDj1SotKCb+q8YPUQSSsqdKN3
         fGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353415; x=1785958215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4S5rDCc1of8MfqKGvH0/SP90Wdz9xuZW0t7RbrAbJlA=;
        b=kqMG+VhUdJDxfEL43KGTPgserwA8IRuIs2CEt65uVzHXfnnYRml1hQzfulpp+rk4ca
         fuhQEePw+ehXCyiCOEzTRfg3CJ9UO51Bx1vQxCm7gaCpNzFjjEBOjxLwXcPVHoxI4jDt
         p+uSKQxR6Cw9cWcllAFp7dCqr6foDkpIpdmW9MzRtOqJFZYv5FbWpYva9RmsakXpcfxE
         evka6EpU0sjcCMe/HpfcfG8tUQjTQ1LPeoCnsu8I7go1Sjqh00azHB7ntAHQ8sajuVca
         1s+zlWZ1AFI03bV3eBiJzGV3D2p2sBayhVCqSJBtizSOkE9xog2mHoJWIwk2KxPxxg0B
         YkvA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7r4dGGLLhfRlpjIKPxK94NhopXYuAETDUubOKmLfA1pDKvJCxMr1o40tZt7QDTBNW6DW2ciP8hJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXLSTisecquzfjQdriwd1w198dNQYCj7JiXNKUepEL6MGXLdHu
	FZqC4C2UftwHLuAg7I8jw96/EDKXPVeNb+mDB0pz8TE2alBozCPpsvW9
X-Gm-Gg: AR+sD10w2NQfgWbd8AZKW4pu7G1thz1nIztVlOMUuU7nd3SUCx9XlV97CAT/v3/IuAD
	mZxVRCfXWcHutaAc6vPDTNFAkUUG5UWXip4VrZNYATNIqSQmYx6OFiOqxPNN3jLT5oUBa3wyYM0
	eNTFF+3vkBl0d3Amdli+gO9OzqXs5L4cPUn04MM6a9JAcPFd0Jl96hEscknvaqaixndku4QKjwM
	EzhFpMWXggyJnhAXqKmvGx3tcT+CheN3ZliBFzsA8nGr4wNwndl/KdRSY65C3qlOC4j2zRK9bJE
	3XlosIZOGU+O6vxihxriluc0AvzPncnQChKGzQmoptgJPx40jdJXWJjPKyxxjoBKBxiPVS++G66
	1Kx407mt9HtMBK610MBDuaMJnk5M/RclkaBe+DTHBv2WVn4Kj5piH3pFxx81xSQ0UKNMZQpfmh9
	6XZd2bocbqzIeNIFn4qPyKv7JHLsTSfYVIInzNrpdWMz5wRSOb7vamb+WLl9OZiiTlO9Ne88p8z
	HtdPzoC7/EN4h9K95oUxhX26f+bG5h/S1LL3ZPGcCbwPK0=
X-Received: by 2002:a17:90b:5484:b0:38d:a150:ee04 with SMTP id 98e67ed59e1d1-38f99384981mr149187a91.30.1785353415396;
        Wed, 29 Jul 2026 12:30:15 -0700 (PDT)
Received: from localhost ([2a03:2880:ff::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6411189bsm3156540a91.3.2026.07.29.12.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:14 -0700 (PDT)
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
	linux-xfs@vger.kernel.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v5 11/22] erofs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:26 -0700
Message-ID: <20260729192737.3190206-12-joannelkoong@gmail.com>
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

Convert erofs iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() and
DEFINE_IOMAP_ITER_NEXT_END() macros, which wrap the iomap_iter_next()
helper to finish the previous mapping if needed and produce the next
one. No functional changes are intended.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/erofs/data.c | 6 ++++--
 fs/erofs/zmap.c | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d1..d2f01245ee79 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -380,9 +380,11 @@ static int erofs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(erofs_iomap_next, erofs_iomap_begin,
+				  erofs_iomap_end);
+
 static const struct iomap_ops erofs_iomap_ops = {
-	.iomap_begin = erofs_iomap_begin,
-	.iomap_end = erofs_iomap_end,
+	.iomap_next = erofs_iomap_next,
 };
 
 int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index bab521613552..3966b62a7051 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -821,6 +821,9 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(z_erofs_iomap_next_report,
+			      z_erofs_iomap_begin_report);
+
 const struct iomap_ops z_erofs_iomap_report_ops = {
-	.iomap_begin = z_erofs_iomap_begin_report,
+	.iomap_next = z_erofs_iomap_next_report,
 };
-- 
2.52.0

