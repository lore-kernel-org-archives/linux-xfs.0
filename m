Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC110E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895626; cv=none; b=tm2dKMcJyKB5NhUtT1mm+zhTaitu6defybTXfAsgpkMGgy3vWSCJ7Bj1I3dhGwB0oQxGPgrFGEddjwnX4ymAbbYbKqaQtBhkhw/nXDuQMCOMqja2JzAbKm7xTfCaQOAY5PTu2twod1Z2IBh1OMc3RUpiUEGbV6NCiTQxUrtKpr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895626; c=relaxed/simple;
	bh=5x8koXvSUAvXLLOmJsdUqVM9dkgo3TYASOMXrWgCxP8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bz0MmSezB5euZ+lzopqxKrDPXADB2WJTmlFqQYn0V5zp715egX6MG1iQqR38JvUkGfaq+rEHeKHGWH6ZZ6IwS4R0jMzxloZ8K49q+UT33lFZoWJFKNGhT2atFvK5744m79xrlczqOcEhLu/77+YZN1n43SZ05yAFfKTLwjd73EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/x61eFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/x61eFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606CEC19425;
	Thu, 19 Mar 2026 04:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895626;
	bh=5x8koXvSUAvXLLOmJsdUqVM9dkgo3TYASOMXrWgCxP8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I/x61eFOLfTknF8eP0PB8olOBImgVn4v2UJVisaejVoJ1PDSEwEZtSZGXqP98hTWS
	 x7h21yQz583POYr+/JNa01I2no9GKPYTFyRtpdjWpw16dsTNEvxQZ4BgvWwm03TizT
	 DoOQb1eOvj5XW85to457aUqW1/iSTM5utPF2Oph2uPLSi0UDXr4DkXe0YMtaaaXQTg
	 jML9AlUwDYBji1lAR0/fDhpoNKxwCxgFpChgf2NZ7JzdA8sc5JCIRwfQShBq2w+OeI
	 D4p4LvsIzU16Aj6bH4cn6Lh3uBzJURdyGZRHoUsGbTKzXiIiu5TyR193GdfOb94M80
	 Oo0NRhE42j8fA==
Date: Wed, 18 Mar 2026 21:47:05 -0700
Subject: [PATCH 06/22] scrub: remove the unused io_disk field in struct
 read_verify
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507050.3681140.6361410651205977832.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 1219efe2590182..56df7a40d6c07a 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -51,7 +51,6 @@ rvp_io_max_size(void)
 
 struct read_verify {
 	void			*io_end_arg;
-	struct disk		*io_disk;
 	uint64_t		io_start;	/* bytes */
 	uint64_t		io_length;	/* bytes */
 };

