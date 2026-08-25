Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491511ACED5
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 06:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639539; cv=none; b=UKflKfLTw8mXBU+PTPO7ldhQugWk6IZQpvDBCknLfuKdn5g5GhF8oHJaQuRUMLBzGpl/IdQm/0Bd/sE1QbAJV8SJGwIXILGAF8igljWuDzJVHXFVVIw/L+39SjSPlcDy0sbxRJ7K8rxhvD+cpB6sdjwuLdvb74CRLq6LtngHNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639539; c=relaxed/simple;
	bh=tJZFgFg4sfMzMrzNylZkfTzEvuwFqwz4F3riHObM9Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDI0hUUG6dqhV3V1UQuTJfXcKAemM37tc0rLNngWccnuV+anGJGHJ44Io+PRH33LnKMXimXJ7rqtQIDnNBfV/n9cwQLekWHjaqw/L9lIZrGlqilxE8mMA2EVHe8BjA6/jb1OjN3rVetQzNTusj5rAKW77ZJyZdwO7DiD5QmKDQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E323B68BFE; Tue, 25 Aug 2026 08:32:14 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:32:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260825063214.GE24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:35:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A longstanding weakness of the metapath repair code is that it can only
> reattach non-directories to the metadata directory tree.  Let's fix that

Why was this not done before?  Why is it possible now?  Testcase?

