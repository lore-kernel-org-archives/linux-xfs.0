Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B8A13C83D;
	Mon, 14 Oct 2024 06:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885663; cv=none; b=f+JfHfRDEAGupmk9CmY74rT8X4uqLUhQXQ/kMypXpm8ps64kC4lqUzeJ9ScNPKlmyN5meu94Eg3hGdt25tfWg27dM8lZze7rpZ/JrCOhCWUFSk+tjsju6nxyy+na1aYyH5A2gKNima7XrL94JFKUuZFdtMSKrEOT9cQn4XITKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885663; c=relaxed/simple;
	bh=/zW9FkJPNO73n82HCLMmp0WEmS0n5GQrziu8ZIV/l50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYC7yO83XS6H/DrfPzK/mOC3pdoayvnzHqM8HmA1FFhN+dBuIh4Ujzp1HLlA8iviFHmj5lakMW6VI9ICFCUzV/8do89N9JbZBbvZbWTl0qOPMfGh3BDXqOQBsGutx4poof3PgJczhwxHTgAtO0n0hCWSyIVPTVi+1NTQVjDeL4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 90027227AC3; Mon, 14 Oct 2024 08:00:54 +0200 (CEST)
Date: Mon, 14 Oct 2024 08:00:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20241014060051.GB20485@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <ZuBVhszqs-fKmc9X@bfoster> <20240910151053.GA22643@lst.de> <ZuBwKQBMsuV-dp18@bfoster> <ZwVdtXUSwEXRpcuQ@bfoster> <20241009080451.GA16822@lst.de> <ZwZ4oviaUHI4Ed6Z@bfoster> <20241009124316.GB21408@lst.de> <Zwad6T5Ip5kGtWDL@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwad6T5Ip5kGtWDL@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 09, 2024 at 11:14:49AM -0400, Brian Foster wrote:
> Thanks. This seems to fix the unmountable fs problem, so I'd guess it's
> reproducing something related.
> 
> The test still fails occasionally with a trans abort and I see some
> bnobt/cntbt corruption messages like the one appended below, but I'll
> leave to you to decide whether this is a regression or preexisting
> problem.

That's because log recovery completely fails to update the in-core
state for the last existing AG.  I've added a fix for that.

