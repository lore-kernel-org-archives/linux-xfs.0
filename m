Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E225F14F125
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560526; cv=none; b=jY/hiwUHXhDQ96ddYK95ztllAFl4RANAWEbjczcjRwvJBgZUdkjfU5H24vmxQkS+KcnnGaNx9nbITC5RRVnojFbgsKm/EwFWV7SWrdwUn3utLJLgpQihkjnTAT0aiSHd23uqNRsyd7OouEouTqXgqvh1UnWbtokDK/ZIfoqmmgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560526; c=relaxed/simple;
	bh=ifnYNt/+jlhTAFtZBjhQEqo4IuNDS0hZz0y07syNYcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqwGfhcBCclx8gQgK6lVApMyQYFS7NqtMVPFDcsR5k75cyyLZQtzk26QDK4H5k5iEF3PPeMjw+gGhXzkPdwD4V0yLBQRWQqcwEPc61QKWprnbPcC2P1aRTqLWBX5vlD8HrGyEjQmyASwFyBiqTI0wDy1nPMun20mhawWQvWFolQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OI8s9UG/; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OI8s9UG/"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718a3b8a2dcso138504b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560524; x=1726165324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1y5ANoM1rABh/Nr7pq0cLc0YXYWTafjj08fvWhSPka8=;
        b=OI8s9UG/QP9JxWjzuXhDmMzlo0yV8ne30pzgAB7+XejkWegotMKsyfOdcXRAsHvKZ3
         tX+6Jbrh2J5MaDbVP9hUmOg20IUF3RFIZXW7YuZj/RhkOIa3hE39apliinV3K44+Nk8V
         W2b11kxIK/J8Q+rHzYMC/IFoIVtGDcEIpw46CgUNHgMEY9nNQDEB7m+Vp8I3qbbp7YWf
         Kyd8cds/LoKAdNUsQABTAh9KOeJlmAP3OJw52hzQXevgY1Lsz9dtPfeFPxxem5tphct1
         uVORp2pAWfG85cxlD0WKdX8dlLccYOBRD3kaJnxZF7cxHRwGELY/vYbtLTDyWxnU5tM4
         F1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560524; x=1726165324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1y5ANoM1rABh/Nr7pq0cLc0YXYWTafjj08fvWhSPka8=;
        b=Nrq4xl8oU85DxHoSh8o3YLZlAJAj0Ev3gKFUMDIHOvQN1wwkTu2t1SFgQee6JT8zEq
         x8+5h3hPnLnM3ympWJC6vqJswtGE6OATI5X0aPBulMkX+4SNFRU0DTIHquD//sY6Jb6/
         Q24EMABZ92FP5vRrvLquTqBC+gTlN3RDntO2hyJhkKQgO0AxRnMU1buPrGgnlQQTT5QT
         XtdSe6F8CFjzQsLfP7io81e+9SnZnTG7NyYvyskCVKLcbg+0X85vB1fP4V1UCpDApH/C
         yBioNY1DYoXovaFVEkh+NwaWdmFwaJYAjZdWgDW9pcOuW/xrbosNR/ixtxruSxmWKk5y
         AeXA==
X-Gm-Message-State: AOJu0Ywj7segNklTHBFrnYIvrmVfcgNZvynEaH1mclfkC6rGM/q8owyq
	7gGGytLb5IZET/257HJGr3w2reFvy3Jcqr4Tw4I9dXtGf6KSWHHBdMwwfGCX
X-Google-Smtp-Source: AGHT+IEK4TSX1oJzat2uLwusqmJRR1FSR0PpJdno+g65ghyjFjjBDaWUC2jX24RBi9bPjvasYQ0DLQ==
X-Received: by 2002:a17:902:d50d:b0:205:4a37:b2ac with SMTP id d9443c01a7336-2054a37b550mr160046115ad.34.1725560524043;
        Thu, 05 Sep 2024 11:22:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:03 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 12/26] xfs: defered work could create precommits
Date: Thu,  5 Sep 2024 11:21:29 -0700
Message-ID: <20240905182144.2691920-13-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb042117488dbf0b3b38b05771639890fada9a52 ]

To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
inode cluster buffer operations to the ->iop_precommit() method.
However, this means that deferred operations can require precommits
to be run on the final transaction that the deferred ops pass back
to xfs_trans_commit() context. This will be exposed by attribute
handling, in that the last changes to the inode in the attr set
state machine "disappear" because the precommit operation is not run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_trans.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..a772f60de4a2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -970,6 +970,11 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
+
+		/* Run precommits from final tx in defer chain. */
+		error = xfs_trans_run_precommits(tp);
+		if (error)
+			goto out_unreserve;
 	}
 
 	/*
-- 
2.46.0.598.g6f2099f65c-goog

