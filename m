Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44A339B1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898666; cv=none; b=GaPKGqSEChAICKCG6LjMTDEm3ZD3fQ8xwV/LXPO/LA+Db522nBGd+nrLe097SskN/HOxvH8cvYDw/7C7s5jQH2tlsbkQ/dcNLGuqWPI8SrsfdG0QXKlRQI67Ky2utqFc2TtBr53a88zKA5W/An4cpsDPCotZ8SRSt/YijAx8TBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898666; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4OtK04Yg8hqTEECFeMFE3iNaRHVBDtc3kwOBIQi7RXgYPE5QZmHsLxDHJdlF2EFl56sciAkBqSOCMFahrUkS8oMqqLdXY/o71cGb85HY3XpTpa7C1mG1/dYuwmgTIn78Q1BWtvEAlDBqOf0CrGVe25WEx84DRH5TMc9tntDnIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 49BAC68B05; Tue,  2 Jul 2024 07:37:42 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:37:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs_scrub_fail: tighten up the security on the
 background systemd service
Message-ID: <20240702053741.GB23155@lst.de>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs> <171988119082.2008208.12273526437995077384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119082.2008208.12273526437995077384.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

