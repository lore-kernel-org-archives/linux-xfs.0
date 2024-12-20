Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE525765
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676919; cv=none; b=ey791j4qB5i6XSabMCfFDUji+oUC2HPrHkjChzmWjc/w/Mo+ZOoPR6BPIDfLB+dksuPdGc6d0VBzfr2qidvvGGc/scyIRj3xO32FRv9sCxMI/TG7vrHZbqh32iV8noRcfh9tEGHYKdymETO/CY3fUaDYoWqGjNJIau7VbckIADs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676919; c=relaxed/simple;
	bh=x9uSHYehEVrex1NftIhxvXw4etQnXOhm0Qg7ZNujA/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/KTcyJXhPwe+6T+p0yWeC/jqsytlD5eOQCMpaPOU3P/2rLuvTXrKcmTx7Y/qLf05GhjoMjhYNtsECRF3UYY/+LflcbbE8/brq8+q+ln/N4XCirbJC4CEC5qFmTbdiqeSlPin0YhEVWHOm39tNFT7Uzq8FLWZV0oCFLitCqLcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xIhb9Ni4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xIhb9Ni4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RXgTMagyMK32zN3uZGz4FSGqjVJdUmVyGApbVv8ygmA=; b=xIhb9Ni47g3IAJfeGlgkyX9UV0
	frRUVe9hqwuXUJ3RffxGwUQjGIK6SVovA+6rF4L3Wz0Vlc/UoFjztLqqXx+31KQr3PVKrYeacp3U2
	908LaiQn460r9EokTsfH4CDfmR33qMIed2PRU9eQ0Wqoupu74oeC+FT04GJGDQHPwIZEaqD0/eZPE
	3AN05qxX3Gy30Inayp0HNXQJQDaQ9JpJQ+k9lZGgbQj24pD8lQAvwJZvu3XT5oL3evywHQi4CPWA5
	5h3e2cvKsbeXJM2xL8NVo99IGp1jiomFnicp8LzCH8bjGHZ/5Sl8fInMDhfkzBxDYw3W9QJiMtk5D
	rsGTaU+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWhx-0000000471S-3fJz;
	Fri, 20 Dec 2024 06:41:57 +0000
Date: Thu, 19 Dec 2024 22:41:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 36/37] xfs: react to fsdax failure notifications on the
 rt device
Message-ID: <Z2URtRqZYwlAiwwZ@infradead.org>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
 <173463580376.1571512.13084612178987057437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463580376.1571512.13084612178987057437.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 19, 2024 at 11:32:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have reverse mapping for the realtime device, use the
> information to kill processes that have mappings to bad pmem.  This
> requires refactoring the existing routines to handle rtgroups or AGs;
> and splitting out the translation function to improve cohesion.
> Also make a proper header file for the dax holder ops.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

