Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFD232A3EA;
	Thu, 21 Aug 2025 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782245; cv=none; b=FCkuQTWSN5FQThhVezArLGt2OE+Zh7sE1ieH5VssAoA/palJY/W5Ip2dFFFSEkmSn4EnE03b798ObdJ/aQkQhlGZlGlpDU63zHKLyunU7JV32lXww+hMXlTHbsgBJD5Odd2g0JUZ/oQL3dG4FksRN7VFKvIB8eBMj5RwJLvdoC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782245; c=relaxed/simple;
	bh=BfUFIpKi0jNSO8qQJnc/RDNHrnU9cLghiPrJydtwd/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iE94843xgj8ZT+zT4pQxu/5TwZOSedn6VhIVlG/vw0pneB1blcEhBUP6VgvbYFmsiJ1DcCtfNbprGXcJIHthObKJeAKo651moFaD5dcfI+9u4t7rO9HHDkBL39/6/q4GRwiCV9vrEukzDaZ87ZjZJH9Rq6L2vDpOXxlD/0dXW0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvMshqzC; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvMshqzC"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb73394b4so146180666b.0;
        Thu, 21 Aug 2025 06:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755782242; x=1756387042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YergQZ9XutIei6tpuNz/ymS/WZO1vUxU6NUoUNtJ1kI=;
        b=gvMshqzCRh0b/aYspPjyrCd8XQe5moLlAXvXuSW9gbQ8eBcgRcJ1jCm+3oRX9/hHsw
         zk8Zr+dKI7JlIR+Mqx4ImhAROk65LJQyLdqiZS2oiy3miiJS5hwNshIp5OqZ0g55lBoi
         EJQV7dr4JQEk5cDVcusQo3UZIdg7FdfGXBOZscqpYvz+Fros6K/YObY7t4DcHCi5Giuv
         oGd3DoiVPGl0P9PdbmMsd0mPfZHvkIII6OAclK+1X4UxBTNk4Jq1/aNwKU/8Jatp0SiU
         jNPNXhz+Czf6F+67WNJ/99IAYQxpJMDDsLp2k7rHzaqur4P1YzY+uK+viOUZTJB7KZo+
         OVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755782242; x=1756387042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YergQZ9XutIei6tpuNz/ymS/WZO1vUxU6NUoUNtJ1kI=;
        b=WkgpficMT8Ecjc9WeTStT21B2wZKoVTVCV0YKX4xeLoxdIC7o7VojHrP5xvANa/IFX
         DJmEYjm1bWCaF+F/GPoVgDRrJ+ZnMiBSGxfd3Efs9Z9vNODp1O9W4LrDsqvc82wTmo9o
         wnBbjsY0VQ6KZRm1KJ3OtaCe25bwaK+DMG/cneasqeik4yVesVVBYIkIo4EGQmB7Bykp
         gnV+sG3AUPZhRUflSkLtvldVlstv4jW0UBmLLExZdJjBzPqKr0/BSY7Be+3RM7yyunUB
         DnbI5BsAag60ZPkw6HyFXGIOwV3XmEy6shOxx8Co5nB4Lk5SRZQCZBhGp/7VwTe1wkHN
         YORQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4aUI/gKYr7vTAbaWqSJRY5W+gesBkKQvu6fBNgca6yBSNbJ16wHCCQNAKoaZt2h+KAsFJF15wJk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYXplhGUCEqJeK5J/XGgDCoeo5vhHPUEE1jt881kkhEZbPH95q
	KQSlRahP974P5/SCawRIK/hPKuCPaUurux5snPmNHsaNhnleFTqQLO36
X-Gm-Gg: ASbGncvYZAK7dr1aF1tmRK86GkmVUhsIGjLe8NKCErFTV3B1G5OqbOgm2Urecb1l8kh
	MseedlxBvw23dghFAjGua5rX9dVpKQgCWgu/17q115N/HO+seZA8iMfX4WrC9Kg6gqARXhhrGQA
	DQG2D8coRLxIbJ/IHQvQpkbaehoQYhUEs+E2mNvfx+tMHN9f1nGLBg+nFJhCH/FB/LnMrVA/B6u
	CO0YH1izq44Rn7Gb3H+UGNiHLmuGYyrH38yZBE6jYOdL6X0YqYP9yFyg24d6pHS7+wkUTUOHOO1
	secCIuLj8KpgCgOJf1MWJXsjUqPZezyDJmeqPLNL6TeLQ6sgMjFF87tXZDc56k7SQ2zrZcaQYCm
	HFJL5OMC/0YzXTIuvc7QqAN6/PJss
X-Google-Smtp-Source: AGHT+IGb0Fy1MDmZpYB0kO3JQdBxpxrwB4Us7cifwwRvXmL6XzplmdSQCPTzJas31V+oGDqyhOJSCg==
X-Received: by 2002:a17:906:d249:b0:afc:a330:e423 with SMTP id a640c23a62f3a-afe07c09c50mr195291066b.42.1755782241851;
        Thu, 21 Aug 2025 06:17:21 -0700 (PDT)
Received: from vagrant.. ([31.223.98.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe1367efbdsm88671666b.25.2025.08.21.06.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 06:17:21 -0700 (PDT)
From: Alperen Aksu <aksulperen@gmail.com>
To: corbet@lwn.net
Cc: linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Alperen Aksu <aksulperen@gmail.com>
Subject: [PATCH] Documentation/filesystems/xfs: Fix typo error
Date: Thu, 21 Aug 2025 13:13:47 +0000
Message-ID: <20250821131404.25461-1-aksulperen@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed typo error in referring to the section's headline
Fixed to correct spelling of "mapping"

Signed-off-by: Alperen Aksu <aksulperen@gmail.com>
---
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index e231d127cd40..b39b588bb995 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -475,7 +475,7 @@ operation, which may cause application failure or an unplanned filesystem
 shutdown.
 
 Inspiration for the secondary metadata repair strategy was drawn from section
-2.4 of Srinivasan above, and sections 2 ("NSF: Inded Build Without Side-File")
+2.4 of Srinivasan above, and sections 2 ("NSF: Index Build Without Side-File")
 and 3.1.1 ("Duplicate Key Insert Problem") in C. Mohan, `"Algorithms for
 Creating Indexes for Very Large Tables Without Quiescing Updates"
 <https://dl.acm.org/doi/10.1145/130283.130337>`_, 1992.
@@ -4179,7 +4179,7 @@ When the exchange is initiated, the sequence of operations is as follows:
    This will be discussed in more detail in subsequent sections.
 
 If the filesystem goes down in the middle of an operation, log recovery will
-find the most recent unfinished maping exchange log intent item and restart
+find the most recent unfinished mapping exchange log intent item and restart
 from there.
 This is how atomic file mapping exchanges guarantees that an outside observer
 will either see the old broken structure or the new one, and never a mismash of
-- 
2.43.0

