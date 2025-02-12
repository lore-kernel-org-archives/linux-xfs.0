Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0997271839;
	Wed, 12 Feb 2025 03:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331494; cv=none; b=Z1JG88RHECSDhL9wG90Rik8eVwmpEl9gJZnoZGY2QK4Arb6pfSq5xE8BRfRVSkL1WUe0idHea+HpHeSub5IayvX6OaHc4huWNdCWb/iy2Kyke0A3VaviRSUGuny15AE2vqbbYYQf1Bsp1YXmLSAIoZs5/Kpfp5/KVx2fuVXSPMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331494; c=relaxed/simple;
	bh=8AU7DE+/aZLX5g/rhmxdGeHg/xNbtnGop86Vgua3GVo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiQoWmIwf+8BuULjgbz0+i6pnRFAtcRahZzAAMotMgO+6WdtKGW2RmvOTzDriKMjXs4P71DC//4WZ1RrKLYxbuMPiZ8dplcrsLtyb3qbJ77a7ftrQSQNhJ467j5DzAzEuqdLtkv3eZYGFqDOgiM/5umTofTwV1NeNGsDymfULhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1lj7m/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1lj7m/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EC9C4CEDF;
	Wed, 12 Feb 2025 03:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331494;
	bh=8AU7DE+/aZLX5g/rhmxdGeHg/xNbtnGop86Vgua3GVo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I1lj7m/lFrSxqcfi22WjQ1mhwQbFlzZJ+21KVDcVEPoOdOtwrn966XRhnm3t+Pekg
	 iOjJtwoZZ3us7bAEQPbOqKCuBd45oIAN+1PJbLJNF4cnqF8OysTxRQyeQJFCWj5htr
	 xD/3lH7wgP4SIkdxE2VvlWCe9tePdUQu9FX1aWkryok+v6pDACL01ecaHY4zS6dqLD
	 clxTHdqTlo8F3P7OKrHJcg3R89PBlgcE+FU+CM8xrxB9LmOkUtzmh2sOoY4McgocrU
	 2+r0tUjQQuyjfva907bxylFDmGaNW3caRrnes2fCHZ/3R9Hlaeb6Udv+MdKCgZPl/G
	 Ph/faMZUNCepw==
Date: Tue, 11 Feb 2025 19:38:14 -0800
Subject: [PATCH 29/34] fsstress: fix a memory leak
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094797.1758477.3270672499473989917.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

