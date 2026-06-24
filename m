Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F67256C8B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324997; cv=none; b=RiufYnGqUiwzVyuk/ErxIWH6UpAz8fr+4Yy0AFbEjgRI7lFakHccgz2gt4d9rIhhR8BOIHpzV39gwBJkm8snvG0VGub4f4l/AHx1eaRY9H4pc1B/Orv9iO1KOGp1W/a12j67iRW1mjvXnUy0mndJIj9R9HN6W07gdTazm47MtiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324997; c=relaxed/simple;
	bh=dZz+wphicOYa9YqSAe4NR6lFr/N+lod6m+ILLpFJ7WI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zt0oQEFOaRinpW7Op92+R8iK75oLRfp0gk+Dwz3478xY5LpjV6lD1Eivxjgh/CWAzE5Iza9Vtk1siaTPet8ifYU+JVg4oc001cqKYt7J9YTPijsuXbA6RnZmW0GnKYmj6yqBpEHeMyNICMikjWwhPQYKc1pVLEoKa7mK1rLWGkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/gSJLgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/gSJLgB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5A0C1F000E9;
	Wed, 24 Jun 2026 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324995;
	bh=5ok5zpQOSGAC5XyoNAvsF8lL/TkyFGeYKEnmbAc8RnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Z/gSJLgBpp1l+3OciqjuoNnS1/Sn0fFlxd0x4/YdYDUyIpLPOGE7GoLlTmsveQNNW
	 U8NvrU9z0/LIXNIwI8ZZ4Z8JuZmooNLUfHOjuc7+f+YoYLp0YTdJlQ8rNFw+w9S2/u
	 wBzIeQZesCEDUhFPfbWfuPlpjyx+6RbG65dx2lF9GM9HiG5HJox8mopBFpfQQjaq03
	 1coaiK990mGAfAwlTwxhT3mAVDMca38eZ+gSIrgG9zX42PPdAEwBQp71eHHN69X4iy
	 FYI2olqn072oFgHcfx8l8L4Y4wqZWcWdFd/qHQ1+psLcWTRT2Y31ACHGlfrmT2PiKc
	 ELEFHJt3gwfcw==
Date: Wed, 24 Jun 2026 11:16:35 -0700
Subject: [PATCH 08/11] xfs_scrub: account only data extent tail after an
 overlap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484586.915780.6556520830869742008.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that the fsmap overlap handling in phase7 isn't quite
right -- if we already saw part of the current fsmapping, we should
*subtract* the overlap, not set the length to it!  Fix that.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 698c6c7cb8ba75 ("xfs_scrub: check summary counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 3b765931a304a9..4a25c521fa0c76 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -127,7 +127,7 @@ count_block_summary(
 		if (counts->next_phys >= fsmap->fmr_physical + len)
 			return 0;
 		else if (counts->next_phys > fsmap->fmr_physical)
-			len = counts->next_phys - fsmap->fmr_physical;
+			len -= counts->next_phys - fsmap->fmr_physical;
 		counts->dbytes += len;
 		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
 		break;

