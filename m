Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4713D3318;
	Fri, 31 Jul 2026 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491634; cv=none; b=OwID1KvjnWVWzwztmG2pCZrb6djyx1HlaOPOj5HpieMTkLOz6peOY9IRuUhAP3cCo+5THv/4kLiBa5e02SLJri+WzcN1LS/vqgBB7NSY+aYhSWYtPh6prNlFtskeZiC8LgAGDlFK3qcnD816tcgKV63oHEGrg/nEzF7Rt5JoFVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491634; c=relaxed/simple;
	bh=haDS0Et+91gr1kICr/xouvfCgZnCRKor2lypPoOH1rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueBhcfemkiDXbdWGLC/jgr0whvVHU8a1EJHlztXPgSPdM7KLJbHhmUju8xCUsfB+psG+h34PVBx0UFkKYsCNPtjbl+hknUpCn7OMU/o068s+Jj0KG1RXtoJ9CsjMxOC8IXz/DygwBwtfIj+wJad+WEaPNAbd06VT+WB7f2VCGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tjysv1PL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tjysv1PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203041F00A3D;
	Fri, 31 Jul 2026 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785491622;
	bh=TBMZzkf/MHKzfOfnFlr3uJtIzBOeyHN8LKXbjFG8O1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tjysv1PL/9bW4EC9EAnrUU9XMaYRCMD/3TRzytd3lYeqctI2QbMvL8YgxOsA1O5Xm
	 Po3zBuS+tKm9wmgACwWGAVcw7idt6/gycrlCK6aGEtY1nEymJ3xnGiXNPOPi3Q+yHi
	 qHxyN/4LzDi8AGEbrW3Nvg+EUS9LtFtY0CIhEa/bWCrfvgmQc2dnKMP/J075YuFvIN
	 yeXMRyuQUSnEV1pC34aDx3GqjlbRBSx/u0iuLeEJdAsm+sjLqddVq39cpkicRaLfg0
	 xpL2S7c1W9VIPS7nvTZtc8M+dv2cPrhZFSNHJkS+92RhZAna+jBrDJi6vQ4phrEq4b
	 Rxg+oNaz17dEA==
Date: Fri, 31 Jul 2026 11:53:38 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260731-zuckungen-nennt-jobsuche-5b0ec82d06f9@brauner>
References: <20260629125229.3400726-1-hch@lst.de>
 <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner>
 <20260707050433.GA12963@lst.de>
 <20260717083120.GA30021@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260717083120.GA30021@lst.de>

On Fri, Jul 17, 2026 at 10:31:20AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 07:04:33AM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 30, 2026 at 12:59:38PM +0200, Christian Brauner wrote:
> > > On Mon, 29 Jun 2026 14:52:29 +0200, Christoph Hellwig wrote:
> > > > iomap: add a separate bio_set for iomap_split_ioend
> > > 
> > > Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> > > Patches in the vfs-7.3.iomap branch should appear in linux-next soon.
> > 
> > Any chance you could propagates this to vfs.fixes?
> 
> Ping again.

Sorry, didn't see that mail in the tui. Yes, doing that now.
