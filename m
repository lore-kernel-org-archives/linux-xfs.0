Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8086B22BAB7;
	Thu, 16 Jan 2025 23:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070239; cv=none; b=GSxZwZypPUirBVtbQYKxueb0RH3gO/wpiXi0u1ZSlS7JQKOUFqiqxqUOvWdZ9j8YV4RgPivu5TW3sxrHnU+kYxqdnaq5K2VbFyvt/kLlhfzcsiKrAziwb8iWxf4hw4Yv3G7xar0yBVKWsOk7QVznKen5wXykiu+H5gwakmmWW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070239; c=relaxed/simple;
	bh=At3Bxfr7sSrI/qpBYHOXD7YiHX585/7ELYh3rNmWhwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjGbr0ROeiYoGR2pAGWEtmxN4lyrB9Vh0qPHoeP+OzJeVVMlvvSDGNSB/KjJ58rlBDDdGiYhOl5ljIjbEawvnC1IAn3MbT2uybvzGOTxcH4uuN55EvXA8A7C5FYTMCqUFgN/9iw8UzqrEyONbj0ZQchDnj9c/O3jTQXvJjS+qgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMTyw8u1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMTyw8u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154E5C4CED6;
	Thu, 16 Jan 2025 23:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070239;
	bh=At3Bxfr7sSrI/qpBYHOXD7YiHX585/7ELYh3rNmWhwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JMTyw8u1N44aq0s1eico8PH8cDpFgVp7GRj3wghlqH4IqIy28JP4dBTBQbphLZiHO
	 wYNy3tFEn9Y4W3WIaFyFCHtR05oBMqWj1GVeVlVRpLU7HgxKkLyKTFOPvgJjv4Pfpj
	 AR/gFI3LyxQXs7U78xFvthuot/r6t+whCD1jhfuFY1GrsT2AR5R/yKPadZheN2ZHKy
	 I26XeDhdsIX20B2eifFbOECdSl/5CIim9CGAvb5WkOFksbRdfYxCuIrq11szaBXqXo
	 ksWt+BXk/tRzhHsYcvq6QCOZ4tMtIbj9sJC6lftHgq2DUrzI+DMjqjagL316SeA7Nq
	 65WFEen5D5dZQ==
Date: Thu, 16 Jan 2025 15:30:38 -0800
Subject: [PATCH 21/23] fsstress: fix a memory leak
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974393.1927324.13119018006451156178.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Someone forgot to free the iovec that readv_f allocates.

Fixes: 80499d8f5f251e ("fsstress: new writev and readv operations test")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 9e8eaa6d8656da..14c29921e8b0f8 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -4652,6 +4652,7 @@ readv_f(opnum_t opno, long r)
 	}
 
 	e = readv(fd, iov, iovcnt) < 0 ? errno : 0;
+	free(iov);
 	free(buf);
 	if (v)
 		printf("%d/%lld: readv %s%s [%lld,%d,%d] %d\n",

