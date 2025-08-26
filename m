Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132DA369343
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222899; cv=none; b=S4PbIZvyVw4MUFX3CKYFhayqEXVgcgznQ1iNt4STJqkFZ81+Jo1klcMh+TMUz9AOcdb2fyOdyJnYrTTXgeB/6HgSKKs+jWpnXu+lzzhvPyNxSB0g69BPLBk6mSr+T/gpMfZTJ9Ga1XeOrpOBQ5dP9lgSCMzn8oKq59JYC/7+kGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222899; c=relaxed/simple;
	bh=BXlX6/e3FMWvwMNd0XczwC8NoieaU2IAVI9/xOw4ajQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ0P3sSklzzZ1RoJZe1w7VbG0voIjcUneulcotI2G4HoziM5F+D8ugJLwPNNDFuODOyHmhIMfvIwSAXqayTS/l1WrT1Vvv7sxwpJw4tELef7rReh/qBtLoSgrhIDFqjj+6QfrYCh6PwdIpIUIOQk9TOi4aX4vvqJqKNsRhajQUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=EozQPsVp; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="EozQPsVp"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d60504788so47005607b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222897; x=1756827697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INSJnyvPg2WRednM7++OGWJKHeVt/LRMVDwrRwGwm+I=;
        b=EozQPsVpDqvP6qhtnb5+TIdQFia/oOY7o40GTMwU5MrnqGP+eQX2uDl1Clwz7TmnOA
         mLpIz43D06MCeQ9rmM53PGlsfxLfdtqkJm0DJk+faObSqnD5DGx4RlZ8/YVa4mfGD2ub
         XcZW1YnPpNpwK/oYEZtKHkQ8xNje8sduDljkT1iYM0T0tfytUgufU0sX+fbEu4j1M1NZ
         C1LbB28AeO440O8XQmCNpCt2ToOiM1H21LaF6TlNlj+Gykz8inKgwjG3nyN3r+JpLhPl
         pbqXZPFFnY5tI05E4Xbw7V2v7O6HA2gA4haIK231XNSyizV1CT2JuYPQ56Efy30YnNb4
         YvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222897; x=1756827697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=INSJnyvPg2WRednM7++OGWJKHeVt/LRMVDwrRwGwm+I=;
        b=VhHUcKXZPK8jF1QOWY5TczXgDcZxZZboN9wwZu6T26W0Iei8WS8YJA4VELswPJFECM
         c5/RRohwb5AeGkjqZBwyO4d1VYOzc2kQgmp8SwRqbpDiqZLNVhqGeWKqF3hR8o6HZJRK
         W7h8iL7rHy20nj6GeHWvzZ80hTyTxJKAqwn9tgY6WI41xuwwvbPJ7LGtQPpeIhgPMHhs
         x37NBHAac3iheqAgHRLiUjd6pQlw8fqIHhM0G968W3XaC5OR4qehbDMqlqTkgsQrOZ1P
         Kcafc20Bl1ANWXuDSvyGrpD/ugEDtCHvjeJOaHL4b55gN8Ji6AkLB1NwZpWL79QkdNxT
         CBpA==
X-Forwarded-Encrypted: i=1; AJvYcCVTwoGVpptoPaPdVTtsGt7a5PDX9/dcIWaT8akYoHlau9cz8Uu2Uqce0i4qtfsF3CkB+pyByphlOBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUp0N9Lxi316/WHK6XlyrXq4Ih/tw7FRtQ2n4MarO+9wWfRDbd
	5OmwSpTH2XCvwVMDt2iVKTfZRFEQ2PjzzZgchdCcpSZUX6lE+jbfeMn9uPy3A+EoWfo=
X-Gm-Gg: ASbGncu71v/8dqpfP+ud17fkiEq1Q9ch8VO8/PUwMkCo0XBy0FMJFdx4x//f+QGixFb
	MU8HMMMSTJXKFaaoLsXBJurl2maoKb/xjeKY73mnpypR074X0dB8E7HsVBkvwMZGiIT06mxHVvZ
	uM3shjs0BBZAUV6Wbgt+tgoxvRXo8YhRJy59HQPY6q8UE1+ubau7iGO+u+zSd1Jx0TsWUTTRF1w
	75B90zT6Dj+LFlaLjqNsQg7OQ9UzL7vCiwLoFVq85+L+1iDXyTIlAubCi42uKhFjmtSm+LDJ5F0
	2LRynLgHbaVlEy5PaXFiwe1tVPauO/pkN9v59cIDBMx/AvURaz5jt2WjR03JJp3Zc8TyeDxFruS
	GtyrHDp65EfU2Wq+HqhsaWbrwI7XEG3tLmpKVaJkbLDtlmYjtpgW2pIwFot7b3UXNl/CGKoDakv
	SjI3O+
X-Google-Smtp-Source: AGHT+IH7pEeTz6Uz6BY9mq83w3WefooqttZ9snitZUIdAl5ESrBe4f30t0FX5yPTibQ5HgYDSnEUOw==
X-Received: by 2002:a05:690c:d1d:b0:710:f55f:7922 with SMTP id 00721157ae682-71fdc40106dmr156858857b3.34.1756222896947;
        Tue, 26 Aug 2025 08:41:36 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff170323esm25307497b3.3.2025.08.26.08.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:36 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 33/54] btrfs: don't check I_WILL_FREE|I_FREEING
Date: Tue, 26 Aug 2025 11:39:33 -0400
Message-ID: <af647029b7c50d887744808315c2640bae298337.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs has it's own per-root inode list for snapshot uses, and it has a
sanity check to make sure we're not overwriting a live inode when we add
one to the root's xarray. Change this to check the refcount to validate
it's not a live inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eb9496342346..69aab55648b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3860,7 +3860,7 @@ static int btrfs_add_inode_to_root(struct btrfs_inode *inode, bool prealloc)
 		ASSERT(ret != -ENOMEM);
 		return ret;
 	} else if (existing) {
-		WARN_ON(!(existing->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));
+		WARN_ON(!icount_read(&existing->vfs_inode));
 	}
 
 	return 0;
-- 
2.49.0

