Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E00B79D1;
	Tue, 18 Jun 2024 00:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671747; cv=none; b=KRFVLrr2AfY/UqClc+GwakTbJjgtr2+W8BBWVG9/0BSjkPxRsFtWryi/xDKU31QjZoaj00qw5T0PGTXJdLEiHW3RnZ4rG76Xu2RM+eSE7NDjwafC1LB6iInHtkAh/0bHtddOUzYdL+Da9GBbowRr+gSiCTFSkAa2384UlOxLvGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671747; c=relaxed/simple;
	bh=ZpgrX+wV3Ey9ZLqfyhRuSMp4PABw3ImqatSnG0tJJ5g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JyJDNK3i9KTkBGbM4IK1iTZzNFMQ/Q5jSxiT8fky3jzXNFS1DjpMmzcJId16Uh6XeJYG4LWyv+pO8COPB+LWWkrMQ0MfKdQkzPKxugvvKgPyLB/MGVClT04mZG4lWS6kCRatKNg7oeCZr7NsN23waxJbwt+1HDvLBmtCNNaEMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urbRfXFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urbRfXFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C464DC2BD10;
	Tue, 18 Jun 2024 00:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671746;
	bh=ZpgrX+wV3Ey9ZLqfyhRuSMp4PABw3ImqatSnG0tJJ5g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=urbRfXFMWM9NYT+gf/ko5Hwk5L3KQXQSbHD2hMm6twRP7guzPD1p1dcwliFnp/5kb
	 PQ4e/cUkkE53FTQINSzr+fb6Kdbdpu/EbMSmSOrRvIpuN7lx9PUh9QHMKTF68IFRPK
	 blD9Ed2PSuHSjBaeCzRD08OuxJibnrqQB6D94Fd5V7YqFX2nO5rS3UePWxXyFgeivg
	 sz2+xayjCkdQ9OgOz+QwGbjtgaxOBVB+EECYmW0BaYIcY3x81da/HZjP+UoYikFTb6
	 xWQNVsCpgZPslovCM5S/5ANuRekGqzubyvWk4+bAIsLoflTi3+zT2dk05kyxDk2KN8
	 2ry5xdjlZ/qoA==
Date: Mon, 17 Jun 2024 17:49:06 -0700
Subject: [PATCH 09/10] xfs/206: screen out exchange-range from golden output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145436.793463.8960807127589028072.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
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

Fix this so that exchange-range doesn't trigger test failures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6dc9..f973980eb2 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -64,6 +64,7 @@ mkfs_filter()
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
+	    -e "/exchange=/d" \
 	    -e "/^Default configuration/d"
 }
 

