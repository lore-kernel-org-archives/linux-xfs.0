Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8E128EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302535; cv=none; b=lU7HSZYARgGPclzi8+sjyjkG8R431PpqCXgDdU74GNdx2L8abfq4J5g4CBSZhKkPPLKeBv2KyqDQ1VhB8JfbjkdQvNrC0SOV5H2Os88OtcxdnFfCE2mXXPFGPV1BETKS9mXLX8hDm4PBxCRXk4DcLztlku6MbG5ECNWfK+Yzy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302535; c=relaxed/simple;
	bh=oXippp+6rBod3iTcJx1PIKkiEO8RUUYAMlVIhzPlVEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZzJhYX8PE+FOtJwkF7DMeYsVQ6Tq8ne/x/dq6ZQKxw+3QDvGcSk7S6Sax2o+htSOh8hSW8BXqBjjhxaR11Qix98q/ROOXcpzFGlPGSng+2oEz5jfU6E8KJfw6A0IJsXSG7v3pa7ovRyUQjkQGdfbZM58nu7xnTlDvWafeOmSnP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hk4pA6IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hk4pA6IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D62C32786;
	Tue, 30 Jul 2024 01:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302535;
	bh=oXippp+6rBod3iTcJx1PIKkiEO8RUUYAMlVIhzPlVEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hk4pA6INktFHLVamQbQJXYC74at4+UweHYN/4BQ9pKBr3hxHJB8vvZuvH9foT7OWy
	 2uodsWd9j8l45ulh8WOjf+Ee8vuGqqq/luIzYheKxB55/PMotRhr1XUIPfCrr9Flt/
	 FK2++Ymq3vzfad1hIymvhFGcq82QqCqq5HKZ4ML3KsqmGzezsNzfU6GgFRR6YiBI62
	 2C37jTIS0QPS6QXDKV0nMsiUBni4or49c5m7sllcOfQcz+TOnobPEEXde1LbC8pun+
	 noW1IU1V4K5J3O6W7VF3jeZCIkkg84l0qJjL89Wf6yx28gRso5QFudmpIbXrhF6c6Z
	 zZelTVf7NqRbQ==
Date: Mon, 29 Jul 2024 18:22:14 -0700
Subject: [PATCH 13/24] xfs_db: report parent pointers in version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850689.1350924.2946468719698977015.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report the presents of PARENT pointers from the version subcommand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index c39011634..7836384a1 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -708,6 +708,8 @@ version_string(
 		strcat(s, ",NREXT64");
 	if (xfs_has_exchange_range(mp))
 		strcat(s, ",EXCHANGE");
+	if (xfs_has_parent(mp))
+		strcat(s, ",PARENT");
 	return s;
 }
 

