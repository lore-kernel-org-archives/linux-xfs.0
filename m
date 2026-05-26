Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A7735CB91;
	Tue, 26 May 2026 10:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779790791; cv=none; b=rCGyFylVo25RZFHiU/ZT5rBjTsyecYHOUV7LMbvav30VV1SMo+ufZkqV8bQy1iiNnZ0h9rG8AjYNmHQBgnVkqne1USFB/Imw7mPcxNtguiR6yMGcCF86HSXE5rnGKAm6+9F9Bh42Bj6IyNvj4lug9k/r5Ke9azfte9XuTfm1oLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779790791; c=relaxed/simple;
	bh=oQi8nMHL3qjqUhC1Bz0zt4vfx6dFsOpBcDtR8g2k33c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0pLCKFtIVkuamnNIDo4NIsWg3WNBtXWKzH2a7TCNMzPEzDDMbqLIGewfTcXQal5nCACb9FPcvyeY+HDyAw98SnfgZ8gE/RAe9NH7WCpCwMKJrKuC1MekegvcNBzuaFvioXTutp9oMVaGH9MkfgBl68j0Y1nXQqd9IiDInJLII0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUMA/lAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUMA/lAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D538B1F00A3C;
	Tue, 26 May 2026 10:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779790789;
	bh=qWbiUioGQWD1oNqwL1vRZhi7+oCXyyFRIUYuY3v+xgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cUMA/lAqbZLBRBVHvV8INPx+YT1E98Lmh8jjTZjyuUdXav6fgsed3ODm8/5GTF6JD
	 woNd2WKuTr7z6+CeBrbc86JH6Pov4/A5ZQHARinht8ydGy9npfb4Ci3fBh9MYNHd2Q
	 +JkYMCR7rM7GdLWkF99iLWWGDeHvCkDjOVtvNUWE3UIYRBSXXPMleSkZ3F19/e2PAq
	 pOuh+w7MH3OX0CUNxFnoNS0CIs2s/NAVOepv+iGfH0D+0xX5/2o2q4ktlWxw3Oj/PV
	 /RQR9Zl2vf1B02hYABnZpIz1Y00Vfb1oEqjVR1FdKrRPcAAQCfzJP8zVSInk+u7WB2
	 Q7D5XFNnYFsgg==
Date: Tue, 26 May 2026 12:19:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Andrey Albershteyn <aalbersh@redhat.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522120757.GA21041@lst.de>

On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > I was expecting this to come through xfs tree too if Eric and Christian
> > > agree.
> > 
> > You may take it through the xfs tree if there are no conflicts with
> > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > vfs-7.2.iomap that you can pull in.
> 
> Merging the iomap bits through the iomap branch might make sense, given
> that iomap usually tends to see quite a bit of activity.
> 

That sounds good to me. If you want to go ahead and pull in the iomap
bits, do so, and give me a heads up when you do it so I'll pull your
branch locally.

Cheers.
