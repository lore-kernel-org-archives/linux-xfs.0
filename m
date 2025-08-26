Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9127335FC33
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222890; cv=none; b=r92OOId9yFCyiardxn9pHnD2bY43XKFNrgEH86OfqkXiz9WA5C+DpUXN6Szavye8XBxzvh49N/xv2N627tKe7DxbzWEv947PiPCryDKetfXs5v/lJHary0yU8MkSBuxt7pfqZe5+BSh3vCe59TBgD8uvDpAfbhBKHT50H1AHJr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222890; c=relaxed/simple;
	bh=sYrjuPeM7K3KQcnfVGtJT+79EiV+VMuzvrHu44CUk/Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXKgW0Nfc3fbIiYPyKTWEiVonwJvlk27VLi4Fn0QbbsB3413Mf1UBeZkmkNwuS1sfnmzcOgaBSVCMStk8MYwOzJ+ckGg2QKhz5gwBDJHWN8PrXN/Z/FsVayPswckQjDpYTLnIXOkfyI0EE3fD8vakVvp3Ld6xmXGQTdjhLSFnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=FMXg1hfO; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="FMXg1hfO"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e96df7ff20eso711583276.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222886; x=1756827686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i/GIckRLBTNo3hmisGAgyU/jYzDZFB7c7b11ZSMovQU=;
        b=FMXg1hfO5kyhbRx15TvhAKipxc646eFXX8N09dcQ0ZrvOlDtdiOZ6QBzaLeUD8Uqh1
         KYWzUTEJYqFUsITnNmSSE3j1aIgG/elk5hEmVTUz/O79Kk5fhV8Dgn6wZT4o47/amYo8
         24mI6kBbZsr+r2ThCZMbzrdLMDZ7kAtoAV3rBSqPCmI5o5hvA8GLifnHjBRZIT2oPgFZ
         UiR6aeTruvxazjljb+zrNd1ctBDo0tRbkc9nS6nQFX4Tf0Wd1nDmujc+YPWXRj5THaAt
         PdjMydNOkgHNptcQ06eQdclHxccA11SsBPowZs7mfbzE2glCsSdGesS3oqHEcP5YsOJS
         p40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222886; x=1756827686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/GIckRLBTNo3hmisGAgyU/jYzDZFB7c7b11ZSMovQU=;
        b=g522COX2llgRoe9xqfO9EBtpHFsBxiho+zFHzVMP90vHvQntV0OtoeJ1lGQ6OeaJMF
         VR7b2257gExUFiZu+utCKImMaTeLml2mFyDfET7vIecQkow0sNM13ufKld4EbVTWFVPc
         E3BkDzgocei9tjiqvTFxJduEQjA7yzFEQ54Ptw9rhg3WBRpCP2sfLJvFuZvPMxFHGCY/
         +8bc8gPQheQ7CtHLOy73SUBWVmDYSgi0wEJsHKK6D++OF+xNoIokcgl/yezgjz+f384C
         ufRsOL4aZThSBz3nx9LyFqVP4ix9OJS40sGmEJstbVHrO7AJw+e47nP8Owq0SFt59oLm
         f8ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUQXJuqSPYJ7Tphlzijd441OOes6+TfjlqMXSvH18UJ5cp79WET9SYl4Q0CGIGQ4lUT/IQZeHrP354=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWDpR4h7yNSjV+Iw2ZNSGMgZtoMqYZ1wlmS6sgoGgYLzVSsJbR
	uNXihNs2N953N1/bDXDg0C5ZEiDjq4zv5LF8tcqGS6Y9IaW0bGNycBU788unzsSKRa0=
X-Gm-Gg: ASbGnctF7fdEuH1daYkWjxXLZDHfGkkJwG698d7/3CSILc71MPGbxEODCgIQkABciAe
	grDG6yZQ0agyt1NYWxCwFJF6hGvsJkRQBeDCXkoVgpz9itG2GdbOdCBBYHAYJ39oBtsZ8Iq92e0
	eSa7yWPuHXeoFupMkZMsR3RCzMN6+0oCp/O70/+6BhmE4TUgrkH1lPigXUEXxUnvIaLoTdYwbn6
	G9ZmMDmUYQpckkc9s6jpnC6cWxLYqjdfVYjN0Q1sN1QvgTgetJodtSyBgi24HYPiQuQSCVkty/Z
	YrHHh0J10xlv1UCmLlZ42Pydf8S7oWiJm2F2aoY8HnC38WF4dxnf91te82qw8iRNbn1wJq/axLA
	Nb1ChBxV8WY5B5YiittXtPvSVsRJbo+dhYtMC1Hgw+XCN8A+1cinw+AUXvemJGZXCH3fNRQ==
X-Google-Smtp-Source: AGHT+IHMjqIN/cv/dNqZaUqk4AIfXq7CeGQ/chI33c+CxPNO4KaD5NOoKQBN/9sJT95k5O4DzOn2ug==
X-Received: by 2002:a05:690c:6d07:b0:71e:84d6:afc4 with SMTP id 00721157ae682-71fdc2e296emr178097767b3.14.1756222886438;
        Tue, 26 Aug 2025 08:41:26 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7213f47d0b0sm159287b3.72.2025.08.26.08.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:25 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 26/54] fs: use igrab in insert_inode_locked
Date: Tue, 26 Aug 2025 11:39:26 -0400
Message-ID: <8e31ead748e11697fff9e4dba0ffe29f082c7c7b.1756222465.git.josef@toxicpanda.com>
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

Follow the same pattern in find_inode*. Instead of checking for
I_WILL_FREE|I_FREEING simply call igrab() and if it succeeds we're done.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8ae9ed9605ef..d34da95a3295 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1883,11 +1883,8 @@ int insert_inode_locked(struct inode *inode)
 				continue;
 			if (old->i_sb != sb)
 				continue;
-			spin_lock(&old->i_lock);
-			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
-				spin_unlock(&old->i_lock);
+			if (!igrab(old))
 				continue;
-			}
 			break;
 		}
 		if (likely(!old)) {
@@ -1899,12 +1896,13 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_hash_lock);
 			return 0;
 		}
+		spin_lock(&old->i_lock);
 		if (unlikely(old->i_state & I_CREATING)) {
 			spin_unlock(&old->i_lock);
 			spin_unlock(&inode_hash_lock);
+			iput(old);
 			return -EBUSY;
 		}
-		__iget(old);
 		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_hash_lock);
 		wait_on_inode(old);
-- 
2.49.0

