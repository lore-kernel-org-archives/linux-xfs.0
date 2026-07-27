Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E746B42DA5D
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187494; cv=none; b=ro3SfOMNYUSesSwFa2bZ+e29lTL+WO0N/+edk4MTdTfumzB72/QiNHQC6XF+PAczQLel4ARjhwe3iGT87nXJZtFINfDUutjlK8ySclk7e5OUkF4gxIBanAXduKW0bX7puLZDywYNX84P8ar3Mmq0FUxMskwj7uIt0BovVfvbHqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187494; c=relaxed/simple;
	bh=NkWTxDB7BVf5kr2NeMKSqq0wtS9n6p/N2UG9HabFDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLds2Tx+Ur/N29h1fbfpeF/B+4AS/6y+/USf0z/TG5if0P6fVK9hvKbQVJHTuQjX4hU4MQbn8413QEhBGb0dMr6/HGyY93daIeBJW1VKgdGAiRJga5JhllU7yboYcDxdDi2b4YyPF+mIuugINQ/qzUf2ol1qpqluqhiKcBViPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbqwMeVC; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbqwMeVC"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38101f85591so339399a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187492; x=1785792292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=HbqwMeVCX974YpYO10UEAgGWwkIX6cQ6tYny0r/YvThQigrbWuU7GtnothhhK5fgMx
         9uvIEWz+hVpGFyz8FyO7r96a9NAUzTCyQ5hRxkgJRUimaLKtIOtvjuD8nE+u0rMiF2d6
         mnrzWFfHNj1HkwPGOHjepVxUAFDBDgtKtWiaGuRd9/IGe/Obr0XUDEAkz7Qy9XTVhyjd
         w3oLjb+0rWf3KnTeimJSsnydejkHjnDBGt10nesUmTf6eFl/XPpHtCkJDDcFfBPFDqsL
         8bH9IOi21FNfoZ9HH4d8HInSOmcdX01dYU+bxzczi14R3Mr+vVYiIL0ZFk4htCOfUf3L
         58yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187492; x=1785792292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=gwHQOAqkaBqUAakUeRVb4FWt3thIXdqDpr3iJe2P4a5KB/Z9TQKUTeSgtk19SoZ0Od
         Ztkofmi/db/KD2d244RNxAwynXEAFSOT5LCJIcinOGtuZLcOj/kc8g/EOg0Jm6QmMJps
         ce7QnSL1KzPb1ALqc6O9wG4vsJ2u1MKnJaAWaS7c6hzIiMaPLqCFEqLAC0gmCmoreim1
         pMyVH7SHtStqWPiPHUAGi07aD3peZpo92B9fa971cZSN1UZB0WxLDHK2tGH2oTIAHnXH
         l8ynPDHAepqUMy7bxA7oYAmnH1UaLdFVh1xXMnVE+P3OXmrb9iFuPlvotu1JjFRITKFp
         63wQ==
X-Forwarded-Encrypted: i=1; AHgh+RokfaEzrgFP7WaiQpjKK29xYXAKv94hBPUQNac93oIKLHN1G3USC73dZrVT9sCWpb61YqSUiHYi8wQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUMf2jZIkFExwnfiwuMWlsDnWM5i522hwJRs3VdU2TPGIAt8pH
	vHy5DnUNDtuWxA+1VfHqx6BV4NdlHerULfJOJTcpCF22CWBx+CciGvKi
X-Gm-Gg: AR+sD13CN3gTYsdoIUVFGzh8MsUmfk5aX0/pExarXm0rCVv9uy5fV6N0XCEyjw6hquv
	/1uiFYP8n/z+O2/7xRWndpWjsaD5Jl63P67WXJvPjA6jnir0/fP6AHDbrIwcpg4avbnG1kuuk2/
	4i9tCIVcffHzUMjZqh4XH4oy/tiV74M14L3D6dmqbO176n7/NKxVc7DNRdt53TbtdwImeDJyJww
	xAXrNijEptBp9KEocLVmymjz5dDWzPAONoOmgrUbW/EPW5qmmhoDHuJ87GQdV/t718r8eUjioX8
	qork2opKHdbWGYSVXtwg8oGvBCpf6mGy0c9E5NGevJkK8HgGeaCYx2AaMkxKywebGtTmBpW9nLU
	ZuDpvVExVZX/Exum2Iu3Wz9gSoxA/OiFK65J9BoiKZWwgkVA5iHzhQbf0WAmdmDd4P0Y6id47Go
	2Fk8xhxZkUeAHYVWVv95d3Soo0u7bjH1zmJeDbJ+s/i2ipwI+Eo0FEF2+lUdY/srJU3AXstcVQM
	Gqspthn/w2RwQ1/5EAl3GkPllMupVZ9D5qNFyTD
X-Received: by 2002:a17:90b:1804:b0:38e:9ca8:e99 with SMTP id 98e67ed59e1d1-38f66c425d2mr347628a91.5.1785187492156;
        Mon, 27 Jul 2026 14:24:52 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6412acd7sm345271a91.6.2026.07.27.14.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:51 -0700 (PDT)
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
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 12/21] ext2: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:49 -0700
Message-ID: <20260727211758.1116539-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ext2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..7e0fa9c454e1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,11 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin,
+				  ext2_iomap_end);
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0

