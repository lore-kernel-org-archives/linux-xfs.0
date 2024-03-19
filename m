Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59B8120F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710858817; cv=none; b=OOsT+eeYZ+uLW4RhvQHdqMaLVbJuek/CUZixx/jTGCp1AemJCUMnwJolOXi5q3JT4KLrM77ZQnWdTmVUbJA8UdlxC6/0e0Z1tQF8xqaTl2G+DM2efoZbdRlpozf631YtRxvJHjl+HDT3tCk2mSuO9Pp6QMPcYMauk97EPNFVdkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710858817; c=relaxed/simple;
	bh=5cUAhp1hoSWvVqDCHxqVKqC1pLOP25+Syn9ZMIVrZdA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=J9YhxOS4aV0Kg7jygz0xfWitCbsVOpgcqugD8gj5FsCZuxT5oFhc+DaJSzjQWuplAd+cQ9r/+k0VoP/yQnpTsg9VSD3Gct2Q6bFywC/4052nSiVWXBDVDmQtvluydKiA+TykyfOJu4LDjrxH+GYePOQhTWe/o6+xtNqWWCVIT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXAMABuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXAMABuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7DBC43394;
	Tue, 19 Mar 2024 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710858816;
	bh=5cUAhp1hoSWvVqDCHxqVKqC1pLOP25+Syn9ZMIVrZdA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=LXAMABuU0JvFX6T/mJAjXXtabViaymLaiC0ETz1Lt1QbZmxp3kbl6rNpL5gOYtSf3
	 iKYqU8mTS3C1LPKQu0a6/PpGH3ELhR7gx/6a3nYs64/NVfsxfwBpn1+yOoaHSXs85X
	 Au1rW6bQ3Gq65w2fenkqmITt3z9FOSQcTW8IaYb256VRhYzrZ4pZ9pwpwlxz8/V1ni
	 /ltSFmnQSnE2J/pZOXOzd4PD8aSUhjVjGCJ4BseNYZxvXcEUP72uWcQzntCcybkPGX
	 2uXwmpQrcPipXWXnxcsviMNcI8SmQ3rgf5moJU8jdWrkD7CB5johqBTjZhK42ZcZrg
	 +COPpTkaN11Aw==
References: <20240319004639.3443383-1-david@fromorbit.com>
 <Zfkyk7b_gh7MLwBP@infradead.org>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: quota radix tree allocations need to be NOFS on
 insert
Date: Tue, 19 Mar 2024 20:02:59 +0530
In-reply-to: <Zfkyk7b_gh7MLwBP@infradead.org>
Message-ID: <87ttl2mguf.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Mar 18, 2024 at 11:37:07 PM -0700, Christoph Hellwig wrote:
> Didn't this just get merged into the for-next tree already?

Yes, This patch was merged into XFS's for-next branch on Monday.

-- 
Chandan
