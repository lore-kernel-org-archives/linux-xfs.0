Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42954493620;
	Mon,  5 Oct 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791207065; cv=none; b=AtDgfeoIknQECXp2FGiw3tBFNgbJyVtmR8GstZxQ23Qf2B4T02+WYqRQDM95Qz+0Vc/wMAtljJMWCXO6Waf3cCVDygIt+y7Qu6ayh/titfY85mQc4+vVzy5VadehHQP83GGqnkt7XyvIw7PiRjZNolAIpYiiD7aE+pQFVNaj8Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791207065; c=relaxed/simple;
	bh=sEB6SwsEKw/juxXaWiNtskiEqoJzpjPGaf36uDKKgFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B873Tyt78eAxIiZfv+JvEsqK1jor+Yz3w5JbxiFvVav1mb0BFnwIoe5fkBaRjrw0JYHlLNQAfgSttxruRawPlFqtaveXumATFeS4cffXpG95ZFmebaqLTQ7+sbM0fzc5kiAScNmH7rrJfs1sVKcRSXtXTT/JMoK8O+6/Iz10CJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZ6Jfn/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZ6Jfn/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F051F000FF;
	Mon,  5 Oct 2026 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791207063;
	bh=YJVFrcH51dcWxKvIvBoz5wPALOazHMgdkbmMui1YFvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NZ6Jfn/XZvbHZ9XZWUeKBjHSx8Gwxg6v9+i6QIGrWRSYK6B+BD325E+wAPloxoe/i
	 Fs0cNZt9HTSfTT2fIuyt6SYI1V09qLZotsQ26++U92UybnNUaDw0daQxMq6OXEmHz0
	 i0PFp2xlI5bN8hSzGOBBRCH3JWS+H70cQojexrMqnWd03bd2zyUxgPDLGWsM8ic8Ku
	 QnX5ZkA4xjMnqmwLM1PpJtDCy+KyfG/1LhrPesOPoEB6lMAvHhPjgubeCTHc9m14iL
	 +eol8QKhP1q2npvOdrJ21JxbWpF29PQuDSXup+Vj4YervpvvbsjXI7A0l5yidd80/U
	 VY/SQv9Bzlw+w==
Date: Mon, 5 Oct 2026 15:30:58 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org, hch@lst.de,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20261005133058.GA3436@quark>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002232542.GA15366@quark>
 <asDvqctUgrxflcCa@nidhogg.toxiclabs.cc>
 <asN8lCPmZpA0tp5S@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asN8lCPmZpA0tp5S@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Mon, Oct 05, 2026 at 01:26:18PM +0200, Andrey Albershteyn wrote:
> On 2026-10-03 14:07:23, Carlos Maiolino wrote:
> > On Fri, Oct 02, 2026 at 04:25:42PM -0700, Eric Biggers wrote:
> > > On Sat, Oct 03, 2026 at 12:36:41AM +0200, Andrey Albershteyn wrote:
> > > > Andrey Albershteyn (19):
> > > >   fsverity: report validation errors through fserror to fsnotify
> > > >   fsverity: expose ensure_fsverity_info()
> > > >   fsverity: pass digest size and hash of the all-zeroes block to ->write
> > > >   fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
> > > >   fsverity: don't allow setting DAX file attribute on fsverity files
> > > >   fsverity: hoist statx reporting of fs-verity flag
> > > 
> > > Would it be helpful if I applied these six patches to fsverity/for-next
> > > for 7.4, or do you want to wait for the full series to go in at once
> > > (presumably through the XFS tree)?
> > > 
> > > - Eric
> > > 
> > 
> > It's your call, I *think*, this is too late for xfs 7.4, so I want to
> > queue it as soon as possible for 7.5.
> > 
> > If you want to take the fsverity patches into 7.4, go for it, then the
> > xfs ones I'll pull in once yours are merged.
> > 
> > Sounds reasonable?
> > 
> > Carlos
> > 
> 
> Fine with me too

Applied patches 1-6 to
https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-next

- Eric
