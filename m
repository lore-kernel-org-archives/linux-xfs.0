Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07F15E810
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095895; cv=none; b=ZO9ewRIPz+0V83HnkKNf306VKxRUoYHn5ieHfZVaWILM1Sl58LGVc5DmLEKa9F4dfCBEVwHYkv3AKBV1QmDPkcpaIa/0+2xLbMI8LYro47Kqs3tG2eROq6xEXXsyLPKHpjWNrFnZwS5OfTsjZt9LOpDLCiSiOewgdXL+J6QTMWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095895; c=relaxed/simple;
	bh=s+hEvMbfl0KtJ8JAWMgnToXiPJsH1qGZ8Jp4CNVaJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TiFS5b0294f5h+h0L8Tmj37iSQtITNcG+fahPsfUCiTfEhdjEUNOHuoJcWVJNicDzX5NMOUgt9USYDxpzkXQi+sMSDDR6jTqCOiEeTW8coIyByazpdElp1O1xldz4fJi4hJkF/i6l5OL1+3+ibAVsrBsXnqA1FEuve9kTALamhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lNv1n85u; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lNv1n85u"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso4615616a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 15:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712095893; x=1712700693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UPkGEH0q5+R59shNSAF+wWW8FUJj83mUTCjp5bx9gCk=;
        b=lNv1n85ueDdQxtWbkPvaNDENwvCVs/c0vmsv0AAN98rx7PqXGhmz/RjiD8mAZNISvz
         D+MXbabwNZFHD6775niszfcbPkfdJuldy1XUl0H+6Fc9oXWdkyWw7GYSg4DgEX20iy7r
         +AfTJY2/cLz2wV24+x0W86q6ZOwACCN0RRJQDn5vmBly0bosw0+GBvvZWv2+zQovtKuI
         S1Q4bp/399RZZzjxkvr6OrafWcL6uUN7xamekngZbf74sqH/UaWdrTNAU//bUvKz85Sa
         vLSbG5mcfJiSyduuukW80wdPIWsHsviT9bgGmxFwjPYykcPFcCaylIJtfsyCSBO7NuWN
         Ze+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712095893; x=1712700693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPkGEH0q5+R59shNSAF+wWW8FUJj83mUTCjp5bx9gCk=;
        b=p1ogRAb/o1/Ysz9++3Eo92MapIfxMSGIDYoESZ6sZqtciP5/0woeRkL9cmwOiIjFc+
         lF2ufuaKI4FzE6CrML6BfESxgiVVFu+i3dybxIt0zK24cop8gf2y7TpfkdeypSHlvSQ6
         MOhEOmGTpI+TLSBULG5cZZdv8eECWeElYeYkZIOmVRabmNtrbMO5uYEIrf2OtIQoFtkE
         k8yGNHMr0iuA2jCKZReBFv3APxmtQNVvzuXJfoV4apBp7Wi6TZfavloSJV83kNv/GMco
         v3MIsiY7SnAwBv0pE9mmbxQBIrHFiATSezHGmaPZ1UeM5DuV4lt8Gune3wMJ+ZhT+5eb
         suyw==
X-Gm-Message-State: AOJu0YxrLN//lIe1rb3ZIhDXQ8Q/7WAcR1rXHcXlhSRpPmamvR5oN0Sz
	pA6U6DLdeFR54HIuCy71HvaSlLkmtv5KVX4LhE5B+tcOPLTc7J0djvo8X00lu+0n3NVG8I1TYS2
	P
X-Google-Smtp-Source: AGHT+IHSbil95lTWYoGUUB8hmyBmVstDRVtxQ4kAM33qDs/PYbc1aKLZXWd6xqmhqxpSvKf3r7vsnA==
X-Received: by 2002:a05:6a21:8cc8:b0:1a3:7e88:2262 with SMTP id ta8-20020a056a218cc800b001a37e882262mr17372000pzb.34.1712095892946;
        Tue, 02 Apr 2024 15:11:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id b3-20020a170902d50300b001dcb654d1a5sm11647680plg.21.2024.04.02.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 15:11:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrmLp-001osH-33;
	Wed, 03 Apr 2024 09:11:29 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrmLp-000000052qp-1tXg;
	Wed, 03 Apr 2024 09:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 0/4] xfs: fixes for 6.9-rcX
Date: Wed,  3 Apr 2024 08:38:15 +1100
Message-ID: <20240402221127.1200501-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Chandan,

The following patches are fixes I consider necessary for the current
-rc cycle.

The first patch addresses a potential regression when allocating
temporary memory buffers for xattr block manipulations. It was found
during BS > PS development. While I don't think it can manifest on
existing kernels (because xattr block size is limited to page size),
it's better to fix it straight away so we don't leave a landmine
that will get stepped on sooner rather than later.

The second patch addresses a regression from the 6.6 kernels. It
removed ENOSPC detection from xfs_alloc_file_space() and replaced it
with an endless loop.  This patch essentially reverts the commit
that caused the issue because it allows xfs_alloc_file_space() to
fall into an unkillable loop where it will endlessly retrying an
allocation that keeps failing. It will not making forwards progress,
and there is no way to break out of the loop. A reboot is needed to
fix the situation. This was found whilst triaging a bug that
corrupted free space accounting.

This was trying to address an issue with RT delalloc and the whacky
"delalloc does partial allocation but reports no allocation at all"
xfs_bmapi_write() semantics that was causing fallocate() to fail on
delalloc extents on RT devices. This was the wrong way to fix the
issue - we need to fix the whacky "partial progress was made but
tell the caller ENOSPC" behaviour so that callers can distinguish
between a hard ENOSPC error and a "keep allocating because we made
partial progress" condition.

The third addresses another problem found during triage of the same
free space accounting issue yesterday. A fchown() was run, leading
to a new dquot cluster being allocated. The transaction reservation
succeeded (because free space counter issues) and then the
allocation failed. This code does not handle allocation failure at
all - it has an ASSERT() that allocation succeeded - leading to it
trying to allocate a buffer over a disk address that was not
initialised and "access beyond EOFS" warnings from the buffer cache.
This patch handles the allocation failure in a manner that prevents
a shutdown from occurring and ensures -ENOSPC is returned to the
caller.

The last patch fixes the free space accounting issue that uncovered
the bugs fixes by the previous two patches. This can be triggered
from userspace, though it requires CAP_SYS_ADMIN and so requires
trust/privilege to be gained before it can be abused.

These have all passed through several fstests runs overnight without
introducing new regressions.

-Dave.
