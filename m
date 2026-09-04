Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B82C3DB63D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518315; cv=none; b=EJHKTqrgA0JjoRxxvsEVoYvc5DDPvfeWICNG1ljiw0ATs3sF2FMGcL8qtGA5vKBiitiD/f2Jow5CtPSi/cd7FdquddP4RB6mvg5DAeMqPMljU0Dj9L1roKa5dG945hJf8FHHeV32l+8gzkkCALNzqM7oFLAhO2K9xj4Y6WYpq1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518315; c=relaxed/simple;
	bh=SdRR4fcKxcRTFw9bfWJRp5SlS6dI7EoBJe2ABZ5ulMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASboay7ZZr/zPKWEvKFfLPuswMONRqToTkrMSEyyKDhJTRjJWdfNXKnYvmkuGJF4+IQ9uGgDlSw3HEIl601i4rDBT5GPOhLX0hqoS9IBaHGBquCajLC54n/jBt27lfw4hcCZ9j+H0y95MJvqe0jCrRpinBgvwbhehFGM+TD/H38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f0Rj4d9A; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f0Rj4d9A"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1430549a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 03:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518312; x=1789123112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1bp/UiAEsf0pmjXU3iYT4sNFD6WOY1SWoYTBFGtvNsk=;
        b=f0Rj4d9AVG/k3pJfxMZ8A5shyFt0rYzP0fcplpGcxxwFvgU8XWU+FDKvGCR+ZpsvjV
         GVzZriWdwnXkRr/oRDjXElamex0nPkYhJOy4q7iGtkLgwfhO44I5CM9nLAFpsXRNLWhL
         UCEWRizgCR18LdV8eArVKmfojPcQO+9IgeUngtBjvouMP3Z+l/7ORy8fU8szWKiWFa5j
         x9n9xE2si3BHSEnXsZTlVl9QXNnfZM22am/DAPaifsO2bbFAwpVqcT3N8coC+VO/bb2c
         99yJ4J7mU6ZMqgZWwEhQyQ++7IHZkzL4iGn9p+MIzYjAP/NpWNkpmz1xVH+Zz2T8djkb
         5Y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518312; x=1789123112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1bp/UiAEsf0pmjXU3iYT4sNFD6WOY1SWoYTBFGtvNsk=;
        b=drXu+OD8c5h1qtZnYhUnG1sFUVNE0jnc2bCSQMWZilUvCo6zZg27JkGp9i++VvlAru
         1fEnZt8vHj+PusmQH7Lux31+TqVOoVC9w86K3XjLNrXwyjhR4ejx80dfLL0FqDsYVdS5
         vNqafbGf0iTpVcoyFEYru84VCH/zUWmeGs1sG2mTzE5hiqcqb4anYHXd5SFYaI3vDQta
         EuQi8iu6OGgL7AaG231Sku7ANlm3f+PxAHqIsFnVebH5Wp+hQFBiRnvFLPS7+Zpjq8nR
         EDwVlPd514lO/xGh9nnZ4LUcCi/uMUVIloVCic8y7Obg6KiVXMsL4Rw6KvvZmLMt1BsB
         Uthw==
X-Forwarded-Encrypted: i=1; AKwUvBzMze85wM4ufE5nZD6Kmn39tKLrRU1/5p8aS/fCy4/Bqxtz1x91V8369udCl+j01+x3HkJSc9HY+tw=@vger.kernel.org
X-Gm-Message-State: AFuF++kc5jHqA3/p60LTj4UB/LF6Rxb7uof42f2riF2wHVvI/MKlVHXS
	wZ0iBS4WyD6OwYgfegDtfNLgkWIxPD01lIKJw0it4uANPgz3CEQAdCTL
X-Gm-Gg: AYBFou26ghc6vTC+gsOfpA+5Gl2SF5FQ14TonN+A3W9D8eynjLkgntj2TLwiwBQWona
	X9bCwXJwB76j0EJPxyVIqcUSL0C9sjh87hFZ+hyY+TDqjDLVZrEp/Rhajc9/dEz8vtgU+hlq5pj
	N71I+3Q1iOUoZo3DsbNx1X1AErkUFW1+RAapzfToxAY4XuJuWv7eaV9LyVBvMeOmkhpnh8Jor+Q
	FuFeOXNh5W7daor0Jk1fZ/XTS7R3IejU5AF7ZaeCUU/7XnvIPyG4HDZeH/kXgEFZrm3E9JXxUpZ
	upxgJcTyFiU5UsNF3SPvtnw6sYdGTXcC56p8BmegOa/RX/g1o/W0rnZy9LiwiDSxXDwAny5uyz7
	qMpLONJr4AaXRaMJjs8oet7wNj2Q7sfH59FHyxqy7cZAJJqDHx7Mm/N7Wt4uvpVTVlx5w9hPbJi
	cr40WtV2EnczgkVBYUUEYdX27QEEa19wawEBiPt4QJ8dgrstfVWfa8qoJ7nqT5s8hWCldZEIhwx
	+SPMHBlBWTw5uKmaC/KbOJZxbM=
X-Received: by 2002:a17:90a:7784:b0:39b:2b1f:4511 with SMTP id 98e67ed59e1d1-39b2b1f52c4mr2665889a91.26.1788518312101;
        Fri, 04 Sep 2026 03:38:32 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa33e96sm6021835eec.12.2026.09.04.03.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:38:31 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] iomap: fix typo "metdata" in comment
Date: Fri,  4 Sep 2026 16:08:22 +0530
Message-ID: <20260904103825.8752-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904103825.8752-1-hemanth.selam@gmail.com>
References: <20260904103825.8752-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "metdata" to "metadata", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/iomap/direct-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..b70f86292049 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -505,7 +505,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 		 * We can only do inline completion for pure overwrites that
 		 * don't require additional I/O at completion time.
 		 *
-		 * This rules out writes that need zeroing or metdata updates to
+		 * This rules out writes that need zeroing or metadata updates to
 		 * convert unwritten or shared extents.
 		 *
 		 * Writes that extend i_size are also not supported, but this is
-- 
2.48.1

