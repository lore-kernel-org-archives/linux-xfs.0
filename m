Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="InsJykVB"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC1F5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xe/Jt6B9PFGfn5uYutibaBdvKvpyrEpbr0Z+8V6ghHE=; b=InsJykVBxGUoFjZPhpbR9xMds1
	KgxTdIZvGGwK/W3XCWBKvDj6yf6ycqvR+i++4XI42b4OaqJf5OAWt5SSzfa8xOK/DfZoQ3BNKPfWM
	m0fzlE2GqeyaTpCpn4VX9Y8hmwhxXqB97BLWCZ5HzS7DcG8JYocTYJUFcq4+oim4V7SNavzwnHyFP
	ih70Tfo2mX0z6jPO/UfrAC2DI9KztrMfNTAj8aAQsAaC9uV2ZNjy/ipvU1hIiT8d9fQz5/INkrHOW
	/Xnphvu5PDE0/I7cZbSwfBchnb1h2hsLF7p+UfIewA7d3CDVhXwj4Pi/bz8NcQmEEdLg4Vm2vWdWe
	18hKV7Ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdcN-00GjdB-2I;
	Thu, 14 Dec 2023 04:46:39 +0000
Date: Wed, 13 Dec 2023 20:46:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: dont cast to char * for XFS_DFORK_*PTR macros
Message-ID: <ZXqIr3tyUB1+NmSL@infradead.org>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
 <170250783531.1399182.12180413015033895645.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250783531.1399182.12180413015033895645.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 13, 2023 at 02:54:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Code in the next patch will assign the return value of XFS_DFORK_*PTR
> macros to a struct pointer.  gcc complains about casting char* strings
> to struct pointers, so let's fix the macro's cast to void* to shut up
> the warnings.
> 
> While we're at it, fix one of the scrub tests that uses PTR to use BOFF
> instead for a simpler integer comparison, since other linters whine
> about char* and void* comparisons.

Well, comparing different point types should be reject even by the
compiler.  But the BOFF check look much nicer anyway..

The patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
