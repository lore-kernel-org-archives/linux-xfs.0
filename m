Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639A828136B;
	Tue, 22 Apr 2025 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330096; cv=none; b=SkRvoW0ERQJhZsLo2iVZsbj68BNecbAcr/srPF42zzdTLIeUmpjtYBFAXhFD5NdMiHFv2sw6Y0R6rGaXncpGUKsmJmhoRgF8iZagOg8uUwI4YId0qr+1PQ945MdoFUYrAva6N6kbXrYqJBcyCUZdjXdJJ70rbEm+C7reDqKZghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330096; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFra7NYEeJs9q3EqMZEHkUEfTBXxfvu5jfUad3fziuXNTY7hiaHdaQkBn3/pMJWzUSVxaDvZvj42ZHqy9eknukFi7Gm05oo+UX0h1/wMj2a0Z447gVpr/cAjvamAqju8CRUchjbCCzGNKL1mJ5fldjuAn7qn5546MXEcng1xD70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5440768C4E; Tue, 22 Apr 2025 15:54:48 +0200 (CEST)
Date: Tue, 22 Apr 2025 15:54:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, Hans.Holmberg@wdc.com,
	linux@roeck-us.net, linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
Message-ID: <20250422135448.GA23791@lst.de>
References: <20250422125501.1016384-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422125501.1016384-1-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

