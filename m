Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796091;
	b=LtIHPTMiZTz6wV5ZOII98M3B21V8ZfS9uQ5R7l0o+gDuNomGYJNao7TRI0Zrbx7NByzC
	 UR1K7Vw/Vr2DLpNh8Qr/6O3RMjoqNErL1ccjQW4bEjvAzNkjSYyy9fZfroOFMxBddBiv1
	 SA6rKVvu8Hjl+XsyQf8gvYy6nTYZOnwvy3/Zo4KjK8ZvazhKTFwEXnZVIDPP7jCJP5eYk
	 XzH680YzUfrE99nmtcpjndksQ0BiJAw6qnpG0EuFOOxZIksitAnJdMwwcJkVOb81cTJ39
	 JML807HO97PCHqZ59xL2HQeFn5rCL/TPe8RqhC9vnDwVO5Nz8NqdVf61vQ+KNA1JbQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ceSp01bh4VEus6wiyFnAVFG6+YqjERwOigBcm0vy/ZE=;
	b=pYGq5GJN32eNGnANPJa93DVyPELdM9VzvV3biHQXWoPde0cF+j4dHMheWdUzWI4IV+IN
	 w2QE7t9K5ZYeVM3d9csEmyWkFHPD2Z7HsQZJKe2pT7vInGbgiIdG6Ii8yRHt0cortyo6e
	 lwZ4FmHo7W3gkLiWSWDBPRPnVzueToYC2rUbXHWN24k6zcNng6xqmYZLB+vTd4Rn03zE3
	 JUfc6vN8mEGhvFU27t+4mQ1b67CrT5onhZPnKiqzOHMjgbTGOcyCiSprRI4ZevbcOzTru
	 IzVPiYew5JdZRkW6WGsAcrmAakr5laSXw/GvJHFX5NrThPxJHJLhsBhikmV0ezrLFwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X4zR+1+K;
	arc=none smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A80606A328
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 12:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A80606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X4zR+1+K
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so333936e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 04:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793796089; x=1794400889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ceSp01bh4VEus6wiyFnAVFG6+YqjERwOigBcm0vy/ZE=;
        b=X4zR+1+KBstcS96EFEOq4WC5KNieO+Vnj2/Q2UtiSPRP2zZDezyo/zaF40VKsHqQTh
         PQwv2ckqoFyNgCAoKuzdFBonfFa9f5mLgeA/bKWRfncW6XFNwst/WmHCsjt5m4ssITn+
         lprVHWzSUMr0uhUZsJMaYtuO/1CVeuiBOL27+LGSdOLU7Kj3w9Fmpa1Sb7F49KQy1BJo
         vhGCkasZGqP+M0Dl6Hr4pFOmn4mFwcRfvFvAc42fVvfaiEv1Od3DE12bDia7wMbnGzw9
         yArgwR5YoVpIHU51GB8G+iI5oFTluWsc8lFbC1G9UIeNG7C3i59aF/ijXhDosQ/i8Qrm
         K2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793796089; x=1794400889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ceSp01bh4VEus6wiyFnAVFG6+YqjERwOigBcm0vy/ZE=;
        b=qQhNRm+XtYrQRavxdwwCDljx+463tp8OrbRc7/tZhArKVNh2dZIHTfKFdMM46CwBZK
         BV2wqcrEDdEuevSQRJiGx0tgxyETP9ldnqAhhThBKUWWDzQg48jx6NQSyzys9nXxLbYR
         qRmp3E2eOWUIORdW6jnm+VA9v96MGA73ONHS1dzwP8vFklh66EDH58fWSl/78X6t+fJk
         4oDcbLOaBEivBW9nAVCHrUFlgVhnPB2HilzfPmBRtwmH7R6fg0dWe8wPWaTr+nYI/aNH
         aBL73QrjcCjOQQ0kZiuVZUKhQyVmnlR5ygFVaiwxA2+Ag5a5H9ek1C4Fu9AcDUIGAwIw
         AQoA==
X-Gm-Message-State: APuU4Z+FVSLxn/P1pGJ07+8DEZ2krYprrgiPgyvoooqZfNvC7EQtUVls
	xMZpi7rkiXhBbpA0iNpDl4/cKu/4rpArWoVGWQbBZOd1puEKU3qmoxDvdKhEDUsgBgE=
