Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888AE36298D
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222895; cv=none; b=k+KusiruhJP88iC1QYbasfXjmChvtzoAQzl3bTZ26vsbM5Q89/nD82+H7+WEwpUjToMiWIb9DLJ4xfV1FCR/xUia5vp3vj/hGN+BS1/RENDlH9GIuoF9xzNNfAP/RQyi5+sVcLrkUKF+nG/2IZOL/C7GA+uoQF4PN2/nIqSOGbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222895; c=relaxed/simple;
	bh=HO3qn6E2mu4iKLp4ae70vUhOoqfZurpCVV09CRALkRY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ4qFdLLLvjb1i9D0PAAw2UuzVN7A9pKpQJ0chuuqpyl0cH5DmOVy9irhZFD7gxGVnNT83xNXgXyCA/rVGJuTiDp6sIEO7EgHHbAZQslBCZ4OKs79AtFf4wj8GeL5JRPCg2cYY+zPycs76Dexa9XSE3hNItUyAqm5kFe/ze2nX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=sEstQBzG; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="sEstQBzG"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d60504788so47004777b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222892; x=1756827692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PY21hOB+0muSrNOgrHptmS8Lc85J39c8M537N7BFIe4=;
        b=sEstQBzGN1LPfhVQ2Rz5gE9Q1fD8N/GQEnAqr8Svk8lo2CdmDjEQF4SGIAR45zluP0
         eYc9gFHTsGaJ+dtZ1b/J9RQz2D49IKVzp/y2VeyjzmQ4bx3hzQc5RCDknQ+Km2/yp/S4
         a/QKOnWyx53s6PTckNaPJO1JPJbcp4TurWvzaWUfjUJuoUM84QgQ93egZUHK1rQswQmx
         Zv4Z0enm/kpHqLBS1+a6J1orIP2n65XxzvFIHtFc6xB2YHRhvhC2gOq8mCNS8ptOyljd
         g7Hb1T/EyczmSiiYX3ANbXTUywkeRBNRQ+e6tN6SyQjgCozQuF/0uAbpu265w3FrJLc3
         zu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222892; x=1756827692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PY21hOB+0muSrNOgrHptmS8Lc85J39c8M537N7BFIe4=;
        b=Ot8Q1Ya4E2gF0WHjngi9HXSSLUIrPlEK6XD6e9R/tf8uh/EudkrZOqx3l70TowDLCp
         gaba3ik1IMukduAH/7Ln1s1yWh36+JDJGvdpeiBIA5vhynZZTchN6PtTVw2C3f4nwe+x
         2QImDsoO5hctw+BhaMDCMiO5PgTe8HfIM6lbD/VqgRYJ2seOJxBOPEemLK/PkMHLhKiG
         2xInXaNLjwSBFqsHgWYDZMlcjVmheS4NBCYOqA6iJ6SC1Nx8AO5+JPXzRyN3yok7hGt8
         VFpj/goekZb9iBu9//TyjZcuvySho2JoQW4rGLZBoS+e4VRwbHsMXQoBaHQAsoEp2YpF
         WDkA==
X-Forwarded-Encrypted: i=1; AJvYcCUL38yC4Qr93/RnkoTts+u2NsMN4st8GhvLvO7HAmUCV62nabrxT0mDeFC6qxixhQmfZO2EEqd9T6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNp3SgiL3SNDkPlhOeqrdZfpO2AMgktdZ4cL4RQn1g9sOERtb3
	XYhodIAJ3lVwfxe5xd12tBaUwNwbEexXR/MgExWi2eZtd9OWHLgW+oPgALHY+8EoLYA=
X-Gm-Gg: ASbGncssIZA+h5iU0W40ngaCDQ50lLW6Z64XCMejYCjCnCO4ZIQoZBf8B6rCcX7COUL
	R1H15htQ6IfKgtg6iJ2uyIIv4iR9gx1R3HOhCJTxtRGjzYKJ8Kqm1ZfgmmU/FOSY2VzATz4COZ5
	R9xSNjg3IUMS7MHxPLWJqjUe7nXhwJ9tS4C4KnalrjXxezNQZUbSeh7S+jD2eEkQbs4SBqY38CP
	lMq0/k8/Th1OqiEg275AnjRXrVdh5IJijbsFB1ZeOmzY2Y0v+0u6odfK/RLyVjzu6vYNy0YnLLh
	srBBL4oOmHcQTTgsQGkBkXQexT9Q4U0GMw/hY94uUWLkxQfdsLnWxnAlkqhWrASTs2GBiVjZpbZ
	uWxavOau/wG7CctYz7SeTYr2JL+7t+yk4zRtoCHxymQfsK0ouNoIO7e5yLEk=
X-Google-Smtp-Source: AGHT+IEGTe9J6APE8G1RzLna9v2A4NhqUMcOqyHW3B9fdF1qoADqmNsdHuHOZlvMk5nr/NaX035KJQ==
X-Received: by 2002:a05:690c:7009:b0:720:999:cc91 with SMTP id 00721157ae682-7200999d319mr90958807b3.28.1756222892428;
        Tue, 26 Aug 2025 08:41:32 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f657f58b61sm2303577d50.2.2025.08.26.08.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:31 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 30/54] fs: change evict_dentries_for_decrypted_inodes to use refcount
Date: Tue, 26 Aug 2025 11:39:30 -0400
Message-ID: <283eebefe938d9a1dd4a3a162820058f3550505c.1756222465.git.josef@toxicpanda.com>
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

Instead of checking for I_WILL_FREE|I_FREEING simply use the refcount to
make sure we have a live inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/keyring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7557f6a88b8f..969db498149a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -956,13 +956,16 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 
 	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
 		inode = ci->ci_inode;
+
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
+		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
 
 		shrink_dcache_inode(inode);
-- 
2.49.0

