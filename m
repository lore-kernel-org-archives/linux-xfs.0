Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7A276027
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 04:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758601326; cv=none; b=mMQKZXJXZdeuigvt17zCMRqylO3p6mkTqFQlfYD7Dv4H8iInTLIzoSH/KhhCM3nO4JVpTMZmQ1o/x0F/xpKbQEjT+95IlaeVxsPpM9c/uiIaDWj+ztxnM2c8T+Z7cRnvJyISQqLnplYuh/IiEATm042qODgDpW/OBB2BKiFgLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758601326; c=relaxed/simple;
	bh=XLZkhs9B7s43yPMz0XkRiX5V/b3jeChbEWeI9PX6mdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahRGFDAujh622fF/h/ylEdDB9h730x5t05S/gkako1hGJNeql0aghZHgTHW7Wcz7MgybuuosnNUTF0xUVrO6RjcTKs0Iuvd9MGH05GkMQgl/t2tXILsf/cJUl+5KmTnbs8hwrr0ZRHsNUb9Hqf1OdslGr+mNX8tUYxB4yB1+27g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QIl2bQ0R; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIl2bQ0R"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77f38a9de0bso1633769b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 21:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758601324; x=1759206124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+ep2im58IjxT7DllA4u/z9ICpD6gnUYG9dPd2F5jf0=;
        b=QIl2bQ0R3qkHGbx7wtcI+aq1Qp5wUz3htJv3pN0OdZlkdmfWLWSSifGLkjZpwemfji
         AluDAtJEUXF05VpONny+dYF5n5ijJSCa9OYdjVZGPuRs1YxvnP+T224tr3DoZSNBcv7n
         OwpECYJwBrrWE9w+wwloDs383yekhoHh5ZWHJ/rCgQsnxdkd+LwcpNHJEoUyCCF3fIOu
         0Z05VlM3tNbi7FR8iZFSM+x7hOJP2+XfRVw7eXjSOPJ6oFkney9lfhPw+AhNAZyYwUAn
         tWsncgSBd3AEoMwmBcbVfg/PVqahoKxYiriV3Ugh5xYsU+p/eiMAUqZuUXclQusGIDwh
         Q74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758601324; x=1759206124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+ep2im58IjxT7DllA4u/z9ICpD6gnUYG9dPd2F5jf0=;
        b=NNQVZajnw29VpdoQB3Jh8FRfSxjKwCEsfb7zvIHs+9WUvIu3YlRFPfdra/J6kJVLT7
         oxxVBRkwIjwewxAXsgHyz0dvMwWZ+qxt5dh3XZekllxyfyp5qwuytaowwsTTqj7KlE3Q
         ykyBgl9kFPhfjTHTQEmEq8krHwUBWCtfA6ayTLplMxClrC5WlhOE+nYsq3PjhnEqmmXg
         6zaKK9rledJufFrH1nzXetq6R9T0KygE6xCKqOkkdNtfTrEE/mUblWIt3WJeLKqTqXv1
         qk9QrQZ0S3ndEFzFlNlaeE+rNnHKPsumks7JSeOrrwbYkTB9ebaNAzfLYcLL5CB0f5o9
         V/Og==
X-Gm-Message-State: AOJu0YxkEClmWpbPqn0+ftbsRj73RAKUgI43/bnVOoZaZXa3Dw0G3xHL
	5g4NrCS31u7MUJILPiy2iRQMntEP6EwjLYRjpOmX0/ViRljYxRbOVMXL
X-Gm-Gg: ASbGnctdT7tY3+AO4AVovwQAupY1ArjUF6s7ERHHcqNPEep71H2FYmP6YLCZP5PiIqy
	CuqCevaARWR21i6Ybbu7oORKn9OM3a0LUp7eftpFcnvPeB7YNHXdf47Rx6iJC7in1pnSuXbacuX
	ZIrWLX5tnWiZmmFcctb1L06h9h/TLcv7h8BtNrLYUqENuAXaQhHfBmh1BedEkXnUtUw9Bat9Zm5
	u410IJIATN0xfe4jEjW0OHqVO+6479fEbCls6DaHfuRCb5hFh/FMkuqWgsuuvR9u4Fd0lOCExFw
	e1F06G/wvkbFVIIcTldNyGx1d32aVwK1L2mQXijVfFtN4Ppx3sQuJeEp5RrcZtSsW/OORhgZW6o
	skixCZrA7VpM5rYLHlJ0OeVUeRK6+4ElbFA==
X-Google-Smtp-Source: AGHT+IFYm7cLGFEmVi93jViXMI0vjzoclxblnK03HrQzBTlwHSUg8RgeIuDYR9ocCKvlWOoegY4qwQ==
X-Received: by 2002:a05:6a00:3d13:b0:775:f2cc:c78e with SMTP id d2e1a72fcca58-77f53a83d8emr1675324b3a.21.1758601324334;
        Mon, 22 Sep 2025 21:22:04 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77d8c3adfd4sm13316513b3a.82.2025.09.22.21.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 21:22:04 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	kernel@pankajraghav.com
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v5 1/4] iomap: make sure iomap_adjust_read_range() are aligned with block_size
Date: Tue, 23 Sep 2025 12:21:55 +0800
Message-ID: <20250923042158.1196568-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250923042158.1196568-1-alexjlzheng@tencent.com>
References: <20250923042158.1196568-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

iomap_folio_state marks the uptodate state in units of block_size, so
it is better to check that pos and length are aligned with block_size.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/iomap/buffered-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..ee1b2cd8a4b4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -234,6 +234,9 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	unsigned first = poff >> block_bits;
 	unsigned last = (poff + plen - 1) >> block_bits;
 
+	WARN_ON_ONCE(*pos & (block_size - 1));
+	WARN_ON_ONCE(length & (block_size - 1));
+
 	/*
 	 * If the block size is smaller than the page size, we need to check the
 	 * per-block uptodate status and adjust the offset and length if needed
-- 
2.49.0

