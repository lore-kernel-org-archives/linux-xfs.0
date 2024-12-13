Received: from pinero.vault24.org (pinero.vault24.org [69.164.212.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6155FB95
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 02:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.164.212.126
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734057094; cv=none; b=WtgiOs4AzfhfcH5COSqw1c8ObTAE+uWgxiANgKGYM2hfUT3p9aRncQAqCGxfLBeIRIB1nn4Nz5/6fYazojug/5ssrfTOyL/ofYsoFIhrA2a6iXEq146EDxoHhpNwIIZJ4CLiwxXpirb4tNDvzWP60kJNkciSXW9wLO19nP1bPws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734057094; c=relaxed/simple;
	bh=FBPgmwhdcRiYbsjCxT/Du5FBcC+yoBT+LgzUSoMJzCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzOcAclFfsK1lzpUBV1Q3TAOoe/keoF47miVIeD71fKOPOTRqLGMTo29lpddGGI5zPDx5XyXSyCXZ0GRoNZlNM0q9Y9Hsmy2pAxWnFfH2hEhD609fEWVdIQE+iwWW+wVOCdnsq0JszehklsZR4v/7byCbMrzIZSn4bfvw0wEifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vault24.org; spf=pass smtp.mailfrom=vault24.org; arc=none smtp.client-ip=69.164.212.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vault24.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vault24.org
Received: from feynman.vault24.org (unknown [IPv6:2601:40f:4000:c7d8::14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by pinero.vault24.org (Postfix) with ESMTPS id 090E260AF;
	Thu, 12 Dec 2024 21:22:30 -0500 (EST)
Received: by feynman.vault24.org (Postfix, from userid 1000)
	id 7C57069C4F; Thu, 12 Dec 2024 21:22:29 -0500 (EST)
Date: Thu, 12 Dec 2024 21:22:29 -0500
From: Jon DeVree <nuxi@vault24.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: grub-devel@gnu.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Marta Lewandowska <mlewando@redhat.com>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
Message-ID: <Z1uaZbUUptETLjWH@feynman.vault24.org>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>, grub-devel@gnu.org,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Marta Lewandowska <mlewando@redhat.com>,
	Andrey Albershteyn <aalbersh@redhat.com>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>

On Wed, Dec 04, 2024 at 07:50:28 -0600, Eric Sandeen wrote:
> When large extent counter / NREXT64 support was added to grub, it missed
> a couple of direct reads of nextents which need to be changed to the new
> NREXT64-aware helper as well. Without this, we'll have mis-reads of some
> directories with this feature enabled.
> 
> (The large extent counter fix likely raced on merge with
> 07318ee7e ("fs/xfs: Fix XFS directory extent parsing") which added the new
> direct nextents reads just prior, causing this issue.)
> 
> Fixes: aa7c1322671e ("fs/xfs: Add large extent counters incompat feature support")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Good catch.

Reviewed-by: Jon DeVree <nuxi@vault24.org>

-- 
Jon
Doge Wrangler
X(7): A program for managing terminal windows. See also screen(1) and tmux(1).
