Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B595456DEC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249852; cv=none; b=qw2jtJkl4XEuyh+IG0DlOIaWf2xRkQuXNthWfa6fH91d34oU04ZbVA5YtcDQw3qXP6pp8CHdXJZTAZiu3vSkKhvKcni+T6L6oniMMbY0qY66rpqp420F88ZuxzDo05YnE+9PbfEB6COcaW6d/sYMjN9b42eLXlteiGgQja7mWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249852; c=relaxed/simple;
	bh=ru2wMwxdrtiChBLKMJ+O9R/ZEREGN2zzSs7sfjFpgls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rketxqux62p0ZtuFRz/Bwb5DQhMiek5cg2h71V79yIZsC1AOeksXzeIEVCV4L+1B1O0CtVCnToEPvCg8iaZYrxZ1XJnII0eDBvPmyGuNbynSY/LzPdi8e2xReLzZFXh95E18IAfGdaMlH1l24U16O80swxsH2TvucnW4iiNq10k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=a9H+i8t8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="a9H+i8t8"
Received: from macsyma.thunk.org (pool-108-20-43-42.bstnma.fios.verizon.net [108.20.43.42])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66SEhWMv003318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 10:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1785249815; bh=hF8jTJ2Y6RKeXf+Xo1YCrExaUVI4ZVsSpHkXg62O3IY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=a9H+i8t809nmwk51y99ma52DOO+NQpDGEtA6TC3zZxO2gyhw8sYtU75dQGSo8uoEd
	 8BO4uHCOKSAMSPFqKK1Zjwmcunvy/Mge8vqAC1bzhOALhZCXALqRIGE0+UiXDObSDH
	 VSLqKQi2766tV68ZUv/wCuXYneAfKcSbeEv+JV6dr5p8IDSwiC9NulBg8P5nolNQT7
	 6znIzWJ3NwEXe+VB+JSA8ib78MXL0uOlyabJH9j5Av8BDv1b+PY58mjdwTg+9pRdYP
	 nC8EHdXghSPvdpZ8GuCafp0vIwaBcG4wwLLKCyhew4ML+kmZYHDWqh5/6aOuIWkfAO
	 AmzyYBc6EzGEw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4F648C7423D; Tue, 28 Jul 2026 10:42:32 -0400 (EDT)
Date: Tue, 28 Jul 2026 10:42:32 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>, changfengnan@bytedance.com,
        Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        workflows@vger.kernel.org
Subject: Re: selective Sashiko replies, was: Re: [PATCH 2/3] iomap: decouple
 simple direct I/O reads from iomap_dio_rw
Message-ID: <ami9NUgcJvr0zHuk@mit.edu>
References: <20260722124931.3159664-1-hch@lst.de>
 <20260722124931.3159664-3-hch@lst.de>
 <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
 <20260723045347.GA6641@lst.de>
 <20260723151021.GC7380@frogsfrogsfrogs>
 <amI3Kf3lFz4FMqXh@mit.edu>
 <amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
 <20260728040120.GA19400@lst.de>
 <20260728072756.7ddc9fdd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728072756.7ddc9fdd@kernel.org>

On Tue, Jul 28, 2026 at 07:27:56AM -0500, Jakub Kicinski wrote:
> 
> +1, maybe perhaps someone wants the off-list option, dunno. 
> But trimming the CC list of the on-list reply is a really weird idea.
> Submissions often CC multiple vger lists, and the bot only replies to one.

It's not (necessarily) "just one" mailing list.

For better or for worse, there are people who have claimed that being
exposed to LLM reviews would "deman their humanity".  So the Sashiko
maintainers have made it completely up to each subsystem whether (a)
Sashiko should review the patch aat all or (b) whether the review
should be sent via e-mail, or just left on sashiko.dev web site.

If it is sent via e-mail, then who it should be sent to can be
configured to send it to the patch author (or not), or what e-mail
addresses should be sent if the patch is qualified as relevant for a
particular subsystem.  This could just be the maintainer(s), or to the
subsystem mailing list, etc.  If a patch is relevant to (say) both the
SCSI subsystem and the s390 subsystem, then it will be sent to both
subsystem mailing lists.  So it's not that the bot only replies to one
list, but only to those lists that the subsystem maintainers have
authorized.

At some level, the Sashiko developers effectively have tossed the hot
potato policy decision to the subsystem maintainers.  Given the
megathead on the ksummit mailing lsit, I can't really blame Roman for
choosing to do this ---- although I'll note the Intel zero-day bot
folks chose differently; I guess automated benchmarks aren't perceived
to demean the humanity of developers as much as LLM reviews, and so
aren't as controversial.

Cheers,

						- Ted
