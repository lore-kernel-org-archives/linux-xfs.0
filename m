Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E515126BFF
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744302706; cv=none; b=bJ2kLWM3zozXA0YqoY9PEquJc9RyP9/JBYxNDAZHZuHI9uOJwbnyU1PCkuk8JwkX3xbcTlNO2sf44P0O/sYf/CDwu71fJxwUEH3dbfCno4qdE3ajg0p8N8IRth6eA9o5qPm9xsBpZGlYlP+zjgDwlZBrARvSc3iYAdb6T/8vK48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744302706; c=relaxed/simple;
	bh=WTsQj0zby/4wJz35iVhuuUdmsOZmVQsQaRZoWoO9GjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4OahAYnMi29MxsXuijGwyUxG4kiUS5RwuW2YiVwtDRtwcz3GPJ42aVzlJv458icMEKjch9uQjxwmklLDok1UyBtvwhFzHfpI0rkMc2nh9Kw5iwDLzztqgdn+lROlSUwDVhPy4IUW2PdcfgRiG1Jy6z8e86cMVofx6o5yDKvqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDY6WenU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDY6WenU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC460C4CEDD;
	Thu, 10 Apr 2025 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744302703;
	bh=WTsQj0zby/4wJz35iVhuuUdmsOZmVQsQaRZoWoO9GjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDY6WenUU+DC54gBO0IxAg//ofyROQeWMLfXye63c4pULB17ngqtxjiiYbhMNp2iN
	 5pGfsn9Q639YHdub/nOMjDqJB3qXgpVqVBnIge2T+4QHxKHiFmmFk26e9qhDVZkyow
	 utF746i/yycgZy6LSZdGL18Lwd9+6qNN+23A0L4Bi/SM8tBbNZPgZDpfdVlJzkWAV+
	 5mcMRItmdwE27ybUYSXYdZUXeJoedto7MnoCrWQd66IyOq3yXx6d1ffK2/b/8QtP31
	 0eDm1dZ0DQSyM0rwfQZr62L+WVATqS3XzSPW/XlvrFeyA4MTYxtF3+JCmyJAPOcXV8
	 WKStKQ0qoxy5Q==
Date: Thu, 10 Apr 2025 09:31:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/45] FIXUP: xfs: define the zoned on-disk format
Message-ID: <20250410163143.GX6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-12-hch@lst.de>
 <20250409154715.GU6283@frogsfrogsfrogs>
 <20250410060132.GB30571@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410060132.GB30571@lst.de>

On Thu, Apr 10, 2025 at 08:01:32AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 08:47:15AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 09, 2025 at 09:55:14AM +0200, Christoph Hellwig wrote:
> > 
> > No SoB?
> 
> The FIXUPs don't really have a clear process yet.  I'll add them where
> missing, but I'd also be interested if these fixups are a generally
> useful process we should follow.

I like the FIXUPS approach because (a) it makes it easier to keep the
libxfs ports in sync with the kernel with a diff/patch script; and (b)
the subtleties of the userspace port are in a separate patch where it's
much easier to see.  The biggest downside is that it breaks compile
testing of every commit in the branch, but that can be worked around
with some (ugh) filtering heuristics on the subject line.

--D
