Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B91F153D;
	Thu, 16 Jan 2025 23:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070614; cv=none; b=lCs7opUSadnOJnJzoEyQiadq2kqA2AiSodV7MGh01fu3RXViuaAXBDQeUFOH9dDPw/ECRZU4wSiqiHEU5W4hJYhTzrH1G/j7Xm+Mfy7ZfrsDp2Xd3peY7OYh/Ydai+Qo6ZCoZk1MBcRJrMLAaAHiDAQt0NYH3AXKoKFI9AT+0S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070614; c=relaxed/simple;
	bh=duWzI1uS82Jk3R0gIyLbBxxtpjoQqhp5UbLvIPzcoI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jATl78doxjUf672YKcD6TyvCcYoCNaxvfOK+RnlaiRbKUiJl6n3ReqjMMoKh88p7zhgYfFOdO06f0VCU7rVa8J/j9Ib3WK88Fv9zp+RoDGiPEjMBLOyzBC+GPQgilvA3DkwqI+FbAoBOyzuwdVysg6+Ap+Si6cVvHVmsizEL97k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBmigk0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBmigk0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0B2C4CED6;
	Thu, 16 Jan 2025 23:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070614;
	bh=duWzI1uS82Jk3R0gIyLbBxxtpjoQqhp5UbLvIPzcoI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gBmigk0r5lFwOA+RtNR5OptXVImmeqkQrtylLxYNAbwIr5+xI7IMT81SAjqg2Bj8P
	 +gwCbDXEzLU9L+Q9zaKeRxFu9wD6q2DCp/XDaNXYYmnmiMyAym8ymmnNOqCbc2X4Lx
	 rG35zIK7a1wRkpKe4xpBiiKd216payph2eUK3E4y+40rnrJTiiak4iSEwKLm66VfrX
	 dxgcijVJL3Q+oxrZDeOa6w1xtQQf8POX0pJCW0oU8Ce8PdUwUvu//1VrQ7H9NK4z1F
	 pOfw0RbGU3zLk07MkopwPZiACcyYpiqybmRKFPqtQcMtn/m52j3SLMV9DgPRa1JDuh
	 Tbku1LnW/mffw==
Date: Thu, 16 Jan 2025 15:36:54 -0800
Subject: [PATCH 07/14] xfs/206: update mkfs filtering for rt groups feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976170.1928798.2498500799249120486.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter out the new mkfs lines that show the rtgroup information, since
this test is heavily dependent on old mkfs output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index ef5f4868e9bdca..01531e1f08c37e 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,6 +65,7 @@ mkfs_filter()
 	    -e "/exchange=/d" \
 	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
+	    -e '/rgcount=/d' \
 	    -e "/^Default configuration/d"
 }
 

