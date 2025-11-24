Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A152BD5BB
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764006797; cv=none; b=FkrtCLe5ZeICJ1I3EHbPEJ/GdIYT9PunlT01V/qlTFj4mXH2H663OfOdCKpZ9sCt0tKdTOx2qz1fogjJgD5gmkAI3cdnI9R48325TSPXcF+1flkEv4J15JVUQL275Vd/9eLleU4vMHbquunTPMG2vcQmaliqjReI8feb1dWv8TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764006797; c=relaxed/simple;
	bh=bBWF8rPKKMglK7OceS8v1RN30lLKUQ1GD0/J7LhaqAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqa+UbfxxgtBOHlYd+TvPtOc7/v5kwmET09cm5CSdaaU86gL/WQjR1U/R+AeyNRbO0dcbIJ6lLNz/wZJJufHKL6ehSDKRny66h8iFptW1jM4nOL/AGRn8NNLpHw8RIEZ4GiNi0WOYCvYWkCayjj7MDR8k5h14fFR+G6CVAe5biY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZiVTdSYg; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiVTdSYg"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88043139c35so45943276d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 09:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764006795; x=1764611595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LURuhpVUuY1JHDBVH0tH7eUgzbVsxd/8tIMD/zbq7mI=;
        b=ZiVTdSYgfCR40FmZDiWRMTfAny9OnIHJMSsN8OtaSpesXoRHrUZGehwiDneYOXfGAU
         kSYTHGE3HVRr/1tLg8S2MEU9OJPcmKnAGVI+TmQqnQgct/0drbV1HRoydVeOgFNuIcqY
         5hRlCbQtLpkbtkiVlHXktne85hJt/eNH2yOuulWHkIsrPC9uHN6pufLPHxZk9ljbSxcd
         EZ/j87lF9Q+g9mM0mm2dLm4ZnXVl94Vb0HFVHgxz61eLlpvxcmZOKDskD25HFn+EqCGU
         hnQ77egJbcQTLfH+YuwpyQNp7n3nK+Ii7vgjg/Hl7LtkosHQ9R7h2YVhWtKsKJQwy881
         SwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764006795; x=1764611595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LURuhpVUuY1JHDBVH0tH7eUgzbVsxd/8tIMD/zbq7mI=;
        b=kwxZNbFn6EO+Kxh3vZTEgFfvTRf+v5RTm0YPeo4KN2I3AUYHCwLOcZeZWZrKt57m3H
         p8dn2WBLVNkYktX7kKiaZSaJhbOkebKV9yyau4iUn7p6wG4BVJfS8GfmiX0cZdH6CEOJ
         BaxfpneVDKqJqtUMW/4NnvAPc9j+qs7L8GeQu8ssV+uRFepBQ3V5RqI/BhpHBAlRc/SU
         D1U+u4ji0+r2EUd+aMhWjPIhiIQM43I3ihRyc+qXilr9pShyZshyPgi3eCDd+o461oF2
         Wo5ZAgeqiLXs8txm58GyFmGFi1uvKd+x+CJ+agqT75vMnNEj8UKQdwqEaOXDVcejA90P
         JG4w==
X-Forwarded-Encrypted: i=1; AJvYcCUVe7dp9stidX1xiR7f6IFIN2rbe+/jwA9KPKjG8Lt4VSqwEFvnh7uKw/xDBnOBnEhIANQuQ9RLtik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF7tdzURh8YXHbC6T7Y+TF1krYGD0dqb0w0zyHEN2c6nINraNA
	SbCnzS80lj3yx/RMaEjHfIcCoQ0Ldt4UPs/37HARDLi0AATM2q+qLHZG
