Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD4318143
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222856; cv=none; b=Atx7ACYfjcSHcVLjKbBFbTdEJHTlbYhZ/8RZqkoZIi3BEFs8bCvk9e6l13Lh33gqJbsxw7/+WnSOpn7XAkNuHXVJyN8DUfk+P3LvftVhi4iKYygnXQR5fX/gUxtRjg53NTcS/Oc3m/zxXE/Yg4Bopf25pgCDT8U/CS10lkG6UQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222856; c=relaxed/simple;
	bh=824s3eeNyPtqfPMcWFvG6qpWsh9sKBrHSzpVhkI4CHA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wjg3QeyaLoqgWqj8Yqd23vYTRKflmVawV3Pt4xsjibE8X09BB8EcwWVYJAYjcj+XNgdgAQUb55MeErNHLVnFbXujsFinqWaC1PD5tdSV3vMypLT+osH5OYfBpTxXe/1GJTj3GRieBM8h0jA4YOfH1kzpJE8Y/IQ508CRd0uUMlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=rhBrX+W6; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="rhBrX+W6"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e95246bd5e8so3615648276.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222852; x=1756827652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOHH5GxgumXNSgv4ws5caQ9qUmUz2v1LLekhwJWPqgQ=;
        b=rhBrX+W6C4K3I41wVrVmf+OKGbkRdx93AtalnWNvKaLxZXReAQ4OrZpiKdSStqEkPR
         kZzZH4pwl4rN4JkwMqPfs6N5OqC3f/10yGV9GoOw0SVJDabs+Fl9IbFl6TEllQTShOI5
         LNER1Bs+N1CbpV0HBKxX1OGmQUJc7YnsemktnS39ZrZ0+PtCeawlx2fIbOezIF+zUV3N
         J8oe22situQdTmTiobPiNW3U6i+GzrutZjm1AgCJwRqVBPEYqEKTCTNyfGvbDDcPgKlO
         zAv8wphWs2apXQnkyzwkl7EWE+6yyR6S+AJyPqlzs5K9Fmi2qUUXJnBvtTpKVnLeuNwy
         iATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222852; x=1756827652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOHH5GxgumXNSgv4ws5caQ9qUmUz2v1LLekhwJWPqgQ=;
        b=KpoTX1jY/MOjaqBcDwmcdzQafzax6gbmVcZXloO5IY42z+wQYYISOMPMMVzwPjhVbg
         0wbtvzGkUQr2dxqO/bebjIgmJMdrAtagbfKjqv60cB3o8fAmsStN00EYe0arYLt9JLFh
         LtxrhuNqVh3y7szMULXM3kfSwO4Bb8qsYEsB6+vcND46sn2IaZbpeFrS346szSu5tjjj
         d9wLIMaHjEa7/Y/4NRBqB6fSqXY8SnOvXe6elV6ObDGJK1Mlf8EoyFLSoPkr6bDKwJ83
         gsn9qQhqM49fC9o502PZj6UJEpcsXB0JVa2QZCsk5r/8AcTqoXJe/8sJMXV6YQb5p98f
         XBYw==
X-Forwarded-Encrypted: i=1; AJvYcCVp5qrlWBjgVAA3bux2KibXXLGW+alKNP26Mx6CBLXShG5K4GQjaNJoGuNnBrTL/MsCvAAlZVPQwY8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOUvrT6pkJTrWUwz9ptRKL/MuvC8sM3AA0upX4aEklvFMHTS3I
	G47CgLX9zgzgTFVFswgPVYltg53/Rwv7YLcVr3EjuKTWPMWnjh7Bz9GcDDmKswxw3tk=
X-Gm-Gg: ASbGncspQKaCvAMRLNJBf4y2XqaJ0LvqTR0dOXQrM57EyOQMZoWvKwwWw3CNpVnDuZz
	/RQoEZh5NySDgLtUDmuuoHBCb/+RHK/lvJ7RHQLEgH+V2m42LkBrkZhdRUIos1YKvc2CmBWRRJR
	5JBEJ7ElR8n/GEdSnyeqJfVxfWwUWP+l6bpZr/8Cy3sOKiEg1H1c3RaFk02PW2uCkeTl6Qz5w3H
	FFnFANYvvXj4OS2Qw8hIMCCE6h+l+nxz6Mgw78gd63ndcJe0R8/CP1odmubeH5hWjlKvldIC6bj
	/S90Xm5HWRd5VnbCQLer7Y3B3qGZ2iWk5ijRG/RctpHPmHOPWnjxe2Tjl3lcV9Qn6eYsj0eQRy8
	6Y4wjsCC3IIjGfYhIYEhnXn0H5C4q+8moKTOn8bZxxq9+5sL+gWp0s+ZZudgFmoEowBgsBWfbQZ
	jE1Hhh
X-Google-Smtp-Source: AGHT+IHCkFxTVHekKtVIMKKoKBA/v/EmSAFjwci1Wt4iPVt6NciQDsFy301ND2wdcONLCbcSXMgElg==
X-Received: by 2002:a05:6902:2b03:b0:e95:1945:8672 with SMTP id 3f1490d57ef6-e951c2ce819mr17137482276.10.1756222852464;
        Tue, 26 Aug 2025 08:40:52 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e952c37715dsm3292356276.36.2025.08.26.08.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:40:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 03/54] fs: rework iput logic
Date: Tue, 26 Aug 2025 11:39:03 -0400
Message-ID: <be208b89bdb650202e712ce2bcfc407ac7044c7a.1756222464.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, if we are the last iput, and we have the I_DIRTY_TIME bit
set, we will grab a reference on the inode again and then mark it dirty
and then redo the put.  This is to make sure we delay the time update
for as long as possible.

We can rework this logic to simply dec i_count if it is not 1, and if it
is do the time update while still holding the i_count reference.

Then we can replace the atomic_dec_and_lock with locking the ->i_lock
and doing atomic_dec_and_test, since we did the atomic_add_unless above.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a3673e1ed157..13e80b434323 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1911,16 +1911,21 @@ void iput(struct inode *inode)
 	if (!inode)
 		return;
 	BUG_ON(inode->i_state & I_CLEAR);
-retry:
-	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
-		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
-			atomic_inc(&inode->i_count);
-			spin_unlock(&inode->i_lock);
-			trace_writeback_lazytime_iput(inode);
-			mark_inode_dirty_sync(inode);
-			goto retry;
-		}
+
+	if (atomic_add_unless(&inode->i_count, -1, 1))
+		return;
+
+	if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
+		trace_writeback_lazytime_iput(inode);
+		mark_inode_dirty_sync(inode);
+	}
+
+	spin_lock(&inode->i_lock);
+	if (atomic_dec_and_test(&inode->i_count)) {
+		/* iput_final() drops i_lock */
 		iput_final(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
 	}
 }
 EXPORT_SYMBOL(iput);
-- 
2.49.0

