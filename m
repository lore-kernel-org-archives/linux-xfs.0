Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46A37C106
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788362934; cv=none; b=Td/9PV1S1T1SWqm9bq7MBpR+SBkgOjk6mEZ0hPVtowzsiVa3QhVdd5sfd1a4tHGaDKClFmEckz+ppmrA9T9z7T/Th9bfYqcwAACe2U2w16OSLCeDduKeLywOL5KtRFGYYbHBU1nJ0ZFfBYi/uxg8HNUXIrz1Wu/nzAW/ZOwx+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788362934; c=relaxed/simple;
	bh=Gjw3OlnRI0kp/7q96aQGN3v2K8/oQKaeiW9oVhtb+kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZva6fxXWvBQzGGSg/clN1v60FuXbxKF9QX8bgHD9TlZ+CO91l2TKQvI2z9Sd5IzpDSbV0MOgsyJCUyUIIAB5ewXUwHCd91g7odkwBe3NQK69kTObzYwRz+wlpZkMCzKAkAdDCWd0GsJIToJQhW+28F1ZMHlIA/O1DBiAzFAgPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bte73Hq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bte73Hq+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 282CF1F000E9;
	Wed,  2 Sep 2026 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362932;
	bh=sz6uXSuy3CxZFllWz7lyAW7vEbaASDuoCm8JjwMp+MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bte73Hq+Gnrm/FYSeeCVHCJNOXkIMhzxh68+8nj7Jik7orY+1ts6/LPgRFDBuk9um
	 U5XzBSWsiO7HYn3juYK/pa+j4DIgJiCnswkXWAR37F5SXGnK3iRUnTYIVLWZwliK0B
	 qn3AUqKKSiFa3R4HK1rQxKmKLsrqD5B0Z+Da+1I8ipniXlJ62cMQJHliQIdoh+OG6p
	 ehHocVoXahDR4YMk0H8EW10uGrDDmZTOeGIdElg8VDtM252SJBo870kwKoURcmcDSI
	 sD3LZtltiyAfKC6zPt+RjxP/2j/6B3FMhz/d9Cjic32qMo5iQ8+q2Z3pxBWsKbuG4B
	 BSH/gJxJbE3WA==
Date: Wed, 2 Sep 2026 08:28:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: move healthmon event merge tracepoint
Message-ID: <20260902152851.GM1933798@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
 <178832750309.3507776.2729420337141667342.stgit@frogsfrogsfrogs>
 <20260902071517.GA25977@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902071517.GA25977@lst.de>

On Wed, Sep 02, 2026 at 09:15:17AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 01, 2026 at 10:46:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Move the tracepoint into the predicate function so that the list
> > conversion in the next patch is easier.
> 
> I would have called the label "out_merge" or even just "merge" instead of 
> "out_true", but the changes otherwise looks fine:

I'll change that.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
