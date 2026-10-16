Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C1336215F
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116731; cv=pass; b=gZpp0LqYaPrLjy6QVoQed0/H63izYNGMBAMSiCBKEXDyqKPhTPocnmkfsRVU4+7ETkTmVyyn01n6lhDgJpoS72reEzO2t84jyjpnU6gpLmPbtM1rHwEDmKbF9vQimtwq8wZrspqY3sEVyx1+sNzevt9i5lEB6wZUp4Zv6jsQFKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116731; c=relaxed/simple;
	bh=qU9eFHuBSKzHpCrHgsV1YmKp00u+14wepzaC757ifcM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DN8fmRa+RY1tXiJZcllJ0r4yG7n3Cv/u+lqHvLRTA1ocU5RBv5IyZUZz7Jg2b4V4kuydnQRuDdX+Q1zJMJ9bbVycl+vTd2WJrkYQVl65qIHnflVyTxyNnZjMcFMe8W9Rl5IFu903/3hxpJ/8x7q/bg1mqGvob9kExq2scIVFk5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hTShg4xO; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hTShg4xO"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66d2b71dc21so633917d50.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 19:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792116729; cv=none;
        d=google.com; s=arc-20260327;
        b=A9YGGIJlpUuCbbrKckEUxHxzUESkU9YdKeBQB646P/bYMNlNVKFDRDjDFe+N4J0q/V
         566WGSt9AqtskNPQJ0ZW43K7raR2ifOzLNXd9rlPIsOBdAeghXzlKqD/1oqk2f4GTsqH
         yHLlPjLs6+2sY28AuzIX8SWDGi0e5UxShqjXP1yENbT8StYMny2zcC9I1yNEDsJqXI6F
         7ctovcDuq36oYWROj5ggvCGM2FBtGgL35XxtQJGiKLPo7xM+G/kMgOpeYODPc+Yzfclb
         FHeUUyWfW8yLOU+oKvzsq4LIOx7sIMyLF5qXvG4fJn7iviVV+W18+e6wpk8Ohj+HtU0g
         J6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yqTCNDtnip1f6x/X6fRxNszH5Gy+3+wzW4YU/97IeGA=;
        fh=gWvYLWfZDQtxmFSLcALyMrppOxbWPx1zOz06RJdiGXc=;
        b=fjdoloPdMMVu/bwWx5TORrH74wrVxhgoLWmpyRAPwo9Ni1bK6DCS02u5RcxQUtkjsF
         v/OY4LTvyXytGK+jlBNvdrvvjlI9BhdIzJW2Dj+CKkrKD+Tv3Ukm8oRtyxSqwykTu8FM
         x3O33TqkFEDjmnVYj1FAhmBu8eae5LuaZ1W/+J8gnz38l3KLF9ysxco014iiIEBJxllW
         z8x0Y7Kjp0bic8pE+rgvvOcIypTWAn8ShgUJtH5lNXZLYFXHzYO21ZnCK/O/+q476kGA
         Jb8gcnzx9DNn8ezqjP2nS+q5q7psNr4Ay22e2yA2HXbDbkmzIz7vPNFHBGOBjk1sQSw9
         96Bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792116729; x=1792721529; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yqTCNDtnip1f6x/X6fRxNszH5Gy+3+wzW4YU/97IeGA=;
        b=hTShg4xOjAQrMvs7yIs+PAtGiI7ve/Vc6Tk/n0xh/ylOnVFUn45o3nVKt2U2xb7YDs
         opC4t8pFYaTbPzkwj4yTl3oKmaQp/vTRydjmfHm7bf9l0j/8SiRniglSc/z7RknjnibB
         JqMxhOWhT7dceRcWvx+f0Yeu93I4McWEUH5d7x4OsjepIofiM4bcrTVJomWCICNFcWwc
         5PCdsBEx7mrqOO4HJImSfX9f69JAp9NM8dyj5yYTdf2xdKgxTidJa+UOsRKO7p7JWy6Y
         7I9Cmq/WbeAsDvT7onwfuBhs+edzmlN30YyXPW0FaLJMCPlH3tnZUQ4g2lMIfBvCJEax
         VunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792116729; x=1792721529;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yqTCNDtnip1f6x/X6fRxNszH5Gy+3+wzW4YU/97IeGA=;
        b=fTqd6qGxto8AFqlAbnUyTRqqa3tZwsZh9icr/F2CSNSSdzy+KV1x6cFUjuY3V9IbWb
         JjoMsH9lhIBOg86BXo6gTQA/xqPYiW667ZxxmKnzgaJbm1I6WKrLrlUbBIEMINVfJxcx
         yOdeWOe4wgPpJj8mUVfssZ5eYuDPwEhnQtALr2+laBJ92UNWatZXn8i9ULPO8FvzQ0Eo
         hv9vwBYdIq3n8nsy3CZ4prr2gxz8MlC4Xf5mgj9mM459RRf/IPthmoQLMsb4pnMu6YF2
         6UqAWRl48aZ2PA1auYfuZejJavrSR2XGdp9EuYtBVZN3v98/wTIt4kTAxtRBspjFuap5
         miJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhXdPpbNVmvnQ5RMAlieRgbFV/OLPUVaenwpgVKMheEnLgFnX1wgkuaARzmqCOlSsU2cdb/6HdlJc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ55nDcgzZ54/eOJUFfB202GtUa1JI7QXPtulE/eWw0CpZbWv44
	DVEtrSR+9Wi8JGENGbUynq36FuG/AUab0IXvHQ3Dx28LWPmaLm7c9NiDibWA+t1vBse4yq8FwNk
	3jr1qgNv+6eEL0EmkQIRFMWw4ushgI84=
