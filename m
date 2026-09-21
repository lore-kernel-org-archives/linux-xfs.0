Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4E7456298
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979539; cv=none; b=uPb7ykkGEDEb0lZRxgGL/0nAxC65xLm2uuwMVPFHudf5Zq/ir5TOiTjGqDjzE3t1+vgxAEsQCoizveHwsQEhiDF4Q0ppoJsPDSW5G1u39lME+a4u7CSxcGMoAbNY1ZdFQj/Esv+EKspIInjOkSf3q43EjOIxiMH2eh6GWBBfsEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979539; c=relaxed/simple;
	bh=6b27Y5R1I/dErxQ51DVfVbmyQ/c01ct05TSMdeHMzBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJtz9ho58f+q2sddRhH9NmbUKo4RVtoPaqXg4D/7gOK2lLN2Eq2j9sSKIGGeQBj3K03QBkKZHIksZYQYUAf3Vygs4mn5+e9SF3FlcFLdkefB/oisbTHCbZEcDXELaVctxRofnOnDdGE1FLKeWtGayva3XuBJjd70FyPWM+PxhA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wr8bkAIJ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wr8bkAIJ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d8239so19085725e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 01:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789979535; x=1790584335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bybxefWUQq7gjGvpEQCe+hIa+5aIsa8PecK6A3/B5/4=;
        b=Wr8bkAIJpxGgqX7bbXJuK19j7Edr9XwMNdoIknGkdxeJ6twZ6WUwpXGHb2Iyt6c9Md
         0UZVWXt2/TlgQJZxvRNoRn+WzpnOE5dk4NGs5tAoa5pQAeiVsbndQG8KqaKMfupEI22q
         Zgchk7acHJnevs3PtK9Y/aPW7Yb7BAGFdFSd1HN30+cNkntXFvu+Z5ZRYmbTEOq8cQ8Y
         qabB/fGmORWROPhm/u24K6bgSz1Sdhhk9W8zbkOF4hHyCdAcKJO0p3vRNmFCblcuqOZm
         rFYEH3k0704nL8nQ9e8ZUFM7LucKDKQ848VFFoA9Wuwobuxo/DWO1HpiSv1bk6S+ke7s
         021Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789979535; x=1790584335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bybxefWUQq7gjGvpEQCe+hIa+5aIsa8PecK6A3/B5/4=;
        b=U/aKngHQ6vffPgoUccptSabvX+7EVrD13ogVGJvYg/qJn3BkYLfgZ56cmrRqHF4TkY
         PTNHOZS/ClAevuar3KYp0/jPxYaD64BCOMinQFpWZ/vmMtOr9/IqSWwF8QwE4pqfuq5r
         ix9owgoIO3XjWw9yJu5ntZNzyKBgbbhiGSSZ/aHEwIEwGxHpYhdKvqLrs8RTcgzg3BUZ
         bqwwGpJLqQ0oLJ0b9RIy81m9HfUw9jkim8Q7fvhuAwIyNvJGyjvd+dqoLx3dIiwghwcy
         ZAjdyYRM8WcsK/VcebV4ebXfyM1lHb3BzSgFFyCZZ76P50a7xM4USCKkt26xkfWS+DN2
         EpBA==
X-Gm-Message-State: AFuF++neF1Gp/QntjYtzoN9MsxEwrNZlx91K3ca/JglW3/5yxWdFKOsW
	RPt9m49opPSkGLWlBdgMFBzK9xoTdncI8CKIc2N+/Kbl+q1jxXBZ2qhd
X-Gm-Gg: AYBFou0owzTSGBwlaq7t/ThRB8QXduKGdldsIm4aUCCplcG9NyvPaDvTcn6M8OZ5lkX
	4VcZ7YPmnLtqu/RvprEg9YrTRIJ+VNSqiWvAFS4NidUFUkQYdeiC1j8NJ7qY5KTuJDVodU10boS
	LqT/qcgrut6SUv8VkzjKMqzgCqYVgjNiGGzQzO2et0rlAdbdiHn+psxh7C+SpIZKNOCRGhGcCa6
	QGXtXe9jRbS7d/RkhIM8dBH77kK3vRJoBPQJqWT2xU4uxAD93apC1pFXBtD171VUaWVCXXaiCBa
	jPIp+Tv3oK+fmo9ItAXjL+PuoXOlhulomZrv1ogrA0fO7b9VjrmyvuEDIFWbkc9HOStYevoxP0g
	K+04I//u+jtZQkudkNcAyTB2j3X3htfInp+jdDdoIHqhNbWeW5Ius+1Xk7DBQ4WJLLMuEeH9J3c
	jdwSAfhX9RGH1C52Ooitd/3C3WrUdv2L0O0wj1I493IGqF+kG4DVw+zVaJyBiFjlz9MKBO2PjW3
	EyXSGdtUxFICmS/f9+r3SOuQ0k0dPFoW0nyNQ439PeA
X-Received: by 2002:a05:600c:c8f:b0:49e:6c9b:4e94 with SMTP id 5b1f17b1804b1-49fc5743124mr136244555e9.28.1789979535490;
        Mon, 21 Sep 2026 01:32:15 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10d174sm222806105e9.11.2026.09.21.01.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 01:32:15 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Parri <parri.andrea@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error when zeroing the tail
Date: Mon, 21 Sep 2026 10:31:33 +0200
Message-ID: <20260921083133.2960-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921083133.2960-1-parri.andrea@gmail.com>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
the data bio submission fails, so that the rest of the block is still
zeroed and stale data is not exposed.  The zeroing result is assigned to
ret, which overwrites the submission error with the successful zeroing
result (zero) and the failed write is reported as success.

Store the zeroing result separately and only use it when the data path
did not already fail.

Fixes: 10553a91652d9 ("iomap: fix iomap_dio_zero() for fs bs > system page size")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 fs/iomap/direct-io.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce89..8ae3fe64e475c 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -581,9 +581,14 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
-		if (pad)
-			ret = iomap_dio_zero(iter, dio, pos,
-					     fs_block_size - pad);
+		if (pad) {
+			ssize_t zerror;
+
+			zerror = iomap_dio_zero(iter, dio, pos,
+						fs_block_size - pad);
+			if (!ret)
+				ret = zerror;
+		}
 	}
 out:
 	/* Undo iter limitation to current extent */
-- 
2.53.0

