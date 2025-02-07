Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1246B14830F
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 06:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738908438; cv=none; b=Y+h6JvGfsGtJAEvK+LzGlX1VvN8y/3G+wGLg/AwxD8WXl56p2nQooe5L2Sltc/rtxenZ0m+AT2DYgHAAyPhBkDt5jLtcPRxAQSBYDxzbT93UcWnOCZvQ4Xhz3JDbB/kA7qYHdNUk6WAaGhzGS9DV+BPo1Rf1TRp3mYosAwInfwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738908438; c=relaxed/simple;
	bh=dB0YnFzUZJ1zDU03vNA9c+oAL8n1jiBMRqme8+QKqSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvkUCOaIuFO4y8rZNMWQ/0di6TrleVSEIN+unaMvCvO7bLsxe2MANtzDfg+OGnQe9um6fcybwBJkxhyGsUbbttr+omvQFWsirHgyM9eYvxivpIXK38kB6qp6YUC9DBC+BwdgZ//LCMJTcIQ+PtNx4816ijeaGZoJdekvHo0qYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTjPyocN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTjPyocN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345C0C4CED1;
	Fri,  7 Feb 2025 06:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738908437;
	bh=dB0YnFzUZJ1zDU03vNA9c+oAL8n1jiBMRqme8+QKqSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lTjPyocNI9ZzPvNpts3zTyoXu6D9UwybX1ttXKTXLGa7Z0+FSSDjHybjaSX8o764m
	 R4Do5I423TUXrTqqbQokyryugS4hpJCQQO5UEYruCUf6sOdJLx65N9z/wphxnK64Hp
	 uTcZyPA9ZizjJkR1j3QTJ3njU2YNZO6adQkYuIC1ySAxpHLlcTQJ296wtZmPdO615I
	 eVZ/pkhaDZG7y5tXNiHRrhYxxPjGCDAndn+ZS1aMe9HqBSA/MzCzw489mDiRkXslTR
	 Z6Q7B3561HX6iAQT0cyBr0HAsj50UZbpjbIpVMhUqWt1FGVgTEObiTiOxuJ4I0ZFRs
	 e84AiLWoFdkBQ==
Date: Thu, 6 Feb 2025 22:07:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/27] mkfs: add some rtgroup inode helpers
Message-ID: <20250207060716.GV21808@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088495.2741033.10645836020741372245.stgit@frogsfrogsfrogs>
 <Z6WhUgZj8I3Ql4gO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WhUgZj8I3Ql4gO@infradead.org>

On Thu, Feb 06, 2025 at 09:59:46PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 02:56:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create some simple helpers to reduce the amount of typing whenever we
> > access rtgroup inodes.  Conversion was done with this spatch and some
> > minor reformatting:
> 
> Shouldn't this just be folded into the patch adding the line touched?

Yeah, I'll do go that.

--D
