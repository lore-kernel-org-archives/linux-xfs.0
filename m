Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DAA284B37
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734711; cv=none; b=EdE6duZrNnbWR4+qXPTJzsZKFBR5qBlZIfcBqm69PDjNNRh58BX03dKpVkTzv4Hlpv6+PwWgvTCf99WRPlvm9EYgMXQorIvdEj5g3q9ahqP65QDhM8M4JbtX8acVMYw98DyPNSzOcwVFwSi/Cozze4O8l01tSd5Zlabcn8/TMj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734711; c=relaxed/simple;
	bh=Gxk0sEzaoSe6VlllYrbpg0OQx06bmUypx376lLazOAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZZTql0RIfpPQa9biqr2mf1XW8a4Sl2iTsZsZqbXbfJwi0qfgiovY86GZbdxi8GAUVkHfp8tvfAJOXpqnUKb1mgB3Lms2uPEYz9SHDHDkzNA2WHslCqvoBw77Vntg09/DN641VXUGFv+KfgeMJ6ye9+cCgQ6GlewqRyuCWzCuNog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3qKmR1M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3qKmR1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kadtEc6XcQ4iDH67DyLSEX0+QliysQnNpS7dMO0XPTo=;
	b=i3qKmR1MRECL0JwbLXHoP2pq1te0bmPVMKqKi/l3tCzT4rbHNbJJjrz5cKG2KJiP8z/cJK
	HNiQQer3qG1RSLWXnTLBg1FNSRsp8MIUNJQgAIVjkWb/U1OIioYmp+Ab2xyRhzAlSkHZVx
	nZagK/KO4N7EiYV2A9uMuzIp+Z/M0Es=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-RHr6x9H6PRKaEMGiokHcuA-1; Mon, 28 Jul 2025 16:31:47 -0400
X-MC-Unique: RHr6x9H6PRKaEMGiokHcuA-1
X-Mimecast-MFC-AGG-ID: RHr6x9H6PRKaEMGiokHcuA_1753734706
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ae3b2630529so478622766b.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734706; x=1754339506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kadtEc6XcQ4iDH67DyLSEX0+QliysQnNpS7dMO0XPTo=;
        b=LoItl+tN5uFNimsUmHeBIOWGRf3eNJxrSpNu9szL0FmaExG54XpPoc5DfcQHLo98Zc
         sampOg0gwqo2EJwAsjuTnRJqNgVjOzMiTv8hCO6zWD5nMZRJNAWZ9jtEP3i6v8uUgAQy
         gPCNsN0Hroe3lbvTVIvf4+M8G8XB8C5AbJLDBkHSut00XYMw/WYAK1LZ1LKhzTl/o0KL
         r62hxTKVQmOi564Wk/hKqj/mvpUP2IMyVOu1s1hsX39bsWSA0HMYUxjkkxAZu9ug+dAy
         LCxNKTUu+16lwn2+mcMHsc3hnPG0KZk7wQ9Rks8MRe3TkgEjlqLbvvTHjK6HhNn5ZFGb
         YbzA==
X-Forwarded-Encrypted: i=1; AJvYcCVwfAWdkxi2FbAdhSSMAwZybjvwFje3Sg9wfqCAVnQRzlb/Hm6E6d71xjSqXY/9l2/Pb3iCWR9iq/M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+8/hmN0dEBmFw4qPwd8CO8aA5wX2If63JP55AkuPCc1mZyesB
	nVawtfb+9Y2ES7hwYfXd1Q2FDX18Zk95rZqLTUlOg92CpsbYcLl8ZaXDRv36CPP4bz0qBgqPUxp
	dHl2Ou9r/PvA9iDUiwoHjbQzqKpNuH75y2+YC71SahgkMSByNkV5otV6wEazv
X-Gm-Gg: ASbGncssDJipBpT36C7Eh7w2IRNct6mRRkEN/Saaa5q6BzxP3ZnvkMq1kAHn7+l1tq5
	hvt7/2WqmBUPt+immFZtom4wO5L6tM1yqfNPVzVOiwwrYmcpCGNK7/8vPqx0tPxaKcHeyRtGx9p
	UEk9ftdJRgbASchQVm8l9ZJgipjFAdiRNxbboaBYDdGeWJCoURS5W+gtvtxJuDaW14Sb8uYftn/
	IIGrSGY0tGwDr5fjjvFUr/6i8uL9C2E2VVerBh8EZ9+pw6NKo/ixzGpAGAgeUwkMoeKN2l5xuB/
	JsErMJ4U+lkqbm9lgStBGNXeFgQWBDH6mMk6lZxtixd5VQ==
X-Received: by 2002:a05:6402:5192:b0:615:5353:5e2c with SMTP id 4fb4d7f45d1cf-61553535e94mr3299443a12.19.1753734705932;
        Mon, 28 Jul 2025 13:31:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3EwyequldE0yYkC1LWl4McATzdbfZq53i6FBVks/dB/ZeKteI7CUgbwJVMwJBiBKyVNXP/g==
X-Received: by 2002:a05:6402:5192:b0:615:5353:5e2c with SMTP id 4fb4d7f45d1cf-61553535e94mr3299415a12.19.1753734705480;
        Mon, 28 Jul 2025 13:31:45 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:45 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:28 +0200
Subject: [PATCH RFC 24/29] xfs: advertise fs-verity being available on
 filesystem
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-24-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1332; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=be/wykvZj9niA0ffxchNInZGSfvYSVY4KIFdLfTfwME=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSYRrfQqvnTzJc5kOT/JrS84vL0XmhAgsfH5pq
 8F5meCH/Zs7SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATGRrCiPDLTc2e0bHNdE+
 ZTv3y03+6GC6vfw5Y0DUwsuTXHYarsj5wciwmf3qDcFU7373qwYy2uUMDF1nvy9wPP6tYMf9+lU
 917awAwDOlUbj
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 12463ba766da..9d07c7872e94 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e32cd2874bcd..7507518a1c72 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1575,6 +1575,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

-- 
2.50.0

