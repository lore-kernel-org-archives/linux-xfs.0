Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B057F142E7C;
	Tue, 19 Nov 2024 05:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995260; cv=none; b=H44G59713qyw7o6j11N+7xlk8Xrl6Q0F3ehTwI9xEUg0jThB0HuFLdcubZZzLmwt3uh9Gr/KUq1d2sPq2BcCMfRgbN1Pp5k9NxCPchu3gQbE3ZWk9Qlgq/E/HApuAsOQLyumYGRmjTqSYIzikZDZMgbmD5kl8lMpLEWypdThrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995260; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fam6HT6h53gMMSmL7o4ptr75LR570SXld+/w2XMHi9WX5P0m0K/FyjAzwJiyJ0AJAH6aYj9cIsj4HdyIDRQUxCwzLo2bxNww51iNKi5GlrZCz79wu2moR6Lwn65CC4nY0TUhGPLQ5PANFlvTbxXBY1+ZglZm9IiW4RMtoYhtczc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CvmgzkPb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CvmgzkPb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CvmgzkPb58/HDIqFkA3ZsUcLhh
	dGpjl3TUYUN7+AF92TX8aZIafQN2+PT7dLu1UKAKEplO1Wa2S0MDJ7mEevNQTjKstNz7xNK3tmQeN
	ou0FyJVkbtK7VSORj5UcjYk1sqI943qZyLw7pgBqvLF4HvpTJ1LIeabGcQQ2yq8UXq9yLM13lYwex
	vMuJxCrsBUuVNTcB0XvKByCrSDYxAwXCo9aJOWn8q9sFtMtVJ2w0nVnySlmEE5Bd+dPWELzMmH9An
	jpOHxrfyJGjc4gc1xV62azjf5tVXhm345LEwiEhDnik5IZmLDqXQjUBwc8GirPWDzY5QXIW8cSBO/
	OYNuQ0wQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH5P-0000000BSGZ-11ZG;
	Tue, 19 Nov 2024 05:47:39 +0000
Date: Mon, 18 Nov 2024 21:47:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly
 when zapping a symlink
Message-ID: <ZzwmexKnYi76Om_9@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084532.911325.5157952313128832887.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084532.911325.5157952313128832887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

