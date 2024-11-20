Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC91CB31A;
	Wed, 20 Nov 2024 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732115260; cv=none; b=DSIa2jaNYu9YFmRvO323kHwr3+VnHT+OaG8p3oLw3C6IyzOEDK/3Lnzclk/uZ99Af+wV9r7Y5cCkdSoxmKrKpLT7Xls/g6pt0uEhRt2yPzoQZc1oKsw/Pmni40yScfKCMqQWkGYMfSF7dq0SeU/P5wx6lRh5M+XPfT6i7iKh5DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732115260; c=relaxed/simple;
	bh=mFSbYXPV+v2cwEB3jjz+Ldk/O/kX3CN9PCSnFH0JjLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jnqhc6TO1GX4D3VRVDDNpY2dVRFjoaSwFZ5oZwRfrJ4pPjmNYH+n3BzriWiTkBwkgCB4399QpXgD2YSqiD9L/L9DG24X48KOLGpvnLfVlZpGCnYhiqzIfGU3IUx9hzfz4GngfZ291dR1DFLNuGx5g9qaMdh+bH81DdBF548Q9zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUcPtb5r; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUcPtb5r"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9ed49edd41so416336666b.0;
        Wed, 20 Nov 2024 07:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732115256; x=1732720056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T15rz/YcFvzeWIWmYn0gRMt/pqbI9YM62Hb9AUjRP4Y=;
        b=GUcPtb5rUN7Jb/JbJ1LWKCbUUk31pbk1Oo4e4urLmH9a1ZRGvpFjOUQZzPf/eXJerH
         PO9IsToeiNi1i4rUpWzIJ2Zj540tmV39A0S7opeFGkhTApq8a8Z7AO+ZOuM45+nXosUm
         YttjTvws3EKcqLECeIfDJ/QIk7cQJAQQHkp5N0gfRq85ngBvx8OGVPLayqqxyYYRqqci
         mr003qIzfwPGOSMarBgVBPZZYUT1vSlW4pZ1JSogsCBEv1RoR0rHUXIPPoBNaH2D6UyQ
         dBQiHXkhiPJJDHHr/IHpr8Cp6n3Sc4ODLSdghRrta1X0QMqDp4ZaF6NQImEa7efOCPnp
         H/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732115256; x=1732720056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T15rz/YcFvzeWIWmYn0gRMt/pqbI9YM62Hb9AUjRP4Y=;
        b=QwjAJ1/p2eyCYTijtAmhh0Ktue1sNJPsVBnum51YMDM5EUGoh2y1UmSh+p5By0ionw
         zHIzjadlEg8aP6ubBNSpjg/j0OvkdvNFVciJRKGAUIPS1n1EdbupwYxzKZdhmUeYU1M2
         9qSgfYYKlioeXgB+2n1En3np99hl/OwmOjU0GYGSqrFJVGZI873xI4y+mrgHebGC9ev4
         RvuLZae6vCK4rLqZJR7YS3TQMb1MxI4qOoZEb8Ck3ZBcfWlt4e9+Chi3uon7tefXSVY1
         ztDRzF8hd2Bp+7PfXrwPnsFO3ZqiXk+Ltf3wX+p+Ks8yuNreN5ngNy+1Aa7B4I/9XXKZ
         HRhg==
X-Forwarded-Encrypted: i=1; AJvYcCUgDcJwQSyozTlb7774GBgYQ8/4MKDhy7e83H7QkgvXo9JepVqifBgHH4pI4L+lURPn3U1YEZ4T5+q9DLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8q2L8393dT0w3ahX2LNmCLoLGwznz83h6oVocBlNp7eAE1AGF
	MHN2M0/EzTfAeIbbdYh+FdIZD8dwcdHkCiE9slFmhG0/jaPyDfEtpHgNiH4+
X-Gm-Gg: ASbGnctCz2EslW/kUTmW1HGLtCrJmJDxbQLcaKIxktdeVyjLG5m2Q3niNl626Z3tIm+
	airwU1vuq5MrCClG4SI9eUs9VRJNdDDIIAmtF7gdDGDEvKOnMKUHiSDYhdJwQBuuxJfvE5X8MZB
	spejMsVXtLHuBgn//pzsTCHJ6A1nRkdZ8GfNZ5H7jqBFnLnB8uPQLB7VWPhK6ULz0F8Vk2NZoWW
	HmjR2Oxfrn2WQ6X+saM9xCcrq7YYNBDe5z8u6f2G4NrMZNnEe6bj1TI2v4=
X-Google-Smtp-Source: AGHT+IHxCToREO2TMV86vV4m4GDNa+70BqrbVmzPWlTxmGJXunTC4Zuj7RZBEiF1IRyh8zHh/fbiXQ==
X-Received: by 2002:a17:907:6eab:b0:aa3:e9a6:a5bf with SMTP id a640c23a62f3a-aa4dd70b960mr330519966b.47.1732115255713;
        Wed, 20 Nov 2024 07:07:35 -0800 (PST)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e08624fsm792677466b.183.2024.11.20.07.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 07:07:35 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
Date: Wed, 20 Nov 2024 16:06:22 +0100
Message-ID: <20241120150725.3378-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

try_cmpxchg() loop with constant "new" value can be substituted
with just xchg() to atomically get and clear the location.

The code on x86_64 improves from:

    1e7f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    1e84:	48 03 14 c5 00 00 00 	add    0x0(,%rax,8),%rdx
    1e8b:	00
			1e88: R_X86_64_32S	__per_cpu_offset
    1e8c:	8b 02                	mov    (%rdx),%eax
    1e8e:	41 89 c5             	mov    %eax,%r13d
    1e91:	31 c9                	xor    %ecx,%ecx
    1e93:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
    1e97:	75 f5                	jne    1e8e <xlog_cil_commit+0x84e>
    1e99:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    1e9e:	45 01 e9             	add    %r13d,%r9d

to just:

    1e7f:	48 03 14 cd 00 00 00 	add    0x0(,%rcx,8),%rdx
    1e86:	00
			1e83: R_X86_64_32S	__per_cpu_offset
    1e87:	31 c9                	xor    %ecx,%ecx
    1e89:	87 0a                	xchg   %ecx,(%rdx)
    1e8b:	41 01 cb             	add    %ecx,%r11d

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 80da0cf87d7a..9d667be1d909 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -171,11 +171,8 @@ xlog_cil_insert_pcp_aggregate(
 	 */
 	for_each_cpu(cpu, &ctx->cil_pcpmask) {
 		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
-		int			old = READ_ONCE(cilpcp->space_used);
 
-		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
-			;
-		count += old;
+		count += xchg(&cilpcp->space_used, 0);
 	}
 	atomic_add(count, &ctx->space_used);
 }
-- 
2.42.0

