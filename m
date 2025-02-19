Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20001B85D3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739942834; cv=none; b=b53dLbEGQyW+84CMcvRJvmMqni7lbyi4ak9S8Iltfn0a/NnwPrIUiAhb4OQR48hqj0pNiKjENRd1I4djpPMzUZ/cCa7AxM37DaTaiXRTk2oNf0lH5A2bmv7U4o2ByeyVQA58vAyB+u+xVNXHadu0KV0oruLxpn9v95ab5m2C/eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739942834; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qwwccd7mDCCSL2dvDP/rJPoHQorrg0Kqn73jOA1fG6wxJ8E6eUkryCZhxchT9JTKGotxVTedKoD0y5H4K2RgIVqpxxIQQYiHcmXfKv5Fwq72dXlG7/rnRIQes7Ie5/Bnh3jPD47dQAoFgt/Qc4cyliqxbFC4buMeY48247pAsLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E700667373; Wed, 19 Feb 2025 06:27:06 +0100 (CET)
Date: Wed, 19 Feb 2025 06:27:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 4/4] xfs_db: add command to copy directory trees
 out of filesystems
Message-ID: <20250219052706.GA10133@lst.de>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs> <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs> <20250218195818.GF21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218195818.GF21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

