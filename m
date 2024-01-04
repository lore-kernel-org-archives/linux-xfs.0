Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794431DFE2
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJNwsfBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D487CC433C8;
	Thu,  4 Jan 2024 07:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704352850;
	bh=4ToePDkZhxAF9PDhRGzVEpjnnvWSR3IP7tyoasfXCdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJNwsfBjsQdTbtK4kf/0BWdQWXSP0wKp4RscFOW/cMtQRbwJmzi9s+NTyFIiBeF2o
	 mdU/0D0uzjXOvjCv1ErgWVu07cCvIbUtJjJFHbFauRIdEksSjRKBDFvvD9XEyVIf/f
	 yMMfStrP/tCQeyJXlyIF31KT6gxCeR8uJA7SnROCSpvoCtpET5MV7wqbTBTHQccnl6
	 3zc3DHlnAmDikTHa/z2TNGK1sbH7vcLCiHLcgqflxgNKQqiZKp1AW1gtSgoZzyGHwK
	 o+2Uoy3zpe28PhMYGfFRGBkd0sx/XbC8JCtGzWmP1ewC5mX1dmjzJQOLvGDCCteXOK
	 hOyh+2uJm2Prg==
Date: Wed, 3 Jan 2024 23:20:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <20240104072050.GA361584@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
 <ZZZOMiqT8MoKhba7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZOMiqT8MoKhba7@infradead.org>

On Wed, Jan 03, 2024 at 10:20:34PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 05:33:56PM -0800, Darrick J. Wong wrote:
> > Sort of both.  For xfbtrees (or anything mapping a xfs_buftarg atop an
> > xfile) we can't use the cheap(er) kmap_local_page and have to use kmap,
> > which ... is expensive, isn't it?
> 
> A little, but not really enough to explain the numbers you quoted..
> 
> > Granted, forbidding highmem like you posted today makes all of this
> > /much/ simpler so I think it's probably worth the increased chances of
> > ENOMEM on i386.
> > 
> > That said, why not avoid a trip through shmem_get_folio_gfp aka
> > filemap_get_entry if we can?  Even if we can use page_address directly
> > now?
> 
> Sure, I just suspect the commit message is wrong and it's not about
> mapping the page into the kernel address space but something else.

Yeah, I only did A/B testing of before and after this patch, so it's
quite plausible that it's the lookup that's slowing us down.

"xfile: implement write caching

"Cache a few of the most recently used pages in the hopes of saving
ourselves a few trips through shmem_get_folio_gfp.  There's enough time
savings to shave a few percent off the runtime of fstests with online
fsck enabled."

How about that?  I guess I could modify this patch in djwong-wtf not to
cache kmappings and retest, but that seems like a lot for a patch that
is pretty simple after it goes on a diet. :)

--D
