Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C4A26B777;
	Wed, 18 Feb 2026 06:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771396413; cv=none; b=LBKcQi2pqcs0ZFiS0HNWTwcWlOcoPc712GvXrJhQ3fjy9/EueyOvsCQSRTkwVRT8U1jlnvnyW3V9V/ZzIldBzAW/S5fYIpnISpHo4oD0XPJo+JYrh340tUbO4ekM8iBnDiEHjF1DRkZBsH0pGa7pemZwutRhewq5McpeyrFsca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771396413; c=relaxed/simple;
	bh=JM6CYKPzTNMWuvNOH1j7DD0XGj0cph2VgrlB9TsAJxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoDiBN5V0+Av2yy771DO8qSpTZ7BerVQXH82jvC0r39sJHq4tgtyl4bk2U74QakQv63+hlkiRUamr/0gXvXXMOoPQNrEMYbk5HB3q+4TSdDN4ODnrUknTu1pnjBWsqWtcq1A+IyEh6FJw0lY5oyfSkTS+VbGDA4aRKObeetr/W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E562468B05; Wed, 18 Feb 2026 07:33:30 +0100 (CET)
Date: Wed, 18 Feb 2026 07:33:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 20/35] xfs: introduce XFS_FSVERITY_REGION_START
 constant
Message-ID: <20260218063329.GB8600@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-21-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260217231937.1183679-21-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> + * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in 53

Overly long line.

