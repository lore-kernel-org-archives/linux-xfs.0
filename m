Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761D520B21A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600472; cv=none; b=j65eVkNH/CvjIHkGU1g0t7GpcOV33jZC1fwX0wwxlKwu9ej+g6ab4U12WAZymVL9CCzEJKemGMXYzMmo9BovtjCqn5/l8Exfuf3o7nMcYIZnXs0IUPDaQvPhi90FQLMR0CqSFfBjXGXyWcMBwYk/1QvD+x0Te5KkkpaxNXtZdUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600472; c=relaxed/simple;
	bh=8qTd+kKm3LnYtUpD1o507twH7CsYNMIlztoOKc2+oPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg468OaON5iyYjzyV+GEgbsob1HyRQvqTmdFBT0gJLqsc+t6OTApd6vfIrZSWoawoFgGi8PzXMCahbBYwUL4+yzpqOiMCxaiE/gw1lWdpXE46BC05fXI/PijP2H4w34nx/TUMapZ+X+KeW3WPU/jsbEXu8xCXEiALieqlNu0Qbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bd3dxb79; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bd3dxb79"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-84cdb6fba9bso367038039f.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 08:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600469; x=1739205269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqfxZwntThbJflNPqCl5YAtRnuXwlFsEr2VGfNr3oPo=;
        b=bd3dxb794hPVSBzWt/cBZy1RpLFZHkxczcjvY4bSfj4gCsR3/D6LY83vLoiFgkU02g
         zfuJ7BEaVXSietiE2HlFC/801WUNrnRIN/hzgaJrQAaSUykpXFHk36XyvrrbX0ulMtH8
         FFD2CpyNUyv2+Y+wkhtima6HwPGEDSlnCJ0VjOLT04jn4vVaplq391oAssLLijpSMS1l
         /ee36spA2Na+AGDj5K/cyTy5sHT3SSNqP/yJoWEPERfhFJsqT/PqcJqfsdjHb7L40dCd
         vbj7OyuZSj1s//ZjI87RkShOEVIhevTyYMm4ChTsdh6av5No39cKO5kpl5gb59gPWGhQ
         YxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600469; x=1739205269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqfxZwntThbJflNPqCl5YAtRnuXwlFsEr2VGfNr3oPo=;
        b=EEWg5kV93lQ1PAAGmPbbHGxCNv+zVGUo3D+VfzAhLdP57Gol2exXsVr5g0qFk1fnM6
         rhzQFxg94OK/Ri4VqCiQCfzmhhZAJ3DgnRBILmlOUru4sV6363yKpS9r6tvnqYI4syyk
         bYCFOBIYOZ8M6od6PYGsFhR4TOj3XM7+hevQdRw3+xiRBJRY+BevbllAdzOKMhFzB6uu
         QnLrcWEURIaYn1PUS+OttlPqunJJBG6WEtKrrCDXstVUZxg5YAZ18/C2KCQ4A5fEW/1B
         B0VQQCOqhfu6vIFT3G0v001aA4GrluxpIFTiew5oGjW1UmSiJZwxXSzRKXiSDBs66hJJ
         ZBAg==
X-Gm-Message-State: AOJu0YwhcdOaO/s5GNwa4u4UwSiJ8FFw+fE7xxeYYpv3ut3tbH+y6fgA
	yyWmrhiIDqWJzilRG6xFXwTDxh7cWLx93E4+ASqosF73lJKb66sF0DTp307SVZI=
X-Gm-Gg: ASbGncvlijy/2ipJg83O/hD+n/49b/yfOh4GmD0IM8458xRQabCrQDKd1MdBnB7Qxz3
	FHZijM0s2FC/HBzxCCHxYVzqDWYABz7ge++oh5juolOSKZN37EdxHnmT2I4/Fq843gfs2lLdcHS
	i4oOpJ5gb9nZTeoFDp0YM9r0svrEPRnSZBYog0Btt/ope767U1mALK0MtgjGHP68sdt6ItHEbGn
	1vM876wzjT12h5HTQKrQENshugO4EGH3QfXySODZ9rGNYVr1pOk9ZXBr5wbIFX53rPSZ0dc+t20
	7T5UgeZp9/kCub4tC70=
X-Google-Smtp-Source: AGHT+IG9OCihTYL54PE1YbSwRPYIug+vgjAXuiNBWIChcbn8FpOJeKyPDKgQac5mavjPxTJmFhzgXQ==
X-Received: by 2002:a05:6e02:1aa7:b0:3cf:cca4:94f9 with SMTP id e9e14a558f8ab-3cffe3a6f2dmr219061495ab.5.1738600469497;
        Mon, 03 Feb 2025 08:34:29 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c917esm2279580173.129.2025.02.03.08.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:34:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Date: Mon,  3 Feb 2025 09:32:38 -0700
Message-ID: <20250203163425.125272-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163425.125272-1-axboe@kernel.dk>
References: <20250203163425.125272-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add iomap buffered write support for RWF_DONTCACHE. If RWF_DONTCACHE is
set for a write, mark the folios being written as uncached. Then
writeback completion will drop the pages. The write_iter handler simply
kicks off writeback for the pages, and writeback completion will take
care of the rest.

This still needs the user of the iomap buffered write helpers to call
folio_end_dropbehind_write() upon successful issue of the writes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/buffered-io.c | 4 ++++
 include/linux/iomap.h  | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d303e6c8900c..ea863c3cf510 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -603,6 +603,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
+	if (iter->flags & IOMAP_DONTCACHE)
+		fgp |= FGP_DONTCACHE;
 	fgp |= fgf_set_order(len);
 
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
@@ -1034,6 +1036,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
+	if (iocb->ki_flags & IOCB_DONTCACHE)
+		iter.flags |= IOMAP_DONTCACHE;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_write_iter(&iter, i);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 75bf54e76f3b..26b0dbe23e62 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -183,6 +183,7 @@ struct iomap_folio_ops {
 #define IOMAP_DAX		0
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9)
+#define IOMAP_DONTCACHE		(1 << 10)
 
 struct iomap_ops {
 	/*
-- 
2.47.2

