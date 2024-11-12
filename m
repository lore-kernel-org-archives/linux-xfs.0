Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593D2194BD
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449968; cv=none; b=Hd2QW2kT5f91yOVZR0jNJFoAD9TDVeamQ7aFps5i6+dIvsd8nnjaigXxvCl+ohN3YpnR24GxG8RPQs5UaLRwYU4EfuI8Fp8+maEvb0sB1ewiJAqHGdpJPxi9oRX939R1uNx2Gc1D4f+8Qu2nIegDXdKlfxCUaLeGDfXFe5a9FBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449968; c=relaxed/simple;
	bh=cPSI/nqyIxHAf8YquedTQIL6L86Imnft8s3oK9B+QFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dfwK0I4bfJf5YU/z2rgbYt3cj+depSpXfsh8DeK82n4W2C4+VEv+X8TXof7Udnd5LoSp01HwCH0ydVgsFszaqhtUvj62lv1um+5e7wrj7CHhm/jLC8TKuiedYTQh4pb5WgZ2ulynHj+AS++V3z3m5jfk1TIPYYyEhmbUxapBM/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wvyksmoK; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wvyksmoK"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-720d5ada03cso6298213b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731449966; x=1732054766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cPSI/nqyIxHAf8YquedTQIL6L86Imnft8s3oK9B+QFM=;
        b=wvyksmoKgou791AziTbDpdkNYvWA51PJVmjJ2ppmZ1DFKw3nQhiDAjoFG1uU2zlhR3
         xfjDNxAWvzmI2IHwgBhWj1bHiqS3BMeSEBzzhDYUyQLMOTYJqtUnxW58iOPZKdK0YXG3
         xAX1AAnPevg1kv6MtzcdV/C7Jn+0/9Fg65vKn8kvuVGsJ0OqqQ9dJXrE7EScsqQ7C9NO
         MVsc8ufnOL2/w11mt21SrcswslTDtWwU3+gC0AqvhqP2PKEHi8Rnw67aa9QXN3GBZvFz
         GSno96cayenqKpro2uWWA874nBu+imH7cWjakA0DxlErv2jCuHfa/JjBRGQn0bumbgBB
         UDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731449966; x=1732054766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPSI/nqyIxHAf8YquedTQIL6L86Imnft8s3oK9B+QFM=;
        b=H32SBZ8D0sJo6np4KmMroV0QDbVLkEjf1SeWlqncsqCm/Mp9JG+5UcpInaMo0wVMKa
         Xk+dCnPfiOP7e2Gk5lLcn7ddV3MdVrMzL6BgplFafHsdbqezfgJvGwMkZr2UmG4DGNAR
         IERssG2qJH7qcS+m+Ro7id98+8awcZefzwElFp1HkuC23LzyuuAPvPS2hoN/btpfSMCe
         g10sH0DG6gCaPuVe67lCaWvqXneE2lk1AdiO6bYVHoBMdQV+ncKgxFRIWRtLN5ogrDde
         3PuaYchbpS4Qs2TAIHNmE0oncfFdYiqENkxEX7FEnZOrQF4+1Fy6FnWu0S9mJVyU1bk5
         b6Rg==
X-Gm-Message-State: AOJu0YyFXxYX1lN1d0Ja959rZ2TPRWTbKmaU3i3ElqKlXsMZMWcNedy9
	T9jIB6j4a7vUFDE4ki4NLU7Bunlun5XIgLlZKUx8YASNi7YthsC2KJxIQBEy8C0W0oySw4FoCSq
	n
X-Google-Smtp-Source: AGHT+IGh+ZtOS0+MAkjYSQI8ZY32UtJDmdVjBzMEJ856+W0P+R/pJs8tizRm1tYXVygaPiqcbKfr5Q==
X-Received: by 2002:a05:6a21:2d86:b0:1db:e329:83f5 with SMTP id adf61e73a8af0-1dc70380a6emr1111373637.14.1731449966352;
        Tue, 12 Nov 2024 14:19:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078609ddsm12118663b3a.22.2024.11.12.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 14:19:25 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1tAzEH-00Dooo-0W;
	Wed, 13 Nov 2024 09:19:21 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1tAzEH-00000004e7u-2NqZ;
	Wed, 13 Nov 2024 09:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 0/3] xfs: miscellaneous bug fixes
Date: Wed, 13 Nov 2024 09:05:13 +1100
Message-ID: <20241112221920.1105007-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are three bug fixes for recent issues.

The first is a repost of the original patch to prevent allocation of
sparse inode clusters at the end of an unaligned runt AG. There
was plenty of discussion over that fix here:

https://lore.kernel.org/linux-xfs/20241024025142.4082218-1-david@fromorbit.com/

And the outcome of that discussion is that we can't allow sparse
inode clusters overlapping the end of the runt AG without an on disk
format definition change. Hence this patch to ensure the check is
done correctly is the only change we need to make to the kernel to
avoid this problem in the future.

Filesystems that have this problem on disk will need to run
xfs_repair to remove the bad cluster, but no data loss is possible
from this because the kernel currently disallows inode allocation
from the bad cluster and so none of the inodes in the sparse cluster
can actually be used. Hence there is no possible data loss or other
metadata corruption possible from this situation, all we need to do
is ensure that it doesn't happen again once repair has done it's
work.

The other two patches are for issues I've recently hit when running
lots of fstests in parallel. That changes loading and hence timing
of events during tests, exposing latent race conditions in the code.
The quota fix removes racy debug code that has been there since the
quota code was first committed in 1996.

The log shutdown race fix is a much more recent issue created by
trying to ensure shutdowns operate in a sane and predictable manner.
The logic flaw is that we allow multiple log shutdowns to start and
force the log before selecting on a single log shutdown task. This
leads to a situation where shutdown log item callback processing
gets stuck waiting on a task holding a buffer lock that is waiting
on a log force that is waiting on shutdown log item callback
processing to complete...

Thoughts?

