Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD0214813;
	Wed, 10 Sep 2025 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499400; cv=none; b=lNrhJnShwAvZt39Jh6aLhI6EZfYzkyXzxIvKzU78wV7mODyAdbLUvvldZsqJn9T1STpOEH5e8z3yew9/1cDIVBxrZQMdIYadtMfgxTv7ufveQIfsnRyCuRPkuHabDDv+krOcD0+n679WstfUfYctIIIIVSY0epmBUbkb8+Yjg5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499400; c=relaxed/simple;
	bh=5WsgoPr0lo5Uw7hXAvjxByjhveCqbww9xMVYrqCn8eE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ummuceoLJiNuUPbm5JOByO4ZC6c6x+Grv7C0nfpz20wWOEYIpbVL2qzR8PAuIRsc+nCkBtKs/9Ur5WfgOodmVrF6XzNGY3d4IBSiZKxCfK4wI3qn+RXG8G8ObCigjztuRt8ZvVkc2clUXjgzCOcQ+Bp+9FC2jxgeKTGsgS5ioIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lnR/9MSC; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lnR/9MSC"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so9389617a12.0;
        Wed, 10 Sep 2025 03:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757499397; x=1758104197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qRSKGpmEYN0/srwW2TqbHPJvdZQo8vau4eyQfT3Zgnw=;
        b=lnR/9MSCsEbC7QbgnU49zsRt3OT5dAVh1U1gP7IaO/tMgqOuR/Lf3tT02dqN6kkeQG
         NWtrELkXYbOqQX7VmhM2ji/SEYZTTXaKCw6uEMNh8xoVTMVdHSpQUeSKFry72MwpCOj6
         J2xsd2KmlL6LdmomUP933AwnB5VR9aJJb3xy0uEF0+4rK6Cn+JmdOlmbmE1hHLv+Z8DE
         IM3KMCNc0DyYZpxVSI0khzsXTh2kk66kaMP5iA2E/WP7wyJgPREo84JUIMawz/8ucZB3
         Yck/6I1/yPreGIPJpkImm/FAB2pBPbDcUhYG+HR/qoagGO0DQFnYGKXZkL+LgkG26L8i
         GlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757499397; x=1758104197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qRSKGpmEYN0/srwW2TqbHPJvdZQo8vau4eyQfT3Zgnw=;
        b=WnVqHj5ISVybSttahBvcZrZb0W4s1Rq14X9gm5rv0PpAZw64XsrUwUPVKI7rJzQybG
         vivd13w8IxD/2K/wN4v36bJ0VRqXceIE1jLotzN06EJ90mrLfWS+bca05T1sTol7erwX
         7RDmHFTSZAQemPtTtq5GtQV+r/MpunwdHyvAPihxYe79hGPIHLajK0g6hOq/YkBn9CD+
         +1fAxvnhlx8Yd0gDeXJETCL8PExrii12s/mlFlBfxveW7Ri0NYtt617Gm4CfeOU2FbbM
         Zng94k9dmdylQb+e9sKMcP+/HbokpADX7rCArUkExVRIbvs1geg0kXXF2Tc3EcMN0NhI
         3yIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhOm5V4HQb7Uxgotyiwv5K3JHugWmnCgKQ/kTxN9BusLddpqT75Kcp/kw1yd3UxS/zW24q4/8i@vger.kernel.org, AJvYcCXkxPio8aWy7CSOEiqsjWKqZvFq6Ub7uMpzVOBN+r4icG6mlS7DQi01sA7VnVAj25eOGF+k5VLqbkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKj4tZqAomlacgq4GnsF5pkWs4KDavM/PY4rTZgB+nxGH9KozV
	fbb+56ImxzsOTvQtuScQWgYTDWMfN0vE74HrRNpKtJEwFxKrRYvvsQBR
X-Gm-Gg: ASbGncu5hTes0R+2H9PP7P3qPQQoVcBX0iJNpuVGG/tWquDCbqA6X7IvbMQDJXkas9B
	i0FOwS/ykgteJFdE8S7x9ArMY3UAgLGtBsIUJ1jAOTxTTJRMxhE0khtI3MTo56MBoGhnJiUyr6t
	jtrBB+Y152mUISp02v+e1+GLSJKEmTZVAjHjzydr80KDALTehw5PMntkv8702dxo5kuFC2WHTcr
	pzrIQofqNfDgp0hQvl+llVQYXMdwiLyrb8rLFeMpkcZdFp7KCX/nY9PUvD/e40LU3spg/9GD00q
	OvVfYMZKlxM63ScRxBdDtjwfF2oninxCRB+ZhQy/ZArD8X4xuKimVAZbjeSykWf6RW3J4EGjhFU
	KT1UX84i7HK6K8KbYHDL5UtRI9l7fGRmxnaEWQJjihK/gJMB8Y+/wSprOAvyzTUHS3wZpe8RvGJ
	8YEELIcI9DHWDxBfh+ErKC/FY=
X-Google-Smtp-Source: AGHT+IETz6aYbUrg7xHdL0EENiwLIIjsRcj8whMW8ha58M9dft6Hjh22MfrHDC/KjHwDc+SdJx0Q8w==
X-Received: by 2002:a05:6402:2347:b0:628:7d38:9ff with SMTP id 4fb4d7f45d1cf-6287d380cf7mr9161856a12.37.1757499397039;
        Wed, 10 Sep 2025 03:16:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62bff34919dsm2872569a12.23.2025.09.10.03.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 03:16:36 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Wed, 10 Sep 2025 12:16:21 +0200
Message-ID: <20250910101622.1967077-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 84712492e6dab803bf595fb8494d11098b74a652 ]

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Greg,

This fixes fstests failure in xfs/606.

The upstream fix applies cleanly to 5.15.y and was already backported
to 6.6.y and 6.1.y by Leah:
https://lore.kernel.org/linux-xfs/20240501184112.3799035-24-leah.rumancik@gmail.com/

Wasn't sure if you'd prefer to keep Leah's SOB and Darrick's ACK from
the 6.1.y backport, so did not keep them.

This is tested and running on our production 5.15 kernel for a while.

Thanks,
Amir.

 fs/xfs/xfs_fsops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5b5b68affe66..2d7467be2a48 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -126,6 +126,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
-- 
2.47.1

