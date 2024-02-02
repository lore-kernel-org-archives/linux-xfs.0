Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC49738DD4
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706856329; cv=none; b=YKyo9DYbAwPPFrbJjmWEcqx71AdcxrHYU55Bq/O9E9Gpeww+ojwgTjneWnsmVmOWaDbUWAWXzMWwAmRzvHbyeihMIlj+SbT4tNMNPWPOhqcmBItZljVllHLlX4EYoKyWYqkUXqVlVyj0btjbvDFzJavydzmwrqwtmjNILA6oyLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706856329; c=relaxed/simple;
	bh=vhJCxXtA0sqOfAvT2W57rYsKxmwP8X+oOheQGEF/y18=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=dz6+M1bppfc5n7hcFyJjslI6OJjwZ3oN83/6orw2kdPXah3beqZkukB/THwMqUISFKuCkkM5FnbEK9KkBfxahw+MSOw6VuNs3ZFSjw6X6EVWZHT1m1YCGj4kigDm5XuLGB+hOeCwzHiC1WC6dpxUAcLLTkB6IAH4Xfgh9OJjHPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: hch@lst.de
Cc: cem@kernel.org,linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/27] configure: don't check for mallinfo
In-Reply-To: <20240129073215.108519-24-hch@lst.de>
Date: Fri, 02 Feb 2024 06:44:31 +0000
Organization: Gentoo
Message-ID: <87cytfcqkd.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

musl doesn't support mallinfo* (as it's kind of nasty anyway - exposing
allocator internals), so this won't work there.
