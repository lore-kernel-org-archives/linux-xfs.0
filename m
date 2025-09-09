Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E5E4D8CE;
	Tue,  9 Sep 2025 00:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376292; cv=none; b=CP/CYcHo6CPOdruBgpvNBLKIY9Ff1rD143R+uzf12tUpoHCAGl/5TO+7d+WuD5/12G7bJGqdahszMI5wItn3OrV0R3H6Z/GwpvXuN3SEY5Vjz/vEjOSMwOHkXUDgrNQzFSZ1X/aZDV0XGb6IYlT9xwDjrS5ZwW1tySRn502Kfy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376292; c=relaxed/simple;
	bh=WdGf+7GX1oqYLGIVMKnGCpfDd9nBgG9QqXGjKOfeczQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KzdTqJehxwo1oGwL6zVmM1xWLRzLXUj8LrS4CseUoi7YeqOrTr7Lcz/Hoo/HggrnnjpbpdI7DbhsKClpzHf3o0Z824OgVtBg7Z4PTMy8vpZd9COXyj1LQolCHSebI2ucGpkKkk8MOYtE8ShcnKp0dVBBjJHolfXIwk7yUGWwfDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoUyexKM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoUyexKM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24c8ef94e5dso40989015ad.1;
        Mon, 08 Sep 2025 17:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757376289; x=1757981089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qOD5ei9uBXe9lzh0xmikmMLL8kCT/tmChQ9kbfXheCY=;
        b=eoUyexKMqVLHag+hBj77XzF4FiA11iElVbgz5F4r+i1vzj2naqsynoLokRphLL4bKg
         BPgp1yEBTP6iL6YPLllQtoeCIb83Liqmty+qDMEkDiOTJGME2CT1hWLRRPfsHrjWnDTh
         5bx/45ZDg1/kv3JcAzkpI0KBM2pZjk+TEw6e4HqcT5pfo1VhVwe3nEe2NikU8vx1X8bd
         vDOSBMd9PlBg3AVVwPZ8gZpxY58qG8QbH+eD8QOknOFO4+B7g4TY1aLptdp+OwlIrcb8
         cyvh0Zbtcp/NNpeDCTbB6wfTQauDue6eo3dtAZ6dWCrKlDf8Pwn4fvYPKGD5ldN1uEa9
         jMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757376289; x=1757981089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOD5ei9uBXe9lzh0xmikmMLL8kCT/tmChQ9kbfXheCY=;
        b=DH9INoFO8KvkvbGsPh3b7Oc+oWp8nDxMhJXK0ahkGNLtieJy8LLK7rhT0hqRdS/gkt
         cIt6mIpD//Gq+UjblYvoWOsbUaW3EKA7KpifeiSRflpcIPzI5pZn1inLRpDHkWCN0EHA
         SmXoBr5fTVHgaShMynZvCGPAkmIMyn002J1mAVgpMH3/XV9/TBA3aVVEXaDUlLuqJoMw
         1mwH8hjZ1fUHOtVQeke3/U7tTupoEAkrxIbxr0/ILrxzH64vUPNfWjklra38+NHjPUpD
         Q3sXCo0z7CiANjQWSNvmUUxr+cC1lR0m77MniAr9cBagZZ7qCjLGgTk1qOiiJuVzZvOk
         0T4g==
X-Forwarded-Encrypted: i=1; AJvYcCWSPULcxzKWxT8sAspaG3TjeO0FlPtEzOKmVYkypGZ52TC8MoUZanLlrhg0U6ICR7G1V7DbpPKFZws=@vger.kernel.org, AJvYcCXy8ZYI+SIEXrw1u1kSXbgJ+YHwuLeGMlIj1OaUNuu1hRlDIyYCige3knqGkoCGTV4I6RyZLnaWFFzT@vger.kernel.org
X-Gm-Message-State: AOJu0Ywml+MFBaIfxbmRJVNPp3TooW8aRgcl2jmUDAiL6iu6DBieQ+fR
	9+GXhQ52vxwJrjlWRS6Ysm2qr3fnBba+7iT290ReEewzHd6frFWi/Kwx
