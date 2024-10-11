Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DAE17543;
	Fri, 11 Oct 2024 01:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610984; cv=none; b=mWS/x56FFMGjpanLoTtEfsHwoDGIU6Ts5g621bpAqm1O37ThoZIsMEd6KCXH0hfkctFu4flPLTg4h3XMmGaJa5gYBlaFuNXwiS9WoInWqNyDHo6TaeJtwROXcvGCKnNfvTPFlKWPSgONTRk1YOhcHZKBjvjlppL0lwZ+9BWasMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610984; c=relaxed/simple;
	bh=NQy46sA3vGvd0gOWyN742K/wahVJMO+paEvNX5y73Vo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEPZFJbuiNDjwsKdJ0dx5GMnoG6LH53p5IoQHGowtt3irrN8ylke3eLUU50sdI211PNua4cak6XOoAomkJe2LAo6+mwekV2qbgKpABJZqjqbl+5enDs58p94jKlmVvGbVIIltF/L/Tw7hNWx/Yzb0GiyRch2dp0KT/HHmEyyIVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiJO/270; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiJO/270"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515F7C4CEC5;
	Fri, 11 Oct 2024 01:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610984;
	bh=NQy46sA3vGvd0gOWyN742K/wahVJMO+paEvNX5y73Vo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tiJO/270I2Yo5f87ZxVsmB60C995oqw7ytKIJdui4JfrR1pbxyfwR8dpEF38fjjO7
	 4kXcrRx1ipALKxkxEZ+MsN+EAx2r/YnGRj84NuZEDtIR2aWEYI0/jmxpX5iO3ebg2C
	 4BvVLeQ4V54gONKYff66cdmhJIaCMBa6ZAvBOD4qziu+oJj04Kiu/GVqVpVD/CAbhG
	 GQvYrVVf5v9FJrwhlsW/dnHB6wOb9AI0YjecqPSAkMRNtjIc/6EoontBfgwM+Lyt41
	 aqUmZAaZv3EF/ozRUV6Vq/DEb4maoyg9uC5b/C3EKeJYqDkbqkZ4KsnJTnhlGeMUMJ
	 U+6oTyObV5QDw==
Date: Thu, 10 Oct 2024 18:43:03 -0700
Subject: [PATCH 08/16] xfs/206: update mkfs filtering for rt groups feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658642.4188964.1452550069283841602.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

Filter out the new mkfs lines that show the rtgroup information, since
this test is heavily dependent on old mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

