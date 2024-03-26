Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E221B285
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474269; cv=none; b=tvl0XK4PdDvURC+pa836mfISLEw5jKfEkPlKPjg/mk++zE5689S0Pb5I3eGQ3fKZ4mMlPM5NcOt7TckLCYPvMsET7w4lmrTYFs3y8oyU69sGHgji72chOv0mtWuGLW3iO4bqioSCkE9P+oew+bJMbyK6gSsYl+MJaf75+UNguX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474269; c=relaxed/simple;
	bh=ugOlJZ4iHbjWxIdfuLHnCN2gP58Fb/mV/4tos/1T7so=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAAS3UtrCd8c6qcMn6EQ1pHOYr9tqkafqHqyZY9U2xDq1OCJnWAcepuGsTCjEod4fW/wDQAMmHqmvi0eMNg2qOnCr4ddg2AQuZP/aYyZqQYimTA6FVyPUiT0CxDZWXlOlI4zae1MBagyQZMh75kfhtn15XRETF3eee1KSvmK/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLbaeM9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLbaeM9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D46C433C7;
	Tue, 26 Mar 2024 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711474268;
	bh=ugOlJZ4iHbjWxIdfuLHnCN2gP58Fb/mV/4tos/1T7so=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLbaeM9kcemFhkJF3iGfQlibhcma5jzNhd0AkkLnbRTHufVyp3h8AeMgqdDXdRpMg
	 hmlL/e5tzELubLRgKJm45Fr2wMM6Ru5uV9DCNYVfZs9KIwwknroxb/WhIZEq72Yi4M
	 RjtbWeFzU0vV2Afpatsy7PKFD3a7FdXeBZ7y1eTzgUT6LFslLQbxeeuoBMg0AqLJQl
	 M9LIJfKlRBFcxnRLgEGIdHHtD69o5S0uSc5/AlSCS5awXvI9ttFyDDLJsHXc5kL4pM
	 g9lC+H4nUGFeNaJgcnOvrLqznhy2P1JeI3UFSmCc0gyBk3YARaHC3kU7eMOC4YBGyQ
	 3yGtJ79IBbFBg==
Date: Tue, 26 Mar 2024 10:31:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_db: fix alignment checks in getbitval
Message-ID: <20240326173107.GT6390@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
 <ZgJZzSMIWDFBzADm@infradead.org>
 <20240326162821.GI6390@frogsfrogsfrogs>
 <ZgL5dH2AIIlz5N0h@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgL5dH2AIIlz5N0h@infradead.org>

On Tue, Mar 26, 2024 at 09:36:04AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 09:28:21AM -0700, Darrick J. Wong wrote:
> > Well we could still use the regular ones for aligned access, e.g.
> 
> We could, but is it worth the effort?  The few xfs_db command that
> do this bit en/decoding are ery much the definition of a slow path.

Seeing as it's the debugger I don't really care about maximal
performance anyway. :)

You might have noticed that the rtgroups patchset formally defines the
rtbitmap words to have le32 ordering (instead of host ordering like we
do now), at which point getbitval will need to be extended to handle
little endian conversions.  This is also useful for decoding fsverity
descriptors.

So I'll go with the less clutter approach.

--D
