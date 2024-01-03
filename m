Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84674136B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edzKXquF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0382FC433C8;
	Wed,  3 Jan 2024 01:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704246741;
	bh=w2r9EKbeMnQ0NSoKhi5h2Ux57oiof9Glxnlqw5c1rB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edzKXquFNngfATEoyclDFL4l1U31PPiLn0U1XhqhwcPnOEvP1i4TvJI+PiuisNqz6
	 PEYLdAO5t+aG00NdCMp8syPvHp8U6ZdOuy/b2AsQiNhTHPnbUBZNpkCxSpPgXwCMr4
	 T1peVZ6zhlNnqS0VcyVIHbJR0uG/3EXymLHNes+gl6TZDQvCvb9RZhgKQHaBn9zVrS
	 /PCZ4kc0LkI62sHEJxHkx7akoAXZG2Pd3+d3Ky2vYnAg8FV4ZWLFxLVNMs5PvSVAmz
	 tUDzfgvlnBdAlTxWZbhPJ8ZpZggwK6WlbZDuY9apDPH4wGF/z/y4m65GgkZ8XCbRiu
	 Hwws+s4UzsJcQ==
Date: Tue, 2 Jan 2024 17:52:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: dump xfiles for debugging purposes
Message-ID: <20240103015220.GI361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>
 <ZZIBMC1E8nz4uNiV@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZIBMC1E8nz4uNiV@casper.infradead.org>

On Mon, Jan 01, 2024 at 12:02:56AM +0000, Matthew Wilcox wrote:
> On Sun, Dec 31, 2023 at 12:13:49PM -0800, Darrick J. Wong wrote:
> > +	error = xfile_stat(xf, &sb);
> > +	if (error)
> > +		return error;
> > +
> > +	printk(KERN_ALERT "xfile ino 0x%lx isize 0x%llx dump:", inode->i_ino,
> > +			sb.size);
> > +	pflags = memalloc_nofs_save();
> 
> Hm, why?  What makes it a bad idea to call back into the filesysteam at
> this point?

I don't want xfile_dump to invoke direct reclaim which will then call
back into xfs because scrub (or any xfile caller) might already be
holding the an ILOCK.

Granted it's /probably/ redundant since the scrub transaction will have
already memalloc_nofs_save'd.  But as this is a debug function, I
figured it was better to burn an unsigned long to prevent making
problems worse...

> > +			page = shmem_read_mapping_page_gfp(mapping,
> > +					datapos >> PAGE_SHIFT, __GFP_NOWARN);
> 
> This GFP flag looks wrong.  Why can't we use GFP_KERNEL here?

I think that's an omission.

> I'm also not thrilled about the use of page APIs instead of folio APIs,
> but given how long this patchset has been in development, I understand why
> you didn't start out with folio APIs.  It's not a blocker by any means.

Heh.  Yeah, I really wish xfiles had been merged before you started the
folioization instead of adding to legacy code creeping.

> I can come through and convert it later when I decide that it's finally
> time to get rid of shmem_read_mapping_page_gfp(), which is going to take
> a big gulp because it now means touching GPU drivers ...

Hehhehee yep.

--D
