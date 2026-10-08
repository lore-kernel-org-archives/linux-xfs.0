Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5883B05A5;
	Thu,  8 Oct 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791481002; cv=none; b=X9ZKxO74mY5kBwXsDqXr2I+3Ykg7xiTwhzXqz/V7OPjnmwtsm9MetmW6UuZaYNF7CMXqreHs/UD4w+v2+ocgp/qeIGgf2YyicTxKLa68qaj37oNrPwaaTXOpVp3eHghNrbawLpKvIwZ1GiD2UENh4wMtFmrm8Vi0BHup1yRAH18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791481002; c=relaxed/simple;
	bh=AwpSE36JMTCHwrh8rSf67L5/XWSWB7TqkGz5UMwx3i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbRiuFud00hm1neKIndW8M5nOCLSTYk215f6Lx7Vw/1ja1EQrn2s7KvgOeIDeCFnPQuQnmV4IdVDDoqAqWAKhVh3jegjnSCHek1uJdsU6voz0B2vKBjHQ0jbgOvKe3XiZOtPYebNpGtWXeIkDYJOQH9fYmBPVRJpwqG9DNyOlkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmW2ST6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmW2ST6s"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 054C71F000FF;
	Thu,  8 Oct 2026 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791481001;
	bh=eu73loxd5VS3le1B4WJTCN98olQdBDh9t9pW4xvUkN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KmW2ST6smaYoTJRyEhRFfpqTN0XRHivJmVDGHtmIZ3nBs8XaPO8UhnRytwmv2+BdP
	 Y6nE6AtEtzFEMModoozR3DCekmX7deLi6hhNXhGIVd/9Eea70PM98mORHbn54Svb+x
	 cjR9ie9vfbWof+CRfbxY0AWxObT04b7zq/nC/f6OOhWzGT54ooX5iSGABLh2No88RB
	 eRCQ/dnnzuuwezeNgFEAzNSM8CpPeq5+/9hH+YDe6rgtpiwT9Blz2PF+DNGHxV8cLX
	 G0KOXFuO5oeFrbuqpo5w5aQ1EZXyoPWSVNkXtH3ZhITRt9C8zTRU3BXQFW4VpMWVQ9
	 bJcuSzyvGEtkA==
Date: Thu, 8 Oct 2026 10:36:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: complain loudly when dirtree checker finds
 broken links
Message-ID: <20261008173640.GU2705364@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521516.2728617.8852126870323780870.stgit@frogsfrogsfrogs>
 <aseG3Jn-GmYBLTzc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseG3Jn-GmYBLTzc@infradead.org>

On Thu, Oct 08, 2026 at 05:04:44AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 10:57:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM observed that the directory tree walk code bails out if it finds
> > broken parent pointers along the way.  However, it flattens the return
> > code to zero, which means that we can end up in the repair code having
> > not completed the scan.  We should never proceed with a repair in this
> > state, so let's mark the scrub incomplete and exit.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> although I think Sashiko is right in that more places need the same
> treatment.

Aha, yes, in the branch that flattens ENOSR/ELRNG/EFSCORRUPTED to zero.
Will fix that.

--D
