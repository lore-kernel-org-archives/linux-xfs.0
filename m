Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFA24468C
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719235; cv=none; b=uj7gbt3YPRgyNMt4DHkOPEG1K09WU2rb4n4tBc67IFSqFhJsTp1/lcWEyDZkRG3JFriRRbwTb7pZD7iTCqoMYJZ6QPgaIzpcMBIiDa59dnl8tb5Ur2vlK3/qMPW8qK/00f0ouw3iFBYGETlSEpAocOAhtvga7GNWrnOOR6GfqxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719235; c=relaxed/simple;
	bh=YZUuYb54WIHNFW23LY+BZ5ZARcmbbwnYju0TEMo8K+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgD1dKzZt9so+D/A3crJAlc08d0sues80mI+amUVUNxtlqq1SLDDx4h2Db0qR2vIsENu02O2iOSBxS732zWVLMr26/zoKlF6Wlubb1mx71DIpqNJ45BYckzjYlaOSCdtaXLntAznogtHjF2Pd9/SKts7M4T/ge51ObPxa7Z9OTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MM3j3CUE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MM3j3CUE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YLnFo75sYEsR/ep9dgjWExiQBsWGuxdr5oC6xFt6GqQ=; b=MM3j3CUEiqX7C6wUjmNnroyj/I
	1chmMLgc23Xa90+2GeakAY2nCfXN4/dpY/9dpzNBsYaUqkbusVrgKTcHoFCvotItEFUmRDYsSpfwn
	JAWqhKYoAxn3S2kVDmO6qbo8Yz31Wum1qxijgxq2fe7YEG3zFePyoss0KOjo3MjC6ERLolWKMn1HD
	ourJARPPeDdfqczYFng3ATfGIWi6uId5TZeg1sl2UgljAjyaRTYUKQr8W3kKZt5/pzFYZ0Yl9sS2W
	6bOnbdMFEu7bSKTOamymD8TCocTYW6uAr9ML9g6o1PoFguyyseRHfdXYxyYKbn8ZOY3q9vCdVVG6a
	VUOMZeUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9Fh-00000001uqh-22rF;
	Thu, 05 Mar 2026 14:00:33 +0000
Date: Thu, 5 Mar 2026 06:00:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <aamMgR3n4LULfgT1@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
 <aacDkSiRLgD1k3Tg@infradead.org>
 <20260303172654.GQ57948@frogsfrogsfrogs>
 <aagtnm0-z3ldfFqd@infradead.org>
 <20260304163020.GU57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304163020.GU57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 08:30:20AM -0800, Darrick J. Wong wrote:
> Yeah.  I tried creating a(nother) anon_inode that has the same sort of
> weak link to the xfs_mount that the healthmon fd has, for the purpose of
> forwarding scrub ioctls.  That got twisty fast because the scrub code
> wants to be able to call things like mnt_want_write_file and file_inode,
> but the file doesn't point to an xfs inode and abusing the anon inode
> file to make that work just became too gross to stomach. :/

Yeah, don't see how that work.  I guess IFF we wanted that it would
have to be a VFS-level weak FD concept, and that seems out of scope for
this at the moment unfortunately.

