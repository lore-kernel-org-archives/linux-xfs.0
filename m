Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D286446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432268; cv=none; b=pgz6wZsr9Ms/DR6RlYnB92FTrihnFBpqwww9mC2aPkLtUsPjA33INR4aoRFnkvDkyq/iALCPdXCKQXRxu8BqjdSEgp7eG5NdbInqPvKwXHtLUZd6gohKlXXiRX3wPScIHgCWMZmwPALk46ZoR8j5wpScXNQL9uMnomY9xwtD3Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432268; c=relaxed/simple;
	bh=kr44xRzQLX2RyYp6v4UfZFJqD5DVNj5kaBSxEigUlYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cH0tF4tvRJfTWOFJgk9GfsJyQBr8YrmcvfpONY1C+obpJUf8sD622K3beubYTSnCJ/7SgCpxGLuYsg7c/n7+IJ4hqF50t+E5AB7NsBfNExM3/Afsz9wyi9ANmP/EyqgXAYRo4fJ6g9DCFP2iCJluJYXBuRtalAs7yqBzZ3Sp2fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B63E68D37; Tue, 26 Mar 2024 06:51:03 +0100 (CET)
Date: Tue, 26 Mar 2024 06:51:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: split xfs_mod_freecounter
Message-ID: <20240326055103.GB6808@lst.de>
References: <20240325022411.2045794-1-hch@lst.de> <20240325022411.2045794-5-hch@lst.de> <20240325234153.GD6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325234153.GD6414@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 25, 2024 at 04:41:53PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 25, 2024 at 10:24:04AM +0800, Christoph Hellwig wrote:
> > xfs_mod_freecounter has two entirely separate code paths for adding or
> > subtracting from the free counters.  Only the subtract case looks at the
> > rsvd flag and can return an error.
> > 
> > Split xfs_mod_freecounter into separate helpers for subtracting or
> > adding the freecounter, and remove all the impossible to reach error
> > handling for the addition case.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'm guessing that the difference between v3 and v4 is that you can more
> easily integrate a freertx reserve pool now?

Yes.
