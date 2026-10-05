Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC348B37B;
	Mon,  5 Oct 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206823; cv=none; b=vDEhZV1I4FoiZR2uqOoF5uDbX6zqOVbl2cpXmVrTcC8b07qTYlz2ai/j2MoFmSjpEXafQZOKbI5lbOR1C/oFumOVbk/LHSGZf2X2wI3xmQUK8frLgeWudv1I6bQoMomajB2rPow7vAEhKdxFzD22ZsCKxtLlgAtA1KME8jxVR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206823; c=relaxed/simple;
	bh=rAM5LkCQaCWbdOqrm3TgRu5msyeiL54Jt3fWe8gqjpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZe6N8YJPA72ZYOkBLe+GgBp4WX9TDatV2TYF7MCHgR6kbXfl0XCPjgZPV98zHK39OCZ65vex/fxtEDZiQzb7x7iGyik5SMOqSAg7oJbIGGcCl0zsObvFN7HRKzS81oaE3HF1P4FQbMy3K1fmcjmX1fHBGloIFf0QAr6jPNenho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B01E68C4E; Mon,  5 Oct 2026 15:26:21 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:26:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs/2306: test mkfs input validation for RT data
 csum options
Message-ID: <20261005132621.GP26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-12-hch@lst.de> <20260929015905.GN2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929015905.GN2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Yeah, we're not in a rush and I want to see the valid ones pass the
sb buf verifier.

