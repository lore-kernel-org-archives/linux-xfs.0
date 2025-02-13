Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49582054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420646; cv=none; b=fZBGJss9E8cRh8QNXNJZ/qTJ0IQiW4Zx+QVvqbxAkuAaVxf71liNHT1RgRs3qUir0iYE4ZsbQn3e16pU2zpOMDsrIxTNUC+a1erKbYWoYJy0xrOeyM1UJw7krN7RNKlBJcUAMPM20Qkrbpt4IbNsBYY/3ShBWKI06MHb6AnXfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420646; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWa9R73tzNdcCKomhPKE6qwyay7H+7TMM0wYsgtQQvuKyF7kTOz8rEgzvPaP1CPcCmrHLiiKj9gf/rDtUXsChnGl4zfc1UJqJCboENBuYwCizdlLgssnDDZrNI2BVAjf9rAUqIBRNtulYq55ewY5FdQ1d+clSWeX/ZqKpL72PL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QHZuaUqe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHZuaUqe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QHZuaUqexuZVLEtv07LbQvRbzu
	6S0SJLpZLh5O03KySFMGwuxsh/n19WA7sjb2q0Am9nGpmVV4yJUVrjalnZZoJJDRQLydk59w3WDuJ
	Vix6d195b9gw6/Y0uVxIu+VOdyaPyFK5AoPCHBmteGOwZSwfj/dyCBrtS8GbZAs9XWUzenYrwwhVv
	brl1ndSTg836XjjhARx9LT8Q0QAkL5zt3bPddDeZDnYH83sJIJvNHMU3SdjaeQZMBsFj3npZa6mT8
	qGZ5ggRswnsQSKBGRJTwlic31nmvqtjLBAUTdU9JHftbEhv+4gGQwvPX8Jnh1kxMlSFiqazv3OOOr
	ilueyGsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQlh-00000009i6Z-1GRn;
	Thu, 13 Feb 2025 04:24:05 +0000
Date: Wed, 12 Feb 2025 20:24:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/22] xfs_spaceman: report health of the realtime
 refcount btree
Message-ID: <Z61z5crhpaS6y4DV@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089085.2741962.7445820399757044454.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089085.2741962.7445820399757044454.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

