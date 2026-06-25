Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A82F83A2
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 02:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356014; cv=none; b=aJouUh+aJg22k+rE8D5rcSd0VHM049o8HvXBUqLeQkbrncqOXxvuHQ1TlAfNBtnK6MPqacPnqTltoU3KS2FTs1lJHJzght8sZL5mGVL+Z8XMkoHZzfrOeLfmXz3DJqzKJ9QfA+TSnqYNuHJj0luoTibdBiIeoKsHTxEFzylxRSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356014; c=relaxed/simple;
	bh=6dxhHyF91WSlZqBzl9EyOWVa49OuZEaI7GaCTiz/vKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3qB4l3BXQ6PHDe0nkueb2v9fkh9tN93pT2Z34UZKLh9kQA+PmfvM1iM9XeevTSmqMljjR0FlOy/6Sfq7KxREl0gLieaoamYU+idtah5timjxBHMn9lPk0JJknlZ2SelEKh7vcjj6pPosxpWovcyHdS1m+jH77qWYbTHQE1n4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkr12fpZ; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkr12fpZ"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e93e0a3364so1282899a34.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 19:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782356012; x=1782960812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yd1pPCkJlR6akp84WzU0lCGb5TteZ3x/UuL8J+rMeu0=;
        b=dkr12fpZEr1qGkYyRtroLqmK8K+oQqYQ0So7XD9Kvz7TYKebhBW8iRvhQqMzd6y22E
         IEI2xNCNv0Xr8XDgmQ0J1JLWcUVP5HxhyNY4q6rDk7ZXx/RAnYMrnFOQ4SfvomgK44pX
         3Y8zapC67eP3CqF2tUx/1LZkEhMtG+eJBu6B198A6bkcAEv7yy5gSSDsjDoX8NGHyb6h
         OeIpqjOif48JVp08JrFp3vpj2PosdKHl8IPeDuA9AVUycrgLdB4SoAjLroKz5F81teyp
         sHVi9NhrV/0RnkjBabD6ooJdqYSELh/3bwlAP5yJnftQPfPK84YE5g6s7FZWDzuV9wax
         VAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782356012; x=1782960812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yd1pPCkJlR6akp84WzU0lCGb5TteZ3x/UuL8J+rMeu0=;
        b=M9wvecNUjPf+adbKBV9WvGP6u/pXRT/ld5I+K1gulI7jCYGkPRjDQ46Bu8G14H940N
         VOE58xg9aClgh0SXrOs7ZbunYWe/Rje57S1WZL8mO9Zif3W39C2tNsdWDWwnpom/ZOMk
         QVtdF4ZMnn0xbhuSwbv4R2IvlHXQ3RSXbbbMLUsu99abBP0muMhtMCjE0MVU+b747e+H
         O1JkxTlC5hUFliekTUR0qZGTAbd5xpKMYKAIKzljSY+U6d30lovB/5BvAS+FNzBwxZ8+
         y/SGZ5RFjCsyyPpej8HT2d+zaGsjoo/lV0zT8eerFtMTM034R2aB7NFuCULgqQOPj5Fi
         4mzg==
X-Forwarded-Encrypted: i=1; AFNElJ9UMRvD0oZ/8jgn9qrpfce/HHLwkKSwfw1IyEs9c8+rZxPVJBtVvZ1h6syeBKMd+vXMZ803wb7AXO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3YFkL4ky5yasPQVOtE9LeFYTkbbkcYKuA3Phgm+Px16ZoYzD0
	3Kyl5lYWt7o/Jfufs7f+8+f85lZ2GuViIbQ272GolZIkva7JFSMbtb4z
X-Gm-Gg: AfdE7ckgBPv7RTbqejR4oJkXZ3G7cqq/HtzcFKvMhNqwhb7+SMvmHrmzVu/OyZnYnkH
	32a3o7IcS8KS/aLpU5lu0qz3DSE7DHem0gL7KDrQfhl4tKnqfRusPo6Il+slMCV4ZB4JOVxTBhR
	fgoO9XJEK9kAVZSIbwCuAOUlN7cRokZcRZ5ylVqEwAOOFlTX/pvj3vnqqlocI3aWZ4wMaxx/wQg
	UUTtE830JycMCsvjteF+ORv30BxivPCrH4Up+QDYudfQHQzFnFae7hAaY/hXgXM52uyUHTx68Fy
	lMtm2myTfyof/YGE73yOZxQhvKjEyYJ0xHWSNe/Q06hT9dzDai0KYRvOgFmwCbkhYYJMx+WegXD
	3ROTa9MGD/l8x1wZPdZRWk3CtiX4DjZ3YBC7243U2voYS3mm8xhPGqtBxw++XMuQchyEamIcI7e
	kY+J1hvHnq02KgnNlVhb5DzQb2k598ioqTlIl1w6dnqDzrnyQp3sd/sfQlcJXqfaI=
X-Received: by 2002:a05:6830:8291:b0:7e6:ed97:ce5a with SMTP id 46e09a7af769-7e99c2ec47cmr866758a34.4.1782356011974;
        Wed, 24 Jun 2026 19:53:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e94400903csm13852942a34.4.2026.06.24.19.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 19:53:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: hch@lst.de,
	willy@infradead.org,
	djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 2/3] xfs: convert read and buffered write iomap ops to ->iomap_next()
Date: Wed, 24 Jun 2026 19:47:22 -0700
Message-ID: <20260625024723.1611000-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260625024723.1611000-1-joannelkoong@gmail.com>
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert two xfs iomap_ops to the new ->iomap_next() callback as
examples (xfs_read_iomap_ops (no ->iomap_end()) and
xfs_buffered_write_iomap_ops (with ->iomap_end()). Both use the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/xfs/xfs_iomap.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..3b212bfe04d7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -2168,9 +2168,19 @@ xfs_buffered_write_iomap_end(
 	return 0;
 }
 
+static int
+xfs_buffered_write_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap,
+			xfs_buffered_write_iomap_begin,
+			xfs_buffered_write_iomap_end);
+}
+
 const struct iomap_ops xfs_buffered_write_iomap_ops = {
-	.iomap_begin		= xfs_buffered_write_iomap_begin,
-	.iomap_end		= xfs_buffered_write_iomap_end,
+	.iomap_next		= xfs_buffered_write_iomap_next,
 };
 
 static int
@@ -2214,8 +2224,17 @@ xfs_read_iomap_begin(
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
+static int
+xfs_read_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_read_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_read_iomap_ops = {
-	.iomap_begin		= xfs_read_iomap_begin,
+	.iomap_next		= xfs_read_iomap_next,
 };
 
 static int
-- 
2.52.0

