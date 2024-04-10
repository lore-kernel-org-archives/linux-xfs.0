Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B6BE5A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712721766; cv=none; b=u99EVWIBDpFNTP8T8gY38b/96JKvFywdOPlaUNHMUemTElRkLCaHw2F7vbIKQNl1MfhoscxDmSlWRCwJNRMH12n50WA/4cwdn4ZfKyjNL0K0oRhaDxsUIfwLL3Buh70aWd7z0mmgvfllgtWgdJxfUnMYRS3NirCF5ZfKp3cXS48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712721766; c=relaxed/simple;
	bh=RwZ8FuA777rL9T24wje6idN5r97ibPN99/7NUVkmaLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8OBOLDujPmUOwMDKFgqgBUiRVVj/KPyPpmT3BgRvPcf/Kh0s642mXTih+7Ayxv6QRBhXXuvykVmdGMM1i90SRIOEfvG2IMFcslytHzCU5M2ziaz0JahA0ukw8+ugFaRk0K2BbAX53uw/2FBZdAP+pSwE6/Klp3Y3zMf6WQdjHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C37268B05; Wed, 10 Apr 2024 06:02:41 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:02:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/8] xfs: fix error returns from xfs_bmapi_write
Message-ID: <20240410040240.GB1883@lst.de>
References: <20240408145454.718047-1-hch@lst.de> <20240408145454.718047-2-hch@lst.de> <20240409231917.GP6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409231917.GP6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 04:19:17PM -0700, Darrick J. Wong wrote:
> Hmm.  So I think the answer to my questions earlier is that with the
> series applied, ENOSR should never leak out because bmapi_write calls
> will always do the piece that the caller asked for, right?

Almost.  With the whole series ENOSR goes away again (but then again
I'm a bit skeptical if it opens new unknown cans of worms, see the
cover letter).

With just this patch it will leak to user space if we ever hit a case
where we completely mishandled this error before.  Which we've not
observed, but which isn't entirely impossible.

