Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9BE20DD4B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694454; cv=none; b=nyFAZMpR0gxOEzElz41AiYG58JAqfSQNQGohIPGoJKfOIHYVSQpQL4d41XCy2I0beDqtF8E2lXSB5s1u5qCDmyLW8aEPu4QeRSKXk9hg358PvZTiKHTMG62e9xtr106qPmbSPYHiQyfOlydXtAP/4e10hvUk339MF67EUKaitkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694454; c=relaxed/simple;
	bh=oCUXgaUgu5aGE5NzsLb23ORiI4nSjbuBo/3AnPTo9Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qAjFhC+68Bf7Lpe7FeAZUnbCsmMlvRdFLVE9sWtDfeeDCSMkQPsEysY8uLyCyOc+VGG4s5goC0eUwb+mVkftySXwsRyssGtr7mD5IBBvL76JcujJRhzXZjErZRmBNmdQ9jItmUy48NordgOSNYJEgdvJQAINYDRwPxt89DV6HAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PHrMv7Ky; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PHrMv7Ky"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844df397754so155559539f.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 10:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738694450; x=1739299250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NY7xqGeHOHxhwlXe+M+SeIr17C8FVrQdcyl8QwUHMXU=;
        b=PHrMv7KyzFJV04EJsflhlIWFHL9d7A8jSMUDSHpVh2yEq24gY6khnVRlWNVs1Qvgmf
         mfwhvra3mcVTv/W7IjQKXyNaxim4BMXAGvNo4DDOLljggnYYk6jM00eD4XOccSPTKAsd
         bVf3pnj9L3zFtqksVKLWYWWWZeUIq4h2fyhCxg5p717a1nkplnntgcCUjtaS0yFCDZeO
         IGO512u1zitFPMcJlWeKSfsngTDU4Cj12nrUQ0NCMo3om849Z2rtmtI5+9QFPUonXHSk
         ThIqIkOkgmOAPiUWv11Le844O4LvKrpwQuUDrW3f2lLIY2GVIIjOACBFiTqwONtKbStB
         +l5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738694450; x=1739299250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NY7xqGeHOHxhwlXe+M+SeIr17C8FVrQdcyl8QwUHMXU=;
        b=Xft7BfaJ8BBJ9Vh0g5nSNKYaCd5sK2iTXsA39DR59CNx2/8QQRi7VvEepEuecgTWut
         dyQAxZ6yWTm/EPMWjCW66Keg5IDpA//NISWYNyzlzOToTLrfGgmWErEHRSdSA0tU1He6
         GjiCAIx8EEr4QUyCAsUc50d5wZt+HMl0n1M5g+hspFAAlUPMsocIr5aqRQ2qHYz09GD8
         G+u8u4OxPy4LuSky2G+oY8czY040CuLv8ZO1jCWxakUD5/RctWZChXu07PYdI/xcm9ZE
         LZiUnvpUd0+IBjUSH7dNMeNr6CabmDlqOlUlZfvb6pVoLDBWhevFzUrODrorAmByg1U/
         espQ==
X-Gm-Message-State: AOJu0YyyciFZ6KJpTvOPQJzoLKdvuSuayfaG0P0YhgSupBPc+OrldmnV
	aHg0A86r3MXrov8rOIE/fMfF+BULqkmV6DFpax7Ry7Rvm2q7LA5m/Iz0rVXOSds=
X-Gm-Gg: ASbGnct+kuT+YaJYfjDvLdwZ7XiaFBw9DJace9lU5jvXxwALDdNz585My22QzB7FY++
	DWkUU4XWaX7TLob6B7Hoe7/n1dUjY5Pbzz6MgJpPZaXDmpCEqxedLd+EtDcwgvezHuixCYWTkdC
	cCHBBRUxpKmOB3tumWfyM8MJiggTAQDHfXIo1Xz1bHV3ZzaUinC2rXQGSYcAPMgTHcmJHpd5zqt
	IIlR6jxqVNWbKgMPg7Cy1gztoxvXuAMhq9m/kF9N7DjVkjCjzjVB8I0MD0yQ1tZsH4E7kGsf4GH
	HELg0FW0wH0E0x+CPbI=
X-Google-Smtp-Source: AGHT+IGBzQ8psMkY7kz4mFKr3er7gXHXC7mNs685lvgAydKecrq187OaLS3vE3tuvswYLETicAeH3A==
X-Received: by 2002:a05:6e02:3709:b0:3d0:10a6:99be with SMTP id e9e14a558f8ab-3d010a69d12mr203848455ab.12.1738694450651;
        Tue, 04 Feb 2025 10:40:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec745b5054sm2843148173.44.2025.02.04.10.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 10:40:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHSET v2 0/2] Add XFS support for RWF_DONTCACHE
Date: Tue,  4 Feb 2025 11:39:58 -0700
Message-ID: <20250204184047.356762-1-axboe@kernel.dk>
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

Since v1:
- Remove stale commit message paragraph
- Add comments for iomap flag from Darrick

-- 
Jens Axboe

