Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F626ADE
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 05:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718342625; cv=none; b=oAMCYWzMp8cPddQ2TcgoJ0H3uQhpldGrF7zOnj2FyTwsrYN30uJJpW4iMNZ3h/ACqQ6U4Wgb5W/O99f4QO54SGvsbVsWPwbalKgxentp/LlykFQTVC5IJS1zc7odU6LDridV4L1HILOk2V12t/j1Z8r4mRb+hocdtlE1rn/BPWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718342625; c=relaxed/simple;
	bh=qlkaOf/dR9AvEpwCtWQ1sW8/dA+mJnoIbdculYQB8mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8Qx9XLzO0LhO5V3+SvZVFELQolxPIP/GJNMIcqiw5Qkcv/QKVliRnguQBbHA430JbJ/Ab6ulIQttZllWDTZWVp08lH5WMlo3XYK0wWvfBcqxR9khEeTi+fZ49Lqs9ml2dTs8QhEMwPEIDetG0HRCRSVzGSGeAPE4iydpDwFB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pOerV/AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pOerV/AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6063C2BD10;
	Fri, 14 Jun 2024 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718342624;
	bh=qlkaOf/dR9AvEpwCtWQ1sW8/dA+mJnoIbdculYQB8mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pOerV/ATCqg7NsDiL/hdPIxrhcKVxxdNoXBblSfIqcEaez5mpWagmzzuN9/8LwwCp
	 omTSR++LjeSnqHxTynuPDmWObVhXddEDt+xWyhsoHUNqgcrtCFn9wkoKQpfH3zZ+Lt
	 QLX4eslR/jU/CoFjqFg/sq4D2/6naoOuxvgUg+JTAHWrVIrcNCwotDsXGdmxWGn72U
	 YcPwlfnsoVWAtGxuZWTS3U2pD/qGYQlwbenrskmITj6TceF7dfwRL+I6BM6q7B56SQ
	 7OUx2q2N0gv5K+Xp/jkOPUpK6oujbdS/91AJtQdGfpEwJtNm/AZqHcrztLM4nkiiCV
	 +JdhDL9J/2LvA==
Date: Thu, 13 Jun 2024 22:23:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: verify buffer, inode, and dquot items every tx
 commit
Message-ID: <20240614052344.GB6147@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>
 <ZmqaDwbXOahCAK1v@dread.disaster.area>
 <20240614034949.GA6125@frogsfrogsfrogs>
 <20240614044238.GB9084@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614044238.GB9084@lst.de>

On Fri, Jun 14, 2024 at 06:42:38AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 13, 2024 at 08:49:49PM -0700, Darrick J. Wong wrote:
> > > Hence I think this should be pushed into a separate debug config
> > > sub-option. Make it something we can easily turn on with
> > > KASAN and lockdep when we our periodic costly extensive validation
> > > test runs.
> > 
> > Do you want a CONFIG_XFS_DEBUG_EXPENSIVE=y guard, then?  Some of the
> > bmbt scanning debug things might qualify for that too.
> 
> Or EXPENSIVE_VALIDATION.  Another option would be a runtime selection,
> but that feels like a bit too much to bother.

Yeah, probably.  FWIW I haven't seen any increase in fstests runtime
since I added this debug patch.  I suspect that the 512b allocations
for the inode easily come out of that slab and don't slow us down much.

--D
