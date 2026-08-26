Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA22D36C0DC
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 05:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787721196; cv=none; b=sWBMfFo0kzMp1qCz59yKGI4Dw+P6cHeqw9kC2P2aNkQrsHRif2aEWZoZXNTTIJkf5MIVX/vCoRb2FXum9ZzF363BIDU1mQY/+UJefZJg7hnAdI9Z/+hkxcH3g1s8VTrrJsGwNzBs3CT+JpvU18OxGT9gKU4aN7H8GSmGxMh1lJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787721196; c=relaxed/simple;
	bh=Evp2pV9WiCnwlKk/Eo8E8FwIbHId+gZFvbQeowGLB4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEakUyD3r552Z1X6NQqyQbtyMfTu4wq8oqsqx3GkPZ9aj4eFF28QFGuDgsr5mhwhqSN2fsrDCE4IBNEkJT6w+7DMKa9gkgL5m+9j4l9xTVlXxyOqCgaXt4VpSMjEU510I7lhOBl00hQOtnig4yMQauQaNiWk1LfeU/3aO3SDsqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C74868BFE; Wed, 26 Aug 2026 07:13:09 +0200 (CEST)
Date: Wed, 26 Aug 2026 07:13:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, bestswngs@gmail.com, brauner@kernel.org,
	cem@kernel.org, chuck.lever@oracle.com, cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn, djwong@kernel.org, gaoyingjie@uniontech.com,
	hch@lst.de, jiapenglin@tencent.com, roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: Re: [PATCH 00/21] xfsprogs: libxfs sync for v7.2
Message-ID: <20260826051309.GB15449@lst.de>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good modulo the cleanups Darrick suggested in the converted
non-libxfs code.

