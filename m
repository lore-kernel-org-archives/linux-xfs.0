Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EE91ADC78
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820080; cv=none; b=QNks3ToE8sWo+EQva2JF58LIGROaKjhkcfqMLKySCwR5uBSk82jPX82WSqMi5GlMHye4GjS7CUecBBplWprwZ123dsKMYT43QFy5b5GNCPKkdlucRDLPjUfmkYSDy9p6HXptQD8R8KTzipZjDsWACGleEJXpfiq3hg5oXi9tI+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820080; c=relaxed/simple;
	bh=dVBSJiOOVi11iNvcEmkKMmGDmbHm3tYwNWvvGucX194=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HKbWILljzd4585VyZhOfkdcAesaaiBOtL88viSKLT86z0KA6dp9U/om3+Ajq6iFs/3pNpH5bTWWaFBGJfe+VLTxFFpQUI9eDdgv8fi3o+Bik5gRYxp1y9Os4XmJfyOLwO4U3f35m05RItOe//l7x4rb+44P2kwu3kUHv+g7SJaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HusJD87Z; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HusJD87Z"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e5e34f4e89so5323596a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744820077; x=1745424877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ibDdLI0vevNCJBX4MN6eWAH3+C6c+l57rDwHuO6sveo=;
        b=HusJD87Z3y3uCxQR/dhR0Y/8Ymqk6qOoOLo5Nk6Y+IE9vhNSoiwEisLUIFETEjo/0v
         wZ/0ookWVvL80HuexA8QouHT3d6Qu8PpFixorCet79fKpVuPBKSGxTWUjGQdJA3/Pjms
         ffOYj6EZQKaiWWl0LK6vluWjQbsMfWHNyui4Nn8FQWfl0QAN0JdnD7SqJl2CSDKUBjNT
         oWyxll7hcg0Vrdia6IyGLoxT9K+uvz4pQ2ybIBBxQ0A033QYaP34IIGbEIYbGhUnHwWI
         DoPcCxUIaXdv5xWX3nQPL3cGZ+xaJybvnXGgms2o73ffHNUv6nc+da1b0IdPyqUYBmvv
         ryFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744820077; x=1745424877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ibDdLI0vevNCJBX4MN6eWAH3+C6c+l57rDwHuO6sveo=;
        b=jwh/4yEgVZATVhvO4ND+26n496X13MKLJMDLCg8Yj7F7GYY68G6/4uTB7nePbK94A3
         kEwY5R894SlYLfLmy6Bk9x9xzMicK4RpTciFFaNHfKBMin+u59WynZX4iMYwsW0u5JaL
         VNA9fHblsUlkLmt1mnpM5TnOG48hB952JWqYR1a6c+2K0owNFpNh5kElyWe92Lp7B525
         38EiqU5ytKCZ+ScaH89hsPXxz+5+3K3DjZ30thzsJWpq5ql/2n5D8/YUXG7WX6M+IXOH
         Pg5qDen0C5QKPXtGYL8U3GZJA7a/Uc3O2hi2QVbq2ZCvfqj1UUfjttHfHgm3/TgFKdkL
         U2Mw==
X-Gm-Message-State: AOJu0YzMc38E8ws9nTHfkHZH8c74x7qPNgjYpz2xwxds1bUCBlHluV5f
	Ew8FsHz/avZfBruRyXoR3iLRcYcOiutdVd9nQRNbky0s4AWF79hKCx1NCQ==
X-Gm-Gg: ASbGnctw2mVYZRIKcvihcKzPn8ZJ2VDPrKA3e+AwOINloc7jOxkBlNsD1Opi16fPe+4
	cghyKIjtxFEO26lL1K/+nQx3Xavfaj57i/SYShVPV45IGgRgXecVho+qwTHq7GeAeeGb64hks8j
	lTvTl7NwNuw0y7xlXFRbrpFsfTRsEwfshudbKM6FgTaT8mZ5+Bk8o5Qvo7JYySIZ46xDCua8eRo
	5ueC+JQtwnJdtDrqxYfukK/2c39ysOH4WBNGRcNAnv3+HggD89ryeE40uBR8FoV3A6yZZFntCN7
	aDeTYNWRxEQagbBHZv6t5KgWIMICUc7Jtl5qXpQwXfikq9f9CzY=
X-Google-Smtp-Source: AGHT+IH3IoqiyKLjF1fTu0/DaiWC4eZhfzUdfB9PMq8tVBMtHuzeK0DBUk8VSNlgp+BUfYVi3eaKcg==
X-Received: by 2002:a05:6402:849:b0:5f3:4194:187 with SMTP id 4fb4d7f45d1cf-5f4b75a6b98mr2064099a12.18.1744820077044;
        Wed, 16 Apr 2025 09:14:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:b07:646e:16a2:bd58:4cd5:9e66:315c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36f52a48esm8954666a12.79.2025.04.16.09.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 09:14:36 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs_profile: fix permission octet when suid/guid is set
Date: Wed, 16 Apr 2025 18:14:13 +0200
Message-ID: <20250416161422.964167-1-luca.dimaio1@gmail.com>
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

[v1] -> [v2]
Improve masking as suggested

Co-authored-by: Luca Di Maio <luca.dimaio1@gmail.com>
Co-authored-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/xfs_protofile.in | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index e83c39f..9418e7f 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -43,7 +43,9 @@ def stat_to_str(statbuf):
 	else:
 		sgid = '-'

-	perms = stat.S_IMODE(statbuf.st_mode)
+	# We already register suid in the proto string, no need
+	# to also represent it into the octet
+	perms = stat.S_IMODE(statbuf.st_mode) & 0o777

 	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
 			statbuf.st_gid)
--
2.49.0
