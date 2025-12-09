Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CA531ED69
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313859; cv=none; b=m+q4lF7dkJoqZ+sy5yoO4VtNZEobfhzj00uteMW7REyNN650aU8PB07u4d5L+Wdc41oa0ZdpkiUj+FkiCYVvt9RhapQOJ+PlBAU+HNj7ugQeIEftyvIFeNBnl0npJ/Qlz9+eor8qNEjmnlwutyoiEJ531/jQCIBNP4jh2Lc0x8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313859; c=relaxed/simple;
	bh=26bdBNd08PUkAmVK/uUonAo1qfBwBXTDjL/bHl7v61c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rG7d4fWDEt66kaxQZJTfho4zjaDKsIn0WyGs6FXS8f26dDJFdzjj2GlUW7jqjhGr2K/ulv29jljiA+QtM4YtwYRkAqvRJXvyLbMEj6yKR2UZs/kNqMHVvaxMSedV/YfZjZeBCyFLl6xzbCpzBSTvEiuTkziu7BblJxNcmKSzBgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnuLTJBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnuLTJBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B67C4CEFB;
	Tue,  9 Dec 2025 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765313859;
	bh=26bdBNd08PUkAmVK/uUonAo1qfBwBXTDjL/bHl7v61c=;
	h=Date:From:To:Cc:Subject:From;
	b=FnuLTJBNkgOuinwd4p2mWgLR1VlCRTo3PbfnZuljNAyJmFtXrucjhICJqbr58pvLV
	 DYnLv7+6H8DuKGVd8bu8AP4s5Xbg8UTsUaVx78uaJ/rFkxfrSfr3AFV8VYQzNfAoI1
	 3HUkrx9E/HCFLMmi75Bg63ExjD10A3IbVLOnsQMUaFIXNfR7Y6WB5G8pZ5OfisndUd
	 t2G9+o6m48+nD3lh/91fnhvoJ7JF6+yqN79+4GU3nQqqbX5w7QN1GfeOw+Zke/1U5O
	 KoSn0I4vWAqXn+NMyAXwYTyq8XFcvFzLDUHSfjbiJBfxlTVwrImJJ0uxzcxcLrht9w
	 6raGnFhGbq0yA==
Date: Tue, 9 Dec 2025 12:57:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <20251209205738.GY89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

generic/055 captures a crash in xfs_logprint due to an incorrect
refactoring trying to increment a pointer-to-pointer whereas before it
incremented a pointer.

Fixes: 5a9b7e95140893 ("logprint: factor out a xlog_print_op helper")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 logprint/log_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 16353ebd728f35..8e0589c161b871 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -992,7 +992,7 @@ xlog_print_op(
 			printf("0x%02x ", (unsigned int)**ptr);
 			if (n % 16 == 15)
 				printf("\n");
-			ptr++;
+			(*ptr)++;
 		}
 		printf("\n");
 		return true;
