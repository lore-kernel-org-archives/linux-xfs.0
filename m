Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3047A53
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100615; cv=none; b=K/gY2IvWKMP36S9zQ/a9o6hrJUQresz9anQbvytDJlKQG64vx2WoTerjyu3NDVTid9q6MnGt/WwL842SX9DC2AOwzufO4ztdPRy1hw+ADayGsdBKl0jbW0fVrqUK4e/nolr3eH7wWuQ7kzfD2hy4FIhg9MWWzUpu+C+V9r7Y2Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100615; c=relaxed/simple;
	bh=mPwG4QjrSXJ2nNLVwR3tWTLOQSBUDJXtV7hYw8pTEcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpfBeyCLYVpIml2WMEg1MC226yS2xsRxn7YTvuqB7pmoiQfIVrAmaB1zSMh4nvNQXqSOOz6pGRsxVsUf2hxn3eeHChFKhUsQlg9E7U2zk+TLK/Y+Qq7L/+FqBxBlkKfUL40fW+WESC7/dVIOa6JKOvrk8GDpxNqoVBdZNyN6BcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=o5c3zhjg; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="o5c3zhjg"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so4481232b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100613; x=1712705413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsUG7SPDsJw7wnvaggfreaw4/diLPmF/IqU8ugjh5qI=;
        b=o5c3zhjgRyC7eJXJTvx5o4AY5loz/c0n0926vPsXelrjufefLVNQOEJQscfJxJ8ThB
         w6Pj+EbeG7lD8CbgrCSJWpPwEfC2v7k5ncRAQ/lTJxFqbM0A8bt7WCOEqHgKXdKtJZ+s
         +YVxSsPKS5lVaUZ1VQYPAJS5esZwv9KfXq5A1wNdOmaguz5QDBtSQ+EF8PJeKvfi5qIk
         cHtWng+xkbdVtN7HmPbOM2UCRalGKIKwhoJprvhz7rOW2EtCIC5HsSUYDON8SUuf5AZg
         j3U+ngPgDS4+RjooubHGcaYldojTX30xGCqKhOMTzqgvJNT5/zisekZryQz1a0QGoaok
         1drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100613; x=1712705413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xsUG7SPDsJw7wnvaggfreaw4/diLPmF/IqU8ugjh5qI=;
        b=p6i+G7iFs65mO7Mw6Ca5haukZa0hnXrSB+dC9VrNEqBJviFqWrt1oAYGIO8q5fDFTd
         lshu/+y1GNM2xBnZjKScDABRWe8H8SyNvhNJcXftl8GfNBeT7z4OvbeIzeiWg/OcW3Y3
         8eWpVVpv39FtrdNs/XJGtUZoqWg/p4OrzR4NXUZGyTOF2lsHacOgAUUtl2KKo8hd+hIa
         DVslQnU+VBhw9davsbnd3br1YutcJ3t3KEyNTTuL5aNAAUZNBoqKWFhsLATSZ8PDzqVR
         57UajbEV4DsfLsEPCTQnX9kLAD8kgtuisYYI+wzrvfSH6UoIN7YPRtWUvtlksF6d6PmL
         SGfg==
X-Gm-Message-State: AOJu0YyVB/HG5eVnNuzVcKpRMYyAFw4bp3GPbOAO35MxJD4s8oiVirEe
	ru4z3Nj/eVwQbAUwaKPyl4u+EQsyGdCMPUxjqIrt6kucEVDpHiyT6yhegp5QmKRn1LIaYomUcAm
	c
X-Google-Smtp-Source: AGHT+IG7QyNhEj/SnJnOqNJY2fJiw8rogEOsUERxoMveZM6lDHzKqRctDpk4Km2tmMYTracPhBe0eg==
X-Received: by 2002:a05:6a00:3c87:b0:6eb:3c2d:76e0 with SMTP id lm7-20020a056a003c8700b006eb3c2d76e0mr9811977pfb.11.1712100612536;
        Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b006ea90941b22sm10426343pfi.40.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001syE-1r;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZx-000000054rF-0Me4;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 2/5] xfs: always tail align maxlen allocations
Date: Wed,  3 Apr 2024 10:28:41 +1100
Message-ID: <20240402233006.1210262-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
References: <20240402233006.1210262-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When we do a large allocation, the core free space allocation code
assumes that args->maxlen is aligned to args->prod/args->mod. hence
if we get a maximum sized extent allocated, it does not do tail
alignment of the extent.

However, this assumes that nothing modifies args->maxlen between the
original allocation context setup and trimming the selected free
space extent to size. This assumption has recently been found to be
invalid - xfs_alloc_space_available() modifies args->maxlen in low
space situations - and there may be more situations we haven't yet
found like this.

Force aligned allocation introduces the requirement that extents are
correctly tail aligned, resulting in this occasional latent
alignment failure to e reclassified from an unimportant curiousity
to a must-fix bug.

Removing the assumption about args->maxlen allocations always being
tail aligned is trivial, and should not impact anything because
args->maxlen for inodes with extent size hints configured are
already aligned. Hence all this change does it avoid weird corner
cases that would have resulted in unaligned extent sizes by always
trimming the extent down to an aligned size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 215265e0f68f..e21fd5c1f802 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -432,20 +432,18 @@ xfs_alloc_compute_diff(
  * Fix up the length, based on mod and prod.
  * len should be k * prod + mod for some k.
  * If len is too small it is returned unchanged.
- * If len hits maxlen it is left alone.
  */
-STATIC void
+static void
 xfs_alloc_fix_len(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args)
 {
-	xfs_extlen_t	k;
-	xfs_extlen_t	rlen;
+	xfs_extlen_t		k;
+	xfs_extlen_t		rlen = args->len;
 
 	ASSERT(args->mod < args->prod);
-	rlen = args->len;
 	ASSERT(rlen >= args->minlen);
 	ASSERT(rlen <= args->maxlen);
-	if (args->prod <= 1 || rlen < args->mod || rlen == args->maxlen ||
+	if (args->prod <= 1 || rlen < args->mod ||
 	    (args->mod == 0 && rlen < args->prod))
 		return;
 	k = rlen % args->prod;
-- 
2.43.0

