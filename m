Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF53016F7
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 06:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009367; cv=none; b=cnYW503OPXR7SYUz7Hf+opY/caesJyT1efp1WzR8RsgM6/VgaLMcny/j/chZ+DvuICCemYN/KpMfkDlImq91nX8zbsMVF1ddlQIP7PFilMjPO3iygw8vcxRPwC6e75VmKIN8WJp9TNY9RgVUwfwqBvkIDdc28/dsx+p2ieRyK+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009367; c=relaxed/simple;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUw89v8KusZ4EGL+eYaqnNKj4ugNmvkaica4o0V0Sgl7u3iS3H9c7MgWSkz8PeAsXViOProwQI5BIcvxOSQKcpMUbaoJrKGmU+mjSVcmRepAmyz/bg9AbEEDXYV7v6rJbUTcp3kJjv1DrJWL5bZtrdrJVqXNuiugQc1xhgKFCME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F203568BFE; Tue, 14 Jul 2026 08:09:21 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:09:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: resample the data fork mapping after cycling ILOCK
Message-ID: <20260714060921.GA1072@lst.de>
References: <20260714060344.GA7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714060344.GA7380@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
