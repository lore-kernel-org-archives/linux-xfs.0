Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A74D29CB57
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770392326; cv=none; b=HaJAer1LuHk/B0UYi6KGp9r4DWiU4+7EDDv44Jeviput9Izs2+2cTTVf0Z2o4wUESHLhE8rVQ/doGxhLXtzSSkhp0jwbVlMEgjl7or56FzPyowFbAYuJovHqM2teKuvXG2XIjPoB0gY6ue815C6IbqzuXfe8EO7jFFK2deK+6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770392326; c=relaxed/simple;
	bh=Q+jKwtINhMrXk60PK9ttBaryzzKp+PIUgdjDa38PFRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1FYvf5+2wYSCoK+eUxk+LwWOyEK56jjY7wlcGA8MrKKNo8HXpczlAWnjdmCUbKR8PA9XxrBb2PfZMp2gkqOIP7Y357cbAZE1rNAPVSuxtnIhfffq7IIWmdJB5KhuoERt5NF2k/OODxqycyo+/Fh8Wl5xYjDQGzWp/SjaU0MVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6E6UkPR; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6E6UkPR"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-823075fed75so1395347b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Feb 2026 07:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770392325; x=1770997125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nsWmNYBIabzKh//vXqMp2ygozfG/NVtVhziWQz+A14=;
        b=O6E6UkPR7J9RhhQuCdqVusZ+4Rr4LD4NZRv86wADxSilW/WgwI7tem7M8ziU6p7XUZ
         7ZjtpthUV5QYf31shGrNKTYMecY+mi2UAOcI7yHjVO/23zYcaCl3VPontEvqwbCdJPw8
         3YLZUU4zWw/l6jw+jn/0Y8UUJiHDFuFZCkVYCwnMCMwb8eCzQzU9zfuEPChG5ACb7JN+
         4h+cjHfzlhvqKngHcbbgfcgPvYCf9esoXgNCc8c0xnjSwfUIGhYdsSdMisy9VDT1XFHA
         bw3vg86Wh/2K2ezzLk4RYbbx/VcRGdxJUvb99pQEtvLmKezUuWejcDWWD8ROMqliEdcO
         I/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770392325; x=1770997125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/nsWmNYBIabzKh//vXqMp2ygozfG/NVtVhziWQz+A14=;
        b=wkBcq6ITfkMLRDFF1tbAQWil+353Ao1+ZD2iwgn0LPFXLT3LhNhXYGcj+RY614vQB7
         kAXbdaf0/gbmtNOXd0WAtT23onRjh4OL+QV95WrJCp4BEUsjtxzJAiSzTgDS583iT0RP
         8uD3wxbTNrlCmG6USigWD09lP3YdXU9UdMSN9azCe0Nq9E+kmmpoGtwwxi+7mygOFVKm
         fTwOHpXElw2bRhmyodU1oSw4Rz3QSA+2V7QMWjSTZFZBPaQvMD1tJoF0nM5ZFqVJnqQF
         PsvwuIJvT+AC9SQCPMbEtRiYP01KX3/msf/q4a5n7UScn0h4PaogyjxDJbVZRQuX0Oju
         /xJA==
X-Gm-Message-State: AOJu0YzAmqzOvTXfL5l/YV/31Dx4iOh+JA8vC5YxlbbjYyX/I3AR08qK
	PoxxWhq2AKiCihku480V8Bwmm6FidUzTF0/GkYYIlwVUFANMTuPRyr6c
X-Gm-Gg: AZuq6aJRm4qmnntr59QWRh4UYxHvresef+mhARfePubWiWMnW6GMvia5s8F6ZcOT+TT
	+5eRdYhwxO03Oua4QNeD1rI01JimqEYeICa1oSnQs/dMWadOiD/iowGJ2EWaMc4st84M9b5Gi0r
	+mA3+Hf28+OlXuSU42zKlM6qNEq720HcMWxOiVmaWvB0dSGFltknB0OXkjTGq/MdmQCAdJNtqSz
	xAa0HRodX3dprlNqmfSNqOcC96MFnkEY0jBWehMSqT4tTxXIJxDY/rnaKRmhlDKP3HuNzQjVcsx
	L6JGruWQ5FbtHsWcdBRP4N8yKfYEjneBibDJSLOna2INqiAYvVkbXoKfZlHHaiSfcjqJ0vEJXYg
	KY7Sv4gfrW2HvXDWrLxoyx+v1oigSDWN1kf54zNMXw8sfuI0mxtuY6qhaTViWF7zCBlDg8HdIOT
	DIgHlzt7MRK48Z3VAmFAsuCv5N9Rdp2hCDBlRXWDfXkeo2Q8R0+46PTQKwGRBUoUXeoLpMxgtuB
	2DnMuMi
X-Received: by 2002:a05:6a21:7a8d:b0:38e:99a0:1057 with SMTP id adf61e73a8af0-393ada6bf63mr2986035637.34.1770392325435;
        Fri, 06 Feb 2026 07:38:45 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c28241fsm6746975a91.11.2026.02.06.07.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 07:38:44 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v1 1/2] xfs: Refactoring the nagcount and delta calculation
Date: Fri,  6 Feb 2026 21:08:00 +0530
Message-ID: <5c6e64dc58ed42566437dac8b2fa2c82d7482c05.1770128479.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce xfs_growfs_compute_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  3 +++
 fs/xfs/xfs_fsops.c     | 17 ++---------------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..f2b35d59d51e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -872,6 +872,34 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_compute_deltas(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nb,
+	int64_t			*deltap,
+	xfs_agnumber_t		*nagcountp)
+{
+	xfs_rfsblock_t	nb_div, nb_mod;
+	int64_t		delta;
+	xfs_agnumber_t	nagcount;
+
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
+	}
+	nagcount = nb_div;
+	delta = nb - mp->m_sb.sb_dblocks;
+	*deltap = delta;
+	*nagcountp = nagcount;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1f24cfa27321..f7b56d486468 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+	int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..8353e2f186f6 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -92,18 +92,17 @@ xfs_growfs_data_private(
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
 	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
+	xfs_rfsblock_t		nb = in->newblocks;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
 
-	nb = in->newblocks;
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
 	if (error)
 		return error;
@@ -122,20 +121,8 @@ xfs_growfs_data_private(
 			mp->m_sb.sb_rextsize);
 	if (error)
 		return error;
+	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
 
-	nb_div = nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
-	}
-	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
 	 * supported, and reject a shrink operation that would cause a
-- 
2.43.5

