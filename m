Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7772765D3
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406907; cv=none; b=gORSfbv6LV44oOc6Bb78gDBZF9sXGZUhfKBWWX3FQIEvi/3hEoTlwvdLbmFYMaXfGKYP4cvckBVio8IxVbYoc2gPkjOZrpgsEdd/5JDbdzVImQ4N8Krg+0scFrUw6TCVlAirTKGDXUOUhsf8r5ydaup4m0306xRPziB3de368y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406907; c=relaxed/simple;
	bh=jExYI2jaoXiycbQo0Q43ubPRMYOXkZVZRm5nOe4POx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fOhfgU8rKMSNITWGp7ETCvyF/pT4pYDWX1iqkU16LmIkrhIrdVUj2VbL+HFx+uX70r4ogWH//S2eTNyJWU1fIo3fEi2FCa3j+vaPXUj/yyMyVe2/ZF9fISyr7TJCe57N+GdeYNlBiFmrEGQm5SCKj9YRTxzcllrqzVM+z8lQVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvRXDnxg; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvRXDnxg"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso4052661b3a.2
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406905; x=1765011705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06c4CDfEOBNFQOCEh49v+FDqCuxNhXoe5zY9J+9QjgY=;
        b=TvRXDnxgYMTshHKZhCkNuQ8FV3gg1bdYMVAug+4q2m7RRIJFZP3bof47t8xMRAwQlt
         sfyTFiIZZuuha8Hz8Ne2dkWvL2hUjjM63zPUh8CuJYHc3B/Uteja/oe46MPZWoA3yZzB
         3LMMCQ/5opwPbW7tW1owwPc0eBfi+cxKVM2bujQFczwpyMq2T6/EULqBvibxevSUXKKz
         J9z7FyBAcYtD0q2gOfX6TLpbPu8zbiHkT5Pv7rnd0vqwnhda/51Qx5yEy9bse7VGr3ze
         ydw9cmZkHB2ELAbaa/CMzlg+Q7Q7MTh075eQ77AxuBGoXv01GceI/QVGQ4zUXSCDHSyT
         AhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406905; x=1765011705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=06c4CDfEOBNFQOCEh49v+FDqCuxNhXoe5zY9J+9QjgY=;
        b=Had+O6At3zSK95QHjicjM2cWg1P0Ia5cSBnlDP094dIdi1h6nQZS55qitaZAOaGMrM
         4mMxJ+i9iKr/A6csUmvCkSEtO8qYUo1IXr7Z1lBbFprMp7gYtEjWhYeypXe94snytL5k
         pUtAxgMJ+ZMrXOCnE9JmmOql1lMAX8SsqjsmT18bKdvN6rijfrHW83FvbFIWSbxcF/Qg
         GGA0TLCx7iba1GjSnpczHMVRyEv0EGn0PJSH+NiEZoHoVvyZf4ycTJ7hFBFkntgqQxqD
         2RzsM++zCyH4nF1czURx2S28DWku1Q141hkAoRQehtOsSTkCCQMtrdhDGw+j+Z4SRRLF
         TeNA==
X-Forwarded-Encrypted: i=1; AJvYcCVArcbEX0ymxucV6JsrBU1mCyggkR61rjQpo94DzSfjVPfkPIhg19zxs3nIsjMf52f5gvusaYtgjoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMAfz77UsKymHw7db0y+gWM2iIgv9x778x9wxIOCERoWdA0NpR
	xA3IaC3Pso7Zt91cVysrN42DIq+Nzjx2NKiYF5kXnjNkm+HPHvz5bgRm
X-Gm-Gg: ASbGncvcS9eKpO6vRssC7sGYjglW+cB0dDBfUw4A9daCEefbyRYhoYQIqPid285t7fj
	uQTUKlC6YgyDVvh/k7iL8dQ9pZnOmpzhNhAactR7gNYclodv1GF3/paCwqb4MhVdrBXree0MOLG
	ivOYQ7w/3jsTMGmGEZsMN3TSp6u5D4zXThFdD2iekazCi2tzkfLR7HULNE6Ct2h5FKfdcaoarha
	ljP4ivwbWFr+53GNNOs/RwA31snFJKuXW5lcbWhxGVbzEz/nrZoajfCK78D8sSX4bsZ8CCApm2i
	TYL1IyCqdQBXssWmQCnWQwPYaD+QRUwRQlmR60xeWJTtSBepMomtppPsUNJnllrKQ49h2te75DO
	J8HEHL004vXS8DV/H9K6CAn1NW9ryxQVoQVGp5lYXzyyFD+mLE2kRSgjqoR2Z0IruMHqSXOqtnn
	hYfujiChT8DYw+XywYzt0fuZgL6A==
X-Google-Smtp-Source: AGHT+IEFFhMF6u7tNXXwfE6dPq1pkaM+HsOKRV95Dom9e3MOSpru2Keq8NWtpHMva0MzTN1ZATf4vQ==
X-Received: by 2002:a05:7022:62aa:b0:11b:c1ab:bdd4 with SMTP id a92af1059eb24-11cbba4ab67mr12173129c88.38.1764406904816;
        Sat, 29 Nov 2025 01:01:44 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:44 -0800 (PST)
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
Subject: [PATCH v3 2/9] block: prohibit calls to bio_chain_endio
Date: Sat, 29 Nov 2025 17:01:15 +0800
Message-Id: <20251129090122.2457896-3-zhangshida@kylinos.cn>
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

Now that all potential callers of bio_chain_endio have been
eliminated, completely prohibit any future calls to this function.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..1b5e4577f4c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/**
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	BUG_ON(1);
 }
 
 /**
-- 
2.34.1

