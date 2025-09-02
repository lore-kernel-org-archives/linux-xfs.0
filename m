Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8232F747
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794434; cv=none; b=il62jQHCLGCb9aeCzrT5/y+FwZk934F53nOlwhDoC9ZpzC1VYR3lP8SvWUpSbk/W7em9jWGfR+8AL+tScY+QVShdVK/oJgoKv8wjq1Icq0MFH5b+N6SAkaALJzEcujF4EEtNsUkfCpSLKx2UG3P5w4hq3SBf/Qhc127730vsPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794434; c=relaxed/simple;
	bh=R3iMGvGsgRTy7nRFlxUrbH1VEsztPLljj73ugFPFhnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ssupe4nMz1kU+6IgL1xK+uR2WNWIkcJycD7kRDFGwPgsT7W2+VzxO5649NO8PLYQCFQZU/cFNZcb3nn7YbxqA5iKxlBEwUCbMZGqiX7hWly6YHRFsFZzRujPHf0lYLo82E/csn/1gTLhbisGgKbJnkIP8gxgrskS6ZEIp/qMdeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B5C168AA6; Tue,  2 Sep 2025 08:27:09 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:27:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: compute realtime device CoW staging extent
 reap limits dynamically
Message-ID: <20250902062709.GE12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126564.761138.12680157577981903157.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126564.761138.12680157577981903157.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 28, 2025 at 07:29:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Calculate the maximum number of CoW staging extents that can be reaped
> in a single transaction chain.  The rough calculation here is:
> 
> nr_extents = (logres - reservation used by any one step) /
> 		(space used by intents per extent)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

