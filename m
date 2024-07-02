Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FFD2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897796; cv=none; b=JCHG1XSn16w9W7gV9Td5SJfZn3MfbdXkA8e4NPXG52qxp46tSmCfiI7Hg29ey1TWfw8CYljPp5kEVwRtWE7qm2k79tQZPK/NwCGJP+JNFyJftgQhTkq4xuF77XRbKw2twZSn56X8s3RpUzjUanBgeco7KPVrUXt/ixlR9HujZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897796; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu7Jzx8JmmbALEBsyaUWSmHdDvgqqQDGKVnGu4Vqsq5XPA+pCS0gAUU5QYSoCdWZczLwFKL6nxryR+ujWx9vUSPq3lia3abyT3xFEDeISXuATDKVLx3sKKE+3KngTgaPHfT2UGXHYviLpF4/k2Ep3BMo3NsBFt/FrGwDQaPifL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E83FD68B05; Tue,  2 Jul 2024 07:23:11 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:23:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/13] xfs_scrub: hoist non-rendering character
 predicate
Message-ID: <20240702052311.GI22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117701.2007123.7758480825890362373.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117701.2007123.7758480825890362373.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

