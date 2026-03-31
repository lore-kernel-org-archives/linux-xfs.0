Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA9A39A7F2
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960007; cv=none; b=n4nRQu7WhpTURzRRJOD8fJAiYDNx9v522xJCFVZy7eEQMmwbb+TJVlUdGqcOicZKWrzXgaa6FLFqFz4qapuOQtK7TiRnx9F37AowS8ySNzwls6n4aP4olm0j/iOvU8gJMdhCnsPjTps5t2gPkHtfmp/JBy7vgv2XIWo8aylteKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960007; c=relaxed/simple;
	bh=HpOMM0HpiHVcMkW8GU28FrgglKU6mRWo+m4rOGSsOyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzHhE7B25AngFqsWMV8u+AsLz+QDz8xziO+QqQaRAFQJXMQSJppZk9HO3sauE/Hm/07Aif6oVdvA23G7ubTPm6Xzd3VrYYmX9WzrkwoEJ4KP8m76dm1kkPz0xfk+sFsj5Q0h26NqzUKxs7Jufo4s+pfEnJ1PAblen0fM2OPeZTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgpFBQhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgpFBQhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB6CC2BC9E;
	Tue, 31 Mar 2026 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774960006;
	bh=HpOMM0HpiHVcMkW8GU28FrgglKU6mRWo+m4rOGSsOyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgpFBQhFxgHFYGfI4za4HM7MR2sNUr3p7pbcUSxBBUi8ZX4Sh/2bVgPQLBm80NIZ5
	 qCqeEoojbA45y14RMO5xvTLCiMYNQNcPWU10wFN05WpjBH0ef8xTgrAQiVlpBsCk93
	 iqud0lzvYWG+xZIX9b8rqzOFztCdPCrlZVsv1re1MRSXFOD3PaHZDmyKG+RybM7Vta
	 z63bqK/IM0OEpBRO3K6lP1TgugWHlONQqUq4nlHMgrTrpjwk8XpOnGLDusdA6waOKl
	 3wbNJLBn5ASyL8hHrAd4tQBlqJXWvE7LD3iiAJVA2mvsO7/Vvn0XBBP0j6EO1wA4rh
	 BM4J77vHKiYvw==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v3 1/2] fsr: package function should check for negative errors
Date: Tue, 31 Mar 2026 14:26:30 +0200
Message-ID: <20260331122639.100956-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331122639.100956-1-cem@kernel.org>
References: <20260331122639.100956-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

xfrog_defragrange as most other functions from libfrog return
a negative error value, while xfs_fsr's packfile(), expects
a positive error value.

Whenever xfrog_defragrange fails, the switch case always falls into the
default clausule, making the error message pointless.
Fix this by inverting xfrog_defragrange() return value call.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

---
V3:
	Just change xfrog_defragrange() return signal.

V2:
	Change packfile() to check for negative error values
	instead of changing the return sign from xfrog_defragrange().

 fsr/xfs_fsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8845ff172fcb..390f7c5276df 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1459,7 +1459,7 @@ packfile(
         }
 
 	/* Swap the extents */
-	error = xfrog_defragrange(file_fd->fd, &xdf);
+	error = -xfrog_defragrange(file_fd->fd, &xdf);
 	switch (error) {
 		case 0:
 			break;
-- 
2.53.0

