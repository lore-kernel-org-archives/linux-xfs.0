Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80419478
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714623219; cv=none; b=k/4Fjy8lfPHKNIn1rzdO1C6lRaoLfyIk/KyWU6LWAhgp83GSTV+W4Zfcl5MLn5mfPCymo3P5L5StCacZbrLiu56mtH5IKlR0xFv73hq95pkdPOdkPwQbQl5UDk4ZHoECF7HdBnHyAsgWB6StM8YE1Z1+Hk8Hc9uucN2OxYxHbiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714623219; c=relaxed/simple;
	bh=+CsqRCvdicFfkiDdqDRTzAiWco+i7xI26h2WPD55jaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqt/sQsvsX9V5kccr3C8RGV7vlCsBhizcglxMtj6JzkIWrms/VvPk+6lRAYJfWOC4L7e/HTQpIVYckR31m0nYW1cybTLMgIsYH4JaI5BBWm2sd2kLlnyVy6GA+6Lrid+B45S6Qo/aJBePcTItDxtKdOkOAWcSlHuzlJ1uawZE7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9FF3227A87; Thu,  2 May 2024 06:13:25 +0200 (CEST)
Date: Thu, 2 May 2024 06:13:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: optimize removing the last 8-byte inode
 from a shortform directory
Message-ID: <20240502041325.GA26601@lst.de>
References: <20240430124926.1775355-1-hch@lst.de> <20240430124926.1775355-11-hch@lst.de> <20240501212519.GY360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501212519.GY360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 02:25:19PM -0700, Darrick J. Wong wrote:
> What happens if a shortform directory contains two entries to the same
> file?  I think @remove really means that the caller has verified that
> the sf directory only contains one link @args->inumber?  If that's so,
> then the comment for this function should say that.

No, I don't think there is such a validation.  But given that i8count is
1 and the entry we are removing has a 4-byte inode when we call this,
we can't by definition have two entries pointing to this inode, as then
i8count would be 2.

But I only thought about that now, and is is far to subtle (and I need
to check if the above is true for whiteouts).  I'll either clearly
document it, or change it to a name comparison.

