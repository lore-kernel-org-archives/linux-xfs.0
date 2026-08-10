Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073E3939C1;
	Mon, 10 Aug 2026 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350503; cv=none; b=n4Fkn7E3f9IKxco1J2glM+6Dg3Mna8Qj4gF2J86zJTqibSE463eg9apbq/GPdg2FDLdtf4c8mitS6mpLA0TDP5BRh5075gFxyfIwA8zYMLSXT2NY14snYKiSOWXxoqeAauAp3+kDKAAMfsrGfwHWvePvO0QHmOAHlCF6ntdoIbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350503; c=relaxed/simple;
	bh=GVYPoYW2Q/7elNyAaitc/i/CVhPy1XmGszpQs4/phD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2SZrksFuaHqdilTeig0GD0dAXOLkFYTrTLFBOAQNC0pWPjibxUTQBgXMS6TwylxN6XcyG+3WC2DNqtHeIiwNqXOgSrACKuKDOekq94kLvxTlMliwGelgM97tYygMgcOipV1nwUBjhjvit9JflbONZ05JguFiFoZbl/hi7xUIU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHSjCgb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHSjCgb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1461F000E9;
	Mon, 10 Aug 2026 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786350502;
	bh=8ooJ1K9gJPbRSmciql3NBWA3FYXEMtRNBkMvQDxZ9OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OHSjCgb0zyYYJnpVXHkENn+EQu/H697chYZZJkFhESi6/NP7iVQcFRaPRbj2caJgl
	 xocFGq5ItG0BNFugzGkJIih4QVQSt7Efs/VOhLmVcuJR+9fbHTMYyG63BqdHzg7wer
	 eYwX0A7sLiPpI3xJIkx6lk3HPbFW2Y1JpD6FFecaYLISsqFnMQ+Pb2l/c6MapY/Oea
	 kCnWp6UIWyn4IbDssy5z3mc9UXSKmUjC5Ar+Eyl5doYemGydfLVLqu6eqO0EY4G+vN
	 al6C0EkcLaKaMi8tV7xa0eWlgFSffXjgc3g0LHInhLZgf5gFVRaiOzhazHcgOfdEqP
	 ZYFQN2F9gv/UA==
Date: Mon, 10 Aug 2026 10:28:17 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v14 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <anmFWhPNOqe4uyht@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260804173548.GA13900@lst.de>
 <20260804175203.GI3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804175203.GI3556460@frogsfrogsfrogs>

On 2026-08-04 10:52:03, Darrick J. Wong wrote:
> On Tue, Aug 04, 2026 at 07:35:48PM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2026 at 10:07:50PM +0200, Andrey Albershteyn wrote:
> > > This series based on v7.2-rc4 + lazy-bounce@hch-misc
> > 
> > Oh, I gave up my hopes to get this into 7.3 and was waiting for
> > your series to land first.  Right now there is one outstanding issue
> > I know of with the series, which is that we need to clear REQ_POLL
> > for bounce buffer I/O, and of course the somewhat complex cross-tree
> > depenencies.
> > 
> > I can try to get it rposted, although this week I'm travelling for
> > two conferences, which doesn't help.
> > 
> > If you only need a few patches from that series and they are kinda
> > localized to xfs, maybe you should just cherry pick those from
> > my series and include them?

I'm basically interested in the BIO in task context patches + read
ioend use of this

> 
> I hadn't noticed that this patchset had added even more patches and were
> waiting for review, but cem told me this morning that he thinks it's too
> late to put this into for-next for 7.3. :(

Yeah, it's probably a bit late.

-- 
- Andrey
