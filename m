Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D0D2475CD;
	Wed, 15 Jan 2025 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736942729; cv=none; b=jljm89riyIWFdbz1asfnmpiPKSN434U/2Exb6yEVMstB+Okv5NXyiW6MjImam+vKq45oB1ZgLGUAf6wCWFb9fo+7RNCMGs0oAfr/bus3P9GEObd1q8+LTkRJFHTEFDqGJtRaSxeVY0oPQwX+mwx3zADiuQ+qTxyZiks3Nr7lsx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736942729; c=relaxed/simple;
	bh=yv/mrGdp5A5x47KM6RatYSKSAE9HnjleDeB6ZvX6V58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kldX0h6aIRz1CR0kUjo0l5s0cNXV9b8t15FiRV07imUhR+Q1KH8MkrUqiR+PCTCNqiKJH3SvrM1VQS0zKlhniREVzD6QyKnA17dOn0wEV9gv3nlp1zZwJ1zbD5vX0AfGeDqFt0IpgyqEtIz5PJeBl5aknRcOGF2sv9ZY1PONWgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=atydfN7Z; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atydfN7Z"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21649a7bcdcso113042975ad.1;
        Wed, 15 Jan 2025 04:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736942727; x=1737547527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oK+gbzY10wgek6yL0hkyZ9bodfFseihibmdyawoEMdY=;
        b=atydfN7ZTMi4nBsWh9PJpfpWUdBU5MEuuigtJow6kif8XOTKhwgH5FnitEUrlac7hG
         fXYFUOo6ddaNxglk1th+IH8XnarfDuUlxwNrKzn8SXz0vw3Fg3XmVyDcuVq3JsY7bvnD
         hkyQuq7tHkpAuCnKrPdsnztmRpvmMN+qtrIhVFKyyHUfiO1Iqjvuj49AmhXD8Bb7kA3K
         IRKlZ+wZlGOdIdV7QJ7YmkehyTrcXkW3kxnWNIi/fyd1uvRjNryo/dnBZXWMXwpsUPlG
         rldz7heVUGJc5nqVohcz0u7dSiEBRzwv7wDeH1RHyjHZIymYqOk3bijopb/xLWzX8d02
         1nug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736942727; x=1737547527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oK+gbzY10wgek6yL0hkyZ9bodfFseihibmdyawoEMdY=;
        b=J471RyTuEcxqIcfrVP8MNxRp+G8n/jSPQVmmpvVxzhLPgYjzpxEVwI1/GEO7X+yzMN
         XMksUqdxG5V5aH+CCWcVJFDo/5JUNDlGfRiYFpV8GlAoPaHSBTA9k/bBciQjSa0b7vti
         CVK/kmSN6lZURy7gpH9+xcPoGbB+ezuv7LeZHwf9Qv+Bt8dWAdZAGUBguJ1hH2aJAK6b
         xhzeuaZ7yMMh9ld+gooVtnKVv78Ep5DX2T2RutjxaNdUsLWYwtsJwRHE2gIH0GTe3Rlr
         M64TnNkEn99rp120S9PdTXs8SMeqEFhBFT73jjju5nOjHV9Os453bZqHf1kDqUZjnNbC
         4fWA==
X-Forwarded-Encrypted: i=1; AJvYcCV7np4+5Jyb6oi8pktShE1wQnC16POcMzv31JjylErvctJPZ1F82UUEmyGtjvM7BgFXRZaaZEe5RjuDi5Q=@vger.kernel.org, AJvYcCXHCmwBD/5TO/0qOdJJxPaawbs7L/CX2h9j7C8Qr/5LQNUAd6QDrSImCmmk5aD0EdwEECIXbgg3smNx@vger.kernel.org
X-Gm-Message-State: AOJu0YyeW6MNM3fSNopbb0VpPQtwjLG9z1RhhLwCKbu8tf9KUycJrNfo
	uviWOoxRMkynO7hh4SJK5vGMuYsDhy1JOYqqcgaOQ1TG31XgPyZN
X-Gm-Gg: ASbGncvrxEF+bsB9nru4FS62OjX+0OG//w3dO1D5gixhlyP6WuY4IRpIvNFToyJlZpc
	5UasY8h5oS1c6aSqQq/sUWLjWK3vYnnTv77pu5MrczOU/CMJ5UQkrkDD6V+Ha/AQ3tPxhCGTRLu
	tPH4RXmRxVJ9XJElZ5Dv7euRwkDyZZkwP3wkiXDAL4iThQwQArtm8/JkXSECPqkLc9D8lfQ89DH
	GifBZaaIpCynrRbE6jiAnAGn1F7aab2lnlQ116qhqFV9vNp3ItjiVUdEaCRZCqOolnphJSm
X-Google-Smtp-Source: AGHT+IG2o+NDYzknwuF/lxHmUyuB18TeGUQTQ7twBRU5ntpVUG+z1GHkxnWYqsu420uT2N1UdWKIWA==
X-Received: by 2002:a05:6a21:9007:b0:1e1:9fef:e959 with SMTP id adf61e73a8af0-1e88d12be47mr48071919637.27.1736942726722;
        Wed, 15 Jan 2025 04:05:26 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d406a553csm8857366b3a.158.2025.01.15.04.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 04:05:26 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	flyingpeng@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Date: Wed, 15 Jan 2025 20:05:21 +0800
Message-ID: <20250115120521.115047-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <Z4cBRufxcp5izFWC@dread.disaster.area>
References: <Z4cBRufxcp5izFWC@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 15 Jan 2025 11:28:54 +1100, Dave Chinner wrote:
> On Fri, Dec 20, 2024 at 01:16:29AM +0800, Jinliang Zheng wrote:
> > xfs_buf uses a semaphore for mutual exclusion, and its count value
> > is initialized to 1, which is equivalent to a mutex.
> > 
> > However, mutex->owner can provide more information when analyzing
> > vmcore, making it easier for us to identify which task currently
> > holds the lock.
> 
> However, the buffer lock also protects the buffer state and contents
> whilst IO id being performed and it *is not owned by any task*.
> 
> A single lock cycle for a buffer can pass through multiple tasks
> before being unlocked in a different task to that which locked it:
> 
> p0			<intr>			<kworker>
> xfs_buf_lock()
> ...
> <submitted for async io>
> <wait for IO completion>
> 		.....
> 			<io completion>
> 			queued to workqueue
> 		.....
> 						perform IO completion
> 						xfs_buf_unlock()
> 
> 
> IOWs, the buffer lock here prevents any other task from accessing
> and modifying the contents/state of the buffer until the IO in
> flight is completed. i.e. the buffer contents are guaranteed to be
> stable during write IO, and unreadable when uninitialised during
> read IO....

Yes.

> 
> i.e. the locking model used by xfs_buf objects is incompatible with
> the single-owner-task critical section model implemented by
> mutexes...
> 

Yes, from a model perspective.

This patch is proposed for two reasons:
1. The maximum count of the xfs_buf->b_sema is 1, which means that only one
   kernel code path can hold it at the same time. From this perspective,
   changing it to mutex will not have any functional impact.
2. When troubleshooting the hungtask of xfs, sometimes it is necessary to
   locate who has acquired the lock. Although, as you said, xfs_buf->b_sema
   will flow to other kernel code paths after being down(), it is also helpful
   to know which kernel code path locked it first.

Haha, that's just my thought. If you think there is really no need to know who
called the down() on xfs_buf->b_sema, please just ignore this patch.

Thank you.
Jinliang Zheng

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
