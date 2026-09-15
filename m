Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8381A3AE6E2;
	Tue, 15 Sep 2026 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453873; cv=none; b=l4EEgmXP6VzeqGWwdPX+KYJfs7mYk/zdamoYHK2CXjg4KqVqxIivSs6L0TaTQGSkQppyIFfAAfngvniM6+6HWa2IvO6dCqkskJOmWd7Xii5O2fSQox3IM4t7OAJSQQjTHCAhJjnpeQ/eYe3pdX/7iAtAmvVJPgBt4usxVI5ccOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453873; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdbVvOsWOsBV7cp1KQZZIgv4/qCrUjlMQPYXG5DZdzWYI9FWNd4DbdVxDgDbKtA30eD8GlfaFEhchD2s8CLf0n2S7pL68Wq0bYNcbutU3gb7iC7D2hPJ0fHtZyAzcI3lApfyBzX6HHB+1mA2CtyrNTWYqM5LUCCjtw2MZSeCY/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xieu9GjV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xieu9GjV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Xieu9GjVgfrisJXdzB3bJL96XW
	LSgcGu/kkhA4V8A84ViLghSVwdQkcwPalPV38r7tdxVIToVfl1AjurG/Arjr5vhDlMDZKMaosMBqf
	AHNUUGIvu3nF2sJs6Z5DH1LKkhd+HjkFmSNCFjxYgmbHCcmd8IFhG9UUoHr7vmpq743hFxZMq6wvL
	Hups6TQ0bX3Yj70yir+H1gndrUNluaIV+hHfeXJgt0cQmAloxPgjdZxthxkID7Gn/5M9ky23c631H
	sUNzy1QDaC4/VGVJbt+TDV6RBFvKNh0w52QCevnIUn/Po6qtP6VeokaE0bEhoblN4HnlKMUmsiIUA
	rmA/n/xA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6Mh5-00000005LcQ-17PF;
	Tue, 15 Sep 2026 06:31:03 +0000
Date: Mon, 14 Sep 2026 23:31:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: fix blockgc group quota scanning when
 usrquota isn't enforced
Message-ID: <aqjmJ8cqjHuI6wJi@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048648.3061055.15354036415153320075.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048648.3061055.15354036415153320075.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

