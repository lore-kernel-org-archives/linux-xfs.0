Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B963279DA6
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734693; cv=none; b=kTWwtylR+qqEfLbXB4jZac/YxUqO4o0W0dedj/LE9gQApuvQ24mg4cqXdhIhmZdLEWicxfGNis1hJAp9PRHAAla5Hkr0hCOmXZNI8e/NKimMHt1AMy3ENWG+hYKpqXhjUHmSrAXcDx+kzwLmmxiGAypcqkzzRpEMucf7yCxdORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734693; c=relaxed/simple;
	bh=1ZgkoljoMyvDKh0qVDwiY2DqikCPW5z+QRth2A0bo3w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=lzP2Ff5WJeJZtMgH4laoyHCtHpP26yAZCFandHbQY3+NWZ+W2728QZ7DywB34cbMjRdwVsaHNKHFK2hlbZ1odcA8BGLjMuKKvRcm+ebkgnpUNUBj8swwjQS6I8lB0rf9rli1J1jE7MgVcDIwonrxa1z7VJUNKSReVRYgPaz4D5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFon0cRU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFon0cRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys5kqXzqz0yqP1LE9hKjn2TJIEFefSHs4ERdcC7rvZk=;
	b=UFon0cRUleoFZja8oEqyRnZFGn8GSl7Nm3z7f0Zxf7WuHzeDJh4N4pKoRmRX9D+H6gUvZs
	jDSCq5yR8B7LHYZhyiCjijyXCz0bUGs7UcviHydTLOA4BicQGzgfh+OmhLGVG8IT+GKeos
	jBTMTPX0lO2CkDEFPDzjnq4PksEQvro=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-xj3S1wUWMvmjiy-bY2zaVQ-1; Mon, 28 Jul 2025 16:31:29 -0400
X-MC-Unique: xj3S1wUWMvmjiy-bY2zaVQ-1
X-Mimecast-MFC-AGG-ID: xj3S1wUWMvmjiy-bY2zaVQ_1753734688
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-61543f038dbso852907a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734688; x=1754339488;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ys5kqXzqz0yqP1LE9hKjn2TJIEFefSHs4ERdcC7rvZk=;
        b=wwtzTPYorT0K2cCT83XNJWAPliXZgN16GhE1AjY8/Y7bi7EvvOGeBiPlR1z4wnWVx9
         DQGa9Z8fmiotVDMPp0K9GRfiFrRqSaKDgYu7GG/uLRmx/KrVs/6D8AmxTHnCPpOVlGLA
         aPLVf20ZVXIGp4jNAMS6dWWrKyIvE97G2MEju9Odh1m4rhjK9DT7HeyY0z2GGEi8EMtZ
         mOnK0CroUv9Ic8jHXooHN8hAg+k8n9vCGe27fpngl7Livvz6eaUHJD/3/CyTfUzPVy3O
         OXu/75LsloiSmFI43+TmXoXKJUTqaxZSC1E86/E/CU6miQFzRsSyran1hDAI1Wsc9K8l
         3hrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXygFZ3aZ/WkF7sSBUKVKmR9ky1JQhUdPPJijSI75LYKepw4v/2MerzcbuYIk6utBTSt5L01kv0dWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFQ10NwkfMiWLK043ofRQ1xkvYZx0t5kq3NhdNLA/HF9i/6W41
	eJ0hX41SSF9YXMdMFTlyBFrR2TlPeiF6kUle5wSHw5pQ5iC5NSvQ/79RCPWDXk+50gKtYNcYUy9
	5Mj7qIyGGRXF16jyAehfzA2N7dIZDDGGHNuv//7Yk91UVe1NjojurypTuOz4E
