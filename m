Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E575138D7DB
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807652; cv=none; b=erxTIGF6Oi0Bw5hlHrsOdR5yC9Xa0RovK2j17QjvIzp7ApUDCN4SY4wOUYGbL5691n9N3Atvb3+6KkdWb9ogxUrB6EkCpimglxbJGndUJk8ZfN+BHGBWwSZeH0PBhFNUyZ6KwkZeh2GH8fLSUD+gzlXUiS42Bu3xS5zTI8bfcY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807652; c=relaxed/simple;
	bh=sjFh0mGnBKewmEu7ZBywUO603QDbf9VVtuxS1iHS3kk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO7eA5AW07xkFba9Mk+KvwpFhi0uIgHfaoJgYY7T+SsoSYZ7U4rP6+rts/S8Kt7StIIYtXe5A/+IcXqKhE/1kQHu4OGpmOjEsahoxBBbyX4AnliaILrnG4uPleEP9JWuvU/0bT8BCtwrmlS2HdHs/ylLjNWM+dpycv1PDrPi5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=N+MAJGxJ; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="N+MAJGxJ"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71e6f84b77eso12791937b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807650; x=1756412450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hjHCUvozywJVec5GzUlQUBVDNE1xIxaP2hRXA4Ep30=;
        b=N+MAJGxJfTVSv5keiL5UKcNhJcQPSc4prVDQwLcPAj1459CD+ebOxUSqLa7tsh/57O
         isB2WPfAyYk7D3u6TWkQMIbx8DaCMzCWxP3z1yafrWJM2ocQOY/hLuDfXHEUgReZUFmF
         2jrtrZht+L0NZnpijNKnIbF+cA2NV4dZab912RaftofRB0mc0QeSqhdMtxU45mux35tu
         xbpsJAQwaYA4gx/hJJF8mMkap3ovm3yonjJsLYh/p3VqOL+VGIc2IiXhlfGCQNKjk2n5
         tEE4nWVMYhK51djz0SNbbBbG1HGIev8fhFNVFCVblb67t2lpmWsoVpkdjxVGOoArOp0M
         z0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807650; x=1756412450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hjHCUvozywJVec5GzUlQUBVDNE1xIxaP2hRXA4Ep30=;
        b=tBsvtJfibqi8cP5BUqAAYL8iQuj8gDdrgZCYrM3M1RRJ5KROvGw7tPAibGpzj1DqZ3
         he0c7CazAp0an0hcesqjeyQP1LaPdFDAkbD3ilBbNUzTmY+zHcOQ2QhbVxObdllp8AOG
         3B72FMD+xRtf6Es3Q+O2iGUGUZsGn0wgVDlz/Kj/Tu+GwlpJcHCgVsxivsbw2lpMGlpy
         EdUe8tFeIVGfejvQ/1nLcAo0BKDxRtsz3xYjS3kiTkjgYdxJrvfNZ2eCs+vIgEwCB1NJ
         5b1f+FY3r26ylIVsrdwYDHB+j5Lnaepnor6YnQ268Zprw9hx6jX5aEPfHOGLfWpgCjwc
         8IAw==
X-Forwarded-Encrypted: i=1; AJvYcCUlF42xbNlEFjEeIaR5B8tBgpDDNDpP/onv0G/DkuLR+5G4IpyWhnNkoxo5O3WudOZPCz0vK+cyrvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWsdyWWJ93xMUZhLuUx5T1knZZG1XxGigzp5p4vd2p2xTAiQ3J
	XlNx6RN7t39DKXSM0Ltiwlz2ZXFQ8ybadk5hn6ZJT3NlLGCHBByaaSpWUn2ECaj9aXs=
X-Gm-Gg: ASbGncsZicjeeLdJp6qDAdEq9JsA0d3y29UQv3YqBQRRMTFfmnhVK5CwIdzGr0CjH7u
	BTBNnga89Jjb1kdiwwYE1NQyjhEwCN+0zZWQi0wBRwmEY5r/R4rY5Era9+Ni1TDoYHr3MizGdZ+
	wBA9jKFTguSUre3RNME4YvEw5ScSv06A4+si6K4AX8gnrzPFOz7w9txHaeTFduk2hARb4L9JAS8
	6BoIpo+oz8/O7mtk4244+OaV482Njb2vigxb9UAA8WB1oU8nwhZ5dOc14Dky1fLMm4tA0g6MuBT
	Kj4iQia687MKKie0/wstyoGrs0yCELT5Z2+rIxA44iHnGj8VpDyTk/CqcweFg7/UPSwhXjnT+cr
	iONreeRi8QRNxCENBtPxAFPSu9JyrSnuj4M2UD2pZRYpo3YbAD14rqekJQYux8hPO5LHSIQ==
X-Google-Smtp-Source: AGHT+IEkPg2uY+pXs4XweETSWm+kP/bcnOO1B2iny2nX044cCwAOn3B/brJlOgYBup4PziSrybkXoA==
X-Received: by 2002:a05:690c:9a03:b0:71f:9e46:835b with SMTP id 00721157ae682-71fdc2b147emr5716127b3.7.1755807650043;
        Thu, 21 Aug 2025 13:20:50 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e05bf0asm46252867b3.54.2025.08.21.13.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 23/50] fs: update find_inode_*rcu to check the i_count count
Date: Thu, 21 Aug 2025 16:18:34 -0400
Message-ID: <73ac2ba542806f2d43ee4fa444e3032294c9a931.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two helpers are always used under the RCU and don't appear to mind
if the inode state changes in between time of check and time of use.
Update them to use the i_count refcount instead of I_WILL_FREE or
I_FREEING.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 893ac902268b..63ccd32fa221 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1839,7 +1839,7 @@ struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
 
 	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		if (inode->i_sb == sb &&
-		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)) &&
+		    refcount_read(&inode->i_count) > 0 &&
 		    test(inode, data))
 			return inode;
 	}
@@ -1878,8 +1878,8 @@ struct inode *find_inode_by_ino_rcu(struct super_block *sb,
 	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		if (inode->i_ino == ino &&
 		    inode->i_sb == sb &&
-		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)))
-		    return inode;
+		    refcount_read(&inode->i_count) > 0)
+			return inode;
 	}
 	return NULL;
 }
-- 
2.49.0

