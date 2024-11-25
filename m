Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE0513CFA6;
	Mon, 25 Nov 2024 05:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511608; cv=none; b=B7LwqnXvbpGbrK8SpJa/i4qmVNQ4eRO32BdLad0AMLEHxn8nnDAeNeSu7YBkJVsQiSX9tYS5/Jv9kzRHRnyIA2rp3Dn6HcSegAr0x52a95exOxbbYL0QTBwpInEExmR5l1Dka7twe0cCfpBUNsObmU+T8bUYZWnbGVOxocz335c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511608; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKHZf5ee480GqN5h/2SQq9bpTs4OEDgGfoU/9/+Vi9e8MONNxZMPna3xWqFtsNUKCLdskmwW0Y6MJhIGuVCCbx3F/sOIVDtSK8OvyKJAayKalWAF082Ec6Wu1fijAU4/JfJHn9Xoxw6ooTueCP2u3G0VyGhiGYbPJTFyVcH3zh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mpoupo6X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mpoupo6X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Mpoupo6Xd30VTosutW8QMXSB41
	eMyGUnWo8sMqPIJKh/yYXV0bpG+fHacMpJCIS7LAKaH4hWTJjDMLd4X8Ssml9LFRoZSoAnGTbxj23
	KON6f44JzYT18lQhK8CoAdlRYIC3kfDTmkMe/ypZGbd4kHoD1lbalROyvqqqwfJT1J0CV8twr0crz
	N4f7Nogr+RZTxJSCnojV5HbFtMHTdn3BpbLlhCnhudb9D7YZUgMuMAN3KVmWsHu/5lFX/oxIki3gI
	hD2qfGZPU1KeY3TlgR1exUTZpZCBqM5JJK7O4q3lw8UyqvPamczgOypE+h7ZVjKwWHAGRYfxqLExC
	uYirNLuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRPb-000000074hI-14el;
	Mon, 25 Nov 2024 05:13:27 +0000
Date: Sun, 24 Nov 2024 21:13:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/17] xfs/508: fix test for 64k blocksize
Message-ID: <Z0QHd5I_V5Yemx8z@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420117.358248.8488570912527103936.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420117.358248.8488570912527103936.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

