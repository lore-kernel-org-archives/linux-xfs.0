Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA382E8E0E
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 08:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996813; cv=none; b=thIdcox92IJytT2Dg3789mag80O+tRoWtJXaulGxndA0LvxYfgXhkGNu9gam+SBL7qQIm0OMdJCYlAZiLc+By9tFIf2AHyM30BCNsGkUDdX2h9TbBYBktrQe+v3pXd7LBkqJMpRsmuy94tpe6pqkONylY0ykaQqC76Ohgn7KAN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996813; c=relaxed/simple;
	bh=xlG7nR5Wpn4toAnFh4yZG5U7bqMO2Ibqli2pgrWdpe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCvVSyBCuxi4gi9GGB2bJKWfBuCSR1yvmoqHiRrTVW2vmtB1rmfUvmEbdStEPg7l+ME5hMtCTJSwS+PuKVJ3zWnO1f0TMZuASk8jgBTNwsBe7BiriYaDhueVYUqLA4QgA1sKcGRJa4iBhshR9hPw5qB0G8iWKJoZocz+M7AY00A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbvDejU9; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbvDejU9"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b4f323cf89bso117646266b.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996809; x=1760601609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5cEv8KCvxqRx2Vo792Uxij3yHT/Pkk8+e6W56mfmGo=;
        b=SbvDejU9ggXuvwZcyBQN7Wh/w7QFoavPE+9gM8uuiuVmO1ELw5sKW93FFpq0UEpTkq
         Ryj/7rO/SHMvr+NwtFE5QTSf5WS341LygOQn3KW7t0vLGZCQTLjHrjRyobIyOLnCITUf
         tzlzCFocGJ4GpNMGGc8xHvX9bSHUppgKd1qcC+NjyZxY8Z7hp+K3ixktQxfiZtv7ESnw
         xndW9hExYjaGy3CHpa5bkadYCG5PWfhGVNiCZT9uLlc+c8hEjNrRTCQ82+h6MLHDdNu/
         WvQgPk7LktcDwjsfXh7eYvK/3q2818LaXoD+P0Hwqy+j8s9Z8YVRBE6t9qPBrNSb0JHf
         54fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996809; x=1760601609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5cEv8KCvxqRx2Vo792Uxij3yHT/Pkk8+e6W56mfmGo=;
        b=oNFTDrxq/JmLE/9UwnMdvBJuIePYtsv+1aul0+eLH0gT/JxCUE9GM0UrGIqQAHaRFP
         V6pcMfFiFzGHJ06SL/qpmEGpJQrfu2DuLBQW31gVoPiDWicr2hRMHEd0bvi8h3VEEEMO
         tO6st4/JZYETmaOcFnJHgtaUp63jAwpo3pkgDhFshMWsFPtJ6/UxiKHFke02VxsGfz/i
         68a88XmQ9R9MHcXnbcL2j7t2A3BfWrW3oBRVN3FIFEN8jPaPGiG/7HOpSsfa3OR03QnN
         gB+ASETjvpYWVwhcVEzxPniniNi7POs7Q7XVIK9BXPKYBJFgHinxL1rrjkfhUQhDS45p
         0FAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIsyMNH6RkMIBk8NXZjkaseebPcMkfjw4LOiD7UnOSwwHBxS9+M5aMJlJxHergd/KTkgwP+aG6SbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqyjBQcU0v9Zoejikr+p5lKvLzWYR99ohb0ilpvVghW5f/zZy3
	oZT5BluU+DHzLEuha8uAYzZyADcs6RsIkdI+5/AwHK9CRr4iaA8HwQAp
X-Gm-Gg: ASbGncsdPKnHtOC3m+RglSl+bpW5zz6T0ABefAiY3vHbRzrBdiDkaE4jUCweAlCWiv8
	Keg2f90YSA2J7WWFh10qK9IrYrS+M9KQjO4dyEXxQJTfOCCCRtswl0da0QDENv2fwjRxsy9Vs40
	+SVP0jbbMVD+5C6YWBzXJ55vFDNHlHJu74LC97Vvi/VdCQoLMYHCPSnXrs6n39rqmoL/RHgEQxB
	vwoMOtBVQqRuHotFUpWN1yDO6tBaZpFxRhg6cpNwf/wJQVhncUHfduw7me6CsNVqNID4wCy9QZR
	0kkUWI8pScpsqhgVbQz2uUZQhUEmoFA67vKwaop1TLjIAiuahQeiwmV3fF0l039M2FlKuKYhxwz
	iPW5GF3Ck5SyZ2+8IuYdXHZ0zlaYFneoMUjFzcH1OfXj61nAXOnd+v681mzrz4WWOLzBzgKTEYF
	prOQdaRpK4Gu28CQKY8hapvGx4Iumwjr9u
X-Google-Smtp-Source: AGHT+IHLM13r5LQMnt/OJInRecUisomAa2MvrC2cG1/52NjvwtuMZLiyrwCa048XZprJyFm6wajB2w==
X-Received: by 2002:a17:907:3daa:b0:b40:5dac:ed3f with SMTP id a640c23a62f3a-b50a9d59a8cmr718516366b.7.1759996806312;
        Thu, 09 Oct 2025 01:00:06 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.01.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 01:00:05 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v7 14/14] fs: make plain ->i_state access fail to compile
Date: Thu,  9 Oct 2025 09:59:28 +0200
Message-ID: <20251009075929.1203950-15-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... to make sure all accesses are properly validated.

Merely renaming the var to __i_state still lets the compiler make the
following suggestion:
error: 'struct inode' has no member named 'i_state'; did you mean '__i_state'?

Unfortunately some people will add the __'s and call it a day.

In order to make it harder to mess up in this way, hide it behind a
struct. The resulting error message should be convincing in terms of
checking what to do:
error: invalid operands to binary & (have 'struct inode_state_flags' and 'int')

Of course people determined to do a plain access can still do it, but
nothing can be done for that case.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 77b6486dcae7..21c73df3ce75 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -785,6 +785,13 @@ enum inode_state_flags_enum {
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
+/*
+ * Use inode_state_read() & friends to access.
+ */
+struct inode_state_flags {
+	enum inode_state_flags_enum __state;
+};
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -843,7 +850,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_enum i_state;
+	struct inode_state_flags i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -909,19 +916,19 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	return inode->i_state;
+	return inode->i_state.__state;
 }
 
 static inline void inode_state_set_raw(struct inode *inode,
 				       enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | flags);
 }
 
 static inline void inode_state_set(struct inode *inode,
@@ -934,7 +941,7 @@ static inline void inode_state_set(struct inode *inode,
 static inline void inode_state_clear_raw(struct inode *inode,
 					 enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~flags);
 }
 
 static inline void inode_state_clear(struct inode *inode,
@@ -947,7 +954,7 @@ static inline void inode_state_clear(struct inode *inode,
 static inline void inode_state_assign_raw(struct inode *inode,
 					  enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, flags);
+	WRITE_ONCE(inode->i_state.__state, flags);
 }
 
 static inline void inode_state_assign(struct inode *inode,
@@ -962,7 +969,7 @@ static inline void inode_state_replace_raw(struct inode *inode,
 					   enum inode_state_flags_enum setflags)
 {
 	enum inode_state_flags_enum flags;
-	flags = inode->i_state;
+	flags = inode->i_state.__state;
 	flags &= ~clearflags;
 	flags |= setflags;
 	inode_state_assign_raw(inode, flags);
-- 
2.34.1

