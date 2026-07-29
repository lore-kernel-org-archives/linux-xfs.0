Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AB9432E68;
	Wed, 29 Jul 2026 08:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314919; cv=none; b=gMcCOBlK7RtgEifNmDNwoXf7mCmMTe2or+ECAsGlNBmlyDINhXwNm2UKMFNVOEo7zxaVvmUJgPAhLnwnVq/uRPs4TDE3AJzUagyCDk0RlWOuste8yuquI/o1du/LiSwqNn5OT//74jNE0/F7F4+VAkYLRubPgTSQOagubO6OwfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314919; c=relaxed/simple;
	bh=/narXh7pPOZ4O+pLXLRtRJ77mb3IERKycuMvFjLVUkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpEOjc6BoiClXjDtVOqjRDKDd8m/+Qmhod8kzohdp51CYliMbQsZ/WXQFvfFLzwDK8UA6x/6xmn0NqB9yYkLW6+/cXn8TjmncJ0TvJ2osqQJFFEYmwdmIrTYq1Q6sOxHaAjG/9Bhq3o2ttnybN0lLN6v8XDBE0Hm6oBWMNQaSh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RZXWSbw8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RZXWSbw8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/narXh7pPOZ4O+pLXLRtRJ77mb3IERKycuMvFjLVUkw=; b=RZXWSbw8u1u57uY2shP/yxlNQq
	R9nR/ZWG3r/ZX/a4kI4Mfv21+SVafHoH2rU0vvbVkGmIJZH2IlJCcji2wdKWfRuJ8OfosxNn8cbpK
	qedUwm0QIZuWAVU77jOxQOOwWKucCQd3ioDZG1ObK5h2+2NDMQopLovEgyN4AWhujYyXeamM88il4
	SlwyJcDysvtZmqntJ80ap8lu1o6rPHfLTN4lu2zXMFDdzOTm9vPiyAIBN6ya7nn+05AhUGk06oF/G
	PJWiNoci1XtaL4F44iCmw+ZXYDSF8bReAknLuzJEAwQUk2moDmiClY7+5NPWTz8tqkHJovN2PTKX+
	P9WdR9eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wozxo-00000007HFQ-3Kwp;
	Wed, 29 Jul 2026 08:48:32 +0000
Date: Wed, 29 Jul 2026 01:48:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <amm-YHQJFUsj4AM6@infradead.org>
References: <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
 <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
 <4ahxusvs255ibn5unrayfeioqijbbidtn3l7joczxphwo2faee@3wtnw4nzu6wi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ahxusvs255ibn5unrayfeioqijbbidtn3l7joczxphwo2faee@3wtnw4nzu6wi>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 10:41:40AM +0200, Jan Kara wrote:
> This looks a bit hacky and at least deserves a comment. Ideally we'd get
> rid of the xfs workqueue and rely on the generic offloading mechanism. But
> as Christoph wrote maybe let's just get something good enough in and we can
> work on improving that later. In particular if Christoph has a plan how to
> clean this up :).

The XFS workqueue can't just go away, as for writes that require
completion time processing (unwritten extent conversion, i_size logging,
zoned block mapping), we want to serialize the processing on a per-inode
basis as otherwise the different helpers would just content on the xfs
inode lock and burn cycles.

We want to get rid of it for read completions, and a patch for that is
in the lazy bounce series I posted a few days ago.
