Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3D36933A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222902; cv=none; b=nXfiBvun8tZy5sVTttwfvZbJGRUHfQ3MT/lqzc5Og9iBImKCcJ24UK5b8cX4xOWAQ0qn2C78RMS5twMvDR97+ugxWvhCocVnPaamzNlJI4TULW7FJh2jpLTWfEm3h3P0HorGLp0Kq46RfCT3uP+kVuJJH7RVG+ud0HfJI96L3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222902; c=relaxed/simple;
	bh=x4c2iqAV39w68dzaJaOLDjwZ1CiAhVhup47lgo1+0KA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaKUVVk4CQn/rjFsZ65DIJU/vcLFMmdDNz6LLpKehiPSwOIIlH+HnQSGP+aSpcz/OfW09oeQNjHIg73XAcFLWutHQ3b5+YRT5o2ZWSy/ZHKYCuvQIkjUlcc996dlZpYtaAghgc63hnQBZ3CtlhG4f/wmx7rFEzw03+teNPfQp2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=d+q91+Ln; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="d+q91+Ln"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d60528734so44380467b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222900; x=1756827700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zphqo+knfBd/U7e2ug3JbW5SVnXfGmWeCnfWX3NqVkc=;
        b=d+q91+LnZeCKIF5NP27wS8hZQE7/PoR4R7ofsaefdHGnVzX4/dD1sKQYT3oudmq/nG
         2JLwDYxzIB5l+1yqc+nrTTC85GCEruVOxvDsD7KCunzaoII1Kv5sdQKsM4AM9YzwGuCn
         kxeMnaQrCB1WYInMXpR22ENyNiAmi7jiuuwFgAI5ikmEenVncS4nIjK1+SvOMNtQOtEk
         rMXjcv+pL2+sraPzhCzF/mCjw9A3/sHvRMPVvjLNv02cIbKROWKyNgghLKoV75POgbJ5
         5cNsRz0LjYOHPj5bZmIy7I3FqFUUyAZrIhPh9mZ2poJyxftf9/i1WhqzKoXb4nCepC9D
         N2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222900; x=1756827700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zphqo+knfBd/U7e2ug3JbW5SVnXfGmWeCnfWX3NqVkc=;
        b=iH1NI4Q7OIqzHw6PfT13b2PZuFfAoOaBZjOqDUZXOfbmboFFisjN0y6/CX9ZPErkRg
         vlaj/TxlW4nZm6iAMmVIVdTkOESMdfRQBVdg5Ljz1l6PLEAFn2b3v9jZKM9zfNgJRWld
         KZxLmFsg+Mlqo3079M3VDJ+GWzxPbHfkhyUKYZ1wRGskk121earkvUZGXqXAlLBuXZSL
         dGneYWzJd14Y3aL3Zr0XegkVYYRZLFl1MCejIJ4FcUPhbRG5W2tTIFJwPfL7JIakxpUT
         WKj637C42vJJY4U1g67V7ZkHzMWYT3l/CBdzjcLTbS1dvDxsXjzhiUUhRcgMN0LziZpQ
         +a2g==
X-Forwarded-Encrypted: i=1; AJvYcCUzcwSh0AE5a5imAOak+i9C0Vtko3HP22mr5He0LVXT5dr5pJzptj0WUoZnm+qqyKWlOdjs8x03U60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5mg4yDuvPYfA4HWZerUSQ/1l5VsG5p2/kUXqVc3CgKqKOkurF
	oNyJ0PTvb6Iy6xKpRnxktM4CgrcbkZVW2kq/ummRmY48MarHarYzR0/9qR/ta1VpI8s=
X-Gm-Gg: ASbGncvtKuwF7GHWcOWQyfjBfnNBhXiIb+APEYjkr358l9hMk/U/xIUItiCZHurvL7d
	jnCD7fHXMRdUW0bqEAMSKu2I16WIb1tO0Cg8Cq+6JM8dqXzCjklYxKMHL04lhzGhYKo1zhIcZCV
	Gt/vbyN/6262FB4U8NZbGODHA1uaQ64+IFbIC9b5LEa/uyU6XJ6+hUWpJoCoXaYv2rtVe7oQQgk
	zjHtIT1+6XL/FmJ1e0HfIReHDSDrTyrBsZuuHIzu0hfPQ1m2ld44ypctLAKc3ClgJg39zf66D3T
	k/1gd1pdKNUcxjnagvrmw1JobX6HzSbEzD781Mh8ymLfvrNrZu7Mv7n6weWJb2Sd1nx851vGKMX
	Vp3ikuCnYSwqhIZLnrDjLEgt01MrdoAU+BQDLbojofI3Xg7vNFfWrndAh4Fs=
X-Google-Smtp-Source: AGHT+IH6IljKhKMKAzfBvsIF2UqCk9sa/1rQsNeda0irdzGfCJ90MbR5GskvJ+4DVKKxRao85tvYhQ==
X-Received: by 2002:a05:690c:ec8:b0:71e:7ee9:839a with SMTP id 00721157ae682-71fdc2f17e3mr171930987b3.2.1756222899935;
        Tue, 26 Aug 2025 08:41:39 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff17354cdsm25393337b3.20.2025.08.26.08.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:39 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 35/54] fs: stop checking I_FREEING in d_find_alias_rcu
Date: Tue, 26 Aug 2025 11:39:35 -0400
Message-ID: <8077a41a37c9088d3118465ca7817048fac35f90.1756222465.git.josef@toxicpanda.com>
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

Instead of checking for I_FREEING, check the refcount of the inode to
see if it is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/dcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 60046ae23d51..3f3bd1373d92 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1072,8 +1072,8 @@ struct dentry *d_find_alias_rcu(struct inode *inode)
 
 	spin_lock(&inode->i_lock);
 	// ->i_dentry and ->i_rcu are colocated, but the latter won't be
-	// used without having I_FREEING set, which means no aliases left
-	if (likely(!(inode->i_state & I_FREEING) && !hlist_empty(l))) {
+	// used without having an i_count reference, which means no aliases left
+	if (likely(icount_read(inode) && !hlist_empty(l))) {
 		if (S_ISDIR(inode->i_mode)) {
 			de = hlist_entry(l->first, struct dentry, d_u.d_alias);
 		} else {
-- 
2.49.0

