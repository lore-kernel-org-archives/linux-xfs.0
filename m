Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442EB356A38;
	Fri, 21 Aug 2026 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326923; cv=none; b=EO4mgp9w941EfvJDzt1fePdrEiFwb85q5wyqnlmxsr/E2vZcNWJEtkCnPp9Qpnk8/aukdyyvujIr5q9EBEiCtwF+tsXyuYsdq5EC80ripUdsJlhsDfVQyfNRC130oI2tqgLATeq+/IbWJf/qgxjH+oefoanBSt2KxOx4fqpJkXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326923; c=relaxed/simple;
	bh=qOpt3D+DYcT6WpNCf+zDD62epunJnGQQn6mykR7nIKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mX4xPRbMaMCVQv7E/p2fecWslqIgnUT9RZ0cRoH0qgTkgW7r9uu399XA8NAUqoC5rzbF4E13xw1s3M7xZU2XrKztTtt/Uucd45kW+Ckd5Yh1OPl/l1e01ZKal2T47q6azLZlloONGIPrikvgm4Ivopp6rfREPFpOu24RBb63B4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCdG81aH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCdG81aH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D5C731F000E9;
	Fri, 21 Aug 2026 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787326921;
	bh=CFVoxXCEF0eW2g+Gvl8Jg3nJiMJMUTjFU05vm91K838=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cCdG81aHDkLjLCSgaaSfvILR5FnhZxMXpl738uDOIDg7PzLvWGLd5TH0Ak3pm6SiU
	 4nYFAENZ7uKPOFTrUWsxVgFN1tFWympltY4agHlnxamD++/9oy6G4A3q7v3ArH2EzP
	 X85jXIfm7A66H2BQ8PFmiuh/wfv7vr5t8Px/DQVia7O5CKTFBborGNQ8s+bTW5XV1W
	 B6ZJg5tJ7/rhfTAPIMCfJdmYPVNsDzZFcn0UwhIDCZmcw0zKpIsfwEWN9Fntb4NJPv
	 e1o10p4H0bJpjtsk49wzlCEHMNPWLmoNIm9nI6kCffUqtZt4yGQSUS+97u98nmCodx
	 /UwQ/4qPy54+w==
Date: Fri, 21 Aug 2026 08:42:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, qsa@qualys.com,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: regression test for refluxfs fixes
Message-ID: <20260821154201.GL6072@frogsfrogsfrogs>
References: <20260819155432.GC839663@frogsfrogsfrogs>
 <aofjt-8uJvl994E7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aofjt-8uJvl994E7@infradead.org>

On Thu, Aug 20, 2026 at 10:35:51PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 19, 2026 at 08:54:32AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Regression test for refluxfs as found by Qualys.
> 
> Looks good.  Should this get a Cc and Co-Developed-by for the authors
> of the C code?

Probably.  I'll respin this one.

--D
