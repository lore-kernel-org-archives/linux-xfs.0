Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAC733ADB3;
	Fri, 10 Apr 2026 06:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801999; cv=none; b=FjDTHA1h44rDqwAtSpFbA1tegoy8RPMCDRzK0NKfjzxGQwZarrB/AYyZfQMUul8/3nYOWb4sWIrycRH72TbUTSu1C8B0R/wGXpDafdPfe1pc0HeB6pt3niUXeJL8Vb3xgSklJBGly5XrlNH6CK066OslMx7ZCRzsy1igouWtAWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801999; c=relaxed/simple;
	bh=4+EqD3YzIPa3Fgi5cN2FOovIS+oyDUHEg1SWegQAuc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebPDEXLmk+JdPSSR/+IO+UscY6oRexTDFKOqQHPCYObsqahj2/XP/jD54AJs4ggnR6D4lmZsktMdH2E3qJPRezQ+OzSA4xst3L8gnIRdWHU4+u7M4KqBRZTcmTvc5zaqqG1Zn4wfJwA2SaD7Kl7p5idKxvCFzg3P/3WM5iGdF8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66B1268B05; Fri, 10 Apr 2026 08:19:53 +0200 (CEST)
Date: Fri, 10 Apr 2026 08:19:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260410061953.GA24795@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <2cdaa767-c071-4e84-b9d7-1c944407f5bb@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cdaa767-c071-4e84-b9d7-1c944407f5bb@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 09, 2026 at 03:06:47PM -0400, Tal Zussman wrote:
> > -#include <linux/llist.h>
> > +#include <linux/freezer.h>
> 
> Why freezer.h and not kthread.h?

I needed freezer.h to try to make the thread freezable, but that didn't
work out.  kthread.h seems to be pulled in implicitly.

> >   struct bio_complete_batch {
> > -	struct llist_head list;
> 
> If we go with this approach, we should remove the newly-added bi_llist from
> struct bio too.

Yes.

