Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34EA2676F4
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838218; cv=none; b=QpI8iQGYqSYDOoCrj39cepnrdW+Sy2BKUEikaYxH9UzTz/1QULZgm1In3Vb25ev4A4/NTb4Y5pK1ijhhZZN8ILjeeIggseH5eLpr+8cniOy3U/a6neL+1OigefwvNbuTqdRV5iiL8BxyEZIzecffB0MyX2MUOH57T8E9bOlZFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838218; c=relaxed/simple;
	bh=wbatvSc5zqDCLsj2CQf601+pVeXE6nWgp+jdwAsun+E=;
	h=From:Date:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XXGfd+ISAmNUAHo6gLcshAICwF4Fd0ce+0sendMPqyC3q6v5w0kYY45FrcDwOOfgRm6gh8LbJ302Eaoz2ob3P9Cj7lbZhOYEX9+AkAm8ku6X+SRgerQwBSgpNk0ZZ+Qzigiri10/q0jX0rScRfT2KTqBNftwpB3AmJgmV4veXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+8G3qeD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+8G3qeD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761838215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=/iL0E0FmuuTFitLOn8c1GYACVCMUBSGpnSgThi/YTLs=;
	b=S+8G3qeDiuQsBjx/X4iCymt5IqLELIxyMNy730H7LQATGV0cnFklIji4YkDPok18Rhuo9P
	HAa9f3noaHZkGBTUdqTMwR4mVFiYOVmFqCAOP/xIyeqinCwUrQ8QKTUt+uVnwPobCoMLBm
	Vl05cPYxDgiSRjVgedHFzkUhquhuduA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-ntyBM5UiMKSwMt8Yz26i2Q-1; Thu, 30 Oct 2025 11:30:13 -0400
X-MC-Unique: ntyBM5UiMKSwMt8Yz26i2Q-1
X-Mimecast-MFC-AGG-ID: ntyBM5UiMKSwMt8Yz26i2Q_1761838212
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-475ddd57999so8738165e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 08:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838211; x=1762443011;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/iL0E0FmuuTFitLOn8c1GYACVCMUBSGpnSgThi/YTLs=;
        b=MMRQnryHrbg7TJElc/6GwHP6r3LY9ySP/X6oqucnOrZlyMfc+sHCshdjqBVkJZs2BE
         emeL2cGLtBoFbQF8z+xroTX2FmMWD496hetm77tDhJkgfEIkMks6vEmVBtLOmMVKBNJ/
         talkdnHHJMa1+F+jV+gonm2+GC4yj9Y0z8RqcCFOOkzaatSY4fNFWHmFNRYSOM2WH1lD
         9XW+e2DHmaUqvCB971R2Qk03IDLB05FsGXWe2glCHJAj7CW2CdiH04X646ZyIHFjBcOW
         s47s8Y0k7zlzV6sRSl+Ta9hHZEOX5VEl0IEgSCvrZMGJX1zXyzDtznhOWnC0VYZhKa3e
         +Tmg==
X-Gm-Message-State: AOJu0YxhhOsRdT1QnlwslDM1EjMYXgpz4enVF3BHZs8NrOipnqnRnhCO
	prurso3N6rJ315zcOCSj/mj+jAgBN1DZEA6aecVfpzTtsKyVuhLTpWylyIlWLv1w7FllODWWYq9
	4iiZl+8cSqdNZ86EJlVdeQQUiPp6m+3pa1Q/muf+qZ4dR/gRu2A2I3WaKbbXHgO4WAgkWwcFu/S
	suu2o79cUFO6els2M3ZWTwV3pNJE8dot18jCa9evBVQRwk
X-Gm-Gg: ASbGncu5+y0C539xmZ865tpaZQ2KrtIqlEabMNgBc7FfJRegtDFhWBKwAjzFFuJ+7Wq
	g5rGkF292s38vCM+vC4OK0QhlZAxhJMrHcwcGUXJOZTEp2cZ/4GSVGPKPvHfloIKgQ9SpMQjTHG
	OSHmmIrFK9r43bvbIjTj07DVsPR37UBQOu+na/5cYykl4bYMh0U7jknw53r1YB1Q+BfQr8Xd1zt
	fJuXTH/qBKEc7nSi6C3EF2Znp10olfiq1bebmcj6pMpMw4OUC5NGgI61p/AWjzAOUhY5BJ/xjsq
	JMcOHOI0gsrNCgD+e7KMzLF07yFUQpaE85kFlR4TEQyJ7rjtlj2mnRExLo98yNPl
X-Received: by 2002:a05:600c:348a:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-477307c22f5mr1481785e9.14.1761838211451;
        Thu, 30 Oct 2025 08:30:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdX7mCIVDw0C9uUK3AN9nI48uZotQy3os0Sj+T8VNYaeCSFY7AB89nkb+OVP5I9mc7QHBaoA==
X-Received: by 2002:a05:600c:348a:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-477307c22f5mr1481105e9.14.1761838210681;
        Thu, 30 Oct 2025 08:30:10 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df682sm32400420f8f.43.2025.10.30.08.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 08:30:10 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 30 Oct 2025 16:30:09 +0100
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com, 
	djwong@kernel.org, aalbersh@kernel.org
Subject: [PATCH v2 0/3] generic/772: split and fix
Message-ID: <cover.1761838171.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This one add one missed file attribute flag (n). Then, the check for
file_getattr/file_setattr on regular and special files is lifted to the
common/ for futher test splitting. The generic/772 is split into two
tests one for regular files and one for special files.

This one based on top of Darrick's "random fixes" patchset [1]

Changes from v1:
- Remove patch which added file attribute as it's now convered
- Use TEST_DIR instead of depending on SCRATCH_MNT

To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: zlang@redhat.com
Cc: djwong@kernel.org

[1]: https://lore.kernel.org/fstests/176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs/

Andrey Albershteyn <aalbersh@kernel.org>:
  generic/772: require filesystem to support file_[g|s]etattr
  generic/772: split this test into 772 and 779 for regular and special files


common/rc             | 32 ++++++++++++++++++++++++++++++++
tests/generic/772     | 41 ++---------------------------------------
tests/generic/772.out | 14 --------------
tests/generic/779     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/generic/779.out | 20 ++++++++++++++++++++
tests/xfs/648         |  6 ++----
6 files changed, 142 insertions(+), 57 deletions(-)

-- 
- Andrey

