Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3F4136349;
	Sun, 21 Dec 2025 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766312711; cv=none; b=Hch6OMRLrd2ps4YrZbh7CEgUMSJ1MJXMOHO/2fWvt4nacOtBeGCz5HYx7Bm6wCtVgxjJY9DOHpC1X0/TU6OUI4N4hpYxkbTVFy8E1usDaLhNbOM/je9pHhXZEDY7CDHS1NQcw5NP8+EYm5K8CqQ1de8rJiYL9TjfWlgTv90kb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766312711; c=relaxed/simple;
	bh=5UmL7SGNCe6bPgMzbIO4IiVZjXL+T9l12POo7+0FrPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K4S6ElhpnxdLMXCTd+Rrq1wZr3gBWeJIPioHINpMQkezKhRjxJ2HvtO7aTAEbdlYAXO2cex3viHL28Lo+WRMuGdkqOZERJc2rEx74PCo4I+BtVcuLKGIh6u4Gtaxx5EzdGiOF/MsRWv1pGFGN/2zFqURPV7DGtEMksNY+Ccqh/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJVD6keY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJVD6keY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC6C4CEFB;
	Sun, 21 Dec 2025 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766312710;
	bh=5UmL7SGNCe6bPgMzbIO4IiVZjXL+T9l12POo7+0FrPU=;
	h=From:To:Cc:Subject:Date:From;
	b=tJVD6keYhrq7e95AE74vWCd/9K0XaM+Uu3AwG7RY3neTjjt0yHCn+HORxakh7IQ1m
	 i+2Hr2q/cYq911tRKrvQnTa0vjNdc8+N1TfT70of3g1DRIwB3Xhf4/BdbGekHHxQzu
	 4pEqlBblIdxt/47VvyxnlgVuiogEnk5FXkQPSnATf2kuOGb76TTKRgBELzBZkOFx2d
	 3fhW76JQoN608RZhyrTT45fuNnptRDqd4Akpr8SqQRFgAV+P0hlErJmgJ6AsTAJzMj
	 NeTXY/cmrts6MgeHNrZCjv2xwMU74V5UgNWp27aSql1yob/b7tHwnViLvGoHK5Gtra
	 BoVnXPcgZYpMQ==
From: cem@kernel.org
To: zlang@kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] punch-alternating: prevent punching all extents
Date: Sun, 21 Dec 2025 11:24:50 +0100
Message-ID: <20251221102500.37388-1-cem@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

If by any chance the punch size is >= the interval, we end up punching
everything, zeroing out the file.

As this is not a tool to dealloc the whole file, so force the user to
pass a configuration that won't cause it to happen.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 src/punch-alternating.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index d2bb4b6a2276..c555b48d8591 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -88,6 +88,11 @@ int main(int argc, char *argv[])
 		usage(argv[0]);
 	}
 
+	if (size >= interval) {
+		printf("Interval must be > size\n");
+		usage(argv[0]);
+	}
+
 	if (optind != argc - 1)
 		usage(argv[0]);
 
-- 
2.52.0

