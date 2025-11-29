Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F227284B25
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406926; cv=none; b=piEcBMXKRzp1hgm6QGAEZcVzbiewdeMkFomN9E37qAC76YBM/5NtORKQFMtpDedN3h4fmQtqIRguD3Qkf4SbD1kuDAFmigApq8MZ1FxWlzVrIarLvTSnQPybWuXi2EF0Jur15AM0SNPTPJYJxhv/Adwbfab0qzGUk105h+GEoFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406926; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fs/kHaaluezOYfPY88FpWE8+vRVStJ+whmO9ltReWbHwenzNiLm0PM9qKmYqXT+cVAlp8/rSSiPH/6gZxmAc0j9eLmxrlSpEwh4ixv1lSR/hOaeLCq7m4XwrFmFJP6/VKoGi/mNsPAKOJIUcw5KMbgW2owVxqqBPTQGJlG7niyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dd1ocxGz; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dd1ocxGz"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3437af8444cso2996805a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406923; x=1765011723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=dd1ocxGzdhjSsgteQ1J8SNLo8OkTdBZAanb6vnoi7oFFq5bU9MJlGPjhuAytnKRXwd
         7foxMQOWM9CeGrUlD1kcXTTvusKIKkyx13/f7/rFKW6layhbqq8l8U5wGBJ8Kgig59eJ
         p99Qc4DmI+mPpo5U5ok8IbPT0fhgeP3x9lRrqtvDlQhJ9QmDIDHVLCauvhgyhhmGfMG8
         FFkIU8Zl1AFofkQhVPM6eE64bjWyk+7YTN9jf6MxPy15TjQlLCGmg68P2pBHzIP6EL4W
         RAQIEa5ud3nDqEtRoDP2v/ieowml3UaYUT+nzfVlXXDAK0DLgRBhxecyQrP3aL2K90zH
         QmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406923; x=1765011723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=ryC0Yi+LoA3LFYHoSZu3pxXUH7n5N7rbFBCl9GLGI5vL6f8FclrVFUXVBkRjDNFX2G
         YP0Rk8TPd3MRQDvs6Osd15CROsp/UwgDKUBPScBC3X6NviQ8uM/H6PW8Qsr+7sfaxyyp
         oFsmnljFdgBduR0/4iWvdCT96ZZ9JCacwt7D+pk+JhvRlkj9O8m9aUFZV2/JeVQY+aeG
         ZB1q68jyy5K7D3fvFpL198bULF7p40vI4V1HRGioRtx9Zj5fAIEsOivl1AjfzTu+BL/C
         KxQh7z2GTcKx7tlkX7cVEPA1464W4Cg5x8FCZW8G5SJKf3gUf+0GWeurH6qycIs+Ypk+
         yAYg==
X-Forwarded-Encrypted: i=1; AJvYcCWOGBQMVgsUmf29BmVId5jg+f/j13OI+4+joP2dji2WuqR9rDvepNCaTj8oWtO3DtWkFSd9+pzINiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTzx7mv71HYhy2vPW4Jm1E0eMf4DhqOuGxsczGQsETxDU8NCZh
	7sRcPp8FRMEWhm1AP6ox6ljSR0JzuZG6oEQ95JAtsHoAUJZKBgN0afC+
X-Gm-Gg: ASbGnctMUEuoI7h3owZBaZ6DQwDWMyQaz/BuyV8J5yz9nFhqsV0TP12gCTV6zTcvted
	eGTjitw73HSltt4LgTdHP9FbHCpq4bQrmVSyHw6HcDXq5nskk/tzI5lR0z8RZWiwSkx1stBZ8fi
	aKqeoRUOHp0vZmQf5qdjNwRMQ5bz6UoCdIcHwEpCPMweGGALMMM7brPz+ARSo2pk1xORgTK8U+q
	I3pORhXI5YhA9fVVQWRHPym5iQgPMY34ctXGgyqU0J16wwussunlGgJeepXCHBN1GWEw+NElXzv
	dgU5QX4/VvVDgoThY0EeMTnUvwodD+LjBQ/R+gqesF3b+b9vv85elw1zMz6M1gR005QmGy031OC
	NIwfX0/7qEgEdmbzVadQu/qGXN6Wr1kNyDDwV+NLVBFuihvADjfsfB1k8p22xStyCUhzEaL9RgB
	vCIJjHibZEbIgAWUyDiK7YsgVJE4YtSWQRra69
X-Google-Smtp-Source: AGHT+IH/QH6JeY8zEnnFSEp2edvSj4WvW2OiftF5ahPSC2LjhfBX3UeSnFliqzhG5QTteUkJDEx/bA==
X-Received: by 2002:a05:7022:ebc2:b0:119:e56b:957d with SMTP id a92af1059eb24-11c9d6127f9mr19966464c88.2.1764406923339;
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 6/9] block: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:19 +0800
Message-Id: <20251129090122.2457896-7-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1

