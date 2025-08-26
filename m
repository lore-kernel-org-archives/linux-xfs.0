Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B53568EF
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222870; cv=none; b=EVE0+NK/ltMVjzSMDnkSwgw+0eKSfPXEmAKLaI7nDaGG7FAkQexAE6uud3LLxbuzsoV9m9DiYN5iWGWBwkApTb+sG9pVj+VwoOg3ckMKRNuMp8PqfvUxsxKnVa2GXBloFFrk4A6GT/G4iOjbkOEAENLgzmwcqV9CNvA90qg3yaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222870; c=relaxed/simple;
	bh=nmdvl9jauNYDtI954LQe8Lq2K6dYkRbi47i+ppOrCYk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh0DtAN6EE9jrUhO8oPbbk1GFziK4EJoBeeasByLbZKw9H6oA+Ea638MoNi4K0iTqppo+PDnxUydSx+km9bslDX2xc6FxMXARLAv4mWIkanU9zBIqi3CdwLTLGULs7Dy/NE8YohFcchx8rEmH8zDr0TZgOqu5jJBlixt5HUL31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=q3nfGKKA; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="q3nfGKKA"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d6014810fso46760187b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222865; x=1756827665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+H1oFX30E0HNNRPQLcGTuC/g8Ntf7m1XHDxknfLx+E=;
        b=q3nfGKKAZ9sC0To7VQ+4dnl4vSnn5AndB/eo/ehq0nfeX0TA+WPKYtWxQ0K3eE+p/D
         4oGjW5WZeeFKvMwDUcHG/gvFVrp7Guet6BIdjns6yDOnD+OYcDlGXcSbQ9DhJqV4KIcX
         Wfq3xP1lHv8KhQXyVgpl4D2yuaftpcHXRIRAvP5tLyY4lM8//6gyHmmeLZJb3311RtHL
         UyfzooKIO22PCH8q3XUjQ3dT2vehBYGbdiAA5WtK+uqgxbnHnE9bIsqA2tgL3EB4Pl5z
         fER4PX0iAemjmygv0NazK+WZZBcG81qnJt2qlveFpP3k/OhsUvBF5CMDQil4jn0Yt/US
         b8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222865; x=1756827665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+H1oFX30E0HNNRPQLcGTuC/g8Ntf7m1XHDxknfLx+E=;
        b=hoNE0Cf2EDrs8l+oKcAMDG8IWBKE/iUeg4rrS/jthSm8AF0TD5BaHWc5AqI79ScIGp
         Wnv6v1jGFx4xkfDp137EByRfSyCHQRVbEfUwJcofWgL6oaYt4G48PbTdsptNOAxbcwxU
         RVjA36IcNNffNcamyjayVXFD5ksBcMLmnBHOBo2WuL5tb+64bAFYBlimamOk5vGi03Dp
         YlrM8bhJ7zgQV3/inkPAski18Br8g+nKv3kXn4JZLLnu+wZnIzx5aCskcndk720ObLr0
         QMRAinllYlmTJIX9UmxTalQpDPo+1IIh2h/Uribl+GXzu0Ft7ld2cnk7etW2/Aoe5F3a
         42sA==
X-Forwarded-Encrypted: i=1; AJvYcCU1MrFdQaTh2dAAoSGixZTR07402jeiWvm9/jctgs52DHb57I6mZu2qYSJoEjaKl+Jf9VEcl28xYZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt7tO3rM4StJOFUBT+jm07cUqmWTseOrm+N0xalug9kufLDmUb
	SuQKmbIMYGWma74zOMSnOF2LCu4p5YSm58Icbqt3vMygb6JFoWo+AKIV+kOwdn1SFbQ=
X-Gm-Gg: ASbGnct8udj7Xqt8P+Fpd2OsqgqXD52tgFULuw60IIbDdoHshBK01JvfNR3HXEdhIxg
	MBMjdU+Ez8/+xqu95aP7YDL4qrQSE1s+uEYZj+JLYm+qM6sXI/IobE3BbqBWC3mK6IcerXlv+sc
	IiszDKWPUcXH4T0DWFETeWUOYtgG1TJ/Xw3SmFNwW36zKPvY3mLp60JB6jw9MKphsXA3zEll5LH
	8AB0YQvdIsQjYVcowYilvem5nQytV3+iCU9R99pyjzI5HTidJaazdVHEZP+lNJaib6nf7p6oVU0
	cieQSHb0BcPpLUBaEZWJYpeXgiYk+WuxtADTz3OPHmtt1tbOrnPsgGj4DpMMEMSDTjHzDYyHCwo
	d5fQgOgzYZ/sHOqhmB3j5ur4i+UILHSB1zFQZ13u2ux8KdvLzjre3MgDZYL2n4B8HAn/jCg==
X-Google-Smtp-Source: AGHT+IGf/vXHdzIVCUBDcyspP6L3gezeLKadrkozOYbpyFddznFi3iBWOvI6XcY42p18ka0bO6bSFQ==
X-Received: by 2002:a05:690c:680c:b0:71e:7e24:41e1 with SMTP id 00721157ae682-71fdc3db18fmr172652127b3.32.1756222864568;
        Tue, 26 Aug 2025 08:41:04 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18b3794sm25075497b3.63.2025.08.26.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:03 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 11/54] fs: hold an i_obj_count reference while on the sb inode list
Date: Tue, 26 Aug 2025 11:39:11 -0400
Message-ID: <f5f18f2d7275128e742ef97c7be13de46e65019d.1756222465.git.josef@toxicpanda.com>
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

We are holding this inode on a sb list, make sure we're holding an
i_obj_count reference while it exists on the list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 0ca0a1725b3c..b146b37f7097 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -630,6 +630,7 @@ void inode_sb_list_add(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
+	iobj_get(inode);
 	spin_lock(&sb->s_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb->s_inode_list_lock);
@@ -644,6 +645,7 @@ static inline void inode_sb_list_del(struct inode *inode)
 		spin_lock(&sb->s_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb->s_inode_list_lock);
+		iobj_put(inode);
 	}
 }
 
-- 
2.49.0

