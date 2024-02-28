Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7763BBC5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142222; cv=none; b=tPGiUEEzRZxidMpeHzXN+iD8BGGvUayVg/2+Onb6dgpo9Y6gfz0zsNOpOaNMMgQpvTgMsj1AYCVWuFeib7IRiaoTtZFNOVbrHseyhhAigj5opsBfr5v2rO+xgq2ZIbK6Dlp6EmptBFYvRn7s4a4/CfU24onYieSOJwn2wTOdbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142222; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUIOfcTKfrUuiz9y1e4HJ+fn9/tqTNUEqheHH655w1Rrrn/4nHevZqol+86ikXYzCYySfxcTA2cGq4GNHb45bnFg5h9d9dOWF/k6dfv9ed9ooB9+zFE1iVVs99oGPG9kmG4qwB+uhDRLj0lKB8uwTRf70/nlBKHBoja5G3TxTdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Tpi0voT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Tpi0voT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3Tpi0voTQALLND8DOzx3khgWIz
	zF7Z6YkEEiwi6PSpRsCHSAqEtinpXXtOrjaSxrhZ/R+WWPGqd2yn4aRl5UKod+5eSRB0kKANJUN2r
	fcz7JyPFV9nh4F1dcGvawEF2HFzJ/vAGC9L20lPNGHS8rvPe3VOP7bcFam0Ui/dO4VeL7kS99W82O
	/qxMTsMAamSV6gxE9Zr3QpltD5pR5DOWBCLrwZ9NZNNCUpThVhuQoDoxgYjDECFSdG8WcczWfgIDB
	fwB2zHEJU1th/balFyJ1moqKW82tBfxq4kapgFwM26XV144CXcaZQNmKM61sNEvWfpFAKIiejm8kV
	EXLaK7vQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNy1-0000000AL8D-0N6L;
	Wed, 28 Feb 2024 17:43:41 +0000
Date: Wed, 28 Feb 2024 09:43:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: create subordinate scrub contexts for
 xchk_metadata_inode_subtype
Message-ID: <Zd9wzXjtUJGxwQyS@infradead.org>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
 <170900016108.940004.1763623118016244603.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900016108.940004.1763623118016244603.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
