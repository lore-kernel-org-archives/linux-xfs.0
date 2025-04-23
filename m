Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A66280CD1
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424962; cv=none; b=vAp1iATg1r1MNFrFGOP6UevBEsC18S7fhe/mUyAaLZozC6jUVdYruYIPpoeUGt0U4ErxiiIrfmYR3ybeQRzvTpRflbg0vo1Uk2MPUaYTfMT4lFUstJEiOLaQyGOl+TdgFMMpxUMF3c3x6wSNOO/BwTaoqwQUXvW9pfVYR6qP/fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424962; c=relaxed/simple;
	bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwd92WqKBRLF86YvhrSPrXV+YpELcxICuylf0Bg0ghN8Ye9Mu9UP+QgQEzEu0VyalX3c2oRwqVNZl4dvSez7jNfDO+BN6hdT13ACzWyYV0Pd/XxPgaKezbc7PAm0iRmcewVOKSb7eyiJ0ltF7URrj+ogCPSf0T48O72O3xnjUkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XebtvgiH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XebtvgiH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39129fc51f8so14121f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424959; x=1746029759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=XebtvgiHEdeCnxAiEReYSLQ2XSuzPxDIMWd7C47lMKPOXJqwriXtxyWtz7M+70lnqj
         jc1ZSYGLmlDimRrUnMZFJLN9Jk5N73JUwvJGtIBgWkvV7S6VqmzFJBjjptDeSLE7QqCz
         oSQK8BXoVc+7x2ngYq253TBUP+xr6jiddww3F6QjfUPZay5YBPwy+4THjtV/8WPCVRRS
         AjYhRQCWhWfNowP7BSg4mOp3+7tX6wrsZ4/djyZba4cBAQIvyFc1tnCMfXqcpJvlWFWo
         EG9Q/C/hVCzsbksSWIM1HdnfXk2dxaJIdrUjQPukrZ0WmoOWiKoYmENWQuq5kkB6gUVC
         Uscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424959; x=1746029759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=oZGoE/UJNkjZL5s49uegyiJ9XWJg36/MFU8nK9U2uVE17SYQkvj7rsemZexUwLiSrT
         8AM1iWa/KxKIPR37YFDMNKy74yOxDuXDBfCU3nRAXCBboSkDZKcTCRVjdoBpgSkByjiT
         DcEZ1Ck+HvdyJinfWN8csPuXHVlWWEp+rB+EJWTZe/am6/XK7SlozY//WFcUQx1Phk2Y
         yGwmRKsRXfxdo1Mi+XWF039JiQLqaPt7yboPGn5BywSJsnJkhB1mCx4a9rL20T75wnw6
         PkrpETgeI4eFsJsTLE8edmcrOs2Wk0quSNXkv9rUs8UPVHaeMHs81fihnohonNk+wDks
         fzRg==
X-Gm-Message-State: AOJu0YyWWefnLHeEi7fZmrLB5fZPufJfPRNGdNvy5HO4hwz4FsuyFyXv
	f2QwwNhl5/Opq52s5JccgvJ+VFITZk1u/n7U+OvCtuPAAfx/6AyK5OAgFw==
X-Gm-Gg: ASbGncsGIo1LGXbPOWfBs5nHraKgWNBu1XTG9RdEzh8MSVZxZIVRu3rf/RQIn+IdWQ8
	pbYAk6bi3PG1tB+RWgIc0dRY0HGiL2P8F7/UIgSCshWPfdnW2PErzO/Plqpfp8LisIa7uyis4bJ
	DCV4eAJwAXXm6VPVEC8axQrOR35i6juOJ/rv0DftoMFtUK8CzXhARx6cDFcQl/M3aG66f2bpFgX
	3Ai0f4NxaZJku75J0EiF1wjHcXyshth8e8IZESBBahVju8bdzI+NfmoOvNbrpfbOiyhjHt7r5cE
	RGN72xpKKJ1ySmuLFXVi
X-Google-Smtp-Source: AGHT+IHSTnHepDdhduwuDritbQL7w8o+WhKZHrZnjq4FmExHhgK2fH8bgnl6AzcPQpIw1UX4kWWm8Q==
X-Received: by 2002:a5d:6d8b:0:b0:39e:faf8:feef with SMTP id ffacd0b85a97d-39efbb1a80amr17260165f8f.56.1745424958668;
        Wed, 23 Apr 2025 09:15:58 -0700 (PDT)
Received: from localhost.localdomain ([78.209.93.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa421c79sm19083567f8f.1.2025.04.23.09.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:15:58 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 4/4] man: document -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 18:03:19 +0200
Message-ID: <20250423160319.810025-5-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423160319.810025-1-luca.dimaio1@gmail.com>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the -P flag into man page.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88..507a2f9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1291,6 +1291,13 @@ creating the file system.
 .B \-K
 Do not attempt to discard blocks at mkfs time.
 .TP
+.BI \-P " directory"
+Populate the filesystem starting from a
+.IR directory .
+This will copy the contents of the given directory into the root directory of
+the filesystem. Ownership, Extended attributes, Permissions and timestamps will
+be preserved from the source.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH Configuration File Format
--
2.49.0
