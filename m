Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4134E5344;
	Mon, 28 Sep 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609789; cv=none; b=lmBl9+YILoHejOCKmqMT1pXR/vJfCe26ib78Q+WKIgRSpEpm4JFRQlQ6LNPjcS4FICUUAQNiWA/ZNyZAih6W4nBAIqvZCC7t6ny9ZqDO+HwnmzBLOnjFm3y09Lv1ZKoBcI8aR2xVdcSEY33/6RZTQXGUgbKEFShYFBeiQ+RNgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609789; c=relaxed/simple;
	bh=TuKiwNf6rx6mzxYjshbgDXaFhwMLxxOJnQVw+J9wu+c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8j2wUV/Lzd4bAqlhNOP1jWkIk0fWXnAnsrmyDm9JHI3aZoow1M3JC5Bm9MExbhqHklLwujMomsQgHGD6KVZgo8GuBJSZ45NHmsAevZ+59zX0tsryWdRnMQ+aIMhhjVdeR1kNKXrZ4Ll96GHTS0XI6dz66YYDN/kdk5uFCzS1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUl8/1U9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUl8/1U9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B9FBB1F00893;
	Mon, 28 Sep 2026 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790609787;
	bh=nShpVs1VJ++4SJYBxU16Puq89DeQHDrY6sK2McXnZEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WUl8/1U9YCcwn4hPk0KtEHlGHr8euQF3uTd/54LtA9ES0AkM2/GYxnFAMj99UhURT
	 Tu9XTh/RTdjl26jCpboGXuY4ueb7TD8EIRvB9j9hzQcbsDIEWNG9MfT8nLF3Ox3UeR
	 gVOpcB4hUXMLmXcHU7wUqrxfYfUIHKRjIZpYdnRrlbTccXY7c+0dBNVeuXqghEfryT
	 EsXCRze55AUv3p+IxAFSijQrMtDcpQrgqse3JracjUVRrswORQyFK6o1TyV0hWSM4u
	 yLxLcLaLdNNVldndwIAwBLXwVHUy3wqRvI8iUCbk7nZ77GBVDClxVsIY9x1Hc9yoCw
	 dRCyI/lfzbx6Q==
Date: Mon, 28 Sep 2026 08:36:27 -0700
Subject: [PATCH 2/4] common/xfs: add zoned/rtstart info to mkfs filter output
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>
In-Reply-To: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A subsequent patch will want to be able to extract the start of an
internal rt volume from the xfs_info output, so add the necessary lines
to _xfs_filter_mkfs to transform the output into bash variables.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/xfs b/common/xfs
index 98981e624ddade..318b1a3b245ae6 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1787,6 +1787,9 @@ _xfs_filter_mkfs()
 	}
 	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
 		print STDERR "rgcount=$1\nrgextents=$2\n";
+	}
+	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
+		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
 	}'
 }
 

