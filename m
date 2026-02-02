Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A4372B24;
	Mon,  2 Feb 2026 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043732; cv=none; b=aWlsxQOyu+SntlNn9ENZBRz9IaFR0JIAV70Hh6m5g4IkUA5uKBF7JZrWzcithiFzzykHwki+3XxFnD7AJe1WjVa1j49XUhrK4lYRAU48jo/cSq0oEwMLJkxzDWFUhEQkcu4cl559W4sDJA5M3Rjoac3mqVA3UPPnt20ouXSGbh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043732; c=relaxed/simple;
	bh=a0i1EGHJ53Cn36Ogm+2TKGDqjDbkwy8XN50DuccTGvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2CTqSIU+bClA+EePUzTa24QauGKfAk+/kd9gzM1/RLFIahjK3e5/5womJtctQ7z7oAZrZOTxhJQcEKtEWoCjt5Bt3npcMwo5bc+jZDG3qIiKhN/+7qaqbv2ymFfgU6s27hee+gQfc/JfbPtYHUuWVj3I34FBIGzwI/AamIRI8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ErlKDL1V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ErlKDL1V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5RfuoFuZfmU6d6xpKp+WWNjws0YGAx9f0t4UKjDQuJQ=; b=ErlKDL1VrxmApC+k1RGI4731b9
	g6U/J6ugzGmf7HqXFcuNK5qCOJENnJzyuTOS1Mki9v1pqhO5TX8C5prq32YkheUfq8pCRqK7KSkQb
	H0fYZ4DIs2hInp5X2AHqavTVWiHu6IW43MGbxhGEqHzj9iC+9VLxpVbKz7FjRAIplYorYhdao6b2X
	PPuHDys4lKDAmCyGejWfL2gJMn2gEr7sDXZ9geZ5iNmhhzzaEdLVVTW5CBAHu+/YE+U4lyg9nsFK4
	m0mtkzdMhOHCV1viHn5KEp4uWoaKPC9pVqCKQXuGLbESv272CJ7VSUsmJX8lifpx3GI1J2K7UvyVR
	IqUVKhAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmvEQ-00000005879-1moJ;
	Mon, 02 Feb 2026 14:48:50 +0000
Date: Mon, 2 Feb 2026 06:48:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Piyush Patle <piyushpatle228@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: handle iterator position advancing beyond current
 mapping
Message-ID: <aYC5Utav-rTKigTw@infradead.org>
References: <20260202130044.567989-1-piyushpatle228@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202130044.567989-1-piyushpatle228@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 02, 2026 at 06:30:44PM +0530, Piyush Patle wrote:
> Closes: https://syzkaller.appspot.com/bug?id=bd5ca596a01d01bfa083

This link doesn't work.  And the commit log has zero details of what's
happening either.

