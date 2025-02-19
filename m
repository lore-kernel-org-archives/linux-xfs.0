Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8C1C3C10;
	Wed, 19 Feb 2025 07:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950958; cv=none; b=KYHJMIOJfTBb8uaiILdkEXB2aIzu8VpyxufG02wURj1L32tMk2Jr3sjX/Sgtd9uZosoCY0jRvkaCJFndqVcFyLUeyT6AtQ49dqAKZI28XPBNQSj5OVelCao4L4vSZEk4/XyOyaDxHbxMrgdgGoz+kFKcMSlCUOd99a/5WOb0q6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950958; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAiUD3yloSU0pdRYM9cIrq2NLF5f19MOww8M88MVUxiHQr2q7NHdK/NzxG8sg0yKNr4VkHuQDDa17ACCfx8+43+fiOdke+0zgzvA6jA7jeSuAU01+AFAkrkRNhfs7PbSoKpsYdcA4woI9oX7p3umc++tfhJyx3yR67YaAuZO7DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=38xVvs26; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="38xVvs26"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=38xVvs26fRmXjzFyJGEuhlcr3C
	bht4MO44lf5+mcYASF2l2qhs3OX7XAlEvq5/Iy7XqVb3Ofc79qkI0toBBLCCoA289NjvsY1FL/6t2
	LhO+pZpZbw0A0fqc8FuJBP4jMp8wcqG+bXNXuIYct2iDrllth0DULeIAcwTkWILEOzkTGKUF2l3DX
	H8vfCSQ2u3lVsIsLrm0MUXZPqRVd6CKrx7qvWdlfxEP9Ui6Wvm1w2i5IRhthPHHJ1sx9ZGMLIB/+c
	lOoSnggjNpdqRXOzHm9c/AgRx/WPmEW7i7OJKFPXQmm7uK27bJvvqmf1gVQyT+vxqzrDEEYqciOoT
	OMtG7KHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkej7-0000000BJUQ-03At;
	Wed, 19 Feb 2025 07:42:37 +0000
Date: Tue, 18 Feb 2025 23:42:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs/27[24]: adapt for checking files on the realtime
 volume
Message-ID: <Z7WLbIa8VoJMS_FK@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591808.4081089.9156294813216623549.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591808.4081089.9156294813216623549.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

