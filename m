Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A751333B6EC
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713105; cv=none; b=dhzirzgT1NO2KGVlQInHvEPhI0PVu79tH6SJaN05w8JDqD8MOnTFnaonwbDPJQrzwcErotvqfzz85Dk9PoVdg67/nQduAOxqdw2fMGkYjYWYKewALd1c0UmyQBTtZxgvmnIjkp22EliSSsrnk3a0Zq4EZ6TcrOZOOl3bvHecyGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713105; c=relaxed/simple;
	bh=GyhI/g6BT2jDyrnrno9j5u6Y8zL8PZ/BqiyLx603u+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pUtfgi0rY2DftfcziIUcG7wp9TCAfg6/7Q9FOl5TEcavO3eK6OAgaOkkumlDgQRV22//z3O1lwyEqjip8tpYU4cnLEQsioB6QuwvbVsBqUrmelsRc6XXRVWdf9cccVGIeUG7ft8XyoPSDf7JE7PTouYISqhSWfRV6VrJFGXRg8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeyWgAVJ; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeyWgAVJ"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11b6bc976d6so2581314c88.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713101; x=1764317901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXggH0+b8/rP3aYBPWiHo2+gkYlGyUfzMd+zPzEVv4o=;
        b=LeyWgAVJr3fMFjr8U4oXey8gEbanof7tLmE6YJnsBE0QZeykEGUxp9+1/5v18RfM/O
         vdO6ZyHA4yKGVly6Yg08nFY3nbFWe0yega91tV8d1PcEPVsOHduLL70LPDD8aWmuo5lJ
         WrW55oflyjt6pmPqRehbq7BkUaeJ9A3NjPrSXjfhS6pOUre+pu6eoAl2Vu/GWqdn/BR7
         wBwN+5ctemDSUEUX6cyd2iXn37wTuG41V0YPf9v5zS70E4h5WSuJ8NQ9Z5iaLLfwYFjC
         fYTVFR+rgqUNcHxFedzbdK2AUo/QVliOgwyKhbr4LKF8TObANBd/z/wKUZoL9u1On9le
         XK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713101; x=1764317901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KXggH0+b8/rP3aYBPWiHo2+gkYlGyUfzMd+zPzEVv4o=;
        b=AepSozLtNlDnOcC04N19+wjh+ojYVnQw9UrdXz85rOSaZvFvhHhUR2x8kDXZDEnbI0
         d3xSRA2mNo8N1YX9KSW+dRlG6uytCOSOP+uRTMcoMJ3wlzfrKmcA9vFIaKJ0+7cwiLHs
         8y8VpI0pgjCZ3svHQOG99m0RVSsYWkzpnrwh3fQ4DfZOk9PAcs516YbboxNoYsxPJV+7
         pPlFsQy7faIGBT1JD/1XSBjqNizE940nOJJvk5q8Ey+XdQ5kzi0AiKEztlaHlZFAxqyk
         1L3WlDF2FB+u2sHN4JGyke/4Is2ITeLfkdd58rtSUNFJA7bUUAzCLU9kgUIZnUbpArwG
         YiEg==
X-Forwarded-Encrypted: i=1; AJvYcCVaZOGM5umxZhtfziHZC6dzVq6jagIjB6WF6ZAUV0Ar66+0L9iH1TqRH/9v0KSA7Q5JNMk8SwiHTJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoC+nPzFAkoDuOyh8d6uIyzCCTxwF/U12sylaznxJ80tVSN3gD
	5yDKoCFlmybK2Dy6yvmuf16IyRWOqfRZxs7pbpsGibUtF8n6CHHpXNfl
X-Gm-Gg: ASbGnctSPVhACLufziL/hAzg0Q+UIFwJgQTKtdguPbF088YSC1ctpzTW4rqdFWBnu5k
	ZEMOawOC7swqCEeRKx9xyggvQRmtONxnBeYtrYgKHRjrMhE9UjJR7MRWSrNWmKaV2jtbIWKuf4o
	CqwA0HP6OwUsR+zXKRFBduhfYnbvWehUkud3ZJaNucttjGHbarDx/CIe4zH0qZmpI4WSrGhYQBM
	qewtunZOzmcoyVBNcsA9gNpKEfdZtuV2+sjXoRAra8MDwuP3AKGNjVyD/Dvga4qgm02krVnLXgX
	Ywl3IvJ5UZ46Hc1lt2L9OsSGG/BdqxuUgRyxnyYTw/c1Yf21Vu75fOMNXZTDXZ9zFEIoEPLiX09
	5mFB2Uf/YRtEMApCAXSWgzXDj1sUDQbZ8gjlWGR6K+5rhIm/G3p5l5f/9PFxzmvsbI3tneACO0/
	YlgDqQIrZyj6W6NJe0RzfhBvXDMORW8hX/7bIk
X-Google-Smtp-Source: AGHT+IEZ79TJZoTtjlwZLisOIZ0dGAr2lEGHTXQQoCt+6eH8PV20aIRNYUKQ7CDTkbiFuInj7IJvjw==
X-Received: by 2002:a05:7022:1e14:b0:119:e569:f86d with SMTP id a92af1059eb24-11c9ca96a9cmr324319c88.10.1763713101474;
        Fri, 21 Nov 2025 00:18:21 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:21 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 5/9] block: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:44 +0800
Message-Id: <20251121081748.1443507-6-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1

