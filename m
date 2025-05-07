Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A1C20B813
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 22:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746655222; cv=none; b=kXVN4QbLUNOv/+hG7jq+zeOwEUXWCc6hmuJGAJd33rOoZNni1kj04NucXR9MZVB0aMJdMnVjivthd/lbHXsnqE8u+YoxRdRAceV6bGBdu28p7XunsKeSZCKmFdtHM0wFk6oG9nkbaQM1O9V4Cvsy+Ge2f1+O9EYGSV6QkPL+gDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746655222; c=relaxed/simple;
	bh=i+q6d31eBlAxutXR1/DozGdFw0o2ls7kDaGxp7WIgtA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6272FnRp7vcJgg6JR4f9m9qlqV5df5nsRzMSY+yWv8wEMOT00Q1g5gU4B1+8nK3DjyOUaE7r0Trdaku6kMUmEJVb0JRVo4VUqSgf4GgsnbUOA8XByre4ayq/s58EljTxC2n+CvUONNsPOzYdZNVeKzOfuuIm1Ra5HzWeqtGIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBGejZyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBGejZyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E269C4CEE2;
	Wed,  7 May 2025 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746655220;
	bh=i+q6d31eBlAxutXR1/DozGdFw0o2ls7kDaGxp7WIgtA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jBGejZyq82ilhwgAUQPjecx4nuRMLbRyOtftj1tWAEl2HI6k32nACLColdpbuQczX
	 xknL8dJ9YVmjJCvstpCxBWzHz31xxwUjQUncB5TRbSzS8OJkfkEaFWWQmAKAyX5YIO
	 Ll1JNX2WHyeqwGJpczkxQyKEhe9amMT1YX11wUo1MU/GUENBSxf2RGSgfQ1+a6/3Hh
	 cRW3Gbp7HBpYHHhwnJgYdYw2IXzSwbWl7zD0aNuuwWN5KwScy9ZfGM01q7etsjAc5C
	 MosoKiRg/0d8Ffrf6hsrQDb9MtJWCDdk+2uomPD0t3FtnpqxWtQ9Vo+SKgHKUjZdxY
	 K1rZXeYWuawcg==
Date: Wed, 07 May 2025 15:00:20 -0700
Subject: [PATCH 3/3] man: adjust description of the statx manpage
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174665514991.2713379.10219378506495036051.stgit@frogsfrogsfrogs>
In-Reply-To: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
References: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Amend the manpage description of how the lack of statx -m options work.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_io.8 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 64b3e907553f48..b0dcfdb72c3ebc 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -995,7 +995,9 @@ .SH FILE I/O COMMANDS
 .TP
 .B \-m all
 Set all bits in the field mask for the statx call except for STATX__RESERVED.
-The default is to set STATX_BASIC_STATS and STATX_BTIME.
+If no
+.B -m
+arguments are specified, the default is STATX_BASIC_STATS and STATX_BTIME.
 .TP
 .B \-m <mask>
 Specify a numeric field mask for the statx call.

