Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D573E192D6C;
	Mon, 25 Nov 2024 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732555143; cv=none; b=O0Iju0Pb1xuvBCJKWj2Tvvo1J/JlPrxC/Oafd5gIfrM724O/GzFSEnymutUPdEjXsMwRjd51SOPLyVq9EXibP9GdRiJoKnekWKnl0uXHc45e+eARd7XRrDKb0yTRdMZ2P6KlG9RAzbICMxYaSuW16VMhouDyqVtoN4mVEx725Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732555143; c=relaxed/simple;
	bh=iNcGrI9d68zEhE5RKTlnRCd1gTE3tpgUDCfpeGp211Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4ZC7o4sODcgzXgTzNIH9payp/g1YCOx9biWAlgFdVG+i5LHSFBT+B2iUIJ8XFAjozXjkej6TisKWbyxyfxraChiLci3xFhpkrXEi5Nzas/AsnFFtSAmKDkj9zpYwj7XRhHyC7Ki+LH+zgMFpC/k4EAIwqlUEIIlTVCmlk4yI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ti/9DrSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ti/9DrSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6EBC4CECE;
	Mon, 25 Nov 2024 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732555143;
	bh=iNcGrI9d68zEhE5RKTlnRCd1gTE3tpgUDCfpeGp211Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ti/9DrSysYNLAqE66/hAxwi4k/28vONDweaBYItytdUGJQYpNaJE9/pxk9pLcZzU+
	 uN/YtHcp1AlH2a/G0VxnwMw0uVaKqM2QE/EJ7rXYEzf3+oVPBks9Z3LiKtISpRuUtj
	 8JrUAHysBZgdI4FIROXqdpDMi2rfBPzybzmvCmuCU+1m+/kjm1OEbQrU3RjBN7eFzH
	 eZkzr4tR8+saLN9vQC2A4ttg8pfWF6qCNS4ZA/LtDGSDHrHMNKbRTElWl5J2AChXgH
	 SjsuR8e8oPTdaGtVHnxqZGtROqaauiI3980TRuKq9j8JILsxkrgv+KUXsbihjh1a2f
	 9dUX+fur+H0Pg==
Date: Mon, 25 Nov 2024 09:19:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] logwrites: warn if we don't think read after
 discard returns zeroes
Message-ID: <20241125171902.GC9425@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420060.358248.11054238752146807489.stgit@frogsfrogsfrogs>
 <Z0QHOjqagg5VuhFf@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0QHOjqagg5VuhFf@infradead.org>

On Sun, Nov 24, 2024 at 09:12:26PM -0800, Christoph Hellwig wrote:
> This feels like it's heading in the wrong direction, as it just adds
> more hacks.
> 
> IMHO the right thing is to:
> 
>  a) document current assumptions and tell users very clearly to use
>     dm-thin to get the expected semantics
>  b) if we have a use for it, provide an option to use write zeroes
>     instead that can be used on any device
> 
> I'm happy to do that work, but until then I'd suggest to skip this and
> the next two patches.

Works for me. :)

Also feel free to grab/modify patch 4 if you like.

--D
