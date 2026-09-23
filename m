Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA64DA540
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 11:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164725; cv=none; b=a6K+YkIRwenzYXo8/kjvxWNBdr3CUuKFIT3HZ0LsB3EIoO7IMoC+2BOI2x2bDAuKnR9MeOiJ0aoxIjYX/M3bc/UkLptoCgyr6P8Z+llVDJ1LR/r24BLnh8HNNdfa4j8dGNlgt41UzysKCDLujQ+Qmzm7LDQC1bnm8UbPalzjpvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164725; c=relaxed/simple;
	bh=g1HCBr8bsZcnUx3gO40OyrqGIOY7LwAa+VsmFs5/+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGyyMoNpGdtfY6S0JfgQ4lasNhO8MXr//xCkA0ZBj60VQaXZVlqjZGGj+0i6MaBPpCjyKqprUn9NuQcQhi03R3ETqrVIYPnUsKOnol6i8NqvocXoj0Btp0G4cFDGtegCcaWCAhQg5VyHu9rnvACW0MAtveEZSgNHrdUy96vCqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/DD0KnQ; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/DD0KnQ"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-78a4c5c582eso316720137.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790164718; x=1790769518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lN2b/UwZ6UTOnQoQGsvb5dcfV+ZMY1X8+RCUQeVLWRk=;
        b=h/DD0KnQOc2oGXVJR2/COVNTGXNVlfKXHWxIUF5spcvkjpAYkYW7oLUdPeVzz4rdkF
         n/NdqC5ze33Y7o/hEZ8R8qTuPFjpYRhhLr/1YI/VePA0qLDSDHQVIJFtSG4DwoF1AVif
         IkdXgFhI9EvyUyq1a4/M3qFkNUAE9KpWnGbysAVHsC/g/kaziU1+Z4vapZ7R5BWv917v
         /PsEqWf6V2ZXndXr42HcoaM1ybOi8BBiOUM7oENIp00GQXzFrZYh9Mvdk5GBsf/v6f0B
         8li/nd/lc89m/PKKSQvGnsVWj1F1VHb9ppdmQ88s039MxNiOME9XKL6xlWanU/VJobNj
         sltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790164718; x=1790769518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lN2b/UwZ6UTOnQoQGsvb5dcfV+ZMY1X8+RCUQeVLWRk=;
        b=2k0WhNp9Dmzp+GLL7lu5sTqO0QqspTAaN7Y74+XWeLUNIf2A8skaQ0Py7N03eAqg3S
         j4J6KJrfaAiyu0pV+/PdII1N6SHzacxfj7lRytNg6jnaab0R+aH+UpCWufpaeGqe5b05
         slpdauTi07LhLY3uH/dZe1jZVuHdtWtUJRB6IxkR0De8fe2Xmgy4TLubVESckwmdsmCF
         mGBRlyPb34MwgF64glJ/hE+2OHEmNqjN3cL7TqvbPpXZp43ZhjupXPbZA1ATMeI2IfF7
         bGoebb4CAQLfwOw030AoEST/7LLz3YSezixp3CZWBj9suYenUwVGqIBEucFb+PhL+AAJ
         xqSg==
X-Gm-Message-State: AFuF++lf4zdQuXK+sVXWjQxqNdU/UWDKr1j5NYAQHfdpdDuiBw3BktIw
	pKxJUD3ffDQCqQ04yZ1dWqr4Th+PJ2bWHrKk0UAgUQs1Gz09u8C2ZzuhDL+yZg==
X-Gm-Gg: AYBFou3W3WAo2NGLzK+2nhjmVJYGMjVBFfjTlYpW2FvbY7T2IwPR3XXMf9wJega7N3B
	Zdp/xQAe6b3ekZoYTapKIZ//DcI4FOkVyqyhkfngraLKs6FYWk0iKGTSriU4FG19GPOO0Yzopc8
	4MmTPRyoRIBNagVg4t1H1GEw+yTai4CL82ASapR9NJGyIXylcWhDZyg2+4m5w4Vycah49hNZQ52
	P5tlCsqV5ndcX7ogATwBTC2oul1cuZr71JC/i+v9OrzHhnIzSKzufJMSGNacf2NBVYFpPbkNtRH
	wOdaxO8p7afAaP77TRScsMuB8R9eQYVvRbG4XbjFLpiT2ALqgFArjAzzpwaDEAUXhUlD5UfW6aq
	1IxlUbWOe7klM7Z6nJnJYkBFJtJoeQjMvs5n+eNXYJHzJNhGSlQnfg+Iv4kMOBtIKeI888mamI4
	ji4lySCn/poMm0s4VSjQ43CKDQJDSThU4DfNrP/LzldVVYy1F6ub/poxBVMboVEGg=
X-Received: by 2002:a05:6102:94b:b0:7a6:a24e:8140 with SMTP id ada2fe7eead31-7ac1bd45308mr2260190137.14.1790164718584;
        Wed, 23 Sep 2026 04:58:38 -0700 (PDT)
Received: from beelink.. ([187.13.30.172])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-985167e6fcfsm3257250241.0.2026.09.23.04.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:58:38 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 RESEND 2/2] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed, 23 Sep 2026 08:58:23 -0300
Message-ID: <20260923115823.3305596-3-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923115823.3305596-1-qwe.aldo@gmail.com>
References: <20260923115823.3305596-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
v2: cc stable (per Darrick).  Now 2/2 of a series: 1/2 fixes the signed
    value-length check in xfs_attr_copy_value(); this read-time verifier
    fix is otherwise unchanged from v1.

 fs/xfs/libxfs/xfs_attr_leaf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d0f7753659c9..948dc8b26fe6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -339,6 +339,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)
-- 
2.53.0

