Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09C198842;
	Thu, 19 Sep 2024 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726733680; cv=none; b=YF0E0/9Wv5111eMS2NaVwmCTSzQ6EYGTSUsyEWhSqr5qYbEKY392ZvtvOtm06Jn8O59reHEUrG59ONejiMxkDQi20YsTBu9yQ0gzN9RbFYp7FoIDMUAxs3RaNspbZ0UzHxvAcPIoO2EQryPg0n0e4NgVDPkNoD/eM4w1Szi5L0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726733680; c=relaxed/simple;
	bh=Tn6RImTGI8VF7LY+8P58+6qS7YF4XWw9roNtbHsMCTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JVbQ4l8QyohRAyHlmhCoZnWG/uvnPcZHXMSwRKdKs3B+WtGmbrIKEhIlJA0VOCHXOM/V2JfOOPNR6/9QF9GKN7WnGTgvobX6LpIccIFSQQkagxnIoKQQUmjedyLZ1b3vSpd45zkj/kVTOVYm97JQA6AtE+1HlCZLOK6It2AcHiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WV+WMHIp; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WV+WMHIp"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c43003a667so772017a12.3;
        Thu, 19 Sep 2024 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726733677; x=1727338477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DeSwJloJcHcXYqhY8Slgyb11RA+XiAXfrqtCeg7UnvU=;
        b=WV+WMHIpCrQ0K44gtGN1OXzBLjvk04fBkXwABeuSkgTwfy4qUTtukNI69yyBorKbze
         sJ0MwupG1+4twWO3kHl9wITPCX/5KU6eOp5Xv46PSQjk4YHoDCfpXzgZo3CPjwGys5u2
         QOEHLvAJoH93zhywxE8zxClR9g6oacD03JCw5UVgABZH9E0Yqj/j2qDUY/EdqSb+5Lsy
         dyaIhCN9P7iT6r5Lx3ePpan6Xjwum8imsgqIoUHPNzked84yIdEErY0uuCkX9fBTg1fl
         94UFbomH/1JJaY7SgKPFguEnWYMKY+Y4zWlKO5lgLywEXO1s2XrwxY3QCNI2uvqnVoJf
         OGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726733677; x=1727338477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DeSwJloJcHcXYqhY8Slgyb11RA+XiAXfrqtCeg7UnvU=;
        b=LjO7GPOccYTpJfDSyQCRGIzSfix7ZuW33w/6lX9qlGgf8R5sTUHmkq6q1qwrQ5wZSr
         GFEF8yTefMn+a9yp4td3EKz0wgMEYo8MTn+Q6n2ulFyjVwVkll2G0I2QRo1WYZwJscxc
         rQencd57SjiRr6pzPN3LmqiVDiqDEeBjxn/rDDMY+1NYSBO1wFvc3DdQhFWUJ875Qrkm
         uKNPaTjjN3QXm3GmPZjK05yOOSYY2BZ+/daz1a4FUufsPt0sFr26ogv9tYvXb+q/upeY
         m9ULF60IaQ54Ti20FCgLE4l3oUgjSlnPj37vAiM/k3WU9Y1xcNp+nuvXBgqZCV06PaJe
         YVYw==
X-Forwarded-Encrypted: i=1; AJvYcCWnhU2pbz/BEuiV3ZVrqPVwuqs6bdApmwWGqKwCxnNoQlUefQAG2faIaEbjKvDXpOIF8Mlc/LjYy7/0J8s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9wy+fhlZzKzf2sBi1Q/tlOPlGpas64EsQ78eB1Q9Cj3qCTzwm
	YnItCG093BoeTjTK7Ei7v9j3HtRNEIVwop9I6pYo9HAPEqXPH+qwd6G16wtt
X-Google-Smtp-Source: AGHT+IFqGslizmlsNGFnxcVO5Kt4qIh194QqLBZK/av4Hvu09FaeoSMpGeJyq6ckqHgxHDDLVdkX/w==
X-Received: by 2002:a05:6402:84a:b0:5c3:ca32:9508 with SMTP id 4fb4d7f45d1cf-5c41e2ad7c2mr20332576a12.31.1726733676838;
        Thu, 19 Sep 2024 01:14:36 -0700 (PDT)
Received: from fedora.iskraemeco.si ([193.77.86.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb49770sm5780296a12.12.2024.09.19.01.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 01:14:36 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Date: Thu, 19 Sep 2024 10:14:05 +0200
Message-ID: <20240919081432.23431-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails. There is no need to re-read the value in the loop.

Note that the value from *ptr should be read using READ_ONCE to prevent
the compiler from merging, refetching or reordering the read.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 391a938d690c..e7a9fcd6935b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -171,13 +171,12 @@ xlog_cil_insert_pcp_aggregate(
 	 * structures that could have a nonzero space_used.
 	 */
 	for_each_cpu(cpu, &ctx->cil_pcpmask) {
-		int	old, prev;
+		int	old;
 
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		old = READ_ONCE(cilpcp->space_used);
 		do {
-			old = cilpcp->space_used;
-			prev = cmpxchg(&cilpcp->space_used, old, 0);
-		} while (old != prev);
+		} while (!try_cmpxchg(&cilpcp->space_used, &old, 0));
 		count += old;
 	}
 	atomic_add(count, &ctx->space_used);
-- 
2.46.1

