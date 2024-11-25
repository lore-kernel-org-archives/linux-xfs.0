Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6AB22094;
	Mon, 25 Nov 2024 05:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732512031; cv=none; b=I+zvzKVAGeXwbRjPdzitZIBpnGSPxUcUBHeu6jolM0RtqPq6bNOXtKdxcZuXCberUphtGwICnVcPgbdJDOV/gvDxFtH+emGdgXr4kl4NGMo3jfJYcz1Gv9HmYGvKtzvrsHpW0HUD6qTTQt3xW51oLxK/zkWWDqtHd3civ2qoKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732512031; c=relaxed/simple;
	bh=zn46Rkl5SiVw4Zu7cozT1ZRO+VhVJN8uQ0mxsPzKmEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6fUvrpYRzEb215OfNIHb8ve+J5ngaJEBVLVQFh56j+Kt/ac9QbaMNwlLXjSIz+AHBi5LzED9axbBaeNBE522maCVS2iPRCKHj6WhJK4jgY3j8DN0u6vXr9H4THODqG3shDuehyR3r3qGufImBYt3CJyAI5WWcDufNX544z/WPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DjGkGHx1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DjGkGHx1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FjTwh2ZSnxIPlpLlEuJIwCjYlk5HOR/6k2L9uuBqobc=; b=DjGkGHx1VFHrpPD45Suwfsnd4w
	Xo4JMJCpnGkE3yhrd4Yp6jrOnuS0qr7l5yXL1RMg7E2oIRN9dF5CxJwAmfEalWR/Uc5X408FcDs6D
	lcs7WUfQrneUYcZB7S3IeuAOSFRy4h2SUZIFxCp/nwPhi3j8D8uAwL/JEqv/VMVZn+13PZG6ZxPHe
	a04qNX3EIvH+VHtMxTX996eb48QUvIOxc37a1jlNWdh5qfluNDgalmEptp3KgE7H0p9e9bwyjBP3R
	TdkAV34D8VNJ5PlD/yQmLfGSN3Jwe73BnWRXklC4Q/VZz0a3ffliXd7LlWiSmkpcnQehE7NW429JS
	1nyGQxdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRWP-0000000756z-0MGs;
	Mon, 25 Nov 2024 05:20:29 +0000
Date: Sun, 24 Nov 2024 21:20:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Filipe Manana <fdmanana@kernel.org>
Subject: Re: [PATCH 09/17] generic/562: handle ENOSPC while cloning gracefully
Message-ID: <Z0QJHXSg-neZvqPE@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
 <Z0QHw2IGqnTsNcqb@infradead.org>
 <20241125051639.GG9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125051639.GG9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 24, 2024 at 09:16:39PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 24, 2024 at 09:14:43PM -0800, Christoph Hellwig wrote:
> > On Fri, Nov 22, 2024 at 08:52:48AM -0800, Darrick J. Wong wrote:
> > > +# with ENOSPC for example.  However, XFS will sometimes run out of space.
> > > +_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
> > > +cat $tmp.err
> > > +test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
> > > +	_notrun "ran out of space while cloning"
> > 
> > Should this simply be unconditional instead of depend on XFS?
> 
> Felipe said no:
> https://lore.kernel.org/fstests/CAL3q7H5KjvXsXzt4n0XP1FTUt=A5cKom7p+dGD6GG-iL7CyDXQ@mail.gmail.com/

Hmm.   Being able to totally fill the fs without ENOSPC seems odd.
Maybe we need to figure out a way to scale down the size for the generic
test and have a separate one for the XFS ENOSPC case?  Not a huge fan
of that, but the current version also seems odd.

