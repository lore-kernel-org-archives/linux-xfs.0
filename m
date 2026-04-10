Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1117D3164B4
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801937; cv=none; b=VL9VMjVht4KoUylOAEGYTCtNCwlL9re/t5dC/Nb20sUqGfapm3yDiPZxn8vZwppKH06uYNKg1aum5/j/2nPsjFna8U4rMfVGH5NPmNhmv4ioEY8olNzAlc0SYR+N+7Y7UYo4uaU9dT1Ryksf7w+a4NqMXkMYIJKlE86WhVZjpMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801937; c=relaxed/simple;
	bh=5x8koXvSUAvXLLOmJsdUqVM9dkgo3TYASOMXrWgCxP8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aEOwPWDrKRSw9LiPp+XBCm+0rqiafxqlIs9PDwLtAcUHk3hSEXhKycnvKuemCIr2+ZW/dU5zpYddvx4OFN3b7jFXF7ScDjrK1ma05Y5zZqI+RWGUqLZ7LvG9y+WN1nRDH63yg5TUqEgqtH7OSW5WsLnyEEWRsACm/PIeemr/VX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utejCzDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utejCzDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1036C19421;
	Fri, 10 Apr 2026 06:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801936;
	bh=5x8koXvSUAvXLLOmJsdUqVM9dkgo3TYASOMXrWgCxP8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=utejCzDQmb4G1CyBkCmoVNc3oi2E4SH2lo8/Hx/mzyT75nxF4B0B+0B/om7TMS9Ii
	 FfJw9Q15XPdki9YAXOYILcw3I5RIkzjXBkXIbSBqoeN4/u4LjuSov+uD6nvvTz/sHh
	 bLyQX/pw0QBz2lzOEicKK8XHrk6fIJJINfgpgxyZhtsw0Ce9hkwMnD/SJy6yaxDz0K
	 PJnrrqvN6iV+1gRKoZsg7fbipIhSziE5PeVHpfaP+N7u2T9b/eqjC8SGYXvwM9n/3g
	 43bZBHWTWxjdXnIvDgrNZQ7stWQi0qSmbDluPQSl3FwD0vbTQge7S0+s81YRlQAG3i
	 SAXYHUTiZIDdw==
Date: Thu, 09 Apr 2026 23:18:56 -0700
Subject: [PATCH 06/21] scrub: remove the unused io_disk field in struct
 read_verify
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385142.2090237.18056425845732280962.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
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

