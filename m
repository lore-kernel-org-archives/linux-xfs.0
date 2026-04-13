Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8FB21FF21
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776060562; cv=none; b=iDtdzUHqZgyqiglx//c4o8Q/z5q8PeeLNTRxm1nQBk95wZ4mlazSBi+W36DJOysUBRxClWatB5C2+XQNvNofRMKvCyKLX3uZiin+UuYgYN+Qe9qpYI5HlTxMbNpev2VzR3otBQiwNZDSbkYoFhzCh9EAi+hMQ7zJCh5FngUgn70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776060562; c=relaxed/simple;
	bh=a05v3ZNAqQv5Dw3tBh+sZpJDznMLT5SvrGz0ZyeNrSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ett1sXLo9ewlBreSBCrMikbgneNnLl92CL5iaudnRTjnobyZ1Ls7supVlc1Fxpg65a6YdLVnzMtMhF/tiBWwHui/VUjBWKfc4IWiX2mUbyGMMENX6zXJ7jLWlQM1DvJxkymsUlW2VViLy1sUzxP7oBmUi1JfbyYgeTdxUQL53OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=fVsci9HJ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="fVsci9HJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jh9HpbKX+PuX+8S+MzvqXAZxwaAH3oIa+KmQwppl/fo=; b=fVsci9HJDKkFmq5l6KjOVbsBU3
	M+9zNkihDXKO6N7iOiHXrTM4Oafj95Xv5plxl5WK+uksL3zOt76Tb/pAAwx2bYt9x3DuX2TaR46NP
	o4qoiAJ52RmJNPVUwQPjg41dReD2jqEeLecEfmbYp2DUZ6e5Qr1sTZvWpzWq/o72CTJD3gbT1oS/H
	aNdgRhIB/bLTi+a6Bo7rd2Q5p/RIw1xeosEWai9T7oadImvpsgw7tBlfp1RNjvxACdn2aF/Hjz+Mm
	2ScALSvCP69QMnYVuB6YA2FGuRbZjE38IEz/qzi4/4rCNw04UFRPM2nIpV9PbF5b1zkfFdYekRZyU
	2H43MfGA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wCAU1-00C5W1-2Q;
	Mon, 13 Apr 2026 06:09:18 +0000
Received: from andreas by mail.an3as.eu with local (Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wCAU0-009YRS-2x;
	Mon, 13 Apr 2026 08:09:16 +0200
Date: Mon, 13 Apr 2026 08:09:16 +0200
From: Andreas Tille <tille@debian.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>,
	Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <adyIjDhyGMhBQDS_@an3as.eu>
References: <ads96yii8bij-UQQ@an3as.eu>
 <20260413035534.GF1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413035534.GF1048989@frogsfrogsfrogs>
X-Debian-User: tille

Hi Darrick,

thank you for your quick response.

Am Sun, Apr 12, 2026 at 08:55:34PM -0700 schrieb Darrick J. Wong:
> > I'd be happy if these packages could be maintained in a publicly visible
> > Git repository on Salsa, with appropriate Vcs fields set.
> 
> That's more or less a matter of setting a couple of fields in
> debian/control, right?
> 
> Vcs-Browser: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> Vcs-Git: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git -b master

Yes.  While I would prefer maintenance on salsa.debian.org for the
Debian packaging having setting those fields is helpful in any case.

Kind regards
    Andreas.

-- 
https://fam-tille.de
