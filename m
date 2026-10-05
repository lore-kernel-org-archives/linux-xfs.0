Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641E1483823;
	Mon,  5 Oct 2026 13:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206098; cv=none; b=lJ1M6CVhTvH+lQQSFdi2xLkybajcIgNR17fB12mRvtEUCx77WPAI3gkPP7xSjop4VdONqBqymVen7JyHyVCY37TS8hkCAORfTh9ujpeNYgX8lP/BLXcB3O1qZpCvehytUHxOVEMWvCMeAY4RNkIyPLMNWyMporVYwlAj9N6n5JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206098; c=relaxed/simple;
	bh=g7PxFaEt0etdpwjF9PtLE7SJ1wgScWeAPjcq0+gXWyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfEuTKUyDglYtL6N4ryvuZYV7+4V0wVHdqxS6osBrP85F1DredZhMdS+AuuMlq0cVDUl9lfdjqClElOVK1UF+6dGwjyAR9cFEsmAJxUgaAhKhXrlNSFZXMbkFn1wpJKzJJF/SpNaupprJsDCCJHa+HakPO5nHfnHvl5YqxwvKeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EACCA68AFE; Mon,  5 Oct 2026 15:14:53 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:14:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/21] xfs: don't try to verify checksums on empty zones
Message-ID: <20261005131453.GF26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-19-hch@lst.de> <20260929012555.GZ2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929012555.GZ2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:25:55PM -0700, Darrick J. Wong wrote:
> Just a general note -- if the csum update never makes it to disk, then
> the remap cannot have been written to disk either.  Therefore, fsmap
> will report that as unowned space, and xfs_scrub won't try to
> read-verify it, given the xfs_scrub patch you post later to only read rt
> blocks for which there are rmap records.
> 
> So I think this is only a theoretical concern, right?

At least earlier I could reproduce a case where scrub raced with
a zone reset and tries to verify the reset zone against the now
implicitly zeroed zone.

