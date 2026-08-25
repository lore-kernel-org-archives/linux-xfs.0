Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC1424A06D;
	Tue, 25 Aug 2026 06:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639597; cv=none; b=tgoMIF7WB8OlKsYnX/SKN39rsntRz2sFtBYhKfZZ6h3JIe4R1WwTPZrhWhQ3VgjUYp1E5Ui1sRe9x2rb2ZVV3DK5NnYlsmvupHQCyC9I56QMjktb0+rXjLXiLqq6SoK3LfzAScZcezfBVlE8+tqCinIQfueZ7NWOMmYmSpPQE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639597; c=relaxed/simple;
	bh=TgbQG/tL9zjJz49fG5+m6IxFeh6WyM0fDMcPpsNnUxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POkPXMcOHvzJFH7jWfsjPgRjnCFM7SAMwBTb9WrrAuiCpSM02v//2p1+3wZEd3UbCpmP+3cWzTLytWcdkksD48toRgBsnWo+893m79bLkz38gxnb/m3mRKqtqL5tiO+5tfe6p3cHAD9Phv9Epj8lKyQubGwrgOzbqDtR/hU1UNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C0C8068BFE; Tue, 25 Aug 2026 08:33:12 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:33:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lock the healthmon when inserting unmount
 event
Message-ID: <20260825063312.GF24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940804.944084.12785441907263638942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940804.944084.12785441907263638942.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:35:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that xfs_healthmon_unmount does an unlocked insert of
> the unmount event into the health monitor's event list.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you also add a lockdep_assert_held to __xfs_healthmon_insert?

