Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3043B51C051;
	Tue, 29 Sep 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695492; cv=none; b=Cj1CpaS5I7XUGVc4eDFgggu8UwdzEME74qrgKzdmg2v+zStLeC/uFkbdiFf5tFq9L8oOjuRjqfmyU4yKjTOG5ewcNtsaZUxiYBOuS7t5FaZB8Ko7N1H1T+kAVG19smQrDcvRL4fLCRowjs9UEY2hAi1ihABYXdAjN5dRVQjjAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695492; c=relaxed/simple;
	bh=ZDqZqmnMst3K8Jzxe3rL6b+elVo2g/TGtXfuKVsq5yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZWrN6f6+auiEqbx2zw7ngasod+5qFbYrcKG9b8K12k472zHj7ZXcUa+5fQTuNxmw1koIIELKE06EKKDnbP060F+6UYGcfB6uw8cphtY9UWlPZiLDvwfmmR0UhPkAcszcwkCGuO0nduBAQAalQ5bJzedLKK+XT54Mot+uOqSeuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGCnxWEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGCnxWEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A441F000FF;
	Tue, 29 Sep 2026 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790695481;
	bh=pteoo/CBdjXRMEqghzMR/7447w1JwyP7h5pRKHXM3i8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TGCnxWEh3M5kkR4lxN7gvH7QxY5HOe211BrA1GhdsIbT02tDvlF31R3HuuoI4sXmo
	 +GH45QI8hh/J+M6ShB4ov1NaAxh7jYPbNDliqgno0128KzgA1YeKA7cfC7KxJtToDI
	 b4APFUCP8q9HzyypcpSAuyomcvRAtM/A4YadqK+VKUroHSD8KrEPSWt9cxS1jF76jd
	 sSL65MpW7KTIkZs6Bkfgy8L0FTFKYPBnRUA06OioTdAqpX8+lvGiEaWfxuclmEXmm+
	 hvl/O8nl20vZdbKUqmcfgZ5Ai8pb6XKMF1Sz5pkPuzYm2urJbVj7TS0GO1n2wUaCBu
	 GHVI6aktNtY6g==
Date: Tue, 29 Sep 2026 17:24:37 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: use bio_complete_in_task for buffered simple
 dio read failures
Message-ID: <arvYJ6euWIjtdHqy@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-4-hch@lst.de>

On 2026-09-28 11:11:09, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
