Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A539FCE;
	Sun, 17 Aug 2025 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755445868; cv=none; b=LxZFtDiqsdCGdEWbTWNSctfBzZ91/GN1TWRr7SsrTaj97Qf291GNyHOKKK1qSx09RmPijXS3leL/tARiQ9RyDV39RjAIB5vDILpViQiXACUUJy4Mzzt4MLkuG1V5W+ZLIOnBaMuSMCg6QuQ4okX4HuS5XByxh8/vKKj337iRN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755445868; c=relaxed/simple;
	bh=JR8jbMCs8QxjEzkOj58G229hlMPUMqRiNV2+nI2zpTc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aj64DifwaZX1DKiTQh5HWLFzqhji9VTtObVYLfBkYKYmc3G+hY/MI9+YMEg4IJ3p6C8KgRBzZzCOUbTIhaJSwoJw7ntC0vPbyxL4ACbR92viKQm5O7vimlNJVPiMCxATQAbVnJ6Fyy7Aov3h8CFoke4OKwUouhUuxBQXphv1+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OwVgzwA4; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OwVgzwA4"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-323266baa22so2563872a91.0;
        Sun, 17 Aug 2025 08:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755445866; x=1756050666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QjOJABZCp548naVzq1SVUQpsRTFmVx7Vnw2LNaJgSpc=;
        b=OwVgzwA4hXT/z39dvOfJPk1T/+IyPZxIcXdfQ+KS0Dw6DkrZdSO4mrg+THaquOOT9/
         18WT2m3+fgou8u4dGUni19O4a3GmCxrZQOU6QN2CFhRg0f8d0mb65fzVITy7jeS2RZc+
         Y67NqDz3gOJnlJM4WSL7+k0TtqWhcglyIGm7/E19NVxLlAer+7i1f19tpEKPQsueYLTT
         34dgmtpi65pt7B0nAb8TS3GNxoxWipXXgiV/kwFPV33yzXpXdOQc20N/ExUwVJq8ga23
         OZdpE3QTRnSfcB1SR/Sa1964BSxd1AXb7MUb+2uONM3ePCvEY8FHJHoF3LLUeQIKKMTY
         /9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755445866; x=1756050666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjOJABZCp548naVzq1SVUQpsRTFmVx7Vnw2LNaJgSpc=;
        b=QOSp0uOBs4EyltwDqpHtSyttQSS/BhwKhjeu9q6T8XDyUTCYu2KNk0khXbz0DMspRG
         LxHvQI2Cx5O+e/v+SPT1JgiiAHZCJ10IxaiQzIUsIbLxg8GCc0WyvJrcaYNE06BObR5U
         RLhBh9m7uknP/P7gJvr/zOoTQ+R4wr3IWkyqKTdBqfLKGdDVD/sKYATfnmvOYM5tK9yz
         2Tmyq1SsiVH6gOrU7wnjS2Om2zkCn1N/QxojPivXwLPXAluekYpArmnyfNkM2v71xZKv
         BYheb6kVkNZUQWyvKNsPpEffeCNQ1A+1OFgFeBcdyqUtRnUr/XT7OnrPTSDv1Qp0nxzY
         9xbw==
X-Forwarded-Encrypted: i=1; AJvYcCXD6M3rLp7gQTyq6aEoftRzjlqLlZAWwLa2YRaechT6YhZ9Ztl8+aRZ64YtzK2polI0TiYkE/ggAygKTqc=@vger.kernel.org, AJvYcCXXpT1OhN2NJv8by/P9iwarLwYomA6Xxp4RwKk8l26pUWqY4JjVR8drwScu4nkowq4ySgeZemWpl5KW@vger.kernel.org
X-Gm-Message-State: AOJu0YwLyUFL3ysnEOFj4EGHBdCDmaUNU7/Q8tuOFDesus9nWoM41SCB
	u/qIWjgiVR98Yaq/3f12VDOlII9kNMEnboPxJf9Hwg3UsRZMIXUoAeIq
X-Gm-Gg: ASbGnctVC24YD9lzMCtcS0M2dfNnTe9E/OELSK5LqZRcXmsBgzVP7LmwWHLp0AfLHrt
	fA08T5yqKXp57nNSe9xSxCaKuMT0VomMGtEkZ3ILRtmz0xKfFdebYX6mv4Xud7hES33sl9jiWKq
	ihNMA1ons3/HAC+fwlft2J2ftXhKnZKxc8pJ6E5pIkWYblWsppaDtRtoBcDYyH3Eqgw3naGS9/5
	ED5M0+vNJggxByj+TX2+ZBmVTtq+H+agZmgeihObUneQ/lt+QAFsCRDIiaYHydPNqBvQjfDKDD1
	zSmWbmG78A4LZ11Z6CvyKPAF9MKVXWLzoDb+GO5sD+r0ZDP2edqJbU7LqQUVRxW5TlkazXnbDCx
	WMXr6kA1xx+dsCL/5t4U=
X-Google-Smtp-Source: AGHT+IHpRWgCYbDi4joXJa+E8544/3ray+wLKLWD1YuD6ZGN7D13+dewr7cVSoJHVCWGfA+uB3mVkw==
X-Received: by 2002:a17:90b:3b8c:b0:31c:3651:2d18 with SMTP id 98e67ed59e1d1-3234dc64767mr9865139a91.16.1755445865738;
        Sun, 17 Aug 2025 08:51:05 -0700 (PDT)
Received: from fedora ([2804:14c:64:af90::1000])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e45292dc1sm5221495b3a.50.2025.08.17.08.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 08:51:05 -0700 (PDT)
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2] xfs: Replace strncpy with memcpy
Date: Sun, 17 Aug 2025 12:50:41 -0300
Message-ID: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following a suggestion from Dave and everyone who contributed to v1, this
changes modernizes the code by aligning it with current kernel best practices.
It improves code clarity and consistency, as strncpy is deprecated as explained
in Documentation/process/deprecated.rst. Furthermore, this change was tested
by xfstests and as it was not an easy task I decided to document on my blog
the step by step of how I did it https://meritissimo1.com/blog/2-xfs-tests :).

This change does not alter the functionality or introduce any behavioral
changes.

Changes include:
 - Replace strncpy with memcpy.

---
Changelog:

Changes since v1:
- Replace strncpy with memcpy instead of strscpy.
- The change was tested using xfstests.

Link to v1: https://lore.kernel.org/linux-kernel-mentees/CAPZ3m_jXwp1FfsvtR2s3nwATT3fER=Mc6qj+GzKuUhY5tjQFNQ@mail.gmail.com/T/#t

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
---
 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 953ce7be78dc..5902398185a8 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
 		return 0;
 
 	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
-	strncpy(target_buf, ifp->if_data, nr);
+	memcpy(target_buf, ifp->if_data, nr);
 	return nr;
 }
 
-- 
2.50.1

