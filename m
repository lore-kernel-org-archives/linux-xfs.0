Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6CD1E0B86
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771484880; cv=none; b=K8YDvGAxh0bUvH9F0K5xJFLzRJwv5392fCcjJ7xWCZ1WQ6GSAU1ws5bIexMeBb2kNVGnjhrsOEbjQlV3qwumZ0L31TFvftjThXjavUjP+ZninwzTRsi/0NHwl21MSpaNuXJjCEhnRWAYE/ogyE/KikUbjjknbaD37ZCiiGGYGFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771484880; c=relaxed/simple;
	bh=tEw4U0dgABPEGTAGoyvOLcd3YvUPyCEA+rjI5b/cqmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCt9+7eEued5RCQEyRuk9VKPW4L2v337MG+mZkG1sVi9kYT5yCmY7SuZItqa3JjPxwPOJy7Sn2/xqhEbtWPBP0hM+C78F9AMFHRUUgjz9Txfi/CV9FQ9SH0Dzp6N1Upu7ebVeDHAJhrGjf3WeYYh+39C3GV/52n9mOf08xZn3SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LJRCZtuq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LJRCZtuq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8l+88Sgx29mJQOFWMYQc9zdFc9MXGJvSzxsbHgAquo8=; b=LJRCZtuqy5cZj6afNMx3vA+yt1
	4KjxR6urexlSIvMdQGIB0oOF85D00blSo1UFUiQleQKrH0ZcrIvQg7SB9ZUP5HGcApqhQB7tGucny
	9CGIaREf40y+W4x5hwqgQXzvZLL3xhXyYM9f8GYwWDs1lYteDY+AedNK2fs3PrDQ3rhC6Ybt3KG7p
	h35MxNXlXsLHN87eo5vQ8la7gcGlfyPJnOcnV0pvvjWh9O8D4xJ4CTiG+u4Ftkj6y9UDVE9oGprNy
	F0q82wQ9ewS+QAjcsTS+aBvAQQdoiwtHFdfqxTiW6o5vrnPBFQLa2z1mNPza45C4QCYzXldh+EMks
	EJABmO0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsy8l-0000000B0Un-0uLS;
	Thu, 19 Feb 2026 07:07:59 +0000
Date: Wed, 18 Feb 2026 23:07:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Message-ID: <aZa2z60j4_WJFOxX@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUEKzVBn5re9JG@infradead.org>
 <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
 <aZav-QE1L87CKq5L@infradead.org>
 <fd8be071-55ce-484d-872b-aaf5eeab1138@gmail.com>
 <aZay6Zub8PFPrQq1@infradead.org>
 <c58134bd-5060-4335-afaa-84fabe9c101c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c58134bd-5060-4335-afaa-84fabe9c101c@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 19, 2026 at 12:35:49PM +0530, Nirjhar Roy (IBM) wrote:
> Okay, got it. Thank you for the explanation. So I guess the reason for
> always keeping lazy counters enabled is for performance? So that on every
> update of the counters, we don't go to the disk and increase latency?

Yes.  They are generally a much better scheme, but it took the XFS
developers a while to figure that out :)

