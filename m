Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E01478C67
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898914; cv=none; b=pXOQ7G3YQJIntZcB+645MYV9dJ/t4YUCwD0mkItJm16D0wOmmuocjtk8VW49vr3/RAbheyddwccOaUxcOzUmdmsMa9JWiX8YmOfZs2Ra3yKaLlb2JK1gAvo5oF4TzOS5BzDll6qRD1oZjAEVkETBOicZpAAB2iMdNnDzXcIPwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898914; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3IK0Xpe4wnV3NkoFEo0gZLpsX1XmjyIBTYrCFn1Kk3pYUlJzpJaS7YfMPekOt7U9PXfkZuEVYjcOqMgHFchTNRV6JsyOixxVzc8j18RsVDo73rzvlyMPa8+nZM76Fj6hd2Pv3RATgiuA2Q07uDUxyLxluGdmtTndiTx+sBeiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A08368B05; Tue,  2 Jul 2024 07:41:50 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:41:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/5] xfs_scrub_all: encapsulate all the systemctl code
 in an object
Message-ID: <20240702054150.GB23338@lst.de>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs> <171988119844.2008718.7103597112377556797.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119844.2008718.7103597112377556797.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

