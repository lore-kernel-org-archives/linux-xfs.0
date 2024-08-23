Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FACA4DA00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724392382; cv=none; b=P1O3RA2J1iPXmLJN8aPc5qe/o/mGI9TffFO9U2g0RjZoyeljU+JMslLRFOLjSrIB3voaJYcUHRY8f+qmegzacpzYyidQRYkiXO6jjPh4MUIK2IaZyXkmITfvIznlsDQVWo0KN9kh49KhJ5D9idEtyzHzbJJpOnewCedIgonE5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724392382; c=relaxed/simple;
	bh=LxxbTiP7PKfl7L9FCE31YSgEQCKfa5DVS3D0+iXc0cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ke2MtopLzil2zKx+UjpHenUMdGimmPFsZ1Kfyfv/a4Dry5wJbZhJpJ6bL2MOaiyJJVhnDhDARNvOjdETTbhLX/OtqK7TiNm48x8m0L5WqpnIjG6wntr/jCLsigs3m0WhZd3ySD+UW8gJFIhp9jO1repdHWSPthdh8SvmnwEEHcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mq5zUU4I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mq5zUU4I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WvDoXBsWanKJ/iESAF91LPUBpKjM7+Z6LVy/pGl4obg=; b=mq5zUU4ILlPYVO3cMohmO5K/EA
	d19Ly9rGID/TscSKTl6FnGOzTIMQxJidh9X9KjfAK7oAdtS1aqiMNCrOCl1G1RkEeWW/tfpj+tS8X
	Urqgrv+hKuHNzHrm0B0VII1QqEcWI56ETQKbt4ZjwmPaxw5Zn23nC2kAqfveAgcCywb3jTCY6aFSG
	l47Bz/ThUTQ/pI/TLDiJXmhpjhnk+zSe57/X0f7v4LRmBtoiTMQbY152XbMRy+L/eTIMFBgfG86Pk
	5H32Uptv+QqRXX69zQZLnnHkhbuNUTmRVjOeDscFz9LV5iRxr8zfW7As0bB0/yCPs5Luh5QsxXCZi
	DklNlgKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shNEK-0000000FNFf-3YqP;
	Fri, 23 Aug 2024 05:53:00 +0000
Date: Thu, 22 Aug 2024 22:53:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: use metadir for quota inodes
Message-ID: <ZsgjvJFjZMHg0Fil@infradead.org>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089397.61495.2669421430531282333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437089397.61495.2669421430531282333.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:28:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Store the quota inodes in a metadata directory if metadir is enabled.

I think this commit log could explain a bit better what this means
and why it is done.

Otherwis looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