X-Gm-Gg: ASbGnctIk449dHGBT/XOxHBqrIiCvxHhkjGvfDAz2w/C9osj2RlkyILc6sSCBkyQA9O
	nHJIoWbLQZ+c1LLW5onwubiaJ5vsl+yohYcZp/bPsZA9GbCzUZB0v+Ez1M/8tsUUTQZkg7Wnw1w
	MoC0jI87jf1yfVlrm4KYXhqRYXjI6fLLp9GZqIEB2WI3OuWC7FkvBhHrkDc/xUWdGzQ+xhjE0iU
	Y/gOOGWXyeiMfwYboPmw85PLFqaH7QBpeEa7JXberpqoIYAlaRg0jUoH5nr3SgB7lA2iv+Bh6Ew
	UFeGNgfeOOS/fYaPmBKbRGLlVKQ9X9DVzMnjHE8sxbwMcs5TIlQYXw/qCztiCW6x9jSO1q93y9f
	Z5fZJC01T0ydLWaduCYf7Wp9mIfCy1NwoaeHubPJ9g+cqsFQSgu7Lk4PqEMvAMYcMXq938dgvO6
	ib/OlC33d4ZIAjPLkFQCmHlg6/A1gr9u49zTpyvdrdyQ==
X-Google-Smtp-Source: AGHT+IGZatrd1Mjg+Nhia8Dfmz1nAgU6r7HISTxMbZWQ2yO30LFfqsql/fK1HY1Zg7Pq9Sx9BsZTdw==
X-Received: by 2002:a05:6214:21cc:b0:880:4695:4626 with SMTP id 6a1803df08f44-8847c4c7bc1mr171890916d6.15.1764006794854;
        Mon, 24 Nov 2025 09:53:14 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e58ded0sm103284776d6.48.2025.11.24.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:53:14 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org
Cc: chandanbabu@kernel.org,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Subject: [PATCH v5] xfs: validate log record version against superblock log version
Date: Mon, 24 Nov 2025 12:47:00 -0500
Message-ID: <20251124174658.59275-3-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aR67xfAFjuVdbgqq@infradead.org>
References: <aR67xfAFjuVdbgqq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot creates a fuzzed record where xfs_has_logv2() but the
xlog_rec_header h_version != XLOG_VERSION_2. This causes a
KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by adding a check to xlog_valid_rec_header() to abort journal
recovery if the xlog_rec_header h_version does not match the super
block log version.

A file system with a version 2 log will only ever set
XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
there is any mismatch, either the journal or the superblock has been
corrupted and therefore we abort processing with a -EFSCORRUPTED error
immediately.

Also, refactor the structure of the validity checks for better
readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
the condition that failed, the file and line number it is
located at, then dumps the stack. This gives us everything we need
to know about the failure if we do a single validity check per
XFS_IS_CORRUPT().

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
---
Changelog
v1 -> v2: 
- reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
v2 -> v3: 
- abort journal recovery if the xlog_rec_header h_version does not 
match the super block log version
v3 -> v4: 
- refactor for readability
v4 -> v5:
- stop pretending h_version is a bitmap, remove check using
XLOG_VERSION_OKBITS

 fs/xfs/xfs_log_recover.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..2ed94be010d0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2950,18 +2950,23 @@ xlog_valid_rec_header(
 	xfs_daddr_t		blkno,
 	int			bufsize)
 {
+	struct xfs_mount	*mp = log->l_mp;
+	u32			h_version = be32_to_cpu(rhead->h_version);
 	int			hlen;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
+	if (XFS_IS_CORRUPT(mp,
 			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
 		return -EFSCORRUPTED;
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   (!rhead->h_version ||
-			   (be32_to_cpu(rhead->h_version) &
-			    (~XLOG_VERSION_OKBITS))))) {
-		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
-			__func__, be32_to_cpu(rhead->h_version));
-		return -EFSCORRUPTED;
+
+	/*
+	 * The log version must match the superblock
+	 */
+	if (xfs_has_logv2(mp)) {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
+			return -EFSCORRUPTED;
+	} else {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
+			return -EFSCORRUPTED;
 	}
 
 	/*
@@ -2969,12 +2974,12 @@ xlog_valid_rec_header(
 	 * and h_len must not be greater than LR buffer size.
 	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
+	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
 		return -EFSCORRUPTED;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   blkno > log->l_logBBsize || blkno > INT_MAX))
+	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
+
 	return 0;
 }
 
-- 
2.43.0

