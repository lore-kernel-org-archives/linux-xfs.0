Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9383537F1;
	Wed, 25 Mar 2026 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774426230; cv=none; b=W16kHnsAFlZSQ3sUrJ7hXQuF0Mic9EUrn3SMN55fjYn1Dlf//183/rjftUjlSbkYqLe44nMc6EOUWCNzYoGJceiRG/q+poEF7PN6bLNO1j8cAQgQKPZfVSGq5crbjnHLHNVJ/QAJ76tuwuOXCMpotks2Q3Vt8C0lNiUz7rMnBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774426230; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=km61U0dJCQ4ibrhFeQa7bTgPbS6wLxGGHjz3snXidtLQQqdeHIZwkG5ZUgFHh/adhtIoWbMT9E430hqIRpCdPRpxr0Vhw/3SalewjE/HwYeI4JjmlgRZzkNR0hfpnxUITHthiX0TCMcOzMkL7p/HmcMygIWT7sl3NL3j3jRb+8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD45E68D1F; Wed, 25 Mar 2026 09:10:26 +0100 (CET)
Date: Wed, 25 Mar 2026 09:10:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 22/25] xfs: check and repair the verity inode flag
 state
Message-ID: <20260325081026.GC2254@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-23-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-23-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

