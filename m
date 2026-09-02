Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC592AD3C;
	Wed,  2 Sep 2026 07:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333210; cv=none; b=cGNEZDlMbgiy1FIHlJKNWDKbHk7PhBLsPvgtwdYfQvzIDTrC02msEgApWgC9GU75PYOsSmoohodgsVELMvU7BriU/ievMX1JEWeH3NiHhxOhgJCDAMzBq7INnDIFQFM3e57poLAfTzFR4qULs0mztC4lXsmewsy9sFUabjFmvwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333210; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxzfKYsuJt9tywiDn6dIVJEwTr3wNZ6Txw3VzzlfQqpsBAyvrokTT5vqppgqGv0jRui/UB3/UycqRxXQsrrg7QoSQgjJ+GqhT03pA/xQjxvCMOFw0yBlP1m5sLnvBN29+GZg2FeaXwEAO6eluqLL+LsxXEsJaRbZLhC3IlziSOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C90668B05; Wed,  2 Sep 2026 09:13:24 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:13:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify
 for dry runs
Message-ID: <20260902071323.GA25939@lst.de>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs> <178832749528.3507209.11787129781318331688.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832749528.3507209.11787129781318331688.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