X-Gm-Gg: ASbGnctWd7A/xpQqu/DdCr3MiFOt9F1iTZmahALhrD9G272CuXLvz0iK3YKe2qLNNhc
	MBeexrFMBDolGggkGk9jYf+MDqadxKVGB6oCdaZ5gqjFqmIqvboIo1PbJ2a16CxM5svxIehWGYy
	QtOLzGEARva+ERaWsTRCI8wL52gN0CRMevLwt2LNjkGkHfm/ySY1w+Ow5ZJBtgQW/Rxq2saWOL/
	ZY2xjiPikZHber36PbQ9teUSQiSXj9dgsgd75G7NI3MZMWZQb0brMjWsM/g+UyQyBDDtg0gnNfb
	gPel9eyGHLP6Rqy0FGoq6tSdzUnp9gZ2F8+GjKa9fYQWUA==
X-Received: by 2002:a05:6402:27c9:b0:615:6917:872 with SMTP id 4fb4d7f45d1cf-615691715bcmr197216a12.31.1753734687671;
        Mon, 28 Jul 2025 13:31:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQv0t2GbQI8mCqWdvIBvXSTnn+jBYTuYa2WcL8ZqxxCZ10dzVrwYpHqc75lDBA2dEYhF/pMw==
X-Received: by 2002:a05:6402:27c9:b0:615:6917:872 with SMTP id 4fb4d7f45d1cf-615691715bcmr197185a12.31.1753734687248;
        Mon, 28 Jul 2025 13:31:27 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:26 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:10 +0200
Subject: [PATCH RFC 06/29] fsverity: report validation errors back to the
 filesystem
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-6-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2734; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=xBUnAzy4V8YhALXwKbVZJNAFAkEy33DdXbkTKrTjLws=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrviW99ZCN1NC3KQOKoqrfy8xoXZYvbHRsNTe6on
 FrC+IDT2LWjlIVBjItBVkyRZZ201tSkIqn8IwY18jBzWJlAhjBwcQrARGbaMfwPj1pyeO/7qG6r
 Q56G9yL/irZkrfuyY/XOfxr2H9WVFn82Yvjv3h17jNPbRe3pYraLS48s+3TF7vIW3STD4qd3rpT
 xe9znAACe9Uju
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Provide a new function call so that validation errors can be reported
back to the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/verify.c              |  4 ++++
 include/linux/fsverity.h        | 14 ++++++++++++++
 include/trace/events/fsverity.h | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 580486168467..917a5fb5388f 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -243,6 +243,10 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		     data_pos, level - 1,
 		     params->hash_alg->name, hsize, want_hash,
 		     params->hash_alg->name, hsize, real_hash);
+	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
+	if (inode->i_sb->s_vop->file_corrupt)
+		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
+						 params->block_size);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 9b91bd54fb75..d263e988bec2 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -120,6 +120,20 @@ struct fsverity_operations {
 	 */
 	int (*write_merkle_tree_block)(struct inode *inode, const void *buf,
 				       u64 pos, unsigned int size);
+
+	/**
+	 * Notify the filesystem that file data is corrupt.
+	 *
+	 * @inode: the inode being validated
+	 * @pos: the file position of the invalid data
+	 * @len: the length of the invalid data
+	 *
+	 * This function is called when fs-verity detects that a portion of a
+	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
+	 * block needed to validate the data is inconsistent with the level
+	 * above it.
+	 */
+	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
 };
 
 #ifdef CONFIG_FS_VERITY
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
index dab220884b89..375fdddac6a9 100644
--- a/include/trace/events/fsverity.h
+++ b/include/trace/events/fsverity.h
@@ -137,6 +137,25 @@ TRACE_EVENT(fsverity_verify_merkle_block,
 		__entry->hidx)
 );
 
+TRACE_EVENT(fsverity_file_corrupt,
+	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
+	TP_ARGS(inode, pos, len),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(loff_t, pos)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->pos = pos;
+		__entry->len = len;
+	),
+	TP_printk("ino %lu pos %llu len %zu",
+		(unsigned long) __entry->ino,
+		__entry->pos,
+		__entry->len)
+);
+
 #endif /* _TRACE_FSVERITY_H */
 
 /* This part must be outside protection */

-- 
2.50.0

