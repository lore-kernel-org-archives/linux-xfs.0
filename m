Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5BA4DD3CA
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792160188; cv=none; b=Z00hdUoE2+932wj0wRAEqMkOdjy/Qt8af40I4I1P1iCJxu46iVsDlrZ34FFGLOa9onCjjcTgUuf9xzaqoX4Dleq88HzufoluRY13T+VZBh8dq67mkKSSvkm61YubAOKJanngYmoaDmCI7oegCNCmC9RgX+fWCWAfuXbo+iL0D5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792160188; c=relaxed/simple;
	bh=u+fkloLOEBfCZ7XVJCKiDAjDI+S6TUXHUiE+ew62bSY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ut9Flltzfaq3vFlu5bZItjw4udHae+ZMpLS+3jb5rgt6NVHQYFLNVquRFkwLVDSLLaQneGzOinZvI6gff9toBxl+eMe9iL/UJ0Mi64c4fPVZgGslfjW6LKHhqdaoxqlnnpzThWmL9JtxPRQyszvQSm9x5D4eVC16grDC9AiCC0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rGJmYFxD; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rGJmYFxD"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e8fe8e343fso28116995ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 07:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792160182; x=1792764982; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:date:subject:cc:to:from:message-id:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jZ+mTiIAxhmwhKCyjV/xAz+dOI1Ti4dVU+974wnLdYQ=;
        b=rGJmYFxDrkf5xsdfC8cDPbrm/FYYMNsH7xVvbsXFHUilUakaHARLRwDtaXnthEkJju
         Kn40s4sQeeYqwo3DY8MUG2h3Gf9Dr8/Nub13Ai5SJtCNHlCd5U99M1qJiMElHjU5EGxz
         fHK89k4E9WPpJyCGtwzVl8C7L36f68pPxIPpFLblGSzjARjM6xWy9XhV6brrRqSGt10s
         mLnEAe8MITUSI/RVPELjwVNXnT6Bdr1wX2Q5DeFCKM9NJTJq0WJ8xRWd0lYni0Ivdmhe
         bei3hBQvKnoS1h1FP2suvct3slav/YvIARdtkDdAFdvzG/sylu/9fowwYK+klsYFdwtZ
         LuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792160182; x=1792764982;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:date:subject:cc:to:from:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jZ+mTiIAxhmwhKCyjV/xAz+dOI1Ti4dVU+974wnLdYQ=;
        b=RB3We6oOF+CdvvH/Xquo7x45nCI7SXjy/CYiSdODqRennSf3vKFqlveOPiUB3jO0Ry
         L11NX6wI0decSPOkXyNRKxeXev+uUa86xAOF73IhdcRhjybcv2d+PVD1vOkKxOj5jltq
         0Lb3KRiGD8RBWIXBP0z0g7qY387m/MOEfevLc18Qp15iOkj1P4B/b4/Fbg+l3goVLcKA
         dYLAJWcajKFDRD2Kj7UVOnZ9RbBxYltrR6vq32Q24S25VkbO7zq/dax7ybU0zE6EzgL9
         dPyw6jaMkB7u/2FqID8mXUUWLrDbBseXEZ6+XPuFkAoOExnnkxcmp6m3kf5n1ZH/9paj
         UuMA==
X-Gm-Message-State: AFq9FYLBW8c18FGocoI5oz3hpTd9jnWunRKwSLGDAqVIKKKzi26O1bjx
	EiAGLzyQmvomc/OL/S4+xLGsLsad/egDe58QQXwraZzouhxsWCxc9hpU
X-Gm-Gg: AYBFou3G+Pq/pZXZ5TSzo1BLPVK6p6KTOHa4LBZUCPAhzMsUq4k3AycjqhH6klNpFUZ
	UwAR4WiFFH6sxVndWwXkPw9V1LeFuaD5lCmRcfuoIhTMTyF3xgvXJSIEUQCm5JlAUYCWzwHHwKJ
	L7h2INJn6nXqQlYThoUwCxcDFgqhru3oROodRamN7JktvVGGdQDnyem3k/jZ7kP/eYuKYE2yhEG
	5ib2jPLMBV53wffhnG74Spfoix9y8qec0srwWs2OxVBvAsEMA+t+w+VBFX5cbqwBXOHl3hg/YZo
	OCoKGlJwJZsiPM4wuzcbEO/vwJVHmQWvjK8kKU6/50BvH02pdJf8iiMjieNyzJrST/W5LCPv41R
	th3PdLNVtqxDgzGIaoxenfLQBnrSgASCQh2VgnYaH6inBRoJIqNLgn1BvCI5sbbPP+cOgMTfDSK
	A937eXxMgbzw6HZlPIpyNdB/ICITkdf9YE0hqZayHIPqEfBf2n8Ql1Xcdk0qw7Tda9OgUzIDTTg
	Q3EoPRg8I6Qu7v4jhKtQw==
X-Received: by 2002:a17:903:2f86:b0:2e2:ffcb:87a9 with SMTP id d9443c01a7336-2e9a68d9693mr992475ad.24.1792160182121;
        Fri, 16 Oct 2026 07:16:22 -0700 (PDT)
Received: from DESKTOP-UCPRL76.localdomain ([113.200.174.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e87994bsm10854635ad.60.2026.10.16.07.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:16:21 -0700 (PDT)
Message-ID: <6ad231b5.6655ddc8.1e37bf.a74a@mx.google.com>
From: Zheng Shuhao <viennaoffh@gmail.com>
To: "Carlos Maiolino" <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Date: Fri, 16 Oct 2026 22:16:18 +0800
In-Reply-To: <atIj2DeA3TOMJQ2-@cronus.toxiclabs.cc>
References: <20261016085536.591-1-viennaoffh@gmail.com>
 <atIj2DeA3TOMJQ2-@cronus.toxiclabs.cc>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Carlos,

Thank you for the pointer, and my apologies for the confusion. This is
my first patch submission to the Linux kernel, and I was not aware of the
known-identity requirement for patch authorship and Signed-off-by.
Understood now; I will use my real name for all future submissions:

    Zheng Shuhao <viennaoffh@gmail.com>

(vienna-0FFH was my GitHub handle only.)

For reference, this is the testing I did on the patch before posting:

 * Built the patched tree with KASAN + XFS_DEBUG enabled; checkpatch.pl
   --strict reports 0 errors and 0 warnings.
 * Reproduced the use-after-free deterministically in QEMU on an
   unpatched kernel; the KASAN splat matches the syzbot report exactly
   (xfs_defer_item_unpause <- xrep_newbt_free <- xrep_bmap_build_new_fork,
   and the xfs_defer_pending object is freed by xfs_defer_finish_noroll).
 * With the patch applied, the same trigger produces no KASAN report: the
   scrub ioctl just returns -EIO and the shutdown path unwinds cleanly.
 * Regression runs on the patched kernel: all metadata scrub types,
   invalid scrub inputs (bad flags/generation/agno/type), and forced bmap
   btree rebuilds from 5 up to 1500 extents (covering both extents- and
   btree-format forks), with read-back verification of the files. No
   regressions; normal scrub/repair paths still succeed.

I can share the reproducer and test scripts if that is useful.

Would you prefer that I resend this as v2 with the correct
From:/Signed-off-by: lines, or can you fix up the authorship when
applying? Either way works for me.

Thanks,
Zheng Shuhao
