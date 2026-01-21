Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAD12DCC03
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008979; cv=none; b=t+evWsuXcAW+5FCfFd7ZGqRL812Y7WdoaCeIADBN/AbktoIZ67y/WvLkiajbHe+v4atdvDvSJsPQ6vdRayhlM4fzCTS1QJMl9FswwM7+15O5gQW6hfJW75d2FirGXF3uUQBrTGFtmU5ugGju7JaB+CXecYo2PAo/vSq7Qw9Jfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008979; c=relaxed/simple;
	bh=hW90o8FNcFcqwdcecEK+nSyjrPqau1Za8pcT8bmkS/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlP76ZyR6/pNzg4J6F88mnZD5JRuHMMKEzO+tJuZbm5Bjk3VyQ6Pa4Uhp082ly8rK7xkA5MeVkA4o3hR6LYGiBKX471Y4OLC0M4PcSDpKmESMGarRaUgOPix1QNoox1QhNkyXcAEXnW+ZNoHHgLICgPx1mtBnAyJPsrWzOFMdT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qWEkVek8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qWEkVek8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=joPIyEruzQYpJtMWTO+hG83VdwOmLdl78ZeWqqzL/Gc=; b=qWEkVek80n+d7A8kgPrLhNyVmU
	hKALDErQHTMQ3TEG5sTB7zPudIp3zUWkIBNQWkeDWMyjiNH9i4SIrTznOIWViM3WCX0tnTzSpnEh9
	27933SO9xvmo2knoFMs+CTlXFckoC/N9sq60yQbLpHxcXkMu91FxxiRDz0M/zzjPdCRU3xSNQJzwl
	3Amw3SI4L1jVLl22FmI4uoM1vk/vpcea7YcczPTMi4zLcE+6cfbjhufCoXIpzQPvBTtgh9hziiAXA
	upfafi41bh0UV6SvkAzsblFQ0V3LZNdVAQ2LVXgQxydKsf6p7HZJsSkQI+tfAeUBidKVRup9bxeX8
	y2WRv37Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1via2q-00000005iHg-33Gi;
	Wed, 21 Jan 2026 15:22:56 +0000
Date: Wed, 21 Jan 2026 07:22:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: add a method to replace shortform attrs
Message-ID: <aXDvUGGUGFzZF_Ts@infradead.org>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
 <176897695994.202851.7241999799670618810.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695994.202851.7241999799670618810.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:40:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're trying to replace an xattr in a shortform attr structure and
> the old entry fits the new entry, we can just memcpy and exit without
> having to delete, compact, and re-add the entry (or worse use the attr
> intent machinery).  For parent pointers this only advantages renaming
> where the filename length stays the same (e.g. mv autoexec.bat
> scandisk.exe) but for regular xattrs it might be useful for updating
> security labels and the like.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

