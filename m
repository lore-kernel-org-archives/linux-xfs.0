Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2CE1758C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714455977; cv=none; b=Dc0q4PB0hnDWZtLeVGGT70v8f7cXYDNlOVrebWCY46BsbPlEo5yoJwFCU0sMciO6jkZe9GZoOUy0DSJYCry2gb9H3svFAqVx1DDaZ820eYcTWc+SdOjT5zai/JkT2ifg60R1hjeaROx0XlOnKZt3PuytW08ICZ7dvdZ5cJIUquI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714455977; c=relaxed/simple;
	bh=5L+DbHHyg9/U1kdFGH+74R7K4u9DGBrF4s+3873+bY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iWYtjII5PTf68VkQnEJl9WGeaGcsCWQFLL4/X4dlbSMW6iJYemmmWfLY6+B2d/jgEKHMr9GxAROUDrL9Gjdb6CfwouKjJlIE57cBh5cRCbHWqKjv/W4ZjgoIOeFJ0f/I1lI33vr2yDLivRxyFkroko5916b7ktO8lEFHcneuqPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=B1v7dDum; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="B1v7dDum"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b2769f017aso367051a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 22:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714455975; x=1715060775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5L+DbHHyg9/U1kdFGH+74R7K4u9DGBrF4s+3873+bY0=;
        b=B1v7dDumqeHkjxijOGBC7I2qcpZ4A6VkicX9vf3dOkGMyS3rGsHTkj9gx+14GHItlb
         pE+0z7J4RBafHiKk2wNOFeAK3y5VlG21xyDuFMvl+fKDptSPMZze4XvjXyB5dkFQFn0g
         8AaE6aer8Q1oTXmCjxSt/Iy/H97+h6u+odnlLWuVeHnIozdK/mdX129F+Ptj3nnVSV3g
         tu6H27dg6m1mBliflk0PjwE81W5y7lUW+2jd0/PwbT7em9BjhsuiYBHAwZy0O1tSQUYk
         8XYgMFeJics+XVBnrNxfcRtt1hXCFLRqsEMjUqBXaijXvqtaS3AwRm5yCns0uy5AOK6N
         OnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714455975; x=1715060775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5L+DbHHyg9/U1kdFGH+74R7K4u9DGBrF4s+3873+bY0=;
        b=hvEliYBk1v5bfhQuqqdg3hhS9W0NiapbcSwuU7iz/pNQTEzX294hxCByRXhK0fqkDq
         FeykiWD59+Byglco4mhe7ES2p0hdV7BHAAQdCFWRkTPWNloG4B9r89J0+B/ANO+383hJ
         vBVGwW59d0BhO/hlXU6B7OE/MRXTvMB5wxHY9OEIWtTUvEmvMm8QC2f8cRgqJIJ40eRK
         JxvEx5moRoafh/BmIEo0ZPQ0IE24nPUV5GqpeT4iCTswxN+NPLweqHL3dnurd+G20+oE
         x+w/RQ6liNLXDu0GN+g4gyuXeCE9sC4bd4I0g87bhDGSP/Y6XRMNWMFRPGvMeEMWNUQ6
         7I3g==
X-Forwarded-Encrypted: i=1; AJvYcCVW4DmU0+gyGoxZy5xDokIE2M59lYwqlmqNrCoHEaYKq1iA9k3BsqUKiOgyVyY8YkvLEb6YSXZfSc9ZPknohh3oIU7yPwrJqbMQ
X-Gm-Message-State: AOJu0YzCRNOKgn7j1A0QdY2sGqw8oEoMjKkHYHWz/Bm6OCiVxAJsr+ig
	VJfBXbI6zdtVFQr+hlEMu3PxHjkEEIMzO0izPa2X7aGkPhfZECj4VhT/vSSzYMs=
X-Google-Smtp-Source: AGHT+IGk6XaLGpfuoUdDJFudtbrf8u4lswHLxBXGWN7TmyCvejeVLID4Xr999uOxMPq+1SjKPHPkVQ==
X-Received: by 2002:a17:90a:b00b:b0:2ac:5a83:b8b7 with SMTP id x11-20020a17090ab00b00b002ac5a83b8b7mr9438434pjq.0.1714455975083;
        Mon, 29 Apr 2024 22:46:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id r6-20020a17090a940600b002b2a7c89970sm252533pjo.35.2024.04.29.22.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 22:46:14 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1s1gJg-00FsCB-1r;
	Tue, 30 Apr 2024 15:46:12 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1s1gJg-0000000HUwm-02aA;
	Tue, 30 Apr 2024 15:46:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	osalvador@suse.de,
	elver@google.com,
	vbabka@suse.cz,
	andreyknvl@gmail.com
Subject: [PATCH 0/3] mm: fix nested allocation context filtering
Date: Tue, 30 Apr 2024 15:28:22 +1000
Message-ID: <20240430054604.4169568-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is the followup to the comment I made earlier today:

https://lore.kernel.org/linux-xfs/ZjAyIWUzDipofHFJ@dread.disaster.area/

Tl;dr: Memory allocations that are done inside the public memory
allocation API need to obey the reclaim recursion constraints placed
on the allocation by the original caller, including the "don't track
recursion for this allocation" case defined by __GFP_NOLOCKDEP.

These nested allocations are generally in debug code that is
tracking something about the allocation (kmemleak, KASAN, etc) and
so are allocating private kernel objects that only that debug system
will use.

Neither the page-owner code nor the stack depot code get this right.
They also also clear GFP_ZONEMASK as a separate operation, which is
completely redundant because the constraint filter applied
immediately after guarantees that GFP_ZONEMASK bits are cleared.

kmemleak gets this filtering right. It preserves the allocation
constraints for deadlock prevention and clears all other context
flags whilst also ensuring that the nested allocation will fail
quickly, silently and without depleting emergency kernel reserves if
there is no memory available.

This can be made much more robust, immune to whack-a-mole games and
the code greatly simplified by lifting gfp_kmemleak_mask() to
include/linux/gfp.h and using that everywhere. Also document it so
that there is no excuse for not knowing about it when writing new
debug code that nests allocations.

Tested with lockdep, KASAN + page_owner=on and kmemleak=on over
multiple fstests runs with XFS.

