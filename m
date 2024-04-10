Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A837116D30E;
	Wed, 10 Apr 2024 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760713; cv=none; b=pdWScvjZ9pdNY5a3AYpbAWrWGenL7siHLxbr6gr2l9YnmmFF40iC2oJNMYf9gBuR03OHcwx9Pynw5oUMP/RLibUmpjmsQZxS2WvYBEMwVQQVOfin8EWsdepC3z5FI4r1B8B/jDLXQUq/pAaDUvY65vur2moWudeD+rDxK9mVTY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760713; c=relaxed/simple;
	bh=2TTiyqRj84QSocdvRq9HmkJlDICdj1fIVOL35a898Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRo9/qOxCdxHmc1eAASLjhYm9K9C7nAEDnMyePr009zNGYQ00c/p0PFPCr27ltMpL03+UxpECAX8+uklmB2VBD3VlzaxSYtwZ/e3nd35uR13K2B7CVpD0YNfW8qrK8kj1S2Y1nxBNYLQYzufD3X4lf9h4yv41hmIHSYcQGVcC1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D632868BEB; Wed, 10 Apr 2024 16:51:40 +0200 (CEST)
Date: Wed, 10 Apr 2024 16:51:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410145140.GA8219@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240408145939.GA26949@lst.de> <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 10, 2024 at 10:42:54PM +0800, Zorro Lang wrote:
> But as the review points from XFS list, looks like the patch 4/6 is better
> to not be merged, and the patch 6/6 need further changes? So I'll look forward
> the V2, to take more actions.

Maybe you can take 1-3 and 5 for now and I'll rework the others?

