Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F32580DE;
	Tue, 13 Jan 2026 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768320933; cv=none; b=pCtHWPwHKPNBBfuOU1fznE4ZdkWhob/R5lG5gsHWRWLsvpR8njT10h451oNG9B/Wd/dEFI0zTSS/ZOfNXFuaV0GgJcsrUShZ+3OVoSeVp1F52w8/IWlonlh0JIU+x3w4WBo9TxW3G5RKRsQJsZqNysgKo7j9R4fWUb4tKCEZOMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768320933; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5DxwLFpNAXIacsZZAtEv3Rpra8uEy0OyDjWs2dOClgy0GudhFd0XH5FBV0lIosAaC2h5nynNqLqZo+IG3BwJSF1LynLBLjorYGIVxuNDHTgIDTBRW4UieVb00cpLBggfTeFX+RVM2q4/4RU9YOYkVDYPjwPWyBPL/1JqaG1w4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71B5A67373; Tue, 13 Jan 2026 17:15:29 +0100 (CET)
Date: Tue, 13 Jan 2026 17:15:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: convey externally discovered fsdax media
 errors to the health monitor
Message-ID: <20260113161528.GA5025@lst.de>
References: <176826412644.3493441.536177954776056129.stgit@frogsfrogsfrogs> <176826412856.3493441.16878850364721175177.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176826412856.3493441.16878850364721175177.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

