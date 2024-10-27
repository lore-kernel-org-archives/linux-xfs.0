Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8203762E0;
	Sun, 27 Oct 2024 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730061164; cv=none; b=criz3df/NrNTGJaC3qzIJsVyzTUSV2fND4CbxHZqE4J7L34OFELX73YXlDud0f+Wk/x/JOnQt6qOy+CPPvWWcU+AVbKONH6uJvg4/skW1Xg/AOD3NZUTjIksdN8RIkPyJd5MnW33iWM2zsnZCrfl5RVCtqnBAhnBTJ/hlY9k7lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730061164; c=relaxed/simple;
	bh=MBLg/OHsvkXmNnHMU5vm8OYpQy434w+URxhW3T+UyhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diInD/5uVO+sFjzVfGO9Up2qnBJj8LCN69cvdxn6KwSPoom9KNlctQqJEpmxHtxKkBC24bAYFcHtWNy4VVFlm4XObD0tM37897RAnIQGqQeFJY+Bzn9DpzqvJpTnYw1SNDqyF23pQKpCI7UCJpr6PK3BU/r9783HKDXsTHzFa5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=armyY3y9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="armyY3y9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e2da8529e1so473056a91.1;
        Sun, 27 Oct 2024 13:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730061162; x=1730665962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JO6Wn/W7DXpFOgOHg2+qI7JkUohymRKs3+L+zv+wF38=;
        b=armyY3y9qUL5Y5GA636IRzQ7n6emVaOFCwgyVX57J1oWwZED073lcNKUZi0/vZ6+RI
         EEk28Pyzs87hLBpCzA7f1rEirYm7FNnEEGSczp9affMR4xhUyKbEiekYY9ZbULdRIrIF
         jfom9RI/vAaYWq7Pl+/YBHCLFwOPTXrsliwtbwox5FI1hfjjiNfQBKniqfa8ieZ7lnNx
         fytPxWXIfdVMzLuRn/xelKjnVmPnVMeT4Wth655LzfaHTKy19EErFXX1ARbphEaHlK6f
         O8BhFu6lqg5gZXiVYJCY2D67rxHepcyw6iQVi8G9AtwJqTSUxkjS+7NA6CmwgjGAm07l
         6miA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730061162; x=1730665962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JO6Wn/W7DXpFOgOHg2+qI7JkUohymRKs3+L+zv+wF38=;
        b=GZxQmpIXc5hJNl5X2WAqaS4k6XEKVCaLfaVlG/PB3dGMmE8KrT73DAz1h3IW7F/dpL
         mfhrAVyTe70t8JuRIRqUdr4svoy69RgJ25ZKv8/oKH4VIiCSAjfPCi78N15NwIDW9qJc
         +OtV89rWC/Ht65Qyks/O4LyTnAgOuryCakJhHVFpfFlOCXTBTop5RKtEw3Djhz6v17CP
         b+aRCoRch5S9vauHthneQOFs2ym5VcM/Ubbno79UAyjpdB3TGoozvNAgDPleB0Y4utw0
         IINPomzxl0+8v6+132uYQMq8PNa/qPBMh5QxPFeXRsNWzKXxTNlzbGL7PcNKI4wIvtB+
         EZ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVVLyjsoRH+U1SUYDFsqQBTpFK76S79/NTc2Nv5vcfPgyJIQ/HJ1wJ9Ai6nEnS9r5DGVyAMpDbl5sMrpvE=@vger.kernel.org, AJvYcCWerhe6tkcEtPVOMSNkvqV86ZxZUUJ6Y5/VInp5RoVw360wuHpSpbinjDxKJIU/YgM5VOG/6fWUrUut@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl/uftLebbii/KWflwwEPUn0uSTGP+VaH55R+GR33Us8eP4h9k
	JDRteZ0A8ZKi6u1L8hBnVTrv+tu2/AiTXbt1WitswijSJhIjlgfh
X-Google-Smtp-Source: AGHT+IE41L74XWGTVeMUakZ4CX5VZvMo59R24MX1T61Km8jGghKlk6rov9vGRiRc9gnRwWI7mCR7Cg==
X-Received: by 2002:a17:90a:780b:b0:2e2:b20b:59de with SMTP id 98e67ed59e1d1-2e8f1068be8mr3059152a91.3.1730061162098;
        Sun, 27 Oct 2024 13:32:42 -0700 (PDT)
Received: from motti-test.. ([2409:40f4:300a:9618:92ca:3f55:718b:1cab])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e48bebasm7721636a91.7.2024.10.27.13.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 13:32:41 -0700 (PDT)
From: MottiKumar Babu <mottikumarbabu@gmail.com>
To: cem@kernel.org
Cc: djwong@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	anupnewsmail@gmail.com,
	skhan@linuxfoundation.org
Subject: [PATCH] Follow-up on Submitted Patch: Fix out-of-bounds access in xfs_bmapi_allocate
Date: Mon, 28 Oct 2024 02:02:28 +0530
Message-ID: <20241027203231.20251-1-mottikumarbabu@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241027193541.14212-1-mottikumarbabu@gmail.com>
References: <20241027193541.14212-1-mottikumarbabu@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi everyone,

I hope this message finds you well. I wanted to follow up on my previously submitted patch titled "[PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by validating whichfork."

As a reminder, this patch addresses an issue reported by Coverity Scan (CID 1633175), where the variable `whichfork` can take invalid values, specifically `2`, leading to an out-of-bounds access in `xfs_bmbt_init_cursor`. The added validation check ensures that `whichfork` remains within the valid range of 0 or 1. If it falls outside this range, the function will return `-EINVAL`, enhancing the code's robustness and preventing potential crashes or undefined behavior.

I appreciate any feedback or suggestions you might have.

Best,  
MottiKumar Babu  
mottikumarbabu@gmail.com
