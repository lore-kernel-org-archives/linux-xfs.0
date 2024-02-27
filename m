Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFF4748A;
	Tue, 27 Feb 2024 02:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999295; cv=none; b=oF5dCs3OznTyf7P6kOQvOFs0C0VznqYXM9sNzPUM7FOpL4clz9OmQLrl1y9rpJQqDsxeFSdOfk5RzDAw+s2DE+P3trwhohVSrmXqV0vocdZ77HgXRJfSLpn6oHyElsk+HYgiUIm84QxYNWSGBGVxm6JY01+HK6q/UMfO4hd8CEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999295; c=relaxed/simple;
	bh=aphw27qmlWJ4fC882oHpD8RxySiHOtA6AY8L6ilMdCo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5pw49YuHU/bKRAc9A0OfenLuxaw0ooiLGUiML7r/+nkCP0I6b4L+2uTJe4G2UJ2chUSis6pzorejUZtVV8devzlmwiMQZl7dhncj12aUpixZhb9+33NSMKEAo4KSwKv02XWEan9dbmu1C62FT8MTIYj/yNpEuHOAC/jGaHREQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAqjeXsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAqjeXsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A751C433F1;
	Tue, 27 Feb 2024 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999295;
	bh=aphw27qmlWJ4fC882oHpD8RxySiHOtA6AY8L6ilMdCo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lAqjeXsFN5x10SpAjKe0Bl7MqDnkX/AOTazuF02VHkLPsbWjbSy5/fl4KTzNKPQ43
	 w/X4pdGTyJnOf0+iPbAACgn2O849yicNNRUpGDxfHZ5ZYYHFkevpPSGt/73mGzimV9
	 42TRQ7yRE+dOTSyT7Mt6YeqBbXLoqKKYLlhsY6zpebzQBUjyBLdmJzt17+u+xIdFmU
	 FiuUD+IBRs5rjjLdtY1zHVwE+f1TFAMaK/ILYgUIM2pBoOR9gStCTfKER962d3em2p
	 7mZCO27GY8mVm7meTDUkzXA1kmHEm8GqyXFNFbm3Xtfz7zv5iSk0p1P3yh0Woi9shI
	 B2WlfTlLjzczg==
Date: Mon, 26 Feb 2024 18:01:34 -0800
Subject: [PATCH 4/8] generic/491: increase test timeout
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915276.896550.7065004814140508980.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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

Bump the read timeout in this test to a few seconds just in case it
actually takes the IO system more than a second to retrieve the data
(e.g. cloud storage network lag).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/491 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/491 b/tests/generic/491
index 797b08d506..5a586c122a 100755
--- a/tests/generic/491
+++ b/tests/generic/491
@@ -44,7 +44,7 @@ xfs_freeze -f $SCRATCH_MNT
 
 # Read file while filesystem is frozen should succeed
 # without blocking
-$TIMEOUT_PROG -s KILL 1s cat $testfile
+$TIMEOUT_PROG -s KILL 5s cat $testfile
 
 xfs_freeze -u $SCRATCH_MNT
 

