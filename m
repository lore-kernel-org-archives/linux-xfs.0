Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF08A524D4
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358383; cv=none; b=Nx1ZTUOicwWDPNo3GEK8lEMg5814qdpEVMI8ipp9FDdvOhrt2SC6el+/ft39nZJFW5mpUr/JXvt6SLqSHWqOxYWdlTEvBtjqPyGh/3Im9AIf+A40aAFGivvQrWo/hWZzW357Gw3gisrwMTyuHvq3sQ2Go186NgfANmkX5qDs4AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358383; c=relaxed/simple;
	bh=G1CXJAZBdC7R61oXoxnLeQOo3q6jTvn60AYQ+yNTBk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K3LOSr6j7nhUQoYsFvDxvos6VRJuHvjn3xQwBGvOl1KuIN0JkckyRs4LOm7RjE8B7x77R7iuN6z3kDdHoiZ7St5RgDDD1DLuoiJdjMV/2dGkn3NKhDvv8B0hA0WIuucRfhFgqSOAaegSsoWvhnlz/xFFSJgL3CLObzXQMohMv7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QusKvT70; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QusKvT70"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wXIKXZWKJz5pz5DBlu+ZCgTbZ3xtN34Ndnq7o695Syw=;
	b=QusKvT70+JRqT5UN645ouiW9hfCvT30ifHMsnHKs+s8j/dQBbNILn5xs/RhoN+YuOnP4yR
	ncl5olHvoULaOkBphnC+Wk2dzPzTSyYLBeyaofq83Xz2cdMZErF46hl9ZZlFxJ3+wyqfQM
	3F5X/NjJVFBQD+x3LGKnHO/L2A0odYE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-Tlpj2VsvNpqDUv9T3eyzeg-1; Wed, 17 Apr 2024 08:52:59 -0400
X-MC-Unique: Tlpj2VsvNpqDUv9T3eyzeg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56e7187af0fso3482466a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358378; x=1713963178;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wXIKXZWKJz5pz5DBlu+ZCgTbZ3xtN34Ndnq7o695Syw=;
        b=S1qOw/hVY6dNJIwuNAeSXijLllzI9oIgaGIA9cf2RyVjVc1lvQhIpwT4xTC/Mpu3QS
         odBrV/VNvWM/68TSM41ICzy6ijsQdySl2PrCw4VwtPHRLOlGZaHFTxe95lBnskDdNX7y
         ktsHtfG40LgoavALhwi2K5v+xp0lFMWXkJvfwWiRbOuNYEagE9vm8toZLI8P0sQJW1GG
         9zi9TIHubkIrn8RgcELhrrNxeuTjR30+wku0ej5DBZFDi8dTClZnpRb30SPIQQshBW2M
         1gyeEojQqXNCSxuZhSqzVQWcIeG33KNobXFWUfhTVZ6venllExmzwFkGlBldXc8R+XAg
         Qhvw==
X-Forwarded-Encrypted: i=1; AJvYcCVEDgh1DoSHGh8LmzMZ+oa1lNn3yNcFhQn+wIrxkFNWzR135T8V+buGFDKJ7g2fi3ZI+9tSSabLG/2gq7/OEu91EV0Ij4S+cux3
X-Gm-Message-State: AOJu0YylrvTBvfw2thHbEvFtCcHIOtPKMGT+Wn/OHaKsDfROgwfoyU0e
	Rp6tOkXjnGZ9niGBDWEGwrx5dimKiXi1e47UsJ/Y4f0JNNclPCwfP3UyMvfUNTtfyqFtMqeFQQb
	DNVc66DKW4XfeCK1ePC2LgO/5oufSdB7X3pNBZQaWAquttijVA8LM7AzKTUWkPauK
X-Received: by 2002:a50:cd19:0:b0:570:1ea8:cd1c with SMTP id z25-20020a50cd19000000b005701ea8cd1cmr7568961edi.35.1713358377547;
        Wed, 17 Apr 2024 05:52:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpD+Clg5pj1hK7EkOV/bXuLnM0qPvTpCH6jfmk9UcDKTzaSt8BmwhQ7hbvdtJiNisLm6rx7w==
X-Received: by 2002:a50:cd19:0:b0:570:1ea8:cd1c with SMTP id z25-20020a50cd19000000b005701ea8cd1cmr7568951edi.35.1713358377021;
        Wed, 17 Apr 2024 05:52:57 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id en8-20020a056402528800b0056e2432d10bsm7258169edb.70.2024.04.17.05.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 0/4] xfsprogs random fixes found by Coverity scan
Date: Wed, 17 Apr 2024 14:52:24 +0200
Message-ID: <20240417125227.916015-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is bunch of random fixes found by Coverity scan, there's memory
leak, truncation of time_t to int, access overflow, and freeing of
uninitialized struct.

v3:
- better error message for too long runtime
v2:
- remove parentheses
- drop count initialization patch as this code goes away with parent
  pointers
- rename unload: label
- howlong limit

--
Andrey

Andrey Albershteyn (4):
  xfs_db: fix leak in flist_find_ftyp()
  xfs_repair: make duration take time_t
  xfs_scrub: don't call phase_end if phase_rusage was not initialized
  xfs_fsr: convert fsrallfs to use time_t instead of int

 db/flist.c          |  4 +++-
 fsr/xfs_fsr.c       | 10 ++++++++--
 repair/globals.c    |  2 +-
 repair/globals.h    |  2 +-
 repair/progress.c   |  7 ++++---
 repair/progress.h   |  2 +-
 repair/xfs_repair.c |  2 +-
 scrub/xfs_scrub.c   |  3 ++-
 8 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.42.0

