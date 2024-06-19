Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0D04A1D;
	Wed, 19 Jun 2024 06:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777421; cv=none; b=bIqwJQ1iXpoTdGPGeaEoiZhVTd+16tXaqg8PIRoQwogszq+g4ky3NUpPXECpdObKpWq6tv051qF8mLv484GRhX3/0X5iyL66RdS9kfmXa0M9NkYzDduu5tdFJ2DRtnPYYkS6viisID1Dbv9WlYdnrGoY85asH3SAMZ8KK4PyrSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777421; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ouxd3ZurHLr4ovhRhZ24sQibrSiUkMBcw0JNyIKKeaxniVvryzCcl3aKTet45uuHRwc36AHSV6vV3KICYSPsuunb3A1KxjLFpdf1y/8vSTfG/FSw9nmh3+7qwmQB8B06Xluh7x006WdKl93NDhIj0LF1yIPrWDvIPEyLTpOB8v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OgWY+N+u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OgWY+N+u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OgWY+N+uT0iR3LD43P5xzbX0IU
	iU2vbyMOYCMmdNZ0RHaqNCM8/asIU6PSZcuo1EdfS5UiL7iiQ8N0JT+xA9y7QdiqZH6N5RQmZuFhA
	bCVrFLuShxEoP0jrYPb4/CQ+MhQOqr/WNWgAsd7I/p9RsI0DQhvpCEHRaRe0WYy6XAt51meD2kfj8
	S6zb1s9FiyBDlBTSLjTKfsu+4GqJoqx3c0OyeCjWPwuCvMJMkS0oIbPKIpR0RuPjQGGCHWxroP7cK
	S1q+KMOr3k50izrACY/RaubcGXQJ6kWH87+7lMvpEdH9VClW0yAOZxNr6szZAn6kJWgCKlpLUHpQn
	wyxu5pCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoWS-000000001Ax-25Td;
	Wed, 19 Jun 2024 06:10:20 +0000
Date: Tue, 18 Jun 2024 23:10:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] src/fiexchange.h: update XFS_IOC_EXCHANGE_RANGE
 definitions
Message-ID: <ZnJ2TEiMTS2ldUA3@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145405.793463.11941083120880917446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145405.793463.11941083120880917446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
