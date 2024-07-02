Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70435282E1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898363; cv=none; b=qwB1vd+XH5YnY32tUzT+6/VvAMbX03h4GcFoWc4Bpfd1RTgvEL8okHXyZY3ArnMZGw1VPPbbN55gBQeJVx+sdoNgifrJKlVNa6BXtRPh+kdvn94GWMIhJJpbwWfWEdnu5Y8M8o3Q3n/jKGzdx5s2qoovx1IoFpEqXC56isfrGEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898363; c=relaxed/simple;
	bh=2gGcqNz5YJbkeC3KCsH6x6G8p+9aVTkUJFQ8evfCaLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3RI4FYLCoaE7oANbpkVSTXr4mdYMUe9KxKN0VQldPLdb4QZcUr2Q0bWtINpEwaphs81RiCGY0+HELZaQ5OTC25ofhEU+hlAIMUn2rCg0ODFNZHYmtywgWaP57KNxbIA0K+79lqL/mHLsv107K8k7869PgxCmC/gxOMOgFvLhHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04ADE68B05; Tue,  2 Jul 2024 07:32:39 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:32:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/7] libfrog: hoist free space histogram code
Message-ID: <20240702053238.GH22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118595.2007921.8810266640574883670.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118595.2007921.8810266640574883670.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +struct histent
> +{

The braces goes to the previous line for our normal coding style.

Also the naming with histend/histogram the naming seems a bit too
generic for something very block specific.  Should the naming be
adjusted a bit?

