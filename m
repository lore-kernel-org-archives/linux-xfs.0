Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC75C74047
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901533; cv=none; b=hWSkjnjLXfZz5drgtKzidPVkR2Sfd1333CKPmkM7wywsR67KRLmAVrzj9yGsHe9A4RMo15Um/0yVT4uzC/SP0c0PzITzJ8toj2hAaVosZoTbQxMlYLlfQlUp3xtNYaYSwhXxFoqVvQSASV6D5P4yyRZmxulYLXdu9HvTl08Uw6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901533; c=relaxed/simple;
	bh=YfPZxaKSAzwkMhsBdsCAQKy8MMyXXspAT24g6A6EdyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1CkWYoWJEz/MtFjBOka8TZ1Qa3/oPgfkdtqoIt9iOT2ileYTWDR878SY77Dr/rWo6Nhra418zE4E7E7XnbikVlh33CRJrFq9qQwPA4ilSbIX2Xi6W8fscPZEmS2x3UWGx+g9VHn/j9QxHS6u47KdH+Tkx6zb/jKkosm2T+S4/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D8E468B05; Tue,  2 Jul 2024 08:25:29 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:25:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 05/24] libfrog: report parent pointers to userspace
Message-ID: <20240702062529.GE24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121139.2009260.15042250941832877051.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121139.2009260.15042250941832877051.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good;

Reviewed-by: Christoph Hellwig <hch@lst.de>
