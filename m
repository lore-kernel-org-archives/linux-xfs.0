Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B42D7DE5
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 09:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760000937; cv=none; b=uc6mdSCpYbGTqa1erJaT02QD/gIsRNUOoQxmc7s+FxWnAh3EDNVUdkXlke65CVfp7XXCK+v9/IqDNGpRV5u89vStouF6ntmeQYByK4LVfUpL3p+BQSXSJeAlBbH8OY26QaCHQg4MMfpRZWgrfR+pknNFSJozyfURr4vjA1O5O3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760000937; c=relaxed/simple;
	bh=KcXa7KpDaur+uFmqn054xcHb7hsTcb+0GQs4M5FBSr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=erKL0KD8cjQ+AHb6zNYtudCEQlCAUNPuySnEmMDIPfbKb+Deq8tVWKtmgCzVa2dmMDQ6lW9nSApSY5FX8mCjR/8KqLznMvjXBqkobkw7wlOrCeX2KqKvHP2q4FSKQ1ZDYMdO78HTaIOE43qXEjj/VVQ1E3gA16191pxbTVAQ0hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQaa6tDj; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQaa6tDj"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7811fa91774so630626b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 02:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760000935; x=1760605735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C+uXX49aJSWydq7w+IBivpuqIIen5cjqVetpqZ6Ubl0=;
        b=UQaa6tDjDv/PU9cLO2WgehElAHghQMqjZ9PeqA+Hwq1E9B9mnvws8epQsJD0ivaohQ
         oWmEvqphVshRl2TYU7vAgn+sfF5L59OKGV3uD3w4STeBzccoWu5TjTogQOhy9WPuVimN
         vjnVU88DnP5OBBZc2GC7vbcDKZITHmhUnwBtoEs8tdOGjnTqG/Q/3DOUi9sxaGb1F91l
         emeZl/skxe0ZZMGeM9j0sLvHmxo4hJmsUCEnRCxLiuhqkz5Y9Q9mjSQdvDk4qD0/uN72
         DDu+VmWk/JWia2mrp/VOrnNBt0SmR1bV7mQ71c9gv8iwpIiYKgaVVnBF19Yqi9DcijPD
         6xQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760000935; x=1760605735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C+uXX49aJSWydq7w+IBivpuqIIen5cjqVetpqZ6Ubl0=;
        b=U9GF6+kgv21SlDB9tGexNs/XqMFQibMkGQvHOrBb+TvcNL7sMNBrNrOkvTf4PuoTml
         UBTv0364H4dw3Ue5gYgu10+5e7u14l54oCQec0eVdw4ZZuwziy0RtnoHGN5aCP87FbNy
         So2St0vKRt8Z8LdME7yl3qlV/S+uu3lq3HIZDZK5qtOmML3kj06tF81IWLJbkZipicOB
         kyqISMf6Qoz7m8xONdqZgeqBeN+hgYVtcsZ3SxvMMdA/fxzPkpEuz7TOWfAyM5ift3XG
         /HFEU6bmjEaEewEOvy5JBRq0HuKOi9H+f59MwvW7fOpw6S0Dum1ohsAHjitZnttJ2RRq
         RdLA==
X-Gm-Message-State: AOJu0Yz+4c4SE0ZnplNd15umllictVxwj+GX/JNpHXxffieteBLe6Mhc
	V5DlGH69xpACe+jcWAo8npC8f0YGBr5uYnDQpH8fcvWiUb7hSPJ6Kz9F
X-Gm-Gg: ASbGncvJHHXByzNbBoxRcL5tC6pPUgEB8qWpvCQtlMRBWEyKbd8MwIuA0hhSYa4ksrf
	rY6yka8GtxBk/gyRRXhoD51xlxkNJjEZLWpm/9Q+uejRw1TwrL1kxJR+JyrcP5X9GhmFF4nQWnY
	GIoknpSnDMKDtpxiOJFgwY2ZM6M81AMktaJappJ/Ghh1k7m0EPBxrKU9+yAhCpoIUetMN1YqBQY
	sPAEK0SZxViDiN9ARlpRY55/Gpp7dsrNtpu6JawsltYTAmRqWzpKr7atBN47mjHqWZpuHR/+hrP
	VGfMk+CcbgCpl+RTgtpKUbEesCevzaNCtYGBziLNI+9pU+Blh8WfcrucCRIOotROtcthUtXn8HM
	bwYoR6Bb8IecGiPSfvLiubRT5atTAQAYJ7nsPrRBwszw8MLzk5erS9qc3V2eOVdPeeYzY
X-Google-Smtp-Source: AGHT+IFGt4O/r0xFNJrXeC/igV78+a3q45ov1VJNkdOtbNUnCJ+CIdkFX31aFA1MGzKQAcgaH9fqOA==
X-Received: by 2002:a05:6a21:3285:b0:2b9:b64:5aae with SMTP id adf61e73a8af0-32da8462febmr8919546637.29.1760000935143;
        Thu, 09 Oct 2025 02:08:55 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f58ac2sm20209182a12.35.2025.10.09.02.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 02:08:54 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: djwong@kernel.org,
	brauner@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave.hansen@linux.intel.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] iomap: move prefaulting out of hot write path
Date: Thu,  9 Oct 2025 17:08:51 +0800
Message-ID: <20251009090851.2811395-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

Prefaulting the write source buffer incurs an extra userspace access
in the common fast path. Make iomap_write_iter() consistent with
generic_perform_write(): only touch userspace an extra time when
copy_folio_from_iter_atomic() has failed to make progress.

This patch is inspired by commit 665575cff098 ("filemap: move
prefaulting out of hot write path").

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/iomap/buffered-io.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8b847a1e27f1..6e6573fce78a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -972,21 +972,6 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		if (bytes > iomap_length(iter))
 			bytes = iomap_length(iter);
 
-		/*
-		 * Bring in the user page that we'll copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 *
-		 * For async buffered writes the assumption is that the user
-		 * page has already been faulted in. This can be optimized by
-		 * faulting the user page.
-		 */
-		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
-			status = -EFAULT;
-			break;
-		}
-
 		status = iomap_write_begin(iter, write_ops, &folio, &offset,
 				&bytes);
 		if (unlikely(status)) {
@@ -1001,6 +986,12 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_folio(folio);
 
+		/*
+		 * Faults here on mmap()s can recurse into arbitrary
+		 * filesystem code. Lots of locks are held that can
+		 * deadlock. Use an atomic copy to avoid deadlocking
+		 * in page fault handling.
+		 */
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
 		written = iomap_write_end(iter, bytes, copied, folio) ?
 			  copied : 0;
@@ -1039,6 +1030,16 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 				bytes = copied;
 				goto retry;
 			}
+
+			/*
+			 * 'folio' is now unlocked and faults on it can be
+			 * handled. Ensure forward progress by trying to
+			 * fault it in now.
+			 */
+			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
+				status = -EFAULT;
+				break;
+			}
 		} else {
 			total_written += written;
 			iomap_iter_advance(iter, &written);
-- 
2.49.0

