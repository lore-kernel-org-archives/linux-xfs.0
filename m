Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854212BE7DD;
	Tue, 21 Jul 2026 04:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784609234; cv=none; b=HTrIhzGdVnm2hANFdOiM2+5/m1bTG+jrYl5azICpgi21aJzfsUkl0T9aCKTin9C4LrkgMQvNrWyTUXvaSFZ9uCTgKD7bTeY3zCp/2OxLjAahHD5tfVLt5QkOMGKzUVSPNCMQFPGN/FCFctts67pIALXz0Y4v/3jqy9W/vLCulWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784609234; c=relaxed/simple;
	bh=F/71vFNoAdNn+akz4yHvfGyvK3tPFTpBEXDEHEQu6fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmshhXVxScEx9+p0Rib2itARsFf6wi/tVJkXHmRuYdWvXcoxXs7JoQTfFOXoSuF/qIGTrOx02rBBgk8avn0urhFH9GtA1gaQwOG6tYEn95KBA7b91miYGrWbAHHEbfs83F58hJNPK/9taSo3souylR0KQcvxb+YzvH2Z4witBOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 666FC68C4E; Tue, 21 Jul 2026 06:47:10 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:47:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: load next_agino from the correct xfarray in
 xrep_iunlink_relink_prev
Message-ID: <20260721044710.GB6644@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419575.830862.6051379847990817321.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419575.830862.6051379847990817321.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 20, 2026 at 08:25:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that xrep_iunlink_relink_prev has the comment "set the
> forward pointer..." but then loads the value from the xfarray that
> stores pointers to the previous inode in the unlinked list.  That's
> wrong, so fix the variable access.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
