Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E3F39CCEE
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784049038; cv=pass; b=NuFOQg7jVHywoBDUK4ffONCduElG4nbV0rBNidsGUf2M7LGEzn2UxfhQiJhhVIt7uJE4QIp7aum0PCQZpweaL72tswQhIMGvbxiV0QY2fG/nO1YNa/wbECqUdll/tom+BEtyCt7s+cceMEkJeHSjSQ0mDvxoao/fmUGP4RoOozQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784049038; c=relaxed/simple;
	bh=uoqCnBCzsbw30aZ60m/CDE+8TS3VxRuPkrhfRDmuhDc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bghXfHCKjXP/aj28QuOF0K1+0hsDkCZw8nYGJ+ZsMQ+GTkpKx6eeny70UrIHV3ekTYgvHqp/gPgDC336CrqZTunpLc/c8RsG0wRuLGOQuoFfiff0jd1vRzgeLzfI1dYY9grk5K9co0Ig6gc2PI8NQuoAaaEBhJFEf08bnJ/VRkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com; spf=pass smtp.mailfrom=reillybrogan.com; dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b=NBBPpFJ5; arc=pass smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b="NBBPpFJ5"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-448b89f700fso2772266fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 10:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784049036; cv=none;
        d=google.com; s=arc-20260327;
        b=dwt8cssOfwuG+PZfj3jHw7usLC1E9CrjvwgWcNWeI6QM4+XV5jane/iaT9U658ERM6
         qC9pPo0PMDiDz4Wg7BfsgFvKksk/TPxtP7C55nsXo7BzCjIeIh18ewSdLbPf9s+3pl2d
         DLow10anU/HwYH2iuLW0Mwhi0oG89hbluFC3o6AMcvsFb5aTaSBuyZOy/VFJHoZX/96V
         uXNfBCkS3gFowW2Sbeco5vCKZE8esqH68Ewt5VeO/rvlxwDVqUpitpex9/lHcYBBVBhD
         bbUmtdSuO3Q8Ij62RbxRT3Rn3/R4c9FjyvDByWctixT0wGEZqkPhlX/pK6g+e1VwqWSB
         zm9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=09/eux3Rf65entca8YTbw14ylc20TqV7ArsL2JqtMNA=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=TwD5Oi+y5XN2zFRdnXUHLG/ahV0RB9it/iQnbEszBeiuLIkxE+j4f1MZgd3Sv5gOHU
         h5q1f9eUaBfvu9yX7eG6L7GWVhk92qadyPknMS02eLhJPy9cwG2Oc/SwsC/rHAZA38f5
         tEFEHIRx6c3lJOifJOY4vS6bTkTaWXmc8mWjs9zf1rj65M1Y3zn7RR0pVGOuQYbNg4Ii
         nwfW+QemKEYbXYkZoJ/8mHyv0Ir3pLR65DcL9Ci8gnDpA8j4UtW7ImJXFBkl6idZtVEl
         JVogkgBqTV3FFS/hQbqJUIdzum+tb0nIuRV2eJCkUUCHpiCuQOdlzpkuLZCBUu3teN++
         pjrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reillybrogan.com; s=google; t=1784049036; x=1784653836; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=09/eux3Rf65entca8YTbw14ylc20TqV7ArsL2JqtMNA=;
        b=NBBPpFJ5Msp8N+X4sKVHVHkdgHSU/H8ZfEtS4t52LI8G8dluolO2DXEEqvjhDiFRmE
         TRIAs7ZJfhw6uPvWOwdUUPXdEfGcGuTryb8/WycKa3lPjDlciqnPrgCwqU5dgdB+frvK
         DxW3BMZOrowuCYrLeh58LUlRsTDMbwHiW6FK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784049036; x=1784653836;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=09/eux3Rf65entca8YTbw14ylc20TqV7ArsL2JqtMNA=;
        b=CX1xdNUKh2FRvXetGNvNGj4yTYzesh4KUJBil6tk1A7oDkWL8sQKSXYsUo/IHzNJVi
         65t8DN/QIIsT2Q/AtSSeab5Fm9aQI7cRkZwd+U2lRnfsfvPLAnPLjjsXmfAXhljJ7fgc
         AH1Mn4fXpYh1xUiwHS1FsUDcrPmFeutpqkTBi7q6uTU1TbLHL9v2umseLCBiDQTpaq7C
         JNtPkM/BfKPjSH66LR1gVPaAhXnToVmeafpwxPfXWQuAVfgodKyhHo+KCUa9V12KNoSl
         BiYhJhTPTZffvawOVn6K4X0ppkUjWICd65JKsIX7RTN4FVYwX5PFudsops5T6U22aopr
         qAYQ==
X-Gm-Message-State: AOJu0Yz/gxq2oW9pZgL7oHaZn51ecR2r2MGXBiyUJ+f0niAY4oZM3bq5
	SwwJhLIg7dvdDJAZwGft2TxZdX2DxdtwqD3Z5clZNmTPAi3iYxZnQgicOdx9XUI52NupB4rsHRs
	MY6d2edjh7TbdojnKR4ESUfmTdJAgxYgTsW1KVqVwIkWG2GIlpllsJG3dSw==
X-Gm-Gg: AfdE7ckQH6mElzXwkXldnknnXdYgC9Lb5ePFJ8skWVLBBDV2zVl7FPb2rqr78QGQfkR
	JqcLg1ILaz/UGa4aZGW9Q/VPKEH9vNBWRlrH4v2fto9QS9Ibz+0k17vMVRqVwazcsQI92UISkQQ
	RjC1DX+rI69hNf12eg+1gindOn+verbHUW46c2lPbvxkJ30ezsxozX2L6Anz2iPbwiPGzgnEDiJ
	qGfxurB21o9/ps5P9MMzCd50LFMaPUSggGJYT8A2il35EfZw7tmI0tOZ6A98zlg6Ka1+QpyPtaq
	CXm3YEw=
X-Received: by 2002:a05:6808:6f8f:b0:495:d7ec:b6be with SMTP id
 5614622812f47-4a42ad68d30mr9725433b6e.18.1784049036072; Tue, 14 Jul 2026
 10:10:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Reilly Brogan <reilly@reillybrogan.com>
Date: Tue, 14 Jul 2026 12:10:24 -0500
X-Gm-Features: AUfX_mxEeAdHu9qfN44Oly9F-sUPivQv7ibpPKawbwEXGUt2QVqDfYXE9Egh3RE
Message-ID: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
Subject: xfsprogs: 7.1.0 Build Failure
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We're seeing a build failure on AerynOS with 7.1.0 that we didn't get
with 7.0.1:

```
Installing healer-install
../install-sh -o root -g root -m 755 -d /usr/lib/xfsprogs
/usr/bin/dash ../libtool --quiet --mode=install ../install-sh -o root
-g root -m 755 xfs_healer xfs_healer_start /usr/lib/xfsprogs
Usage: /mason/build/x86_64/xfsprogs-7.1.0.tar.xz/libtool [OPTION]...
[MODE-ARG]...
Try 'libtool --help' for more information.
libtool:   error: '/usr/lib/xfsprogs' is not a directory
make[1]: *** [Makefile:72: install-healer] Error 1
```

We use slibtool as our libtool implementation and dash as /usr/bin/sh
so perhaps this is an incompatibility with either of those (likely
slibtool).

It looks like the issue is in `healer/Makefile`. On AerynOS at least
`$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)` doesn't work
if there are multiple BUILD_TARGETS, and this is the only Makefile
that uses LTINSTALL like that. If I replace it with a loop to install
each target separately the build succeeds as expected.

Regards,
Reilly
