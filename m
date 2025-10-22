Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4A71E00A0;
	Wed, 22 Oct 2025 04:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106698; cv=none; b=BkFTfkmh8Z77wwks3xxQ+yCDS37I36v+RBh1zLAqmKXCiCWnXfQITC4HV7Eh1k0p37g0FoZgBN0XUVsltqjWAUTJr276+h1tCGFHYGpxRdjVZ20Mr3QKrfd13FkixThNp5nAABewhWXXPnGBXBVzzh3Ww+UTZi+Evll3OY8yo2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106698; c=relaxed/simple;
	bh=2qU3Ve7h//LS/NTkdGSeKalbtsVSXFyXl2q3m9u/oO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEUTSOhzGRlxDnhYzxtEIwxhRS0OiLFvMVMhHGOu4dajqJRPVfJIFM+ONPA9eptltPdNesFAgPYGrGC8JVsoebkwru+Ob4xFBhFnU2OpY+DdGQKskjibKyksya0NGkiNMrC51E1BLVEug+7bGDMZ6G7oWRormxtckWHn8oSkpyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G7uReDee; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G7uReDee"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eT1O9g1FddY++a39RdyG2ghN8mn4i2bBrIEk8RH5sQk=; b=G7uReDee+xaTUEfmCGeUvO342v
	xZNPzgcXc+OCEdO/2LkmzlZFMTfnCjxp5zPhPIDf2jdfLufEBvlKtRmZp2WGCD9vhjDWepTrvoodf
	uqFvEZzXBRatctAqkGkb6OC1wyfwqD5QG3HHyiaHSS9lkgVaspDMSWFClEXzfhzecWw4woiOAC/Co
	fikRFABPmCJTp15H1KvZ4WveUcqRg6LdGNOpgd8tKGk9+De87Iy+7chylGxhly/Oy5HsSyFXA0PQA
	2CGRks8eayorhvFF1TmWk+Z48MXTdkkXrnRL8MrvNR7OZm+OD2rXIxgDwnGht6B+xQ7k6E2viA12R
	xMXCuktQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQIi-00000001Q0O-28JL;
	Wed, 22 Oct 2025 04:18:16 +0000
Date: Tue, 21 Oct 2025 21:18:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] common/filter: fix _filter_file_attributes to
 handle src/file_attr.c file flags
Message-ID: <aPhbCKGUsM182Hvi@infradead.org>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188777.4163693.5636086769178869317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107188777.4163693.5636086769178869317.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 21, 2025 at 11:40:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, _filter_file_attributes filters ext4 lsattr flags, but it's
> only callers (all introduced in 4eb4017) are using it to filter the file
> attribute letters from src/file_attr.c.  These correspond to the flags
> defined by the new file_getattr system call, so let's rename the helper
> to make it clear we're filtering *VFS* attribute characters, and change
> the code to filter all known characters from that interface.

Thanks, with this commit message even me understands what's going on now
:)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
