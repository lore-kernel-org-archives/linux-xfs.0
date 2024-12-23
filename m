Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC8B38F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989828; cv=none; b=CdFYJHHpQH+h17wqLMUQ69YWzFLjOLwNiiA3vFbEA3UUAQZR69qLCvfiYmvGbpZgpGqS/Ix9t3fSxvkpUe5NprcoOt4kKLv6N5jNhztvh0Bn/jj0fk2mU/B/izQpJxJoY/j952loZo49jaTh6RrBTeiE61w5n/PwaFV7ixPq7Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989828; c=relaxed/simple;
	bh=fchwwvVta9wTjCYlPokRdtjaSayY04I+x3pnSR793zY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzGXFIUqwcdAXTKCngT7gt0jVwc56SmNtTrU+j21uZqTRC51Zx72XwPUXyXTamLagxr0fjJfE/TQ6cRemeP1t0Js1AlM5YweCLoiUdvcoAFxrLT8VM3Una+thskja2aeBo8uwEZVBbT74H4oKiJeeQD1CyHn/bEpIqA4JpcbCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoJC0VPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoJC0VPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05598C4CED3;
	Mon, 23 Dec 2024 21:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989828;
	bh=fchwwvVta9wTjCYlPokRdtjaSayY04I+x3pnSR793zY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IoJC0VPFyrICifzf4xO/H8Z50cqWnyqejyowY9+hQwuzszj8DnC+JC+atPbf3bJXx
	 seeJQhiOQqtQzJzVbClsBxJpoyYarvZQYhbUjEmxyQvEMs7FbrbWFBsdzhJVHWFIW+
	 Q61rrD3FfS9PIwLsgq2EzEBKvn2CP9AXazbF5azQGdM78vOE9qYemBsZdcNq7IeEqz
	 v8w7+hhYMfscmzLkAG9c6RUdJjwrcJKJyHb+ccjZEPzpWv42iH6kkM6oFc9zRcgvrN
	 XBLYrwMZrl2H7/F91NPq+obOmEuausnidKMmwL/TjF+HbFaXJ277eaJBv/unSpTjI7
	 NI6avVb74K7ZQ==
Date: Mon, 23 Dec 2024 13:37:07 -0800
Subject: [PATCH 3/3] man: document the -n parent mkfs option
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498939527.2292884.14700159259964798040.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
References: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the -n parent option to mkfs.xfs so that users will actually
know how to turn on directory parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a854b0e87cb1a2..e56c8f31a52c78 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -902,6 +902,18 @@ .SH OPTIONS
 enabled, and cannot be turned off.
 .IP
 In other words, this option is only tunable on the deprecated V4 format.
+.TP
+.BI parent= value
+This feature creates back references from child files to parent directories
+so that online repair can reconstruct broken directory files.
+The value is either 0 to disable the feature, or 1 to create parent pointers.
+
+By default,
+.B mkfs.xfs
+will not create parent pointers.
+This feature is only available for filesystems created with the (default)
+.B \-m crc=1
+option set.
 .RE
 .PP
 .PD 0

