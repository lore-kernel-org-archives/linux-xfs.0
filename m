Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16799DF4F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a9EvJ9hG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f723zMd+AAYMGjxNz1Pf6rUx7HDylhP6CB/iqw9VxCY=; b=a9EvJ9hG9LZH393LkAT7hF77VB
	/Faf55SLjUy44HJ48OtJxTH+8XIRAgvvG47UsnoSKaS5NOaF2rES4D1Wbfvv8F48XOYTPzSOVuJG6
	VOi9JDTgwwhx2GzaqGRigiwSE8uWglQDaJnRmKlRN8X73BLLHvHRhWpgH5BKLAFQ0sfItqSXbb07X
	WuSNJgDhjj93cjxrRAuyMuBI1EhNz3BpHGa5xOn6Br1nlSrrkCXSHDM67vwXnyjy6PHvUoB5B/t93
	j4X1M/TS7I/uN27wfjJ4QAmp8+DLaj23Af1TQJUK9O+yofUpsCAvCHxXuUcfISOIFJUQMIuF0XPWc
	rk8uqYiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKciA-007gVM-1j;
	Tue, 02 Jan 2024 11:13:30 +0000
Date: Tue, 2 Jan 2024 03:13:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create a macro for decoding ftypes in
 tracepoints
Message-ID: <ZZPv2kzw5mr38RE1@infradead.org>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827020.1747851.3610479881365181597.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827020.1747851.3610479881365181597.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:07:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
> strings instead of numbers in tracepoints.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But why not fold this into the patch actually using the macro?
