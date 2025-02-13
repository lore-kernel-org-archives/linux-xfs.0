Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FE92063D4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420437; cv=none; b=JT07MgQGUDH+rehsNTkTLI4kuwbyw9/LAtqWwFla8giucmvJmAaDeQ4fxH6UilnLHpgqVnZNUK/tVJPbt6ZNB5HUph4g0h9C/+eM+zCesNpa7tEDDz7FxrZahFqb/G4PeAdvQ1f1CfOV/P6SiT/KycoDTDWuLROiU7M5LW3+kmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420437; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTn/eHAQ92JLy+zWFCxwShGUwmC4LzQovXqkMmC3mM+8GsyWX1lO7TFLBfN6xPv+dfxjB5qHTlcPLR/o8yqrlmt/5Bhy1/wXR3UjVJfGMTmDYKiRyiiY9ya602gNk0lhSJJz5tKZhi9sA5Rm+Z1S8JOutOOpxsE0bbyPpeVcJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XapWh5JO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XapWh5JO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XapWh5JOYGhnm7hCsbU6RuuvOj
	brgZ3b6waYiMtqE/86gFAbSL9dXZk81O5jIaQGgSDYn6zedRefwiOkosH+s1OX8s77CvzBSe4F1Og
	9mYO1Pw9PbKoItwIwiQlO+uuVcJOA3p4IdxvNCkDEX1jRy3T3xFMy3uj9QyFgRVw1XAByDwEuJupF
	ADYIGtbPQLQoebQTxSN7mt1Qlcadn5TYFN96baL7bg/3K4upjBPnMaaB9cC4bejSJlZleRrZyNYjQ
	aGiaLgqlzNrDjdDaj2S6v8LQyvBxFDmySSMsmkDaWNfjSY99D7glVGrn8PDt3s/eQRs8mGO6rcOrh
	4Bx45sIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQiI-00000009hoj-1Tkz;
	Thu, 13 Feb 2025 04:20:34 +0000
Date: Wed, 12 Feb 2025 20:20:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/22] libxfs: compute the rt refcount btree maxlevels
 during initialization
Message-ID: <Z61zEjU6v49ZgiXL@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888088950.2741962.6915597562604311279.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088950.2741962.6915597562604311279.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

