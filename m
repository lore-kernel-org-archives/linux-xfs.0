Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531C1FA4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831239; cv=none; b=CIX+ku3KvULF/MzgkyFQY0HM4GO8F5jdRYAohPIK6ik1KZae9CHxSFNqNWmOfcR2yKUWQonkZGpfzf+Obair+Cj2Ra7/CQUl3VV6CXstYYMdh5Rdf8WLLOdnJbEVmKpNsMj3z/0ix8lK615sCEaYZi3OpMkD7sH+3vf5i+Dihf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831239; c=relaxed/simple;
	bh=A5RkBSjzOQjgLuTLdVD4Y630X3KaQyBjN0Z9n+WRqpA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lcnzERRbKNXoA3K/whJ6ULpKkOWU1EOxN+Jk4UwW2y51o+J6kMEzR3uppdSZJ8f1VmrPvXcSiCjt7ZcpIyHipC95mPHBSJfwHVYfhb4f9eU15V5RqqhV7oX9WDbrjkyJCWET9Ytim+Uzg+D6/37sv4GUMm/GY/CpmsHk2djUBAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7Vt8weH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7Vt8weH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C98BC4CEC6;
	Wed,  2 Oct 2024 01:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831239;
	bh=A5RkBSjzOQjgLuTLdVD4Y630X3KaQyBjN0Z9n+WRqpA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G7Vt8weHibAKDyLgRw+3yqF3xysTUp2OMl7/VaLwSnIl6YbGdPeHsQ0gQbVPULZyC
	 djv6bb8suVp/IiAN/6bwxSj8JiUQeHGZPUcaOGNNWzaA8MsPFBS7U0utmoO9SPXjCy
	 Uq6M5Tj2ZJRLEU6fX/IsFRybFwcJR+EUxLjSer3dlSCqUw8wGEOIuZwRXW3kijP7qd
	 0rbXdRDQ5aIIOaDB/Zr5zx5n8/COfCzFvF79Lgb5sAdtJTnmlGNdyU8esj5iNtR9bb
	 YYCmbGgFT2FgEX1RyMChme6gKSKQzYFtLZSrDRwo3Y8nZ0I8fIthzdzUJ0hckAan29
	 7U4hheiIzYM1Q==
Date: Tue, 01 Oct 2024 18:07:18 -0700
Subject: [PATCH 6/6] debian: Correct the day-of-week on 2024-09-04
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172783101059.4034333.17426691099755547847.stgit@frogsfrogsfrogs>
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
References: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Bastian Germann <bage@debian.org>

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/changelog |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/changelog b/debian/changelog
index cf7fcb4c5..82d4a4886 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -2,7 +2,7 @@ xfsprogs (6.10.1-1) unstable; urgency=low
 
   * New upstream release
 
- -- Nathan Scott <nathans@debian.org>  Mon, 04 Sep 2024 14:00:00 +0100
+ -- Nathan Scott <nathans@debian.org>  Wed, 04 Sep 2024 14:00:00 +0100
 
 xfsprogs (6.10.0-1) unstable; urgency=low
 

