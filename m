Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0304283C94
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396604; cv=none; b=JlXsozSSzBObmWAln6kz6Gzar0pD+0yEb0OsvTwinOit5ZYnjQVIQZrg47LZ+DUExcAlPC8WzqRHEx+Xr4LqGnlgIgbYPoqQtw8Db0nJO7wB4hxO6NFDtdf3d8PkdPpJIAGPZxAgnz0NmxtRW6ucAIjQ4Ro0zA3tsu5Z5USSstQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396604; c=relaxed/simple;
	bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEYG7FNovcKlEIrRdX2Wn2DhtkeSLxMieNx5I9Vs0AiL+mXEykxCjZmUav6no+bCcrLSOjd68bG9u89GrVyMUKRZHzVFAbdppeYd1xJW+sHeiWqVpPvOiqkUeRMiY1/LnD+u8UFujrr8u2ZANRHp5LzIYlgOD+Cl/9lUu4BekIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zuh3tBH0; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zuh3tBH0"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3828232f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 01:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745396601; x=1746001401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=Zuh3tBH05nfBLUqkS4Q5yYdxLR/C0EgDBYM1I9PH2S58urIZuZ9PvbY2mZ8ZmTbGdK
         4Cg3xDgbJDKb1p+z0vMOaIs5RJ293guZk046jueFOQI5t6w+5UoVMObRiAiEwAnn3ZgZ
         XEf9WrxdDswg9aY/6JoC903Inky3kj1a0vbGRRZSA20BASo6M+QrXqmYoXXfyPKja8hf
         SBGFdW3HgalRQV92lBOxJQY9Avhb+aWLlFGGhZCzcOnC5bnEoUMZky0af/881hP8h0Mi
         xjX+QuZi4opi7GYuwtjDTLAn7aPnwCdWS7mUnzA9X6d+0ApkIF0lqmQZFTv7buVHrJ6U
         YEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745396601; x=1746001401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=glr1kIo49mIz8z88RTLkiFAFBKtwSJIdq/jNRxIJeKPAmK05xx2MWU0adTFi0XBzOr
         DdPC5brMueP2CIhYSeUqU5f31KGH+9xJ39b3/ThJqwJozRm6X5hJqrvaZM9+41povDqC
         aVhHlOOsKXbj7GHEue9HpNitLP2T7UHxHhWaotl1DuIwQHfJsdmLfY36QXRtUzu+Ra/y
         KOOBQFqRs76ahASjcL7IkUNmK92HCVe2tjAHhwbejT6Ae7/N8RgF45SPvHmLI9DFL/E+
         SScIvb/sPAQi1eP9Gdle1hzWZGjV7J1xwZIKHMtj6Ver0+dgLpOnwVNXazaAaDyQ1Gpi
         8QaA==
X-Gm-Message-State: AOJu0Yyn+003+6BQZDIhFGZdOAXZX/+VIUkDIUg9dFYPpxJzi+s+BsMw
	Fp5uzOE+yk1DCDKZ9bBVcX9BI/kjra+RsjVW5+PZnrBcKQW7GUT6m1Wguw==
X-Gm-Gg: ASbGncvLZOVNanS9BfWxJFVtmI62UY7e4ECT+TaWBwzYBgx7ODgtY+gC6VK0KXXYoiU
	yLCR+aPYT8tjg2hZJ36Mgipm27eRTPkQ43Vzwzxi4C15RqAqFyop4cvhvH4yGLu4tztutPM9kSj
	Ju/twtH4JQ1uv2EcqdJ7I7f7d5QtloJneRqd24aelkyQTB6j7+tVh4khsvvlU73bobc3BI6DVMw
	cEe3wv5YKqv0XN0azF/qgmZYPrywhcCafMK+D/4dFPnPi/0VuyW2CPUyRjJOp33VZjUjBjRWwq3
	sGiy1d+FmWiA/SiUHM0Yf+TB20Ti6ZY=
X-Google-Smtp-Source: AGHT+IF9QfFCa5rZ7P5rPtE3ZHyC3J/7r69gbSjeOCkeVjNGvXqpq9FkqfyXzHVP5wgB5n2q/99vhA==
X-Received: by 2002:a05:6000:25f7:b0:39c:1efb:ec8e with SMTP id ffacd0b85a97d-39efba263d8mr12882375f8f.6.1745396600097;
        Wed, 23 Apr 2025 01:23:20 -0700 (PDT)
Received: from localhost.localdomain ([78.208.91.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c37sm18345313f8f.98.2025.04.23.01.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 01:23:19 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v4 3/4] man: document -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 10:22:45 +0200
Message-ID: <20250423082246.572483-4-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423082246.572483-1-luca.dimaio1@gmail.com>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the -P flag into man page.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88..507a2f9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1291,6 +1291,13 @@ creating the file system.
 .B \-K
 Do not attempt to discard blocks at mkfs time.
 .TP
+.BI \-P " directory"
+Populate the filesystem starting from a
+.IR directory .
+This will copy the contents of the given directory into the root directory of
+the filesystem. Ownership, Extended attributes, Permissions and timestamps will
+be preserved from the source.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH Configuration File Format
--
2.49.0
