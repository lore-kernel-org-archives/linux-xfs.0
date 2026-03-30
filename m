Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B31286D73;
	Mon, 30 Mar 2026 05:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774848818; cv=none; b=IgcPZWXvh5YGavbBnHUjr3LyNe843rAzJyIo/hkfM6npBty+Rk6KPUMcVVwHdd36O9QG6RD7l0jrLymB+J1K7D1vIU6kxygYCtaB4VI/0Qwe8PA98CIiFwsf56Yz3+r3vdC4lns2G81lwN/zyUpw0QXGv7cu2V+Hrd3JPcCs2gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774848818; c=relaxed/simple;
	bh=B7pkyEut7Scqa/auAkrfA7+jUNpCArsQJb7UedF8o9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPUXVUdVa00d1/TtFh5NfWOwrDTkkW5vu7pXgoUOWBxytJkOvn82FOiC9OXKrZv3FBda1ch2pEHD9zHpRJyZNGLk3BPeA2nxRtxkqzqaTY3z6Ag8JW0LkXZFNxBEnN87Jn5Cn+om/tZJOSRp2/pArrSBm34SnaiKT0o2W+cZ3/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A764D68B05; Mon, 30 Mar 2026 07:33:34 +0200 (CEST)
Date: Mon, 30 Mar 2026 07:33:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs/647: turn rt dev block device lookup into a
 common helper
Message-ID: <20260330053334.GB4876@lst.de>
References: <20260327123429.39330-1-hans.holmberg@wdc.com> <20260327123429.39330-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327123429.39330-2-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 27, 2026 at 01:34:28PM +0100, Hans Holmberg wrote:
> Turn the logic figuring out on which block device the rt data is stored on
> into a common helper.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

