Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89042383998;
	Thu, 16 Jul 2026 08:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189999; cv=none; b=D+FB/yMnC5ZWw4muxivhFREcbiETIzHQqmTmOaV6m1hbYstSCDpFptin06HxdMJ/S5dxGZfQsgFTlZgsxcKXcPiZrzfT551gT3w5lSrUvBvXN1N9Orgh0zg1QM1gNx3XjzmJbDBPYSPd2TkCNkB6Pox6PwEe/isyb0VF7TiyyKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189999; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXDJH5xYbRzDrKoHUfb9lFNUaHPTTglDAVOIO87i/PH9M87ibrhS1XFiqK06/sHtkuzBP+hPlnZXgdrlQlbhN1s5k/VVI3y99cZoa9JhwMYV8KWa0iXps3aK5cs7V0bk/lOWKIeYDkPc0hJa+L57MGCmA1wF1eSxZMwZULNSenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 039CB6732A; Thu, 16 Jul 2026 10:19:55 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:19:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: mark nonzero sb_gquotino as corrupt on
 metadir filesystems
Message-ID: <20260716081955.GG12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797465.2008054.5748103424434594657.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797465.2008054.5748103424434594657.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

