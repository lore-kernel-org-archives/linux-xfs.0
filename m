Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FF04CB41
	for <linux-xfs@vger.kernel.org>; Sat,  3 Feb 2024 07:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706946297; cv=none; b=YmbjyG7GsX5BdEPI7P927UXocuUmp4ML5gBI7pHT8sI4inI9l2+1XhkbxHYNUs90GZgb9tjHMutG0e+/M8LSBWEPx+4JuNZRwaiuTgN4o/N6DFomxR+Cb2xUR36qD/f+MCLwk/EVqDBYhSu0DxjHS+pI53shK9RbStPLsOwy1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706946297; c=relaxed/simple;
	bh=b1HuzqDgLACR2sMIUEHkiIaVVkQO8vTjfSVFvbKfhPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGPnlCwa5GtQLflg/NGzhkBp+G5DMKHBSV2AIEbPd7S/M9zlTIt4hrxuuizliTp7f3yiZ3A4WGUc9UCvOPr0tC+V1gHbHJmLZJ0HP0HvsJlV5VYJFvzFUKVVtBcG95XX4K+xf1QiYNpRdN0JE60nIGy0zQ93cgj+ZabCzBz4iDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C9DA68AFE; Sat,  3 Feb 2024 08:44:45 +0100 (CET)
Date: Sat, 3 Feb 2024 08:44:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sam James <sam@gentoo.org>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/27] configure: don't check for mallinfo
Message-ID: <20240203074445.GA18531@lst.de>
References: <20240129073215.108519-24-hch@lst.de> <87cytfcqkd.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cytfcqkd.fsf@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 02, 2024 at 06:44:31AM +0000, Sam James wrote:
> musl doesn't support mallinfo* (as it's kind of nasty anyway - exposing
> allocator internals), so this won't work there.

Well, we can drop the patch then, the following ons apply fine without
it.
