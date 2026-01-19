Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9361B3806C4
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832852; cv=none; b=leRiWUsW4VZIxQzNTqojyPqJaVYjHzgYLq7v4ngwU0JvAo3CBbLRIylAHYxVP+FPRGJGUpXnZlJOANbqF6xaPf9e3GjcvQz+tNTwUx4Z3zTwXz2cdb/gtqfR4O3E2/0bv6htTis0205nb+mdYiArKzRBdL4oMIhXxssmUTF6xHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832852; c=relaxed/simple;
	bh=WUX557ErU13zFdPFK1dwRdxoBAtWpnwpu5uU23EtOEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QW+AVd7Zb6PKgm0k5Vhkb83AKeGEEG0EwA1v3+KNfqZ6hLHvroA2E+8tSAv6iQIGqSMdCxsK8uAn/65CIM0vcrl/MAqjPJTY9ST4VxUnE4LXWUHMbJA+TvQqruCsmcr1Lc6ykpGmjhj4oWf2A4bGaVOqyAeaTlQ2L1abKGhVu5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chx54KNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chx54KNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44565C116C6;
	Mon, 19 Jan 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832852;
	bh=WUX557ErU13zFdPFK1dwRdxoBAtWpnwpu5uU23EtOEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chx54KNNEOU6vG23ln1q1av9FS5hVRlBypd/ASWghwNIED12VzE8Q+bsdmDcpUHcD
	 PgjCS1iwPAinh1vyGEy7SgjA9Oh5y5BW8bAWJX5XYUVp5Ey6j5WdVXTaXj28tIs+uU
	 AX4mAwb/1exlBaEM+7+8v2gn1Vz83PXH37uLvo/OFXEmjdou6/zkHhlu4bJWUXYwaM
	 CNYrSHHKOl+77fwy+6DIhYv6NjGtWyCr6CgdIkJIEkNel89Mibz+oTFuyjASxpAXGh
	 Ael1aDxn+whPQgQN2gI3nTNGUqr/z0sLJORGuNPfn37ugp+AzxEjpnDATRAQcHu99M
	 eNf81UksKW5cA==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 1/2] libfrog: make xfrog_defragrange return a positive valued
Date: Mon, 19 Jan 2026 15:26:50 +0100
Message-ID: <20260119142724.284933-2-cem@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119142724.284933-1-cem@kernel.org>
References: <20260119142724.284933-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Currently, the only user for xfrog_defragrange is xfs_fsr's packfile(),
which expects error to be a positive value.

Whenever xfrog_defragrange fails, the switch case always falls into the
default clausule, making the error message pointless.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libfrog/file_exchange.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
index e6c3f486b0ff..31bbc6da60c3 100644
--- a/libfrog/file_exchange.c
+++ b/libfrog/file_exchange.c
@@ -232,7 +232,7 @@ xfrog_defragrange(
 	if (ret) {
 		if (errno == EOPNOTSUPP || errno != ENOTTY)
 			goto legacy_fallback;
-		return -errno;
+		return errno;
 	}
 
 	return 0;
@@ -240,7 +240,7 @@ xfrog_defragrange(
 legacy_fallback:
 	ret = xfrog_ioc_swapext(file2_fd, xdf);
 	if (ret)
-		return -errno;
+		return errno;
 
 	return 0;
 }
-- 
2.52.0

