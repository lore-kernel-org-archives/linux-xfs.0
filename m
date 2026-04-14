Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BF399006;
	Tue, 14 Apr 2026 08:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154417; cv=none; b=dlIRQBSVKkwM8SdP6F+9dw081rxaxixU9odYWfXp5pW7xWOmyxJGSPfVzklnTyMHA/ATlaq0n4Q4ONCdvauuK6ce3KCwSqir6QBM6d7Q8poL3IBHotCL/RlftKEKWpLwR+kxWCeNGsiErGxoAEeFH6Bk2qmrGQy8kfSK2C908s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154417; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRShZFL0fxkCXtjBxIFqRHccko9H0Ru3sFCfvM5k62HGgbcDpoVQFlEQVdWbY8flFuErB4CxSkxgl2WzPUAHmlAMwY8WQVhG1XGUIhL0YQrPslFsXhfrrnvvkzD1A/LWERW7WztePo2PsVKMoRYYEXDksPqJCVw6nLJ5IW5uoJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B72E868CFE; Tue, 14 Apr 2026 10:13:33 +0200 (CEST)
Date: Tue, 14 Apr 2026 10:13:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v7 07/22] iomap: introduce IOMAP_F_FSVERITY and teach
 writeback to handle fsverity
Message-ID: <20260414081333.GC11138@lst.de>
References: <20260409131404.1545834-1-aalbersh@kernel.org> <20260409131404.1545834-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409131404.1545834-8-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

