Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EE14F70
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 02:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356008; cv=none; b=aI6IQVsYjrR3DCrN5HVgTQjyulq7MUDzcPKQRNkzzWwcIjZu1w7W3yueOfz5qHpsYHqOfjnwdEPUKudAY44/gYMaOk5r+wwmg8+Sz5sCdZ5syori1TOd1XX8YYli3cPYMqxb9hrERorrFE4E0c89ik6j5GrUGAAKJHnCApdlxlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356008; c=relaxed/simple;
	bh=82P2aAvdbErIb2u2uSt6N0Zq50CMXom0XaepfiVW/Is=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZc2pSeobWNWLws47VZQAru2RNxYWwRW4EjH7BZ5198sOFbjE+LawBhCg5X0tRvTMfLdneXwT5ffQAvDQNxqmD+nuq+6xbkSoZVDGWYmRXCRmWJ8uY+cGI1rzv+/dttl8l2rLeQw8TYz4gkL0LF6oHSM5Rbdc+ku+e3NzkXv11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMKygq89; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMKygq89"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6deacafa8so272318a34.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 19:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782356006; x=1782960806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h4WjU3Axdd/jtiKx3LjuPiSqi4lBo7DMVzuiHhfDMkY=;
        b=SMKygq89bIJ12IVCC4G4cDGt7vngFGAtRDrEtuf65oMRfg7adlonKEMiA4lzrhvB1c
         FsTPeqQB7jznouB9qlB3D9X+xd80xlW+yL62Qrcg3towLAIWNVP1Zst1P7Pq4v6O85Nd
         QVjM6LlQdwVKBstigkPXTNdCieyi3YV0zEaoq2iOLFjgNeT7glZp/5E+SMia3GyH/hBX
         JisqNpSWqMt3XQ7OKFsrlJHhCduuPNqPPP6yWkWot7hep8GYxEqIfz2vYwd4kzqCiSZq
         bD5UXxY7oVhncxB1Ud3NUdxfa+mCNnUXQ1X7jViMufMUhvkNeK587DW6+0g9u1D6aBwP
         IQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782356006; x=1782960806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4WjU3Axdd/jtiKx3LjuPiSqi4lBo7DMVzuiHhfDMkY=;
        b=b+jpou9uUnsH/+5VA/VL//hVZ0Jhw+bIGlqx4SowSHd1ii4xGdJAMF0enILAfvoHm7
         +vxKv9KDHHOTwIhJn4irfkHoJtheOO2oJkNcUUa8lVRp/LPV2gsHO29VCtytxyf6078J
         iwu5nHqZ54UgcUymjC2rRq7KUkwDZhZwH1w/dL380lZCtipJDMnmGHMctmpdwP8aKrsV
         FcWvyJDYN/ikKbgXig59/dCTrEH8sB/+/IWqQiXC1ZrybLWcDjQqp6x89jGGD1+oVnr6
         l9WU+E60V/dhtTUuLqiFMOnInTT4VVdw2j9i+GS+hqpcHoAMM9y+xfkN9b+TNOFoazPr
         x0oQ==
X-Forwarded-Encrypted: i=1; AFNElJ/iuMvutoFY+tDXuZlVdueQC6+QvwTSA9bHG/X/N7QB36+fSKQkxzfweh2mbKqqHNgCvU+hlGfjK8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUaKQKpeAjfxHADT0xKx+mYvjRfz304TZEBqiVUBixV0N8AHVr
	70cliL2A38rOIMqDjWFYqgxaf62oK9SLdsxlBh4Z4CeKVJd0FkyLRJRBdyoZ9A==
X-Gm-Gg: AfdE7cn08opKCkIy0PQ1sl/51cPNN00ic6ujOWUD77dL4dpcMBuWpD2pib3o4zDEJAu
	zThyLO37CubavAxB6cfHfyyR97VjsWMfhwlVlJ8yw8vmLtYV2qVXZMK2+6m40bK+W3JT6oKVfi8
	63pnF4RWeP/uHHaLMss0Bo++lXHxTgbzjU4cL7QDXUVsmgQF2D/8wFx3k7E0uCELcN5b1xZ3vgi
	2apRG4G9zFbCx7EQpk+pH69zRmOB1+fwD+vYJKP5779Z4GpTXbRAy7EPDjk7YxckkCC5uKt51HP
	McN2ujovh8JJQl9RcS/gB5zrSOjif/jngthbDfxCBM2ghLQ1Rvzf0rgJaDVZVYOuPj7i5EnLosE
	QRvcmHrVjn5tW6M6wMWSGbSZ75e3HcCyO92bu+TVysgl60zUH2zxl0dCVEWe0JYCav996PukiKm
	8FtTN52+QvA2h5D6gROPkNdNKjugV6MtGAAttlITHaNLfujb2/taufwRGHTefhS2WQ
X-Received: by 2002:a05:6808:5028:b0:491:ef05:2c0a with SMTP id 5614622812f47-491ef052db3mr1276968b6e.26.1782356006138;
        Wed, 24 Jun 2026 19:53:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aee43c088sm9997162b6e.14.2026.06.24.19.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 19:53:24 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: hch@lst.de,
	willy@infradead.org,
	djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
Date: Wed, 24 Jun 2026 19:47:20 -0700
Message-ID: <20260625024723.1611000-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is submitted to get some feedback on what converting to an in-iter
->iomap_next() model would look like. It revives Matthew's previous RFC [1],
which had the same goal.

The series merges ->iomap_begin()/->iomap_end() into a single ->iomap_next()
callback (patches 1-2) and shows an example of devirtualizing the callbacks on
a hot path so the indirect call through struct iomap_ops is avoided (patch 3).
This series is on top of vfs.all (commit e7a6d06e3c3e8).

A few questions:
* is this roughly the in-iter direction you had in mind?
* is removing the indirect call still worth it? My understanding is that
  indirect calls are cheap on modern eIBRS hardware and the conversion adds
  some per-filesystem boilerplate, so I'm unsure if it carries its weight. If
  not, do you think the in-iter model is still worth having on its own?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u

Joanne Koong (3):
  iomap: add ->iomap_next() and iomap_process() helper
  xfs: convert read and buffered write iomap ops to ->iomap_next()
  xfs: example of devirtualizing buffered write iomap callbacks

 fs/iomap/buffered-io.c |  3 +-
 fs/iomap/iter.c        | 99 ++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_file.c      | 26 +++++++++--
 fs/xfs/xfs_iomap.c     | 29 ++++++++++---
 fs/xfs/xfs_iomap.h     |  7 +++
 include/linux/iomap.h  | 98 ++++++++++++++++++++++++++++++++++++++---
 6 files changed, 231 insertions(+), 31 deletions(-)

-- 
2.52.0

