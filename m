Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C371F3DB64A;
	Tue, 29 Sep 2026 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695448; cv=none; b=KhbPgOA/z9WVm0A/MaK8Fggakv2ndnMW9u5GkAwWD8UYsV9C0IbkI6bGBmpg00rt8rsmAhdxROGQiylRh4prOdFKClmlJmNHE6W56dz/juKY4S1Z4VZGpe2c7zPio2ruKLh21QdhAw114UPI/WR/qaP8lyqpuy0bYnfiNxn0KkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695448; c=relaxed/simple;
	bh=Oma8EugSpwVvl9VLVpEFV7N/TrhDINdMTb+aEghf1ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAhD3afU3g6u/Xs3vxmZ3ZWqLR1/gBIllQ8rIsm6XWAw3OhgYiqUuvxWKtS4tt6jGLUwmPuhPziDiX0/NPFQlk9IFIdSKCjEiVbpN8yUF2qj2mQaZuC+oKOdrBokSRCXHnbaKd6xMP9ThFKxSs+JrD30zF7PO9MWtvhhdlVeB4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7Hw9HEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7Hw9HEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3671F000FF;
	Tue, 29 Sep 2026 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790695437;
	bh=IxiHJmueuhGXyxQnVm3o4Jy27/xJsYP3K0qkK++uqdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O7Hw9HEBAv/t5iJpHI4k7nOw53hpFLlroMuhxVudgyLLp0RrAxN88/oVpI4gaOgu3
	 Ty6WnKhSeX66kX7i96MbUdp88y/aqI1gmY33io29NSWfpY1PHAklEHf3IhyswwYww3
	 QTY/suLMHYQJKZ+18FW98l01PWHKNEeb4yRBHg5z0ywZZfLqRv82V20IVS7Xz/QPO9
	 euLVwSB79EMgOa2lU2uuAR3q6uFwo62S5GSxK/EkH85Ucmi+0bSKZhKQZDlzsVxZLm
	 4gcSNCTHn7E3bnDxdLMwUoHAqhLJJ8unLngPAfbALQvjqeNUfw7N648AHeLIfpskeD
	 inFURbAuTSESA==
Date: Tue, 29 Sep 2026 17:23:54 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: use bio_complete_in_task for buffered read
 failures
Message-ID: <arvXsExocnkUa2TT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-2-hch@lst.de>

On 2026-09-28 11:11:07, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
