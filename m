Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9362989B5;
	Mon, 13 Jul 2026 06:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925468; cv=none; b=ILS3xbSywosGF4TeHjhOKQ9aXTsFo5uPDZypCf9IPy8lN376q2clTrjXvfsd+rA1goEfsbiiGikNcwsJHMJZxWQu0asglJfoPcNd1/bz3mFLdClOJibzFol8+Q7zNZ8x+K5qghtnyQPmUkWJ1YblZY6E64ZmHgu0KScd1pjjnTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925468; c=relaxed/simple;
	bh=2Wg/+f9hRtsxUaGscYlidBuKUnfmp057FaOKqD7fWo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Akj20xvDbm23vU2xg8yoGJPUdXJ/gcZJKx1GUlYuVUvTGKx7MjFhxVXlhdadBqOvwfzcGci90W7EZ1Vw2mNt/WSP47z/PDVhgepxBQWDW1K4+7uUZ8S0343BQ1fp5z59ifvYb2JkwR/eKpKz2NhiAZnTihTNLEoXC2oGEafbSHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C39C68B05; Mon, 13 Jul 2026 08:41:05 +0200 (CEST)
Date: Mon, 13 Jul 2026 08:41:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: write the rg superblock when fixing it
Message-ID: <20260713064105.GA29416@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726193.1271589.8429966417697809477.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:04:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The rtgroup superblock fixer should write the rtgroup superblock.
> LOLLM noticed this, oops. :/

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can we get a testcase to verify this?

