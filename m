Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABA364A0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898067; cv=none; b=cWOjwZld/EP9x/q38MN5p5U9JAR9R1+7zN4RC3p8y8AcBMQsPoQlw141U3hsEfmKV5qbF9nB3IYl4Rwc4y02W6KC8tdRK1czbuh5LhoFwoU8oQrdczTz9ygesdKOK0uDGjUKItaQeXRGz3fosVCP7e7COZrAmcXoxITdyEWLFTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0gtRJFClNMt4wyHfUTbMvlFsFfMYw3s90U4oySt3ZA5/OHH4YDg/ClmtU8ua39n+3Lhxg550/p/ZFHfqvckNUZ/gPgqB1BSawH+VhSF/qYwdYvvyA5hpEc3qxtIIY4cAm9+OCLQkOGHtoQaclfJ3KBCsabs2xouaCOoXN5Vx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3781068B05; Tue,  2 Jul 2024 07:27:43 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:27:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/8] xfs_scrub: collapse trim_filesystem
Message-ID: <20240702052743.GC22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118175.2007602.6970743462017002792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118175.2007602.6970743462017002792.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

