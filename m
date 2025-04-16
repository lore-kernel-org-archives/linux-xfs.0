Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E433184E
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806926; cv=none; b=kERyShuLt4gom+BOkg1iiwqzkvR+zrZ8uDYfCR/hLaOzz8ToQqPXRu+AwFiTpWUezm7DhJAh4zMwdHe5R2IO5VglCmpjb3dtN/2Vr/t1AZSbTZTxrpvCEmm5Dd26mj4w/KqNH7HFjfIbLJoBZEKCHoYYxi54W0W2ECzOE5JYtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806926; c=relaxed/simple;
	bh=RjVmTnbH9by5t4s/1XZ4AoGezgfn6bGdh/peOeOzxe0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p919T3Xv9wNlzMJT0xORxwb0lidloaOMuEYWPiKKMXPI+m8LB9gWzg32Xu5rgMDck25epKGrMWaMNRzGG8zyHBhx4xdVJVf6Vh3msImrTgWIOEOuAY2wjc0Dzuu6hq3XW4qsF4zKxhByHspolOkEc0IFsTh9yqTuOa2hSINGYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLxy4fhJ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLxy4fhJ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e5e8274a74so10620508a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744806923; x=1745411723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Anb+fGjZGPEPmLTq1FG2wZiIGzx4zkdpjhongqmhlE=;
        b=DLxy4fhJO72G2n+kW7w5n5PqJi4kZipaX0i6NzcUEi/Yw3giU5Da3YmGK65bF3W3Gj
         It/Jc1z1fdDCtEWqh3frLI5SwfKeOeOzwb0U2DB+YNTmT3Zm6WjYkRtRbZITc2NYZqdT
         1x0sx3SFtnH4J/sT8CBTuSjz7eBZX+IJMmJ0yIQyhRzN+p42X7afPzMm8Qlj7uGXJ/6w
         4tvOPknamJgL1Z9bitxBBp8YBYIWM7vjxW6dvtO3Lt0uxhf5cTsXNOZFq2F6pdLa+nme
         Svgd6A/RvV6beXenHNmm6gozKherOPPI0eBM7sLM4wlwBzqgdIg3zoueE46adJUrm5NB
         g8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744806923; x=1745411723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Anb+fGjZGPEPmLTq1FG2wZiIGzx4zkdpjhongqmhlE=;
        b=vp/7SwfJAoQtrUPTuA1cpcS7LfygpPabXQychioLW48Q+91EvV9zoetmB1cMcbBgw5
         /FdGA5qWy3Kxt3dIS/dSLCmnU6xFouTDlwrmlfMhidcud92pg3Ba7weceqz4/mnn9Y3j
         poZ2NrP0AgCN3VN7idLuuWQc/JfFiXaRS/v58fuDGRhEEqL9nbGqUec0RTQtQ5Xw6gv6
         39jZqswVzE1JNfzo3Hf0RSMgBy9fygGrnAdAMj4Ay8Ptzu5PJLxFmNiTe9kbiVPx+TaA
         9VV+ijL2C3dSNM3SeCmsbkJfHyvs7NhHdpD92eBG7S1tmLfCK//HizI4HPNFs0Izkaxx
         kNwA==
X-Gm-Message-State: AOJu0Ywq+qpWGwWYVhekK2W3pC9sYGNFuszb3QAvwV7ayeSPXFlTvbix
	0nXQuU3sl4206qdQIAdZ+65L9jS62HQBOOhS+6A434fT3TAVCuL/7+COYA==
X-Gm-Gg: ASbGnctjpS/VUsxYAZrOBfqyhyjbUPdP9Jx3rJiueB06+U5Cu6HYgMImNRBLMLS3X7k
	e1Koen5fDD7eiS0OEx6/JXJBGEnS6Sny25ADd9v8VCpA1qKL/MiNwfFcu4aGv8EdZE4ysVKikNM
	GjK5Vmnz6qRQdPrk3yXp1dlNOCBVA9AyI71/3hWF+ftRwzlRqDetg7xIykLOQeIIXD3snlP9pKs
	LD2OhFp4W+2caJw0nK9K4+u1kQJNaZdXZCpiIUksTi/Z7bgLrQbR4xYePGcPSeu50PwcitL0HiG
	H0EMYCVojlAYF1WbCwO3kmiMVEuqb7NB+VEAabrZkBWFO43icpFKtr+xSg==
X-Google-Smtp-Source: AGHT+IFgBrRZ4p1EHSl/J8Hl5UG2QThQS4Gzon0ej8sULTBvEvi91BtN6VpDtRuDlXUUVQBFJO0FRg==
X-Received: by 2002:a05:6402:90e:b0:5f3:4ac5:9b84 with SMTP id 4fb4d7f45d1cf-5f4b733f025mr1574392a12.17.1744806922497;
        Wed, 16 Apr 2025 05:35:22 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e11:3:1ff0:6b28:66a8:2f33:6258])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f4aee673c7sm971945a12.69.2025.04.16.05.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 05:35:22 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: [PATCH] xfs_profile: fix permission octet when suid/guid is set
Date: Wed, 16 Apr 2025 14:35:00 +0200
Message-ID: <20250416123508.900340-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When encountering suid or sgid files, we already set the `u` or `g` property
in the prototype file.
Given that proto.c only supports three numbers for permissions, we need to
remove the redundant information from the permission, else it was incorrectly
parsed.

Before:

    wall                                    --g2755 0 0 rootfs/usr/bin/wall
    sudo                                    -u-4755 0 0 rootfs/usr/bin/sudo

This wrongly generates (suid + 475 permissions):

    -r-Srwxr-x. 1 root root 514704 Apr 16 11:56 /usr/bin/su


After:

    wall                                    --g755 0 0 rootfs/usr/bin/wall
    sudo                                    -u-755 0 0 rootfs/usr/bin/sudo

This correctly generates (suid + 755 permissions):

    -rwsr-xr-x 1 root root 514704 Apr 16 11:56 /usr/bin/su

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/xfs_protofile.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index e83c39f..9672ca3 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -43,7 +43,13 @@ def stat_to_str(statbuf):
 	else:
 		sgid = '-'

+	# We already register suid in the proto string, no need
+	# to also represent it into the octet
 	perms = stat.S_IMODE(statbuf.st_mode)
+	if suid == 'u':
+		perms = perms & ~stat.S_ISUID
+	if sgid == 'g':
+		perms = perms & ~stat.S_ISGID

 	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
 			statbuf.st_gid)
2.49.0
