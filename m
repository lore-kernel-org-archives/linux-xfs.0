Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1593E1AE005
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081040; cv=none; b=rF0Oi9UfFBhewgdl3pzV10Lzw/jPXYFAqhgKD9mTs6NNeZ2jsFeVzMh06aFsZcjDR920Uyb/6LYiuqUXIhJ+1gxfDLjgm8RV/43BN4LYhd+VFt+fGWWasjHeKsJN2XPfUMzJ/OqKYFvowoSGd+Dn9usUheTrxJg6v41vg5rCbAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081040; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5rJkjvhDb2TRZ6VTIfB9Ub+3LA1gzvSBbLCjWtdN7V+J4+/M3FSVLRiUXNO4GgBbBwjShjxjXjWUh7jNb0IvqR9Lb2qmMF1FheQwERR4zzxdWnFXlkL32gpQbCVdbygPo1qK7i5Uag/sRu3CVzRVpqsG9dkb7AqXEj5xmKmmu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3WopnUla; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3WopnUla"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3WopnUla8taUUYG8eabSfCBJTh
	EyPOR2AOCf5ic8IArrfFg1oQ16osub4Ga54h5DAfkuINhoTwG/tYCMiLt5S9dV08PU19QVdyeGk3Q
	Pnetyr8BpUw/sNJ3xznHS2onVppbEaS+99HP9UQcVmWm0A7Ui1QSz/H9MSxhka1XY4fyvyo2GZPP+
	iDzJWBgoMS7HnA1zPAUcTkWrl0ZPhsIA1qoSG1CpOJefjpqOHD3QOFLwi6UiJ75ynLd0NNLrCuvhD
	1zVMk0orLayS9RooOtWQPCMCskJevGdSV+ERgDqOwR2x/Q5O46JZCTuXHZBlz4dCbWwJ8AwjuKqJT
	EHU6KW3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1h0-00000003C7H-32is;
	Fri, 13 Dec 2024 09:10:38 +0000
Date: Fri, 13 Dec 2024 01:10:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/43] xfs: add realtime refcount btree block detection
 to log recovery
Message-ID: <Z1v6DqiD7LaZ7c-5@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124722.1182620.17398362509623993412.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124722.1182620.17398362509623993412.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

