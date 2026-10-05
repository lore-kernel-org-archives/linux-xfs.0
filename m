Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C358546AA6B;
	Mon,  5 Oct 2026 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206677; cv=none; b=PMv7cZuA6eNqDo8lUsD+Cy4BRXQ3CmyKtKStlYaweXmf0Js5gOstA/z545fBC6mF2F9vYtTfxJWyFUAdRGMF88CnT+vTIYngmP6J/I8Ogo/CPYN7k+Sh2h7hacP8FJyBLtmBWtlWdXaNcTLhJ3fDShqQpjmzuuLv+2pC+AR/+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206677; c=relaxed/simple;
	bh=Cx1zYDCqntcF99hH0HqjwZlpJC5AYeZ2d1+WFI9NOhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kk1dhys4raPM+pIEEA9x36DaomL+wRYMjS3jDbWy66QHeyYecmYDbqdPDPCXJ8u43IKmwNdIQEE7Hz/nhcfNt1WOJjkiVqa7Ncx1ILe9nFyGVzlWSHcKy6B0nWbvaK1t3QcEKO0WcG4bpCgXW71oeWJoIO6eokfuEufWVZkErqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9211068AFE; Mon,  5 Oct 2026 15:23:49 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:23:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs/2303: test that data checksums detect data
 misplacement
Message-ID: <20261005132349.GM26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-9-hch@lst.de> <20260929015439.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929015439.GK2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:54:39PM -0700, Darrick J. Wong wrote:
> > +ls -i $backing_file1 $backing_file2 >> $seqres.full
> 
> Heh, this is an amusing way to induce a data checksum verification
> failure -- switching the zone backing files. :)  Given that one of the
> previous tests directly writes to the rt dev I think this one is less
> important, but I guess that's one way to simulate an evil-maid device.

Silent misplacement was a fairly common error in early SSDs, so this
seems useful to test.  Note that this would not be caught by simple
checksums in extended LBAs without the reftag in T10 PI.

