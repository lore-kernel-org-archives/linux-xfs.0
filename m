Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1AA20127D;
	Thu,  1 May 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111770; cv=none; b=WAk85SttfMSCSx55J2r3zm6OIs/Zp18M++sm894RTQ8g3d1jfSldTrSSSgS3PIhzciE4pIVFb8C+1z8Dx0ETTDLXdieMKwgEDfwz1caimOxDlReVY1oAkUZ1U0CW9RGwQZA/9iEsYlS1C75xj+bnTLYpqEZmPDxtDU5t4ceB7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111770; c=relaxed/simple;
	bh=lISCMhmMFm7JrXmVTOzkdrxJOfIqoUMImxdgZCY08/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfAwyu8RMsmQJtqBbOTBGfaIwOIGfx4u/KEbpEQfbl8K1suEdy/yqZSUyesnRnZQ6+ZjK7ydUPogQnny0BjRSVkrzas11n4k62KGbu/rsBBVgT88oM52GpBiAhZRCnsOIJ9dhWALnIbaRJdEV7AhxK6YEz5g8zyPN57b2Ooe0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F45TMQmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F45TMQmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075F1C4CEE3;
	Thu,  1 May 2025 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746111770;
	bh=lISCMhmMFm7JrXmVTOzkdrxJOfIqoUMImxdgZCY08/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F45TMQmp/U5SCQUymxwpmFtv+ZXcFqHnHHILmodnEiIGQN1aqN5CUPJp4VePjP1V2
	 YCAb606VIwr+AlvVT8FIesmNInUqqaPCkztHV7LHJV9C3BtUl5S3y+G+YwCmvK1aRI
	 HmDRrU8f5IzS2lVR8q3YD3hiXjvkZZ7COy+BqBMETlHrUnZxy3qMoghhRYjtrsRo+n
	 nSQxlx4bGZSX5Y+pqEHUL7N37P5EVNGh5ZIJ3A414AebkUxAlGpVIccIUd4oOkv8qP
	 1d2b9bxCA4arQ/AIBJcB4W+dy803okQK2oltvwpOP+V6/04QkvpiUld5/W2iQZbQrY
	 +WZelauFFBJtg==
Date: Thu, 1 May 2025 08:02:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: finishe xfstests support for zoned XFS
Message-ID: <20250501150249.GN25667@frogsfrogsfrogs>
References: <20250501133900.2880958-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501133900.2880958-1-hch@lst.de>

On Thu, May 01, 2025 at 08:38:54AM -0500, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds the remaining core bits to support zoned XFS file
> systems, to go along with the kernel code in 6.15-rc and the xfsprogs
> series on the list.  It does not include several newly developed
> test cases which will be sent separately.

The series looks ok (by which I mean I've been running this for weeks
with no issues) so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

