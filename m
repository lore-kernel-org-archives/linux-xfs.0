Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99A445019
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100614; cv=none; b=UxbUVq6dVsfLJop2VKKDHu0srXA1EWDjrnH4rjkuvtqE5lefOL2MeX7OjlNz/h484xzaF+zRBKBsYnkUDXhjxo7gSuGLGjWjFpKKSiTL8z/wcaHkJPgRU7JYGnS7+nDG/6Zx0U7mxTETYgP6f2IjY8O9uFfLAs9hMfeK4GiltUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100614; c=relaxed/simple;
	bh=iD+RgyjalIvdogv/9uaBd6NI1llbUWMvFhClFjDA1ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQ4Rn7zZE2RupNWnr1ExgActoK0z3Sy+dWX6QdHWyiGH4NXq5X7BC1XmAjUL2qH3SNEg1r9ZsFzknM204SwsrFvFi0xMZY9+5jIZ1ybEaOLm3O58FWGY3Y7EwzAuB4qL528s4wdQ8EBtiZjMGebkURoASp8RVss/X+OnKhe6+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UWkrJrrQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UWkrJrrQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ea7f2d093aso5415256b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100612; x=1712705412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ERY26Qzt+Kq5tgdp7geru/m/eZo5PcXD1kBDYu0VADo=;
        b=UWkrJrrQtZ6c4nAZUouEV+EruKjok6sc+NpcWavFs4Zg0ZDW0uYutzhIEtgK1kFXSG
         VQ27HayVIkJwGkjobMRG1EI9bobdUpv3Eo2fT/XDxZ78ghFXwv02ZXEknfhKNdu68buC
         uy2OR6LQiJDtk8hlOsZlrjngv5RzoPLgcHnAnD25bmKeVyj+ZoDlrC0nJepbN8p08pm9
         fR4sxZm5H/igcisXOZoIWIQAnsz8c+rpf/ZFjrx7LRYFO5qkaxpNHIQ1z8egzIf3XdXL
         rAF0NurbSAUQ5HVwnbLMrB8v5bY/BjyZSKWsl49Hnxv0N/qPx42l+5nKIPIRc4S+FTAe
         bSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100612; x=1712705412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERY26Qzt+Kq5tgdp7geru/m/eZo5PcXD1kBDYu0VADo=;
        b=cYxKhl09nVGLe6cqFxWFQQGRD12wmHyk+kUdDMYEjEDFfuQ8CYhpSSJ1+LHLNhVkrd
         ragHo59YoBBk1D9ShUn989GjlK6pxo5CuMuWhv4Y7xzihx6xYAiggXoeWwfMqXyQ9JK0
         j58t/+WDcmBWQzHpSyYzs5w1kUyQaSsovGwmaEbpfckBFGqSR8czaUxSSDPMdf2BV+pw
         OyiZIDDAxq93rs2BACXJFJntO1Fj1vMNHYx75OGq5y/W7hr2jEZp5sgfjbPaK7DQW+el
         58DABfiiRVoP0QsWj9P73whKQr0H0977JsvkuBHieVQgWeH5tx35iiDcpASmDHfGUbfG
         K4zg==
X-Gm-Message-State: AOJu0YzhN2mOgTU6F5PfixMbKHkOYFBH8A8iBu4CiMtCpqZA80IiZNSu
	aoTkf2cKnwFuANneQFBk1bv2llBxuG5hxFD1mf/3m+iCMILiZzw7CmEnuR8SLUWrLHgDsmqF/lc
	e
X-Google-Smtp-Source: AGHT+IEnlJYJw5PAK4ypYlKbXV4N3TvdsrNczESltfrRGnj+99Y+RB2DK38KhjIqvO1qk3EWkkyvRg==
X-Received: by 2002:a05:6a20:12d0:b0:1a7:1f8:9be2 with SMTP id v16-20020a056a2012d000b001a701f89be2mr1607130pzg.9.1712100611933;
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id m9-20020a62f209000000b006e6be006637sm10356717pfh.135.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001sy4-1c;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZw-000000054r8-49gG;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 0/5] xfs: allocation alignment for forced alignment
Date: Wed,  3 Apr 2024 10:28:39 +1100
Message-ID: <20240402233006.1210262-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset prepares the allocator infrastructure for extent size
hint alignment to guarantee alignment of extents rather than just be
a hint.

Extent alignment is currently driven by multiple variables that come
from different sources and are applied at different times. Stripe
alignment currently defines the extent start alignment, whilst
extent size hints only affect the extent length and not the start
alignment.  There are also assumptions about alignment of allocation
parameters (such as the maximum length of the allocation) and if
these aren't followed the extent size hints don't actually trim
extents properly.

This patch set aims to unify alignment entirely via args->alignment
and args->prod/args->mod. Alignment at both ends of the extent
should always occur when the free space selected allows for start
alignment of an extent that is at least args->minlen in length.

Hence we need to modify args->alignment setup to take into account
extent size hints in addition to stripe alignment, and we need to
ensure that extent length is always aligned to extent size hints,
even if it means we cannot do a args->maxlen allocation.

This means that only when we completely fail to find aligned free
space to allocate from will extent size hints no longer be start
aligned. They will continue to be tail aligned up until we run out
of contiguous free space extents large enough to hold an extent the
size of a hint. Hence there is no real change of behaviour for
extent size hints; they will simply prefer aligned allocations
first, then naturally fall back to the current unaligned hint sized
allocation strategy.

Unifying the allocation alignment stratgies simplifies the code,
too. It means that the only time we don't align allocation is when
trying to do contiguous allocation when extending the file (which
should already be aligned if alignment is required!) or when there
are no alignment constraints to begin with.  As a result, we can
simplify the allocation failure fallback strategies and make the
code easier to understand and follow.

Finally, we introduce a stub for force aligned allocation and add
the logic fail the allocation if aligned allocation cannot be done.

This has run through fstests for some time here without inducing new
failures or causing any obvious near-ENOSPC performance regressions.

