Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C242669A;
	Fri, 11 Sep 2026 07:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110924; cv=none; b=tMw17JJgvkGRCIyfx2n3nM0OQBH9TOI7n1Xm0smb9ywPLP1saFpkHzTzlUDgUy8JVG9hV/KGvDgxRQhrRvWG25+PgX8Qc1O1ye4EB+fC5RfPNieWE423EWQXzNVdkQXETGGkU4b00EwTFfZs5E9D1XASfFJpirDivBvKfFNmui0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110924; c=relaxed/simple;
	bh=ho8RUefjsWsKtJuiZUziON0+LxRvJyaaaEjgkgpcBPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzeO4PO1B5wbkP5j0XC63bqRLqk/5mnjlhZPbG5pf3fodMDpPAFtZsYwrJnzlIDs/eSictvbqVWOwHcUP6sFMBj9cb2L6V2R1EGDRpeU0UmPD9R6xiYiOet30fFMsgsTlaBHFaxDHu5i/xngwBUr1q1JC9Ki2iZ31iWVSP39+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7223D68C7B; Fri, 11 Sep 2026 09:15:10 +0200 (CEST)
Date: Fri, 11 Sep 2026 09:15:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: use the correct reservations for
 rtrmap/refcount recovery
Message-ID: <20260911071510.GC16914@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162084.174887.6554307015098246037.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162084.174887.6554307015098246037.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 10, 2026 at 10:54:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we might reserve the wrong number of blocks for
> recovering rtrmap and rtrefcount updates after a crash.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

