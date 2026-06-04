Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA80E47F2F0
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 13:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780581307; cv=none; b=OMFfj3rjYvDWxfBRNa66j/70A4pEuNTIgJ1WgOiWGFJqseHscVz6VBIOJQ1Z6cQj9MQn0C+Us27lFzZRa02FmC8olzs/OizfmXDu42ET8QlgZ7zs1GXxdMoGoMyCaJYOrKvjJ+ousS4y8kTYMzpeh3BFv7IRkswygoiWD10P7VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780581307; c=relaxed/simple;
	bh=6HuNjtIpV9Ygv8lNyyuaUEc7Ye3L0PzwokggCAvgoCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6dL1+WomRaH1Dqn7Mz43gAL2XZ3KxDw22HtIPKbdlOahrCDfvEChCSBDDMupxCOQJOrtrYX/omSTNDu/GRrOc1ycKj8gYQt2cdZwnIVdMyK9gdkaLzzVh2oJlH5Azw3AFwOkYDktyLjkd4GpFhpAOj+8qhNQO6bpQzWGRg6SsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0FyUcA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0FyUcA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2921F00898;
	Thu,  4 Jun 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780581306;
	bh=c9KpXv51yYvu2deZ8gzP1kEHKxu+p+XTUs6gD9TGiMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k0FyUcA0lzPBNmgUgQN2RLMXAvjMFS6EZd1WCQEbXMYshUOFQPIGU8enD2TocRITu
	 U0Sg3wE6PQKWgGEPRYgqp4HXeCLTqFaYvaFdoNWIqSWaq7c80X6zHDqjWDamdQaF68
	 jbKbnBn5OChkfRoX+yI61pBzaLatZZQEDSygxN5ifTw5AUe5i/+oqDQtvyFTJy0+uj
	 9mlSC+HQJqHaR0MRHvXd75k1YJzzf2VJVu3fQYxh7TelhkGCGh44hn9eKaLm0SFGcL
	 QFfIrpqu8H360PkG8Io5We5eoWjh8TnnsnTS+gsAH0hJvSlWoMQpgFlcR4wZsgmV23
	 /gQAOcssf7Hvw==
Date: Thu, 4 Jun 2026 15:55:03 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/21] xfs_scrub: return SCRUB_RET_OPERROR if unicode
 collision detection fails to initialize
Message-ID: <aiGDqDPdeRjUj5iZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303312.2608728.7622814423707470375.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303312.2608728.7622814423707470375.stgit@frogsfrogsfrogs>

On 2026-06-03 23:07:11, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we can't initialize libicu, we should report that as an operational
> failure via exitcode instead of "success".  Codex found this one.
> 
> Cc: <linux-xfs@vger.kernel.org> # v5.11.0
> Fixes: ff8717e52b7364 ("xfs_scrub: load and unload libicu properly")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
