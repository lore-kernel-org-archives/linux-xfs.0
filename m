Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A81C1F04;
	Wed, 19 Feb 2025 07:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949282; cv=none; b=o4PzTkIar0tniago/dk9WmNO4vGEp58MXYblw1Tgyr3FHimU3L2KlKe+Fice1N/QHszkL00ahZ6fXR954f/hCyKuVjXHW4kcXPTS0FueEvyJf4KOgbEoT633Ct9JC0KXvA/nNAPKJJ1ugYCs8TFFyHdztqxORAQ+z3MzgmWJqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949282; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCkCSkC3cZMiYkKIVJdgJzgpP41RzsGeNclAPPckLDj5PYVuLp38ZAzpR9x3Pn/OqyzowneY8HNz3HAUrfGPlK8g7UX+KgMfHS8nrKQloufKZZhRs5zy6f+hTA7zmr8HWapPl/JjQmoFGvVHAErZuvW9hETNW5hemeAgRjehKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BMWuiFzK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BMWuiFzK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BMWuiFzKUhTk9805Ulfk2XmAgj
	VMIN/4gT/yN9fqRKA8rJt7W2XhYAHZFcho5ssOBsuyagL5FotSAXtfei/fPhq78IeEdsr7hAD/mP+
	+ryugbnhM++1J+6Uie3FO+4yi53b7Q5/LnTmsrLBaAhkfgueto/8H7jqFeJB+4PejYw8pSQi8EsnB
	noLGP2cQOzOh0yGXlKecxuvAV0sc0R0yDzSn76gCl8SpH5k22j6r7uAxX+CIaCFx047tkU8zn3t2l
	F60tcAMkizWLfRShx6gtqUVQPqE2WQbjdW7ytkWaLfH12ab34cYyV+4DLTfn0OsKod7mo3tQdq5Cs
	m9A9e7Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeI5-0000000BBWs-0I28;
	Wed, 19 Feb 2025 07:14:41 +0000
Date: Tue, 18 Feb 2025 23:14:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/15] common/populate: use metadump v2 format by default
 for fs metadata snapshots
Message-ID: <Z7WE4TCJw74EOEIG@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589290.4079457.11127255945217928255.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589290.4079457.11127255945217928255.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

