Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC76B2E7F39
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318781; cv=none; b=clzgGcqfEWZw3IwFKyvRoVnSpNunjHdKa80Wzmcvu7c1fkaOHSISti0F2s8CDsSIaKFFPPRW5ZgfX5lU28N3ed2ahQYHeH6R1oNrSOJS7q4C7JpgH8rCeCTNyq+z7TWBzMqWjzzK7XRfslZanHNW/gq784qlAMGB0XIgQ+7/5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318781; c=relaxed/simple;
	bh=XfGf+/4TH9UT7Q+DEbtJ2829MlGgMcgOkxUS/OB2JNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gl/Y5EUPV0w9RUyxHsfN4UxQPWvA0KS+uTOdtzX39wMbQl6sibZ/uzKAoZx5hKjqA51OGWPH51acEqIJlopwjXBOQw/8A0yrV9UpPDl+mSo/OnrPqVAqQGP0+BoTE86d2LwwPN7e6sKd22Pcqvmc4e6SwcuDxJ4GxixOedsuafU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SI4ktECW; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SI4ktECW"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so2014259b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318778; x=1764923578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=SI4ktECWGAdxQ/h5ju+9D467iQ0/b5onxBwTSANKtpdW6BDsrTCOBt0Z2whVC1Kgc6
         SqxC9/yrtDlAggVPK64cjH8kfhOzaGrZ22JS17I7r32M+F/OOlRvLkW9VmrFlWdD9BQi
         cd1dIhzw76SZZqIIZBA55GnPK92aV9L3rFxGG87UGo6p7jPJJvEACSIdXqbPgIIAoWXm
         dpzrjxLacGVnjfljRCZozEBRW8Srq7qH4WQAk2301BB7dH1yjlKEIYl+H49ja7BuNBTu
         4msQwv/o6Lclgz2gjm+b7vK17E6S1wuf2ciylRy+pf7mRsGXYNvw0hyiuerrllb/+E4l
         NaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318778; x=1764923578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=F+33eEaY8aSOx8LyHca2V19p91YJ7pEgGb3o0QK/utjHz7l7qDquNLdzh4ZonQ4vCR
         DAku5oPwvzgFm8stGQLfq7jJageTnTEio/1uH/8bQumNY8JjRn+LJxaDXJOPHIemmCgz
         kAdI1CupdLtHj8/Dg8QktzENS5OI5tmdR0MyWiEJszYzjL3KSU0BK42kfA82m3DOW8zn
         M0PKsj1gQe7JFjM0qX4CAmgYFBuWgr87HaX3erXZENBAkfw1rPBFLmn+wvAZMqykmZeB
         59XtpFwT204u4U45/lfdKEM7SN0e0v1LmZYOMj2zMltydkooSPwVRdQO6kNaAELWJocM
         bKkA==
X-Forwarded-Encrypted: i=1; AJvYcCWQpGcuIElyFbssLpXzxnNl+aVcHQ8/wsNV8GJTO4LvMGFgkA2kV0oInJUF7HXz5DIjfOZKLmg4X6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqUXKp58dNEmFYbHR88wPLPdTvTwC9ISx6uObLhQjLhSIgiBfw
	WdnEdTTM/wgCtS92dNaPrTicRiyNVXHJ9k9UtdoDW7wwPLEKTUg3xL2u
X-Gm-Gg: ASbGnctG+U2ll/+RYaWvbMdPzrjV5cGreglKduiemtoRrNsplEhxOzznOotM1Bbzsya
	S40xQbSlU9NYSgCthM15O/yNSISJuUBhPtd+HnqBauVEATASI6QqULuLSACmZ8V2DVy/wLMwxBM
	RBGgyt0DXaqrTVxBjXDPKRAWnNvkahf5IkR16dvwwwnM4iB6Pa8aQm4aJz3vbL3z0co1EBEyxBZ
	gjzPJi2t0vwbITo960w0hqANWoKItpz3C6U9gpUbAnYJ+4cegwhdiRxckIIXdsl1jm+1tuk9Q7p
	H9aY77mNBxWf0OOqRllax0pmi6NlwyYwL14lQF6t1a5fZ7D4GRCQCHofBdDe+5DNs7M1pJ7mH3a
	LWx+lymPp21coHFwNNomphW6/+sURD9Suo1UthQIVh4hSailc21pn30JFUU+xW8gaNEjnsOhvdv
	Nc0TwtOwOicjmh2NzqVfzhRd8ZQg==
X-Google-Smtp-Source: AGHT+IHuO0sAEeNowy1+oe3IeEgaIYQcRN0FMbygDOiWMPQmdT1sBtyBJY7y0vyzVSrhuxE7eNWdhQ==
X-Received: by 2002:a05:7022:5f0c:b0:11b:88a7:e1b0 with SMTP id a92af1059eb24-11c9d8539f7mr12036129c88.26.1764318777892;
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:11 +0800
Message-Id: <20251128083219.2332407-5-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
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
 block/bio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index aa43435c15f..2473a2c0d2f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/**
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
+	BUG_ON(1);
 	bio_endio(bio);
 }
 
-- 
2.34.1

