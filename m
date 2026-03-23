Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85453B9DA5;
	Mon, 23 Mar 2026 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279352; cv=none; b=VvzHCHegafVJf0nBNZ5vZOhUv6xi+8wuCGF9NmsyebYQwrwn+UD6YRzGjkbtW3fHdRAKsXg0UlavAurkX8AueYV6u+/1Gb9nqixFNRVAgk4wUy2y0j/CjkrYAwV7ofNb9WkWbU86QPafl/1oF0XfpVIPrIDpQcW/mlUTVhCShL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279352; c=relaxed/simple;
	bh=qV7DpFkV+nsnn0tP+Ge2akl4zG5VfoW+Sh+vQpJP5AM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KY++Wf2W3G3yvOTu8Evqc50hoZKCBYBNps92C5MU4OaCvmXUZfXLS4QkghgM7icIFegyeR3Q6ZyaKd2o9MbFKyfTzdspRIZXInmzLT20gTz4R4QZTMcZ0YkYuW1MAccI+kkWn3uyL4SZyH02E7nUP9+Z5d6g5KOoc/h/NJWNcjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0oZuZxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0oZuZxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD27FC2BC9E;
	Mon, 23 Mar 2026 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279351;
	bh=qV7DpFkV+nsnn0tP+Ge2akl4zG5VfoW+Sh+vQpJP5AM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0oZuZxRyOjCleQhidJdnwzAG6fRrhr3J9de6D4XQu+tJyoLPAeh7mmRcsIhwt3nl
	 LfhRnzvDDBM6o3OukFM9y+4SNBtxOPeIeNEYL/J+7Ftol5g6Hz/gD4CV6KE/8KAUL+
	 uuWXt0oU/1udRHQTHgn1ohqQqp2EyWACuMV3qlSkYYjPV5ewMUM86cl8rnTC0g8exo
	 xkM1lLDXH7P92Kb0BMYeSAHoB7jdAcLyUAlh6g/TiVQTdayHHi8u3CPY/25CezVnPK
	 s5pVs6VjZRZ+HPULb+FJFFmPgCTLUjY6GeFSP6MRKtiAlF0aao/scoa4tCuiW6n4Zl
	 ha4/7a2N2IBmQ==
Date: Mon, 23 Mar 2026 08:22:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	Tal Zussman <tz2294@columbia.edu>, axboe@kernel.dk,
	linux-block@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260323152231.GG6223@frogsfrogsfrogs>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
 <acDbFtQw0mom798e@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acDbFtQw0mom798e@infradead.org>

On Sun, Mar 22, 2026 at 11:17:58PM -0700, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 09:34:44AM -0700, Darrick J. Wong wrote:
> > --- a/fs/iomap/bio.c
> > +++ b/fs/iomap/bio.c
> > @@ -8,7 +8,15 @@
> >  #include "internal.h"
> >  #include "trace.h"
> >  
> > -static void iomap_read_end_io(struct bio *bio)
> > +struct iomap_failed_bio {
> > +	struct list_head io_list;
> > +	struct bio *bio;
> > +};
> 
> Between this and the blockdev dontcache work I really wish we could
> have a generic offload using a percpu lit and workqueue.

<shrug> For IO errors I don't think it's urgent, but yes it would be
very nice to have a single mechanism for "kick IO completion to a
workqueue" type things.

> Also I don't think we need the separate list here, a linked list using
> bi_next should be sufficient and avoid the allocation in the failure
> path.

For now, I'll change this patch to use a bio_list.

--D
