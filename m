Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2388E30E0D5;
	Wed, 15 Apr 2026 05:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231854; cv=none; b=Ne5eUe2kgx4VBjeea5Im0Vg0anuezH7tsDPkDSZtgz9ra0NG/DH3BXyCpM1YifaPGp2hI8bzTe0AEkls4KbQWfTzNdfoxpzGzfgEZmaTlA8pn577AZOu6dVYY28gg6mWP6sO1UTxjw2uXEiw1zhPHqiVzBXmPbW6MXEo++sJikM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231854; c=relaxed/simple;
	bh=wSDA79cXLk2ng7vvxu6ReR9v2Eu5plRJRyhgqvgR4DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGswIvbAkf6ZJcfj3Se+Cz4cIv/MrIsOgjRyLSWeq7A5Gz+0snhKDdDjUxGIJtLQK0MSN4DPIes8PV1wZ/HYCWdhAWdsaS77s5Sf7S4JqeBmUjSD8eq3ytEyK1q+AVaFr2zzeulDkpWwhJqSuTDtZ/+HwjqLPr/R3a8E/LhG5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B147B68C4E; Wed, 15 Apr 2026 07:44:07 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:44:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <20260415054407.GA26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-5-hch@lst.de> <adgJqiA0vivaW7NA@casper.infradead.org> <20260410061725.GA24667@lst.de> <adj6iibxNot-yc9X@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adj6iibxNot-yc9X@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 10, 2026 at 02:26:34PM +0100, Matthew Wilcox wrote:
> > Yes.  On the other hand we can actually use it when we don't know if
> > we need to offload beforehand, which enabls the two later conversions
> > and probably more.
> 
> I don't understand why we need to remove _this_ way to defer completions
> to take context in order to _add_ the ability to defer completions
> inside the bi_end_io handler.

I don't need to, but we'd better have very strong reasons for two ways
to do the same thing, and I don't really see it here.  But I can give it
a try if the consensus is that we want to way to do it, and we're not
worried about people getting the bio-flag one wrong as we could set it
from ->bi_end_io, but it would not do anything.
