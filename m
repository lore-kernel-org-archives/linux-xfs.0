Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312105916B
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706520351; cv=none; b=IjiymNm3yxlse2HAizybuVHR+hAgKmbZUzuSfZnAzD8ooTlErfTRlA8cqSxGyMUqYxfjSfPYm7TH7Eq6eQSDaQqqDM/cb9kwNIfOS2hK7wWaTEGjckvNyqxxAVwkfEbUzBk0OmsLxaM9NzqgyOsAP9/SKrtkg7nQEvVshpJkHYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706520351; c=relaxed/simple;
	bh=lLBH8b6kx0zEsUF5vuXO6XCVa8fi4FtouT8xq+etZBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dV12UJBH9xLb/gekrGxdTHU65t2l/Px17IKZI6XnqwtuaaKiVjlkP4jrKj9tgJ29sz+hHyu4jg7TNEYfHQa2eJq/oHqMfuhhn9WpNCPGLS0+QZV7/s3qpKMyVzGZjEAhLA47zp1WhfhK+i7qrWJiCQxIxQ3z3oiwC67TL/fIogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=sbtpjHZ3; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="sbtpjHZ3"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4TNjZx3Fz3z9sXk;
	Mon, 29 Jan 2024 10:25:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1706520345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iWtwJ3he0md4JvfBmPGuqlkTsrWbACZhGHmn9JVPuR0=;
	b=sbtpjHZ3EV58rR41BEFswt/fNn8/CA0SlH4dnsEo+jRjXB/95nM5o10epEvxVvPWDENHMm
	GtFLzetuZNkgk92mz9FnBzMQtFRIdFkIqhkigt37ndm+6842Z7g0MTCz1KJkaEq/qtvyHx
	xir2cyJwdu5xlYIKaigL656bImtDSZE2uXrhR+X+b+fIGUnpGVDGo1LoxcSxsBikxKHy9F
	g1/LX6bL1SvBMiVBLvHHbg/DizfzwtQ1B6OcW4sfivjpeR4Wm5MIn7ucgh3kURtdVjNbJP
	KcUZa25wNfM/8HQApQ4aQb05c23FjpYPvIVR4uPGavdijbHy7r0HPAkwsflrSg==
Date: Mon, 29 Jan 2024 10:25:42 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, p.raghav@samsung.com
Subject: Re: [PATCH 5/5] mkfs: use a sensible log sector size default
Message-ID: <zqvg32xuem2c3kz7o5gdoewfyoyhcpwbdh2dgw2zbp4hkbqta6@7b6x4qnujz2e>
References: <20240117173312.868103-1-hch@lst.de>
 <20240117173312.868103-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117173312.868103-6-hch@lst.de>
X-Rspamd-Queue-Id: 4TNjZx3Fz3z9sXk

On Wed, Jan 17, 2024 at 06:33:12PM +0100, Christoph Hellwig wrote:
> Currently the XFS log sector size defaults to the 512 bytes unless
> explicitly overriden.  Default to the device logical block size queried
> by get_topology instead.  If that is also 512 nothing changes, and if
> the device logical block size is larger this prevents a mkfs failure
> because the libxfs buffer cache blows up and as we obviously can't
> use a smaller than hardware supported sector size.  This fixes xfs/157
> with a 4k block size device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
I tested out this patch, and it indeeds fixes xfs/157 for 4k device logical
block size.

Tested-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj Raghav
