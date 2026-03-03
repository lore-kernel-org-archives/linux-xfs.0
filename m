Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A681891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552750; cv=none; b=smSDnD2Yrrc3wO9DjXgjCRFkdtEDl/yn8g5NAt6L5ZryCylmHO11Lmd6SkKVYuhB7oL+a5S/CT9mGOZIL2v0Nss+gQZqZVM6pCaL0HzlhMTzgP/64oD9SCdxOtHwM9daiO6gpZlv5MwzDTEqmNozjZPDViaNvDFviFcN+H1xdAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552750; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5kVe0w83NRLA/0wSnV35wQioLEbSI3hFkAGMcNSsusvkBbGtDJv9fwv54Sc9eof+YJv6Ayge4DEYT0RL8zVKilNb3VxhFy2e16PmJfyzshY/zdIyxCjFIXNHCF3LDxvQ+FUMXFKiR9HlHRmPhd7s5vC+VMgdK60YCuW5MWOaf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HOv9V5Oh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HOv9V5Oh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HOv9V5Oh14D+D8bl+CzEiMUafn
	3JNO8pbSu3rVfLEFGwEa3U6oLMDpsRIHVAllxtKJZCxCbdi6LjxG78Q6+fE8d0yaRH6xv3+umYP8F
	+xsExQjH5H0PPg5yWU9CX2rGClgBB+dBdlkRdd0MZ+Lt0HCosnToNhzy2yAeI7kw8uMp1yPK+r1ae
	H5XeLBNtU4ZkEj4zi7IsV3LMN7/VyuG9iD8JMHKUqEpZbR979mEqHPK8tSdodGljR82uhBEe96SF4
	EWtnjajgvSbrb2yTGBw0nXwtvmlQLSuHqjgDs1Z4iCDk2xqVcBz7uwjIvhpJlt3qAAC7atLmxBLGB
	kBnP7hew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRwT-0000000FS7L-1vNz;
	Tue, 03 Mar 2026 15:45:49 +0000
Date: Tue, 3 Mar 2026 07:45:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] libfrog: hoist a couple of service helper functions
Message-ID: <aacCLSRSGYnXKy__@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783366.482027.6931104577818307338.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783366.482027.6931104577818307338.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
