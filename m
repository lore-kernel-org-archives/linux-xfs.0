Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45622C21F7
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 00:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788137249; cv=none; b=ZTpjVLTwx/ckERLcPVJsM4DCHKjNeXvinDKKWf/vVnEYoPnknLY6MrldDRGjJPP5Q6YHR701FUJO9QYSBT+736lNCFAWPnjua7tj7EsUAf1Flfy79X4Uhir8hH5L+vn+2Qh8L1xsmV7Vgu3egkmKsa52/T0pUXZDkhJLA7uqwJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788137249; c=relaxed/simple;
	bh=MQpEu3wDAHZbqdrzHyo2zLigoYyYqflCjqnCr9jAqkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QvFOhwf7NqTfXZBJ+P7us6Li/U56nGNDo0csBCQc/4iSdd9jB3/+96v3sVgeimknMmbN6jdv3triaRPuHR0Gz++XAwDgVukeDYy1SDu/h+TocdofhPyuanrTfuCk9ee5yYp6oziaYkCsly6KCVOGN75mky4ERAA0EiKAt1qJ2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sTOl0lfW; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sTOl0lfW"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so2339010a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788137247; x=1788742047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A+W4QAJjuVkYQEhPreimIx5fbHXfcE4i26hZPrxZmPw=;
        b=sTOl0lfWB+j9Z1+HhiIzgWqta9eoVGPwE44bsv0bAAVGo5YOp3/I1/HdMwrMHmsR9T
         Dwsflgf5gV5mMIWXtRzTcDqxY6d5G1zhZE3WaQM2KxEe6169OYLUNIoJQPbM4ZsyPdZu
         JBHjWKIzxqtTU1ldExwzuXhlxT8c3DzJpK33b1stIPUKPfhPjQWNTtgT8TGR1vw2lzKD
         rGYXujpudf6zrubAz6T9eQwVG+0u3+jrkRCzDL4jD+6CcdEbCCWE2gi1Zbhs+h9deJJV
         TRzu19w9zIAH49WQjoDykoVMnYP6rARQqdXWBFfDPnKw29PpeFrUlnOQoTuUbZvac1qO
         NpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788137247; x=1788742047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A+W4QAJjuVkYQEhPreimIx5fbHXfcE4i26hZPrxZmPw=;
        b=Yr4pOaT3BaZizAHiTzpQfuVtJ2sTbmErKh/T6gYmH5BMhC8ypH9flxemvfuvsUW1T7
         q4s34qIXsRmCv+1YHFRHPbPX+mFN43nc3H3k9XEOOJitkP+xhA4eGquv2+2S7B3jgplL
         x4d8jCa8zo73lOBtOSbRzrfLLFw8S3jI0p0JFYBJT4KuaPHkytJD79mr4WEPtYMssFUw
         flUekmcf7skdb1UZZL2nSKvlt0vTqTFyptEDJTmKqnPkdJmTfjfzDElJYbyefjHmkzVZ
         TTneDSgSQW2fm25+pD5eLhuxqZiQ1hpV7/Pwn6PywMM/LeFC6NTRLnQd1x9d6r+IVyIl
         42jQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCmMNrsV7FGVujArsw3iWXKvtdn910zB/oNfOQu3aiX4AJnEQUuwYZ1snG7JcXy78b8qtzXB5mC2U=@vger.kernel.org
X-Gm-Message-State: AFuF++lIOooWC1hfpYk7BTroBGdPvXKpu4FqUXPJvOJTtTna67jqiESw
	EYw3RJDFqZ4XxTSsI/yVu6awMsSBr2F1U8fybv02HrJS3/JPisiJ06c4
X-Gm-Gg: AYBFou3UREQ/4GUGGN4z/Yq2IVopBCSpV5BxcI+Id78t486S1bX81G2bmk7TcRwjup+
	/66x8WeBwu1sji4FO60QxNTljdxU2tAUfLVidZUHzEXR5WXbO9pzd26nMD+1c5xdH5gpKaKd+0Y
	56kUnHLK4pamnFJecawyNpocohDP08xS+8ZG1cb1Zml49DFifbOrZG+Ec3n6Bw+SG+idq7D17/T
	dLkxqpfD0UHwMKAfRHDyq8xhIV/OvYo+Gtz3v1hso6AuEah1axdzdMIbJiAAVC/aMw2qpy3ZM7Y
	qnLnFobzs9xtZUYmSncaGbb/rwwhSOWE+ROjSaWsynLMqQ9RCm7ptmevLQOUjLWmJ7L5PMWk3EF
	N+GatY7D3BLgKtV+ofYKnanC2XabBRYBWsqfvcE0ZAV18K7qihRhWtHJ4owhxwmvYS+dCKBaBnm
	BDNMGxnEsKyjTtHHxEl33BQvI/VipiQkIAWbx+GKwml3U5Mkfa4HTt9eb214ImD8z88UTNzkaAc
	5GHCQNM2BkOhae8xiZjuA2aY69y080Qo4Hlbj62nbArcrt29gdJ144=
X-Received: by 2002:a17:90b:3ec7:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-396d1041324mr29242537a91.16.1788137246849;
        Sun, 30 Aug 2026 17:47:26 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda36ed6sm13688653a91.2.2026.08.30.17.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 17:47:26 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Eric Peterson <linuxinstalled@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Peterson <eric.peterson@hpe.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Date: Sun, 30 Aug 2026 18:47:00 -0600
Message-Id: <20260831004700.4072037-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <apSgHPl4er6Jy9xi@dread>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com> <apSgHPl4er6Jy9xi@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 31, 2026 at 07:26:52AM +1000, Dave Chinner wrote:
> Hence this really doesn't seem like something we should be trying to
> infer from indirect filesystem stats. Why can't you use the bdev
> stats to get the actual filesystem wide queue depth information?

The block device measures the device queue, which is a different
quantity than filesystem outstanding I/O - not just a lower-layer view
of the same thing.

Below are three cases where filesystem queue depth is not what the block
layer sees:

1. Cache hits never reach the block layer. Under a heavy read workload
   with a warm cache, a large share of ops are serviced from the page
   cache and are never seen at the block level. Device queue depth can
   sit near zero while the filesystem is servicing a very high op rate.

2. Filesystem ops don't map 1:1 to block I/O. A single read or write can
   produce one block I/O, several (metadata, readahead, writeback
   coalescing), or none at all. So device queue depth isn't the
   filesystem's outstanding-operation count.

3. Work can be outstanding inside the filesystem before any block I/O is
   issued - waiting on locks, log space/reservation, delalloc, etc.
   Such I/O has entered the filesystem but is invisible at the bdev.

The block-device queue depth answers "how deep is the device queue,"
which is not the same as "how much work is outstanding in the
filesystem." When the filesystem is just one layer an I/O passes
through, the block stats fold the layers together and structurally
cannot isolate the filesystem's own contribution.

To be clear about scope: I'm not proposing a queue-depth feature in
the kernel. The change just adds read/write completion counters to pair
with the existing call (submission) counters, so userspace can compute
outstanding I/O and derive a response-time estimate itself. The kernel
side is only exposing the complementary raw signal that's currently
missing - calls are counted, completions are not.

Being upfront: what userspace derives from this is an instantaneous
approximation, not a precise time-weighted queue length. It's meant as
a cheap, always-on aggregate, not a replacement for accurate per-op
tooling.

Does exposing the completion side of the existing call counters seem
reasonable on that basis?

-Eric
