Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D811618E057
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435737; cv=none; b=ZVBKy9tIrKiKlsteNmc9xLPqVHi2vjLbqZbdOT1LuX7KhzSki234xyA6ZOiFDfpDfltlUhLEVKD+LmDnh0+LLU0ymQHqPsOpSqjZohq458ng9iL+urawzAGshm1TNdHYpP40WXBRskEoZYjLhTd0UhuAMf9oHlYLOLH1HpQgmo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435737; c=relaxed/simple;
	bh=ZCcEQCrreyDhCtuE8aVVXALmTFYEj55Zqi+HgarkWvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EONvAiHgpqnnmDxr6QP/CCOKtxAVYRgEG6XdUwEWgQt9/RtzYwp+7m2+W2KBarWd8Bf61OB1Td2F6i7/OOmKbF/fQ50D9vb/mEwABpQdFFMwKi+sMIo2zAHUS2OeH1K1CkkcSAvckn9XfGvhw32KDXGQPEsPlSbK0pxQAbpwC8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgOH7vir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgOH7vir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577B7C32786;
	Fri, 23 Aug 2024 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724435737;
	bh=ZCcEQCrreyDhCtuE8aVVXALmTFYEj55Zqi+HgarkWvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgOH7virJq4vUjATxt8oeyAzUetibJY+OA1j3VUtMlGmfrYACwM4xju8GYUK3Y2XM
	 vDaS7GGzTi63kU5fIwM+rDRZ/XI2gvkyw4aGCWHoHpiMCTdhPs5DSuZ8m0TDvDzYJw
	 o0V9b1IbxkqG2mO8ddbqoYENQqBjVYyNLdW6KdGBu8od0kAKqOqQ5eFHasX+7Nm1CQ
	 8UQVjl0Jx82ER/izryKuO8CS43MOfeAGFzZKNdqjiAHirlYRxDidVd/ZMm6H5jDUEQ
	 e2UKrZ94Dw2Cwc0UWMBN3zSjkdmdUdKVHjpWYYOOjT4rnC0sMojSufdMjFvSFg8u4E
	 ckwA0I4G/fMGA==
Date: Fri, 23 Aug 2024 10:55:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs: enforce metadata inode flag
Message-ID: <20240823175536.GM865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085258.57482.14715560733408039930.stgit@frogsfrogsfrogs>
 <ZsgSKIpnSEYQKWRB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgSKIpnSEYQKWRB@infradead.org>

On Thu, Aug 22, 2024 at 09:38:00PM -0700, Christoph Hellwig wrote:
> > +	/* Mandatory directory flags must be set */
> 
> s/directory/inode/ ?
> 
> > +/* All metadata directory files must have these flags set. */
> 
> s/directory files/directories/ ?

Fixed.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
