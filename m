Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B914425CEE;
	Mon, 17 Aug 2026 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786983094; cv=none; b=C4A//mugkFV2Wyd9TpvQO4kPUDyzuu86dX/jtP4rJX1DFGb9SZFGIusDVj65BDWrYMMOfrIheiJXdOPDp5FcPuiToLNPptKw68iKZuhBF7oMVCTWLrDj7qoVKaZR4y1VdKFm/h4gxteD3eQnq9srMiPha9FSyUTKw8ysRbc5gJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786983094; c=relaxed/simple;
	bh=fc4O8Prtm5XWK/2YQuD3TPTvW0idTy3oawokzt+0vUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URp8dH2PSoZefCEK0iF7s7A2HkB0VC58qEeM1BqtuI9hUwkJqEl6ybH1GqZuG0NpE3WrJJcKoy7yrmLz/4aB4NJ0N2AGm9UdeZqv5nJDH4h3wmVE9dD6aaf7fqSiDpG2AyU1wbbJW0KNK4U6ydvB4FZbf5Ly9b1GcjxSaG/7oJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnqRopGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnqRopGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD191F000E9;
	Mon, 17 Aug 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983092;
	bh=0nV0ITWCr+SwB/qQVV59nZ8a7Fv35HT3JcbHcjhrXNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnqRopGyXK2yZB1YmPItzCn7//8PjNAn3JpS8iYUtl8uBYIEEHLtqCaKjGW4HTc8r
	 /gTRYE+X6V0J90TARmPzfMLSjzzoldSayEaLf4deskBvRiRHBnuDB0OQHXTQ9Wztoh
	 LgePo89MCNJF+5TbT2bQadem4bYTgKv6kv7grc8d2X8x/FQ5WHIeAYRgAUEjDNFC4O
	 UnSOI0g4qB8M5CscknyTbyD95664Mb8ejFS5wx2gJFrzuQ7bTwePYLe6HmKuGiuG/1
	 YT+g9+A/pF4YyV2q+kv4bmJuxIr3pe7mhQAMDP9BXMsFDB38V8sPMc4OuH8WJyZV6E
	 8hi//uG+Ehr+w==
Date: Mon, 17 Aug 2026 18:11:26 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, ebiggers@kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 00/25] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <aoMyh4b1qxa0k6eZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
 <20260817070240.GA17371@lst.de>
 <aoMZaqbKxmp9lhKs@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMZaqbKxmp9lhKs@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On 2026-08-17 17:37:13, Andrey Albershteyn wrote:
> On 2026-08-17 09:02:40, Christoph Hellwig wrote:
> > On Fri, Aug 14, 2026 at 11:24:17AM +0200, Andrey Albershteyn wrote:
> > > Hi all,
> > > 
> > > This is next revision of fsverity for XFS.
> > > 
> > > Range-diff with v14 also below.
> > > 
> > > Patches without review:
> > > [PATCH v15 07/25] block: add task-context bio completion
> > > [PATCH v15 08/25] block: don't delay bio task completions
> > > [PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
> > > [PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with fsverity
> > > 
> > > The patchset include some patches from lazy-bounce@hch-misc series for
> > > BIO completion in task context
> > 
> > A different version of that landed in the block tree.  
> 
> oh didn't know that
> 
> > So let's hash
> > out how we want to handle this for the 7.4-rc merge window after the
> > dust for the current merges settles.
> 
> 7.3-rc?
> 
> > I can have the lazy bounce series
> > ready early for the merge window, and should be able to send it out
> > once all depdendency trees hit mainline.  Does that sound good?
> > Or should we split the minimum requirements into a separate
> > branch?
> 
> Then the only patches I will need is IOMAP_IOEND_INTEGRITY with the
> helper. This is probably a bit too small change for separate series,
> but this will also work.

oh and the one which enables task context for read ioends on xfs

> I'm fine with waiting for lazy bounce, as I still will have at least
> one more revision.
> 
> -- 
> - Andrey
> 

-- 
- Andrey