X-Gm-Gg: ASbGncu9s17D6LftA9pJ8OF99eo84ZuT68E6ywDufp6pIqUu6eLgFBGG1oqAKbI+PH0
	lFlWUwrDAE/BNlmfSDwB5fUKiOw+PvCoP5+N15C27/3C8hPI3ce44VUVIK1W7R+giOXbyP6YIMv
	R6GE12cpwGBtXHFgFxaPyt1+ghvZfXvn0+5kNFPQR07AN0KMpWQYSxBOY/GI5hJzVxX1t0M+MmS
	z2IqkvthMxwLc5mkkfqnYnrRALxLHJJiQnqNtHmBODbq1Ji5/JRv91a86fUOBM2PMMhT2lhbPZC
	jtTOtsVGdON/sfbn32zZgciQUU/96da3/Il2j2BpVV189KI1j1Jhe7nv+5vGB47O0cBWF39XYIW
	5qWsNy9KBuePdmo3gAaF3s/yblg==
X-Google-Smtp-Source: AGHT+IElPRkCKmy3yKD496KWEtWkJi3Nd4zSMZCMWnuyJTlcKTI5S5vbRjGGUWeBjcC+1sK0M4iAKQ==
X-Received: by 2002:a17:902:e804:b0:249:37b2:8630 with SMTP id d9443c01a7336-24cedc3973dmr209377695ad.5.1757376289188;
        Mon, 08 Sep 2025 17:04:49 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774660e5572sm142142b3a.14.2025.09.08.17.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 17:04:48 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id AB2D84206923; Tue, 09 Sep 2025 07:04:45 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux XFS <linux-xfs@vger.kernel.org>
Cc: David Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Charles Han <hanchunchao@inspur.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] xfs: extend removed sysctls table
Date: Tue,  9 Sep 2025 07:04:31 +0700
Message-ID: <20250909000431.7474-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2446; i=bagasdotme@gmail.com; h=from:subject; bh=WdGf+7GX1oqYLGIVMKnGCpfDd9nBgG9QqXGjKOfeczQ=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBn780rZjUPe8MSfrzpy54O25vyTy+awG7zYol9pnnZaf mql42y2jlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExkvwojw0Wzk0GtbEJFUUsS cw799ptq9TJE0lSlSrAt5WL7UrHtRYwM0494u08wK68J3bP99uGddVdbdoV/KN7QafluQY6wqOh CLgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Commit 21d59d00221e4e ("xfs: remove deprecated sysctl knobs") moves
recently-removed sysctls to the removed sysctls table but fails to
extend the table, hence triggering Sphinx warning:

Documentation/admin-guide/xfs.rst:365: ERROR: Malformed table.
Text in column margin in table line 8.

=============================   =======
  Name                          Removed
=============================   =======
  fs.xfs.xfsbufd_centisec       v4.0
  fs.xfs.age_buffer_centisecs   v4.0
  fs.xfs.irix_symlink_mode      v6.18
  fs.xfs.irix_sgid_inherit      v6.18
  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
=============================   ======= [docutils]

Extend "Name" column of the table to fit the now-longest sysctl, which
is fs.xfs.speculative_cow_prealloc_lifetime.

Fixes: 21d59d00221e ("xfs: remove deprecated sysctl knobs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250908180406.32124fb7@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/xfs.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index d6f531f2c0e694..c85cd327af284d 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -355,15 +355,15 @@ None currently.
 Removed Sysctls
 ===============
 
-=============================	=======
-  Name				Removed
-=============================	=======
-  fs.xfs.xfsbufd_centisec	v4.0
-  fs.xfs.age_buffer_centisecs	v4.0
-  fs.xfs.irix_symlink_mode      v6.18
-  fs.xfs.irix_sgid_inherit      v6.18
-  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
-=============================	=======
+==========================================   =======
+  Name                                       Removed
+==========================================   =======
+  fs.xfs.xfsbufd_centisec                    v4.0
+  fs.xfs.age_buffer_centisecs                v4.0
+  fs.xfs.irix_symlink_mode                   v6.18
+  fs.xfs.irix_sgid_inherit                   v6.18
+  fs.xfs.speculative_cow_prealloc_lifetime   v6.18
+==========================================   =======
 
 Error handling
 ==============

base-commit: e90dcba0a350836a5e1a1ac0f65f9e74644d7d3b
-- 
An old man doll... just what I always wanted! - Clara

