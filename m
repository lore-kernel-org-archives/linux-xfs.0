Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424AD3176EF
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968557; cv=none; b=Ycud+7O79c/iqTnLdoPNUpuLsZzZ9V18N7NXXrIqzHqtijjWgoMURI+gvpkmcVgUncwKlE3FKeocsABpuwYmdGg67BZ3uEDfR2zqb7z7+urQTNzMSG9U7r0/HUgns/0vPQeDJY2Ge+GMkXyIRgyWZI+MCoCuSTl/YHswPZUyL00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968557; c=relaxed/simple;
	bh=GmbQ2jXhDm7vy2iDgaO/7OoZbduITFdgv011FhLwyA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DFNkE3FJ5Nvv0mCg+uRHARgLaoF3fdHgxLe2QBSChRt5xR7Grm64OTtaBjWkx81ErS8drDP0ob+Y4kSNp/f+FGX+YwnV/eQJKhfQ6tT2WqotHM6YxHGxQZ+pTMO575ka/ftOgldG8OvthlL0hNNQfCc14dwWppTy75u6BqwpXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CX3ha1Vl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CX3ha1Vl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760968555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6J67v77z2C8c8cpDHO3kHr83huPFvvnav5l9yd83eE4=;
	b=CX3ha1VleIh+cunoyHcichkuzuXgGys1FR566es+d2fZtXHRZ49Hsq1xUukvdj8PThQzH6
	3OG7f2AS6c9QulFSs1qENTQG5VrB6IJADu8Vvf/gLZsK+0YziGKF0BzVcuposZUG5D4wek
	MDxDQUJReH9HrzYoxHvbhE3nwqunmnk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-kozzmgU_M22rTJQp9KUrqw-1; Mon, 20 Oct 2025 09:55:53 -0400
X-MC-Unique: kozzmgU_M22rTJQp9KUrqw-1
X-Mimecast-MFC-AGG-ID: kozzmgU_M22rTJQp9KUrqw_1760968552
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-470fd5ba449so15568845e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 06:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968551; x=1761573351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6J67v77z2C8c8cpDHO3kHr83huPFvvnav5l9yd83eE4=;
        b=wsZVHVCuKAd4m+eavg5k2ksYUtFvAqBNgnqHLjPKTPaEt7mUAZGAG9p2Wub/BzUGoo
         yd35MgPYNd/hQ8q64530EQarAAnzfFh9Cb+OBGVSwyKLKLE3nClN3WHcj5axzItVHcIV
         PqCrG4FzDyhw9RUrVFr1Hkecx+TxwmEvjOyXjUeqzpCMWanm36gdCAnU94fXbgRw1X4T
         sz7FNbIiN1rzi4z1AR1ZVGi3c0qoiQJc0YzW7PnXItdZqkoh/j5iHxseDBIpzq9V7FNP
         +FVt4c1YtvocdFv/79h0FgTHVwmUL9EOkc4A53D1CFakvL6cb744vnnkj+nVMxs1yEkA
         A/PA==
X-Gm-Message-State: AOJu0YwIRcTIu0038Bz1vTN1ecrWzXrKa/0FNuALf9+uztyRV+kfM7W4
	fWN04stpY8EeBFWws5+au97ef01Ql16p+I6MjiQirM3YEg+9Mbn8wo8L8ydC2/y6v7fXdA0IsJM
	OLcDWt1nWvmq8JyxzJnCfVY5It5TahWetJx1/9tTn2ISm+/D9qt5FfM6hlN3egi58hK5XfpgCpq
	uDWIX2jv12Hxmpjn7dKDt7UbltfMQqELTbcImtgT3ubKaw
X-Gm-Gg: ASbGncunHKeQ0F6vAIpOqF/yEnmorIltUClNdKcYDYQfzVv8TTEo55E3qw0cPfGd8wm
	C0X1Fim35ynSWqEZqOQqEVIwM19u/HPCYK/iTCkQ4Jud55KITiKTN7XWKUK/GAvkzUpD51ZZHK5
	4jc0As/3Vg8QFjD+8yJMRaVF6Ex3+yhn1rrBPkXmk/5o1GCRiQJjr5EY1LdCZaoyoMwB1UKO1z+
	yC+DGl17j7VfsTPFxAbu0nIkiPtTqh7fI8IB+M588/QE7gplAa28JkG12hSYH7Oh4c0kLkIuGfj
	XEjgCa0o7zL2mxWw44VcI70A3FYmpZ9U6HuMk4BDD/aRHzOuARfQ7TRP/gQT6OvCdwgGQN2ly2f
	GxWojhKZwFcxl2uaS4zIeuNzeEEsZUMZQ9A==
X-Received: by 2002:a05:600c:8183:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-4711724e5bcmr97818405e9.7.1760968551407;
        Mon, 20 Oct 2025 06:55:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoNeNjAOEFjzezPaRjRgxNsc3TH8pxblhe4oKdUeogy3uxUDDRaVGenIo3sbIkIFY6QuXKhQ==
X-Received: by 2002:a05:600c:8183:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-4711724e5bcmr97818105e9.7.1760968550781;
        Mon, 20 Oct 2025 06:55:50 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm151404645e9.6.2025.10.20.06.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 06:55:50 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: djwong@kernel.org,
	zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/3] generic/772: split and fix
Date: Mon, 20 Oct 2025 15:55:27 +0200
Message-ID: <20251020135530.1391193-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This one add one missed file attribute flag (n). Then, the check for
file_getattr/file_setattr on regular and special files is lifted to the
common/ for futher test splitting. The generic/772 is split into two
tests one for regular files and one for special files.

This one based on top of Darrick's "random fixes" patchset [1]

To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: zlang@redhat.com
Cc: djwong@kernel.org

[1]: https://lore.kernel.org/fstests/176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs/T/#t

Andrey Albershteyn (3):
  common/filter: add missing file attribute
  generic/772: require filesystem to support file_[g|s]etattr
  generic/772: split this test into 772 and 773 for regular and special
    files

 common/filter         |  2 +-
 common/rc             | 32 +++++++++++++++++
 tests/generic/772     | 41 ++-------------------
 tests/generic/772.out | 14 --------
 tests/generic/773     | 84 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/773.out | 20 +++++++++++
 tests/xfs/648         |  7 ++--
 7 files changed, 142 insertions(+), 58 deletions(-)
 create mode 100755 tests/generic/773
 create mode 100644 tests/generic/773.out

-- 
2.50.1

