Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E66A747F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jul 2024 05:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070584; cv=none; b=EL5bwjtKsyND0M2wijEVp1ChEJosyfZqkvUbOcFJ4EMrHmsi3EctL/c42a/O26fbX6ulrVvotqkHJFMJ7jHxRGe54TkDmzlthW62VrxB6QaU0rsRIrWgCGrojzeoezaimErIElqDSOogI8q4mEFGRhH+1FIRoBhbR/mdF5ORt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070584; c=relaxed/simple;
	bh=peVZDXlcJ/sFCApDoMXKApoaiEx/0m3sPWy5caJ0uc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3xImCb+N+xnGbX5az6UdPcVC94SB199e11QYsmohdTPdqD1qXsX6JovWumSD318rnuG7YllX0vIqqBgz9givLkFiOhKZz8ccfTPxCysJyoU4IIn04rnNPlGoFX+93+vjHvfrm7C+3+fLA8Sez7fItL+rzZDtktkqagu2rPXWz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 490A768AFE; Thu,  4 Jul 2024 07:23:00 +0200 (CEST)
Date: Thu, 4 Jul 2024 07:22:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: hoist free space histogram code
Message-ID: <20240704052259.GC19637@lst.de>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs> <172004320027.3392477.14495882444654849509.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172004320027.3392477.14495882444654849509.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +struct histbucket
> +{

This still use the non-standard brace placement.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
