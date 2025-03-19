Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BCF24EA9C
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 06:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742365880; cv=none; b=m3rtYns1FitEyATqQrvF/Sylq/o/Ax1f+ay/TZJZ/yDrKGerjtiDvkEZh/G3P/eqsZjccjf5uOjMcOD9NF8dVsQuOany5wIfr8H9Bb3kiA7FvfLlMxsYgX7yCmM5grTqj8V6qyBXYWavW64h6yk276tzJfk5ioCgMklfaLLscLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742365880; c=relaxed/simple;
	bh=RnrzGnSeywOqy9bOaSfykdeSOz9ogIIYrXsZtC1Nz7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hB4IIUV9Bwx6tNY1zJOfSG1bkJ+W319ZxYODCkkiIjuABsFnV2CRuC2dkWkvi45/9pn/5LKM8JGncOnIlh2lVEahnQ3CpBUOMo2nqmGq0lYRiNJsxEyUDp8BBgNAUTkRtYIb4wV8pE8JcIOY8+obveKCAGQD04nKUbNlsQocV+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C0D9C68C7B; Wed, 19 Mar 2025 07:31:13 +0100 (CET)
Date: Wed, 19 Mar 2025 07:31:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250319063113.GA23743@lst.de>
References: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 18, 2025 at 11:40:47AM +0300, Dan Carpenter wrote:
> Hello Christoph Hellwig,
> 
> Commit e2874632a621 ("xfs: use vmalloc instead of vm_map_area for
> buffer backing memory") from Mar 10, 2025 (linux-next), leads to the
> following Smatch static checker warning:

Just a question to reconfirm how smatch works:  the vm_unmap_ram
replaced by vfree in this patch also had a might_sleep(), so I think
this bug is older and the check should have also triggeted before.
Or am I missing something?