X-Gm-Gg: AYBFou13V8VsL+w3x+Yb3hNw1Lh/Ldgrp2HnUMqipzxG+i04j7qnMZkJotg9jdf/4r2
	dovMlToxLdrHKpqCdUE9b+b13NEcIFBa2F37cIluI1qViK17CXlmPu2CzuuDGQhjRlMuA6KzPeF
	OTVWfU9P+/qTCUzceYKCBwHz1PiGwZIfA4CgSVuAFq5mrQ0BWuRhrWV5Snmj1/cRH+1PGm0ZeoN
	HckdimXQYSIx5/kkPZ9IUWLsWPbqm/JbKw6IVxyIoKRzB6j+qnA88q8sUbN5tHBqMCmxVqlmmG7
	LNkUlIVvU2PIgYqbXHS2dbocnD5owxajXGuMpEqjsn5C/f2e1VqWS+WjOF1cCUG8FGty0LM3r3C
	XPgyvJVRoc4xJ7vrHzIa5F58rKOtVGan4GXHWuvz68DJOLb7wYHcj6UtY4DFl6IHBBTR7Ow==
X-Received: by 2002:a05:690e:1309:b0:679:3765:f01d with SMTP id
 956f58d0204a3-679376605f2mr11650522d50.4.1792116728632; Thu, 15 Oct 2026
 19:12:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Reid D <skibletz@gmail.com>
Date: Thu, 15 Oct 2026 22:11:57 -0400
X-Gm-Features: AclHuK9osQiWniGHpbG4Ve0gko3Z_iWaB2dskCMVirr_QbHk7UbV_rzUGzJvXC4
Message-ID: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
Subject: [PATCH] xfs: fix bs_xflags copied from wrong compat field
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reid Downing (b1nv0id) <skibletz@gmail.com>
Subject: [PATCH] xfs: fix bs_xflags copied from wrong compat field

Read bs_xflags from the correct compat field in
xfs_ioctl32_bstat_copyin().

Signed-off-by: Reid Downing (b1nv0id) <skibletz@gmail.com>
---
 fs/xfs/xfs_ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -124,7 +124,7 @@
            xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
            xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
            get_user(bstat->bs_blocks,  &bstat32->bs_size)      ||
-           get_user(bstat->bs_xflags,  &bstat32->bs_size)      ||
+           get_user(bstat->bs_xflags,  &bstat32->bs_xflags)    ||
            get_user(bstat->bs_extsize, &bstat32->bs_extsize)   ||
            get_user(bstat->bs_extents, &bstat32->bs_extents)   ||
            get_user(bstat->bs_gen,     &bstat32->bs_gen)       ||
