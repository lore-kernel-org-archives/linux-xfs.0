Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BB432316
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187500; cv=none; b=qusDiS6eDcE06ZUwgKeEuB00tMfTMuEF08VQ0W50LQl4bfHs3fID006oy0aiZ5+erj4vNLZT7nZ7eIze7KpR7Zi58IKKNBYXJuK9bJoXt0uCfGcLSi8nWKeQYV+ChTyEjOfnW8aoA3sCyC46cSURHqFurS5tc9N9SunxO5CkcIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187500; c=relaxed/simple;
	bh=HHxOrJYOsxXujbtNOZYiKxqT98cJWgSli6XX9Kw9VZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXRCUNfXwZncypnZ4oJiLOcTnM6Mv69p7a5HazjTW86k4WLaN1+pFsZ4EjzbRKDbnifTg+Hm1GbpW/qQDmEyQgtEviY+pCDTGUY6UAgc/YQG2h+W0xkaWh48pA74qfuunuKkPtHQwObBKkrkmTe6qs/W5Pdd6VoWkEDURiX+e2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHN0newo; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHN0newo"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cace91f112so36032025ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187498; x=1785792298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0Y5kYgnq47GiPzAl5xZ9gQOM4CGwKa3ZKYndZjd3EM=;
        b=IHN0newo77L8e/SVfqvpElYI10zdL2Nn80KS7kUZ2NljqU26OSC7r9eGXdU4a+EBJn
         BqP4G5qxxyeb2q+V2EltZrv9/OWlZoppETN8UBjZCwv6I8dSykUP+c+oNVImElqXXSDe
         +Zv0G2oFAJ2uUMaFNuebx0iz8Zcp+sE9sL+Vfgg6VQVlUFwKbF3kM1RZO+J6BlQocfcB
         sJpt0R98dOh1WxlHbZ4NdZFXNjPoIox3jlNXRkI8wr5vWvZAvNRVfKjJUJNbJXZUCtX+
         g3uxJitFlpURw8mdg95jNYXIWkHxOWukoUn76/dUdqMxrgpBOfQMCDvFHRCWHFo/KRKW
         KRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187498; x=1785792298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t0Y5kYgnq47GiPzAl5xZ9gQOM4CGwKa3ZKYndZjd3EM=;
        b=cTLaoDZ9LVWwzaZDyL5Rrxj/w74Cu9qpTBSTNQZYgFCd2ZDAULhHEEsZaHQu+VkJIP
         iQ4bbi2qvdHo5jfZ17AWo4fZxz2Bg9wMW4bifCXa/e65pWGdZvl8+CiGL1FL/6aUUPfk
         AiDSAf6LGvK5fF+2GyEP0nQ7ierJrEZPWcDXd7iRL1GokNV52jdIM41Y9qBRUjxyD9Wv
         Tteh8ewKMAvkhFlDxKjO/XWzLC19FaMiYPElyukjD8hhLWXVuhZrG22nAUqjF7VZgNpR
         FbDKAd5TgMxmvhxG7lLhpFE9Cc2qdy5er7+s8SeuAAGDnX2bcZYCbMm5A+vqCKDg6OgQ
         PM9w==
X-Forwarded-Encrypted: i=1; AHgh+RpaMJDWanzbGkyvc7FTh5ToD/ybdUM4He1ZSq8e5k7omN0wkggQfq2EeIUVvOdW0lpQPFtoaCyM4sQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFpszyWSFuj7AC+Ec66PWLeYfo6hXsXkohK600OzsIgWSEBhVL
	ArQzAKD347yqtk0VZBKsFjQrpn2A9Fj2nYF7GsumRd9noHNob+EFTGhA
X-Gm-Gg: AR+sD12BcgBUwU0xe6Cqguu9oRHzsHfwLDuqdP7ZZi/bGcwEqEZCMf8nY46RoMSzOBp
	N3aYQquVva+gIhxqald/ktxWBlBTrTEdLcGgb3MmJrnTLnhRV5LrFU4cl1UFHM571bbBt8du9bD
	wUjQZq4U22UxfsffatAAl1OMigTtXzsGgtjYT8qHdt5l1r5Su1QhekIcRmVXRd1liqqaz1MJUiE
	kt5y9AfA/W7kHy5S4rS+97Ddnmp+UZuQG3C63i9mbOI4P9QuRznTETztsFpfi+btQr2mPcwbiJg
	FzFgMNxihBjij98y7qUMdYPy0VDkvDCZSrm/rJUl+SN7zFAj/W0ODXNoWhbHkj0xmaMh130s8EE
	9pNiUe97vbD20mstPX/Yl+hFoCkBS2QZ2PbiJVl/m7nB0cHHNm+4XsPJ8hRnTvlI0X78xpEclCw
	0/+CPAR4fsXloKLlZHCeDXWBWhqnAQp7TkVIMr9Sm5miOAb+jtCdgM+A==
X-Received: by 2002:a17:902:ce8e:b0:2ca:e3f:6a4a with SMTP id d9443c01a7336-2d00f337248mr8663625ad.21.1785187498085;
        Mon, 27 Jul 2026 14:24:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bc5asm40856345ad.6.2026.07.27.14.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:57 -0700 (PDT)
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
Subject: [PATCH v4 15/21] gfs2: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:52 -0700
Message-ID: <20260727211758.1116539-16-joannelkoong@gmail.com>
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

Convert gfs2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/gfs2/bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 51ac1fd44f78..73c626971163 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1200,9 +1200,11 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(gfs2_iomap_next, gfs2_iomap_begin,
+				  gfs2_iomap_end);
+
 const struct iomap_ops gfs2_iomap_ops = {
-	.iomap_begin = gfs2_iomap_begin,
-	.iomap_end = gfs2_iomap_end,
+	.iomap_next = gfs2_iomap_next,
 };
 
 /**
-- 
2.52.0

