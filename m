Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B104854E8
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353434; cv=none; b=JPVO/q2vk4BLtVk6Zi2fatjtO8l5Vv/2Xvlt1vTfz/val3f1Elww6GC/zNgG/GnCyc6+wxduXDuGct3vRK8/Mx6mDFimlVffShE9JIF696rcf5vHI+5cg4+n+9zzWGbRYB3T/9Ywswnf+wbO27Y7KRvPjiiz+CLxPoXLKE41FD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353434; c=relaxed/simple;
	bh=3Fbl5MaGSEhPrjx9pliGoJqPoQm8nDp7ZS+WKqitgus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDo3B4F1djQOeuBZEInaTwPLtWdibhjzo7AhbPTVs+pe05Lu/uQIYYwE5kg5YEtJKscoVbg4wFw52mYojRzph5Xw83ILEy8hu6lymqV2Ve0DZsuow7pw5sY4AcJUNsG4I4Byu+C2txuVts/AndRKlVnK4AZQ3VM5tLeCKXNqQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H06m41OB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H06m41OB"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cea3004256so16265415ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353426; x=1785958226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=H06m41OByIOb+7bpYmBbvmgaAAu5JSrdjwMfjBhS8Ju5+anz8twzpKFbzmc/07yDpE
         bTGsmLbIQPXeKV215TyGAR/OCymAFn/kSx+rpmRuajT4Ko71uKal1mCOuUaJCqqmcrpJ
         461Ze4ctidrkn5V1LvcJHxtxTYgLEFBA1MaPJgnN5sB1jkZsZWkBFPTMHx2Hc2LT9ITA
         D0TIJUCe5TZZa+6q1ia+5h3ROzEPW5yA1EWqkZFhiJCpVSZ74kxHFl/FQhDNJx4nK9Am
         S3tAmu08WpFNqaGxdalUlWp7G4/RLjXOwCs14EgQGwzvT7zFq9AM1Tmpjiyk7q+2xxj2
         3IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353426; x=1785958226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=KAiOlJX6sLKjP+JI48oyT6CfoJNjNkQXlMeqUy/L2nms09qkmLqiuEiP3YOTcw3bx+
         Kzoi1yEXlwySnLxmAd6iy4LQgFWHbOPCzBWivLOhBRcXp+3svMlZ8r7Cwh9GEVKBWIvn
         jy+WbD+aKes3TcPMLdhKp7tXK5cK2SFQCR3fRzkTa4J9pa29J3JS7uJd7xIMnD9VOjj0
         1yNzX6cfr3nQimz5V/fdHZV14UZHBvBxAZffPbyxSoqhIlFk7Wx4R+LSKayxW0GXegxJ
         y2ahtUkxcvo+BvH4wOYkZxaka0ZrbPXpCQJlcL45n67DeqZqWBGnnLg1EBa9CnmBOXbT
         NTjw==
X-Forwarded-Encrypted: i=1; AHgh+RqwjN56jTRII8fdHty8J6ilIQWfR0l82hkRtZJMneTkQFqIbeqGya88yO3lfUBW4UyHmyl8o0wHLeY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoQlK6LcPi0bAbJ4ylbIo07uP2sEy2FYVdqQR3790Z6zlJqmoW
	Q4+KFhVKpYVbqKvXzq2MkCqYWGEPJSf6u+wYy7PksP9lJHlBz844nkyi
X-Gm-Gg: AR+sD13P5utB/wRtx1Q9nnlaeiBnyzVVs8eZSAp34AbY44x/Eh3bDoD4DULHX/gsQyp
	c88vglAjZfrkkDwUXBTyzaIg/jxCskDrKafZX09x1K/Pbfq8Tejf4XycAMlLhzKxoidCBXCn7ih
	YRSMenNnS4BLWd6pI22xIRst7rV6qnwfNXXpmApuu29DS6HumWJm38sDrLj32VRhxpbWYZYt60K
	C2j6jb7EfgQUjATDgpFjuVxbwOOMgDPbu23cFZ9jsd04pH3x7FMOQy6kKaI4B3sDlGM//2VcsPy
	aaoeMDgIsDbAqeREA+Y/E9LbL9Egyg7CyBMUmYQQ75edZepc2T/N3j7FcS/LnISxG7J4iMIabgT
	AtL/cOMSHgzP9c0RXtKWJXXwEIQtwfYSxBjCfW1KhX+co7QVIMx1fpYwYnTViQ9wacnU2luWXWF
	cCDZ5nHuuFC6RgPbUiv+6uPWJg3ARa8W+n0ttH1Hym0TiMQv6ux3PeaIyQ3/GGTLAXIz9xYGTDs
	BLoX4Rc3XLH8cPzIux7w6vEKDKn9rkDjpJeqFUsVVvM+AfQmA==
X-Received: by 2002:a17:902:cec3:b0:2c9:d55d:2d3 with SMTP id d9443c01a7336-2d033b2ad0cmr1860175ad.15.1785353425702;
        Wed, 29 Jul 2026 12:30:25 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a16987sm15596345ad.16.2026.07.29.12.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:25 -0700 (PDT)
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
Subject: [PATCH v5 15/22] f2fs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:30 -0700
Message-ID: <20260729192737.3190206-16-joannelkoong@gmail.com>
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

Convert f2fs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..8977ad379f50 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4653,6 +4653,8 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
+
 const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_begin	= f2fs_iomap_begin,
+	.iomap_next	= f2fs_iomap_next,
 };
-- 
2.52.0

