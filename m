Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E0542B327
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380210; cv=none; b=oWko1zx9GchUfx5x2fNTm8ptevbxcJ/q/DAy1ZZtiU0k02qylUlUclYS6x2ZWKZta7niv4Aw5e5b5BCZ1sZND/HMCqzbhXMniNVZ1qeyyj/GetJ3GDoEZ2HrvI4ocIvCZGkheyNwXAW/lopBvmFvRk3cCfCr9XLrnF0oY5e952k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380210; c=relaxed/simple;
	bh=WUMwcYpE3AS+4QjuhS/jgyUS/yuSPcI3ZCY9XCLDSrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az7fehPeyxGb22Dm3+Aqhcd0FGenXhk8psdwBhRye7T7NAj1+My82FQa8rySmzVrldILtCuaLrxpaFaoxJtZD/0d4vfSvy4ePNAJwfs9PqWsImVQ9k3hvF52Ul/MpJsmjaqAizxCph+ZMsMvBPxITq1esCo55GTWFOw3qWK/QAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=RGH0xXQ1; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="RGH0xXQ1"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-73a334d1128so53517137.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380206; x=1786985006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7FI9sV3SC7KIDrqjsYK+ZGfiq5bL/Z0zCXvO/BalY2U=;
        b=RGH0xXQ1NI1cBl/1QPyLdKnEcRbZPbpysJi1+7OUmr6+U/bEbVThLuU32ZlKyGnMXJ
         Fk8hZBm4YIzNuNIYHG05D3p2Bu9wylE7P9TG+XJcFxlgCz6AfpIWDgOMzU9dLoJq5vaF
         pqb9PU+OkkAmo56G1Rexvm6do4Dvy9th2/+BC+126CZUdK/44+RKeUZkPL0G7H4a4Edf
         PsUK+sUkp274ah+cDVGHt8BF0iBv9eJjCu7fcxD52WSFgy8V6zsT2n5QuF/l93hMIJNb
         LNATutxVzqxqn2vEsdI0eia/J17zqFm444DDxONExb56fjTuhy4wyb1Yt1xQQfghQM+2
         C0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380206; x=1786985006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7FI9sV3SC7KIDrqjsYK+ZGfiq5bL/Z0zCXvO/BalY2U=;
        b=f4xStEY5G7wJivrpq0jbSqyFW7Lw9Tr3NF3VUljv3cBTdgaxaftK2ppJ4+mAPpwC8O
         z/YR7hLJT5DjgDQza6HOs/SPvKusxwyWuOmaRKv0i/EvAaB69rNcWZaBvmHPxqsp9BwI
         /vW/VdxPIgD+cPC0m2ZcFRuy22Ixs/F/VFr53s1Byz34SFluyClFwCzvo83hoOAJSkX0
         e0pNI3X/3RTRa8jd4zyNkVelXapZdV/yZDj1FG2Ocb2vwrkWoWJvOvHcK25Z1FFXGooQ
         krJM9CxZrvb3gy92qw6U5PDgbAHQb/B+v5N6jc5G77drP1NJPQCdHuCf4MxkhXLcTf1Q
         PZtw==
X-Forwarded-Encrypted: i=1; AHgh+RoEKtEGiWI7+6/AaEwDJD0tVJVYuZP/OKQMZcW1rFywcdnbgA9JucWhwPs9Sptv+AlgfrVdh3KPJOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPgPq3Cz4XqKPqUhzz5Q2KsjliW2WdhsnH6pxwK0tRrcgana3M
	7ZnCKE4/wd/a92Ew2936KCLPy6daD2LF2loOKPmYiGM8lz9aNPJafoRfgpZxrozfHGY=
X-Gm-Gg: AR+sD10X2erI45gD1tylzfFdr41xt0Qsudh/ArOBJsCnpETkL0Vfmq+ZydUqUc0elHO
	lWvdSzsMDdSrK50AhKejwgEca3W8byb7XtQQBIWjtkNNxiGaPJokVfBFdz7JfhzxhkiItmGlXA+
	fGfUdJJ1JRPEj41R0C0kvFZCQamwSo95zF6dNtYS8PlRpsPLUyUUZNgxsq/8L9hb3LDm9xd+NqF
	LEbHo54abs9VoNLjOkhaIayYTYVWyYrnzqoZ/iDoQ1SwOIWR9A9oxT6bp1lR5tRIfjWhGLVV2yL
	2bHgJ2EKUWL+OvP3WNrj4qO1t9jbAfqW7/co0+HEtbc/ObU5XjKrILZV1npLzY+O7uDq2Y3ZmZr
	KvsnZ+2E61ekKKUIkBsNGfbERM0zdAlEc1E9OWM6/x0hzjtCduWfzKmAREw4mCe9NU1wT4bq4+r
	+WY7O5fV79+KWXhqUdxTDDHbF8slY51gaMt40XkRrIvWSZOPBeQobj5UdiPpgrtmD9
X-Received: by 2002:a05:6102:2c16:b0:74d:ce65:3e8b with SMTP id ada2fe7eead31-760e9045be4mr6624544137.2.1786380205646;
        Mon, 10 Aug 2026 09:43:25 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-979f303b72bsm3554691241.8.2026.08.10.09.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:25 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] xfs: assert the reservation covers each da fork growth
Date: Mon, 10 Aug 2026 10:43:19 -0600
Message-ID: <20260810164312.960721-14-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810164312.960721-8-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1072; i=floss@jetm.me; h=from:subject; bh=WUMwcYpE3AS+4QjuhS/jgyUS/yuSPcI3ZCY9XCLDSrY=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+huQBuK2Ls3gZrdanYUvw6te9z2Nwbhkhd7 /GM3i3kMOWJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 H/GXC/sGYrjrNkJl5ZuwOt7HEPwHEuJ8ZisqAvTfVgvAldoCklvU9eWZAnRAEEbcNUuCYKCI4qU CaYRGrjYVQ5e3eBAbHUgWx0mQ0vT4RJtOMKZm16/5YXixeKVY2+i4icM7n5d/YBwotxPkJDaktG cuMSkdU7fYr/T9j9Ea0EaKBTWaLWJ+4aayYds04qiHoGK98Prn5PiAph3J+CcP/pQUu6uegH1d6 UPAJX15BNPSgTUS82KjMIY8Q6mk1yYmE77Z7LhmRE8bH25qIAmq2J8YfXFTySAHobugKzxdkN8n Pam2Nt0RuS7zV8n7GapgStuyNbxW1636RSWjKs+38PXqfmcIn6KbJTQy0bFcGIyqQcuSn/UzntO +itSogi/bOhnrLspU+lTVcUTZ3MiaNuMAj9LLh+/m2gNWk5ZZdRpi54D4dhnE4tFeNWbI87MEuE 3dz8x/4kDwEKj/Xr9tRSVdURyDeMuL9Rg8EHvHLTrm92JOwESWkW9qyBmpilSbXG2QaJ0=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_da_grow_inode_int() subtracts the blocks it just allocated from
args->total, the caller's remaining block reservation.  The subtraction
is unsigned, so a caller that reaches it with too small a total wraps
the field instead of failing, and every allocation afterwards runs with
a bogus reservation.  Assert the remaining reservation still covers the
step, so an under-reserved or uninitialised total trips in debug builds
instead of silently wrapping.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_da_btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..9be407affc6e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2385,6 +2385,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
+	ASSERT(args->total >= dp->i_nblocks - nblks);
 	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
-- 
Javier Tia

