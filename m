Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516A420AF99
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600470; cv=none; b=AWHeVtACvUsAiLEYdvhOY8JH/Hw0D0xGi0KMalPXDAufcko+eX61Pvo1nP6vg11Qzzm4cdO6+u1UNFi1Gbq+qzDwQ85GWoV50eTYI2tGPr+1BmcYoAAnhrClUQbVTALEk0oQqfhjrhlnOn1atpC47GGnU6ZBqZP6AVxWE+jjPUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600470; c=relaxed/simple;
	bh=D6y076eQMwoYW6/+0KovysUeu/0Nq3tu4XALLRAdqf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CNfxPS61vjFL8MupzbmwOqNps/+LIPT5CN7m2nB5zfoScN+9ykPWNW5CgifIScc+j+Q0hd2BzM43V69Erj5h8iU9/hOJOYCjlD4S0KXjUBCTWFOZhxY0/vTpuQw0N5H9NUonvB6nA1tRDknGblfOCUmQ80kmn+vycQ0e/D1xK0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tnd5AHPj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tnd5AHPj"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d00a6b26e4so38105575ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 08:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600468; x=1739205268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PKA0z3IovImfQpVCDBcM4fsZxyxGPG4Lt1aZ6epGsbg=;
        b=tnd5AHPjNsv5anKASUTfs8caPm51QUA0cY5aNTDeukUUy10WWWlCaOXX985/J/ORSq
         TohEri8DiU4mGUdy7oVTvYcnShfk5VhttTZP2pene0AmALs0RRfxa01wCCMki9fBttz6
         RvF2UqT5l6Gu9HE9Lq+II+V7rTv+vziiIC0Odt+ePUZWyoBmC8KBxM5DTdrTa/+GK1Qo
         Mge+NFhEs1OXXiv9mAhs5CrUYnBNv1daRLKx+l0PXbIp37VZZT9rwxOT0tP3p6gY6O+K
         I00P9V+RextConaoZ8yqv26eV+UCER6zJvOIgAWfASqlULd/SlUhR6x6qn1SK40PddEJ
         2K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600468; x=1739205268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKA0z3IovImfQpVCDBcM4fsZxyxGPG4Lt1aZ6epGsbg=;
        b=c/X21ZZRLRzBIbijkjFkA93fwJqbaspU8D6EIfUvrcNjcSWzal+BxPLDS7t6dmj4Zp
         ky/RD8ozzJVhMd89srmLrQbwV6WRmPO3t5v5cs8GbmmRuJh5WTFiGex0Nl9qRU68DDrH
         6KRBF6d6/KYxbuSX7SOJ1oQiX3wdH1jXj/SCjgbbcl8ke7Qu5N8WYGzfJs74qAFLiaol
         v4xnv3HrQUoh+7Jlm5VXvcmr3K7/ENT18jkDuzt+px/To+bjV1kRP+Zqk/cZDIs3DVCI
         wluNtyL9fkoOtsMjelcu7rQe1odfUaCR+Nm/PPFmej8dCsSluoy93XsLeNkRWIOXiNRu
         39lQ==
X-Gm-Message-State: AOJu0YzZQhG5cXgneZrnuhy28Fy/jpix9sX92Wo6Ssx3NsuwaCX/KF6Y
	9Y3Asx0fb5bM1sQfPDGrVQbmldHmQVr+JqZtdhNWpjJ0MLCYdlu7HK6fMgyU1F4=
X-Gm-Gg: ASbGnctI3rBssfozAEax0qPVHJShlp8LHPjt+gCMXQ/o+PQcVB/FUeuA75UCX1GTBKq
	Q9lcCcfg5/z3sgTuVThMOExXyCzGnxlsUlbscj5veekFufc/btDVz80NAG3mRiuAQu0qaWtpl9Z
	lR0CzM/YGBPLhBBuKW6cEQbEiZxyH+Af2InQcPRwDist3unk7LH61LjPckjRQyOYbQ9cbTOmojp
	AtGuqfOCVGO54engP3eyadXrHnIhO1Ivjqq9RZhaELHJUvasQKjGRsdHtQWvna/QJUx2J26ASNm
	JUstT5+a6ADE1lLiI/0=
X-Google-Smtp-Source: AGHT+IGhkVKwscutKRhbcaS2lVT+g+nQ06KfBYkcQW2wJfu2NR3yD+XHnFeum34LwjqU7lXi0tnSNQ==
X-Received: by 2002:a05:6e02:1fc2:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3cffe46798cmr178840575ab.14.1738600468175;
        Mon, 03 Feb 2025 08:34:28 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c917esm2279580173.129.2025.02.03.08.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:34:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHSET 0/2] Add XFS support for RWF_DONTCACHE
Date: Mon,  3 Feb 2025 09:32:37 -0700
Message-ID: <20250203163425.125272-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Now that the main bits are in mainline, here are the XFS patches for
adding RWF_DONTCACHE support. It's pretty trivial - patch 1 adds the
basic iomap flag and check, and patch 2 flags FOP_DONTCACHE support
in the file_operations struct. Could be folded into a single patch
at this point, I'll leave that up to you guys what you prefer.

Patches are aginst 6.14-rc1.

-- 
Jens Axboe