X-Gm-Gg: AYBFou1PN+e0sR2YPRF9xuf0Qk6kswVni26l+G8PdmHifs7SP7T4Obf6jhxgXB2OtJz
	SbzaitYu39Me1L65yI0n4jpxGqM+isPhi4hBpGTKH56/w6mSjJksFeSBAr/r/7ZpB8M1nCuxZTm
	X6+hgx8e6gdrbaAUlQl07gcwj3trPvoDkMaLfsOZr2syMNN+mEfe2t212V6tB/BcVv1fozv9KJM
	WG5oQ2OrGK60qrjh7orrJ2QoLtR7CjunZHPuZkHbZZnttioVeQ7oJfO/w02ecLLTW0oIoSn1dpK
	0tRfK3xpNO7brFydzMEDNEgbwmdDYsSRvalEPYbItwQORILsUJQoIJvgQH5Ov3Z6pmHloZ/OZE4
	A6zOE8L6Pk0+O7JGau3+YFnY1+AiGXDiPdzStjnCDZdcY00KinRQPOH5yN0pr1j7z5I71WaUvLi
	1MwMEZp5PqT4d06B2y/Hr6EsGwBaWWmFIxlTmd+UPa2KtSRN7uYlXg4Fhlr48pSPqIWhgjIy3+U
	seX7ldoiiVdcJb8K2f02E/d4hBJsh2SXGoqmex4DqbvpPJDfe3nFwjYWX+J0LWRIQj3F+cbsewL
	IKo44FiF2Vm6NUadhRPcLCx5sHeQZBbBOiDDSFYEEw//WtJZ2VMRsl9C7NitvDaWJTGxkTNyxN3
	C26fBMuToASutPZzO2X8pPBitExwDkIr5eyHjnTgJUBW9CriGgj/5CfHn7BVvzGyz+q6tgA5Qq0
	OVkQ==
X-Received: by 2002:a05:6512:6691:20b0:5bf:f6c1:4322 with SMTP id 2adb3069b0e04-5bff6c14790mr365717e87.25.1793796088658;
        Wed, 04 Nov 2026 04:41:28 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxehov627ria7cs7-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:f4f0:2294:6e69:7e77])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff38c2704sm380904e87.53.2026.11.04.04.41.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 04:41:28 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Wed,  4 Nov 2026 14:41:16 +0200
Message-ID: <20261104124118.34200-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <aulwLCnibXfaMzR_@infradead.org>
References: <aulwLCnibXfaMzR_@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 02, 2026 at 09:25:00PM -0800, Christoph Hellwig wrote:
> FIEMAP is purely a debug interface for file system developers.  So
> running it in parallel for lots of files is highly unexpected and
> suggests a misuse of the interface.

Understood, and that is why I am looking at the alternatives below.

> It needs to protect against agf_refcount_level changing, so yes.
> In theory it would be fine with a shared lock on the AGF buffer if
> we had a shared/exclusive lock on the buffers (which is something
> I've wondered about a few times before), or some other high-level
> synchronization against adding more reflinks.

Thanks, that answers it. If shared buffer locks are ever tried, I can
run the reproducer against the patches.

> The more efficient way to do this
> would be to subtract the multiple mapped extents based on the
> refcount btree, i.e.
>
>	for each AG (and RTG with rtreflink):
>		for each entry in the (rt)refcountbt:
>			subtract rc_blockcount * (rc_refcount - 1);
>
> We'd need a new ioctl for that, but it should be pretty easy.
> The major downside is that this only works for whole-device du,
> but then also any other version would have a really hard time figuring
> out what to do with reflinks the span the reported/not reported
> boundary.

A whole-device total would be useful on its own, but du tools mostly
report per directory. dust handles the boundary by counting each
shared extent once within the scanned tree, so a block shared with a
file outside the scan is charged to the scan in full. That is a policy
choice, and it needs to know which files own which shared blocks.

GETFSMAP already returns that: with rmapbt, each shared range comes
back once per owning inode. On a test image with 100,000 reflinked
pairs (7.2.12, arm64 VM, xfsprogs 6.6.0 defaults, which enable rmapbt),
a whole-device fsmap walk took about 120 ms, against 387 ms for a
single-threaded FIEMAP walk of the same 200,000 files. But it returns
owners only with CAP_SYS_ADMIN, as ioctl_fsmap(2) documents, so it
covers a du tool run as root and not one run as an ordinary user.

Would the refcount-sum ioctl you describe be callable without
CAP_SYS_ADMIN? A device-wide total reveals much less than per-file
owners.

On the dust side, a per-AG mutex in userspace removes the worst case,
threads in one AG running slower than a single thread, but recovers
little parallelism when threads are already spread over AGs.

Thanks,
Lauri
