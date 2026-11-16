Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871061;
	b=n9IS35TJGwmCQcrxzeaI4NpmHl/qCo/2R6Sy5+PWSFZxoKTjeOkfEgR9DAUvPOEm9u5/
	 Md1nx9JLas2mgJOpuE/vzO7kbo1r+QpxvyvjsWVAodwjLDi/NBVgy9wrjUIp7xhaSBVfX
	 QXBWk3WIBmrXoxWtT+8DGqDlhqmDAsIzILQ3ASL8M2UmBtb3QMupGRzBBEQ5/dM7zUSGX
	 D4c5z0GNQqnw6lDq4GpBXPwxdZliQvF/0UBdO4hkGOXug/MHwg+yXZcAl6vACR7zY6oxm
	 8mu8kSoESf2YqmNYKvwWSOqgH5YwoBENOKhwJY2pqpTkY3bIlexlLKmgAoSyvYAn1Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+buSzaKm8U3l8D/yTvMO/+ydaJe0wAKKCBPM7kVLl4U=;
	b=KSnL1/UVDRSVvQc/3BizYCKktFDWRnWXHqBvjuea3Bt17T35gBvBcWjWIn2K4JI9uI5k
	 cTu7Rkcud6n33a73qi4mQgq1yUkJ9F9bblIPFlF0eiCO7hkTkCpozO5YDURYMbaJ10X4v
	 XNk6f9CGGmFW6biCmYpPMGGZcgC5BJR1WgAYo5Vx/kXZp3tCMt+YFy8QvUsh8q042o5mK
	 27zVDjwpY1iVtYTc5VNUspfG++PqsVvV8cUK7q8tr/2ofXEK6OwtSOc0Q6bcUUAlZ1Smz
	 x89Oflfu+fcqx6nnMAYbVGRrF2/HPNwOCWZB2KpHMJU2dctq3DXe7PCm/1zZEkUfFNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFhSEFl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DF8606A32F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFhSEFl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CBA1F000C5;
	Mon, 16 Nov 2026 23:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871061;
	bh=+buSzaKm8U3l8D/yTvMO/+ydaJe0wAKKCBPM7kVLl4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFhSEFl6HK/8NTZp3weA9qyD6ThLXmUMdpkVlLVT4vbH++Q4o5K1WGJfp+OrDELpw
	 mBk1nm6H4oQE9W0Hx47L/964sscUURr/Fqu4J0LzgNZeaqi0FoeQD6RFltK8gH/eam
	 9Tu5OjXzhSLEe++behwFuuI1mk5ygZj0sNIo0qQi2lmgZTdKOotqJg9lZ7KOcOaLaL
	 kP7xD/rXtKtZ8h+RPV5DzQbCs8zHh+A/uXqeE4Bpgc07LtYK8BijuTWYFJbUXTXPhR
	 cXnJU7RXQ+DqcMNl/2hY98ifstBnAgKEo6hxtu7cNJ6W4w3nGGxwkQ9U53vVL+FSFV
	 qaSJBU0AsoqQQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 21/59] xfs: validate the operation header padding during recovery
Date: Tue, 17 Nov 2026 10:14:38 +1100
Message-ID: <20261116231707.3625263-22-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
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

The operation header padding field is always written as zero, so a non-zero
value in a recovered ophdr is a reliable indication of corruption that
recovery currently ignores.

Reject a non-zero padding field during ophdr validation.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 472e0093d589..2ff06d80a05b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2725,6 +2725,13 @@ xlog_recover_validate_ophdr(
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
+	/* The padding is always written as zero. */
+	if (ohead->oh_res2 != 0) {
+		xfs_warn(log->l_mp, "%s: bad padding 0x%x",
+			__func__, ohead->oh_res2);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	return ohead;
 }
 
-- 
2.55.0

