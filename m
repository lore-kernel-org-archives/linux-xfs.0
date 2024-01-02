Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D1DDA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZbKMmHH4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cgf2i3T5BD8Ipv0sRzrCd4sNoHjnlvjDtyfryuCVKqg=; b=ZbKMmHH4Oi6OQy4mxVDuNEnDXV
	37gijVMfUKEyh25mRqyj74oJnCmiuMYBot7WEv0UhtVKOtT5okOaEzQxMuHmW26KgtX8ltwlbt4ba
	Bd3YC5vETFWjUmHOz1pMUbn6EQSQNHLkDTTIEn6S4tA0KXurQcVdImEEphP/hhrBtcHqxIKb0ds7P
	P4DgiHPaZ7wJGN82oZ+UcTEQF8lLfUtQlghx5qCF6EJiZa7jMY0fB7LYDeHZkZtJFrNE8tUZ86hAA
	xOzYAtqz4AQC0M7iretOGt7Ib85TDCEgfocm57FKC4HWUC1gncTN8ChO39sNIxeb6Z3mtOVkmx29H
	UVxZyuIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcDo-007d9A-0l;
	Tue, 02 Jan 2024 10:42:08 +0000
Date: Tue, 2 Jan 2024 02:42:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create refcount bag structure for btree repairs
Message-ID: <ZZPogM0Z3tpRW1r6@infradead.org>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831054.1749557.2525900741908980674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831054.1749557.2525900741908980674.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:20:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a bag structure for refcount information that uses the refcount
> bag btree defined in the previous patch.

Same commit log information comment as for the previous patch here.
