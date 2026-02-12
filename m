Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84BB35293D
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904947; cv=none; b=Hr/KLWjYg41vlC+rX6aYXlbecaei/zoD/+g+OA1fQ9e6M4i0v5fL4ZqdiowjafB5SCi0T78O0668TDdoS1iJgtEhnIwaZuTuGjqaA2PBGYVBLu4rHWLzJ+Yl0C59LaY1VR7rVS5zZPhjws41Yw32dhx27P5Cj/PeKWLFcfmIIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904947; c=relaxed/simple;
	bh=1Gj+luuohPnHba36r8Kyu2ouCmVDx0M417TYvUkwtbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sh7bfwo8G1myWcx+EMA9KBGBtcrm49ZsNxgVh67QsobiH1jwI7zliz4SnBMnIyflerlQMCdNOFFGwqJU5EH2fw0X6964Zt/MKeI8h/SI5/2zkbvkQfLTC0bnvi5bMGMTjNBvhO29dG+OrzDANEMVl9DcSXq23esjOdmUkIPBV2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gX2hhOdf; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gX2hhOdf"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82418b0178cso1900497b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 06:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904945; x=1771509745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D+p+o0iKcVUhyhze9aJSemhOaUp3Jt6VRsJnFNuDT64=;
        b=gX2hhOdfvEnzI6U3/wlVkVtBSbghG9vHm7HA/tFJprzFM52/4d22n8AD3oXdEPtYF6
         29r7TBN2ktArV4bANf1rNSSs2LxC3miV37RkAihaUbghJ4/DNuhS2k1z2e8Ct807tODp
         PL4cGbafX17bYyq5G4cXr3eCZJ3c1KXrZ6mgl19FWxUKSAXy0jhts5n+IQc6dRJSWRn4
         XO751mgUcm0UYuFvBg8jVywGMYVuUPUWq+B6aHjes+6ynVzKFnCvdzoMgaJeGxs8+GTj
         tzLk1LEik82nIpYzmAxXhpdhUqfKk81MwK9WF9OEkQ+NcBm+2nGJZXudEBleUNV61Xad
         c2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904945; x=1771509745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+p+o0iKcVUhyhze9aJSemhOaUp3Jt6VRsJnFNuDT64=;
        b=whtgZTzN9/uMMdakhNxNpJqDEc9J5wmsMFJNZx+LRXecVhylgiBfY9rSocMD+P5dLH
         dDWm62SxP2eXpR6Al9z9uWn1Nd57fqMTMRYcvgaqKfdr6E7m7yuLaUt7PQM4ahepwf5e
         JeCcRxuE0a9o/VcT1PVItfv36W6GFnyrs9VFwTgdbG+/wJ2ZakFm7+Zv21IBxzCaZJDU
         4CttNgkqEc6NrE4Eb3SiZXwD9atY0fsbgnU/nAKGB2L9KurBArcnczQaXzQRbPCCKbNU
         aI8bgeYq3gmgM8PaRDPrvm9chmrjz+FXcHiP+4fUduZLcLFt5Qt7dIKfxTuw2HElAumK
         zyfA==
X-Gm-Message-State: AOJu0YxRTUlNmHBBSaUct+3GgVwByiItgbeiSpE5amA+ZflgCDAAa8gz
	adFCECWJ8ssX11DXZQGnmVJYBdUsqUOEKXJJj0RadxrQPc3tJ1hPnRZC
X-Gm-Gg: AZuq6aJVg3z6kYA0XdF5NmtqnDt7N1juzHbkEp/o7qv2bNkC00fSop6ZTukbBMgYvZH
	2JqOScETrclIdEjglW5ANTZ1FYvII/jUxCA2/S2tj/aUS+w7S1i0LW4efehVGwEDMiGk7IhV5y8
	d56ca2nGmn1kzBCuZzSoPv0ye5/tGvq2GmZ/21GQ62k6GlByOPdXk3mE6ijDEaVoSHT2aRG3yDY
	q5ICNGOvY6V7MeU2rvM9jv83pUFUIhtv0br0132Tb+sah+q8hR1+xTOhKLdYpssFddwlap8Aa9t
	koG9mxyObWsVssgqRHoqdaoo2GGhW8nhswyskGcgPkZmn+a7EvZg7hA/Lg4EYOwidaZJA+ZERlQ
	2QgS3QwPDBC4rXXLJJ7zaGIY5HU4Tdw8B4dkmjW+pvENopdqDKYYZHP7lHGXDyS1UEsDH2hfwk1
	j1Io0wFT0YXllpbyn5PK5CojpjJIx8VHunhTn0d1vIELdOY1JP2CYHOWGLMs8KLAqxvLZTDqx45
	/gJM5ioRg==
X-Received: by 2002:a05:6a00:3e20:b0:81f:3f10:6b7c with SMTP id d2e1a72fcca58-824b2e18679mr2377154b3a.28.1770904945136;
        Thu, 12 Feb 2026 06:02:25 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e367b7esm5116590b3a.4.2026.02.12.06.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:02:24 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 0/4] xfs: Misc changes to XFS realtime
Date: Thu, 12 Feb 2026 19:31:43 +0530
Message-ID: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series has a bug fix and adds some missing operations to
growfs code in the realtime code. Details are in the commit messages

Nirjhar Roy (IBM) (4):
  xfs: Fix xfs_last_rt_bmblock()
  xfs: Update sb_frextents when lazy count is set
  xfs: Update lazy counters in xfs_growfs_rt_bmblock()
  xfs: Add some comments in some macros.

 fs/xfs/libxfs/xfs_sb.c | 23 ++++++++++++-----------
 fs/xfs/xfs_linux.h     |  6 ++++++
 fs/xfs/xfs_rtalloc.c   | 33 +++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 17 deletions(-)

--
2.43.5

