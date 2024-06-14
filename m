Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A3F12F5A0
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 10:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718360058; cv=none; b=ijNBzy7z6cHbuerib74RVgKB8VfQt7oIrAb+6xwgtdEZZBevlMMcVmtUsHeKDiUfloOTxB+I6C9OF4HoQrkNj2F8cIgW6oJupUdu8nTCaNtpeCYrFK/QP1RlrivZC31RSDnixvkm/ML9oNrKDfO8oHD24gD1T/iWiYxRi20BP3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718360058; c=relaxed/simple;
	bh=Bul9s4a5x0zvHWcmiNUDUpkLH5sKJGvayWJnKhPUb6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vn+ZR65v0CJrKMJg0pTKvlT9K9BFCIgB4jrk4fK8U9K1jw6LsROoIqPT6ppi6MepMijbeDgHrXhVALzAnqEZ7bwAz0kBnyFQOtRiXCiVFLHEU/0pjZTRxqfXqqvR16XzvDxNmprqZ8o5+lT1jLC6SH7RnPDL/WrlgSkPxEZflo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4FK9Urdi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4FK9Urdi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d2vOn51pcjUGDnEmoPzO09OzV+Id4QwpubysZ1pl7lQ=; b=4FK9UrdiYdh7OaVRJKNUDboJxQ
	f7sUxCZf9cOC9XyguVqvDkYPcDwbzPoiHPC29Lbq+EoYlNh9kWbrHMlqhuegFe5o4DquwhslAYtVj
	2E1HZ2MXzyZ+gEaniDQ7N6GvjWJIoavoxw9kNAdb2Yy/pNLtb/DUR+FfPxuw6qDcTdkVKLWVkN0qH
	pvzDvuOzXd4SbQU+8JKJ+UEl56+raY/MbXNUKIbE50QFJNDARhLNpm02JE4Vf5FGJ72znYUh6i5PA
	IuPhiaUJWjXOTxGEyanPKXEtV/c300Axc/XzitBpcqvFeDv8lZWt5wE73nZzhsak3n29vS1o1Ou0a
	Gp1jDInw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sI3wl-00000002MmL-38jP;
	Fri, 14 Jun 2024 10:14:15 +0000
Date: Fri, 14 Jun 2024 03:14:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Message-ID: <ZmwX91xXpuvPnPh7@infradead.org>
References: <20240612225148.3989713-1-david@fromorbit.com>
 <87frtfx2al.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frtfx2al.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 14, 2024 at 03:31:23PM +0530, Chandan Babu R wrote:
> I am planning to include this patch for v6.11 rather than for v6.10 since -rc4
> is generally the last release candidate where we add new XFS fixes unless the
> bug fix is critical. Also, linux-next won't have new releases until June 30th
> i.e. the next linux-next release is on July 1st. Hence, we will miss out on
> testing/usage of XFS changes from the community.

It is "critical" in the sense of it fixes a long standing bug people
had to hack around for months with things like this:

http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=ea8d9cd0eb485c53eac01a3cf8524278381c31ee

it also is trivial in terms of code.  Not including it would be a
really strange decision.

