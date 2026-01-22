Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312736C590;
	Thu, 22 Jan 2026 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061846; cv=none; b=S57/aBIdP8NNGTAN/D0Txj2uenMqaIjDeu5yuubyKYUoVtQWOeBpWFxTzxfIpdnUpjMrVBqTC0iIiWc7jfv2h42waISr7xTMCsDZOqNJumRV8iUlBsAjBoTUQ64/1INtKFdoTq87xQpUoJytVjVlBlEpHCjr5Z8QUItCiiFNrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061846; c=relaxed/simple;
	bh=qL/6fhBAIeZg7aAiyzwJ0h1lBqVBWusJUvD+4Ey7hsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOGlUcQ0MBSpYmnY56IOIV1g+7CSMSwWaP6jZWqnlCjHTBJYZe0cL3ploVCV3R5uFNlLP77zgYZjAM/MpjFLXPnHerEMmRze8GIgqRWLt48PPf2sPTFnemIjXS2A5FQr6iBsbZvS+krtdFkfiJ/kpoIDQ8A0Ry9CFUtA0sdLOWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DA21227AA8; Thu, 22 Jan 2026 07:04:01 +0100 (CET)
Date: Thu, 22 Jan 2026 07:04:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to
 bio_iov_iter_bounce
Message-ID: <20260122060400.GD24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-8-hch@lst.de> <20260122010440.GT5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122010440.GT5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 05:04:40PM -0800, Darrick J. Wong wrote:
> >  	if (dio->flags & IOMAP_DIO_BOUNCE)
> > -		ret = bio_iov_iter_bounce(bio, dio->submit.iter);
> > +		ret = bio_iov_iter_bounce(bio, dio->submit.iter, UINT_MAX);
> 
> Nitpicking here, but shouldn't this be SIZE_MAX?

bi_size can't store more than UINT_MAX, so I think this is correct.

