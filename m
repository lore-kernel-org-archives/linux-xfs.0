Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98267C6EB;
	Thu, 20 Jun 2024 20:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917001; cv=none; b=io2UM46wAJjjUJ+vZ2DwpvczXRQpVlyENfT2fBj80DvsWvWgUKBqRs7bcDVbrjClJG9c2JRucBFFkidgZ0/KRnfFoNlU1s9XQ5DZUCODOEy+yI4nvtAuOtTOm/j05JacP6pkOKgefADukMO8xw5hqc/3vzRCDLjnYOYeKycNero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917001; c=relaxed/simple;
	bh=dOoi0cY8/v7xXf2xAIR78zv9owA7CiegGw+mnFiQ1pI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8bjTJzAsA+z8FhOIKVBBhk5/KNA9O2KiL+mSVqEtpvlFfFMXCu2lI68TjhTmCG4JGxuG/6FUHuRTcUFrfRfFKrKSz/9SuNZD76NZ8fbs6A+K6uMth06Oku/SBLRUu++8meShNH0Hg17tz0n3Z7cmdnrqPqn8X10+E5yp2b++eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DM2n+u35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DM2n+u35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82593C32781;
	Thu, 20 Jun 2024 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917000;
	bh=dOoi0cY8/v7xXf2xAIR78zv9owA7CiegGw+mnFiQ1pI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DM2n+u35gM2mGEv/5imDcW/U0M/uYtJr/Nio5hQOIF8/0fV9PTurZBgkXjmbbXHqw
	 5baEOR2hImfkgqJxNBcAd2G7p9Ba2rNLSqnm3Sgb9t3fr7egxpH3uIkwEdIGxiB8kY
	 vSJ20BZ1S+UEhRb/r4WcNvRhZTG5EjEhV1QrwA9S+oq9cFF8H2+v0z8kvWfF0lJu89
	 LA3tekB0DAlEeyKzdeliqOLgbpXBHz3XYlwGDAKgHkc0QSWld1UScbJ1JaYnefDAlb
	 tK93LSSZwI0ZlmtnGEF1G1XIbcNFBmpr+U7n5auJ1NmJQ0xHx+PB3UwTYLSwSrWlLT
	 F0IyEIf60kcIw==
Date: Thu, 20 Jun 2024 13:56:40 -0700
Subject: [PATCH 10/11] xfs/206: screen out exchange-range from golden output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669264.3034840.4662263364429761236.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

