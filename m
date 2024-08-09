Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401816A947
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229115; cv=none; b=dvtSK9IGqlrQjz1MiijibrxRU0VRkc2JVBmnnxdfp4yKzwxXNPOCmE055nC8Aqi3y3AM3YCZ21733dpcxO94/K0SV3ST2PhL3T0A6cFyXp6lwcwOTbTtGxgOLz6VIDnwmMQY3CPo+nsszkPViTSUG6LWuzZFciBqylrETQfUSaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229115; c=relaxed/simple;
	bh=uxGrBiucD7p7Ovvt2NnMtbNYRzbUNbXg1SgQqjwZgKM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBXktmCeE95Pz7uA8TUGs8b+JDodlp5vcAroLjpHKFEsCguqBiHInYCvAhkrqwPDqdUlOt9zx/fLRpvku+plFRQcy3ps69pnFY69W5jmrRbna2B0WDCa0QGS2dqOwuU/nAAhAil6JOGAbwsHF7Rz1McbHAJXleh6RPTA2C0MNNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Bt279Dal; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Bt279Dal"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7a1e4c75488so147133785a.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229112; x=1723833912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBcIS8bGmeuMqrkOmKfrTgkr7F6YqxXKL01YAxI4iS8=;
        b=Bt279Dalj3eU5oBwnRlmShkiS9zjiEM3XexSZUeyeVsufXYaMC6UbEu3vOfOeXQZe2
         MFVv/3AIEN0GnK7HwiLpqBzQ+3JF5IULyL70GCC/bT9Fmejao/QPezrhtUxH0ju+y2yB
         AYgdFX+DdIGXLlK2Sl0FfypE+aJqIW4ZMaG0etbFl8bGoAiOx9hYQQqFOkarAjZpnppj
         uAMr4slpZZKG2QOKFYyxodnEch7AKpfo41ZGVfVl4RYQzbCQaHUkz+8J4dAsZcjuzJpq
         bJ+EC4MFDVIqsC3thlad01vjpuWKLBDtQS/t5BKub34PLfLm5sqo7Zz+8TR09FQI9ufu
         6gDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229112; x=1723833912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OBcIS8bGmeuMqrkOmKfrTgkr7F6YqxXKL01YAxI4iS8=;
        b=JE02GI1W+YWU6L8Ab56xOwAhxn8T7dUw3Nxr3yXvrCm+bdH3DXtGmtxbgfoTh3LO98
         bpVBQUl0ISFrz126n211QZmlLic1GCPdgwgTqS/FnTJOPGy26g15eGgZfey/Lc3qP935
         4ggTosFqC0o77Y/WyC168YY4Ug5bAWN4Q4jo26dv19f0Wywr8GgjcREHR+1wUXo0e5CE
         YeJtZBlpQRz0rndNCsW4AJmVLoDJQOogRl06NpoadJ3OtIf2BXZJMmIEhfp6TuaXx0gA
         rzQMjeir+UVXHkemO05YsB3nFZYqi+fEQLf36TivJHh8xY1ulhbfw0CEWI2T/EXTocHB
         yCYg==
X-Forwarded-Encrypted: i=1; AJvYcCUsxvGVA2kHiVY2AKR772gnXSA701H3A6tLOcirReLe555jHhxv9VDhKYJiZMtTxpMLylnBD9Vz6ucslpkgY3RnxRheb3TRkZdV
X-Gm-Message-State: AOJu0YydY3hCPsTm4SUPCVeXtMqKjb/xTZ7BNOivejiL/UhVLkuZHC/S
	nKDcX7FkjFrHS8yntOq6TE6CH6pAeE6TdrRn5TK2D/OdHFLDM5z9AGhhi2/m4D0=
X-Google-Smtp-Source: AGHT+IEVNWswz8XKUFZnR+goo2+SardBOKKITXIcdyWrk78l67J7dmhAt2AUo3GEZ+BKyFRa3g0TFw==
X-Received: by 2002:a05:620a:172b:b0:79f:16df:a69f with SMTP id af79cd13be357-7a4c179206cmr276973585a.2.1723229112575;
        Fri, 09 Aug 2024 11:45:12 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7dedd2dsm3895385a.76.2024.08.09.11.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 16/16] xfs: add pre-content fsnotify hook for write faults
Date: Fri,  9 Aug 2024 14:44:24 -0400
Message-ID: <89eb3a19d19c9b4bc19b6edbc708a8a33a911516.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs has it's own handling for write faults, so we need to add the
pre-content fsnotify hook for this case.  Reads go through filemap_fault
so they're handled properly there.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc9686..a00436dd29d1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1328,8 +1328,13 @@ __xfs_filemap_fault(
 
 	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
 
-	if (write_fault)
-		return xfs_write_fault(vmf, order);
+	if (write_fault) {
+		vm_fault_t ret = filemap_maybe_emit_fsnotify_event(vmf);
+		if (unlikely(ret))
+			return ret;
+		xfs_write_fault(vmf, order);
+	}
+
 	if (IS_DAX(inode))
 		return xfs_dax_read_fault(vmf, order);
 	return filemap_fault(vmf);
-- 
2.43.0

