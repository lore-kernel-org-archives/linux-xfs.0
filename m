Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769428;
	b=h4CWdZaT0mQwTCl1rdwb6o1sseEOJHWK6FIggtdIOn3MBxrPyeaUlClO35F6lLDoKeQc
	 ymDTClDqyUlxI1z8BqgxsHoxQD5gATTGNuBje9/HhF7pligIcCKAXpxfGuQrOjp5FtPka
	 0iHte+JEEJa4U6+IYMucOOmBryG/sWa1lKMUHmOM/2CCWL9YM0RRngDqMIWoBk4L0vRdg
	 yG3bwgXRsyxxSso8bD9n+c8D0oLB9OJ98/CnEpzgHKKcy3syf+w/bJMTJXKoVzTZohCEe
	 sHlzE6YlmMJ9E8sduyM0j8yW/aH8eIM9yc+hMoUHiV77sZvzfiiVhlBSroBLmqUWY/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769428;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
	b=Qf5reO8oWVOGbgigZwk9In+NefKmpknoNa/k4KNQW3K5Mr0WehQ/M+H+SwcMOmwbSvA9
	 TOfpgjI+OGCzISwP+ix1t//AdwkRCi4EmAG7ILGE+4adBKsV+kNxIR+Av9h/W0rdQhtA9
	 cmSEcHpqmwjv3gp/4w48bnQ9SfzrXoUlW36m6OHfVlFQNVrXpM5Z5/cmiNN1jHG9SDTSu
	 XQBoZLMveJ8Oi8zUCam83Xz0/8FgyiWsKr9Xc9H8plWVnxUaengUmKcBaslDQvj7AGq6Y
	 pdHEExWW5lW0r541+hxYG0cUqoW6Fu8cmfvRrdylQmYMkqrQsMh7gxN2nXA0ATimjwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="g/xCeUbc";
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F8606A6B3
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A85F8606A6B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g/xCeUbc
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so4898003f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 00:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769426; x=1796374226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
        b=g/xCeUbchw3f/7WFuHHQB4er9HUf42ben8Zb5/Tbl8F+B0HO346GrlqWYF1Q0p5WK1
         znlCIb8D8+/nE5XpC3jpABV5zQEZGwTYOK8Yk8iGYFjDY268Bj6fWCEXCcEb0q/AJ5P9
         bKAbrN+eUmNhq8ZgYe0cQJcwNce+iMoHtBp58gOHn2XbCcMnLRpsx8/acNEHjylTWo8T
         8SXTwGAkYa/XYqr2bJH1iqsbAuwthLMl3C9WGVinmbw8OzZ23sGXGVGKWTVfgMsXzxJD
         LObG9qXofC82hUZJT+g9Wbh7wEnXyXIJwK+03yUPCFWFw+SQblrjhFN5OxJG0SxoUffE
         SAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769426; x=1796374226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
        b=vs6HYrajar78qYql0K0gTSLfyVNKUCBvNMMZRPWApOZB9yNf8IxHZKVCHQgjW3qHMg
         yxPQfr+cZcl+7c8dR9+NCCcx9UAsY+Q8Xjcqc+LHTuwMFtys/2It+VV6/x12NQTAhw/2
         v9esCxM17yDkQsol3vzA2MWFAUuwgrM03GpHADGwRlLiBA0jigd/87ZUS13rhZJYH9Gr
         aeY5pVpicz98jgMlMAXbkZnUHVRrg95Inf7GJuC3ZHpgAtjvGrBYaIDZHaqIK5eKgyJu
         rDm+xcSBRBYVSEClmZbn1dPeqasND8jXHQ+0kjLoJRfI7fOk66K4Y37a01cJaUrrX1mB
         q8kQ==
X-Forwarded-Encrypted: i=1; AL+hErELXJYYQuENuDC5WUMq+frbhJ7qo96yW0rVxQswhD4n+/LYt8wm8L9cexlYeQoEUlU855tTlnUuYO8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+AmHueZpec1+wAH8XgYw785/0qZHBBjMUJJPQ9YwXkPWXlJ+9N
	aPkxpHJObfJJj0dXNsm2UTcJAbXF+52QK5kvQuRIcXtak+fytWLk/U5t
X-Gm-Gg: AZFdTZfHIBBTa8fOrHfQFvasPxJNYrOe8h2dBt9rVy0pQ3WkR5XRm5Nndym6OGKIn8u
	lL1lO0hFzJ4l+cT3U6kF1YFJXxwJ5QxmzMf3xaax0uXEqX9vRglNiWF9KYg7Bz8Z3+qnUOBmsy/
	WTFmvgzoF3iyaCUHSpFU8tQZuLII0qvXXfs042gz5C/matbT5BRtUMlMqdrP/oam3StjEi2oM8E
	iMIjFFkzsOF10I0kyWS2wcCuE274qrWTm2RJg+LjTA2R0eUDG+IptF9LoYG+cOFEgGBg+mAt5d9
	oSe08TmnoqpVA8KtibEoPRJWouNqQ6GsA0IAQvYdXh1BuIaopp5+4hXi30Y2RZdB9KK0Pu0bnQT
	OvN1czyGArjVrWVQXOchAfMwXW+V7eOzQzpgt5p2zPRypUEMq31XtJPCdrw6cq9gs/55+d7KZZk
	wmK4sbSiP2pN2UlWfbNpD5EzgYgZIVwxGZglM/iz7I8MEpGAReKnaXXdVqZuTcfQvBPW1Z9g81i
	SsmL9y5iRKiL0Ru50ZdEvJyDwhlZt/ngRNrQiGmpq3JR54yeFAZuyb59d5yeAMqC9jgo7G3FjB6
	qJiEgnAEbgXc8nTQjW07PX1TInkVKs+utWHEP2CD6cajoM7u0rFDjLpicbmHMFjF0i4bzsmazH5
	c+KqWF0uXuQE=
X-Received: by 2002:a5d:5d88:0:b0:4b4:510c:51da with SMTP id ffacd0b85a97d-4b4510c553amr30670632f8f.11.1795769425756;
        Fri, 27 Nov 2026 00:50:25 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf630esm46461938f8f.16.2026.11.27.00.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:50:25 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18] xfs: only assert new size for datafork during truncate extents
Date: Fri, 27 Nov 2026 09:50:23 +0100
Message-ID: <20261127085023.2340874-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

commit e942498385bf80f4d6d075b47174035545eb6a2e upstream.

The assertion functions properly because we currently only truncate the
attr to a zero size. Any other new size of the attr is not preempted.
Make this assertion is specific to the datafork, preparing for
subsequent patches to truncate the attribute to a non-zero size.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: b854e1c4eff3 ("xfs: close crash window in attr dabtree inactivation")
[amir: without this patch, the backport of b854e1c4eff3 trips
 this assertion from xfs_attr_inactive() in fstests generic/013, generic/070,
 generic/103, generic/117, generic/417 and xfs/181 with CONFIG_XFS_WARN=y]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3b487341348a..5abdcf1f46c9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1025,7 +1025,8 @@ xfs_itruncate_extents_flags(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (atomic_read(&VFS_I(ip)->i_count))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
-	ASSERT(new_size <= XFS_ISIZE(ip));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-- 
2.47.1

