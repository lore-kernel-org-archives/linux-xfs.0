Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794669552;
	b=svqHVxSRPk5OytE9w/jWylX0X+MCvahHdYF+H28AFMKPWcTNgKE9wcMTrPB8osE+vv2g
	 psf3P25eeimztlHtFvhDMSvlAShb2U5iX4AC5hrM/zF/5pKL52PGMJCIO1Y3mkFUEoqt6
	 BLwinc342cI2U/GxmfN3WzLNqGcicEpPS/TnwuFKRbc0i61RX9yz/DRj/yObc6ip1jcke
	 lprMi62+DQQuiN9pCsCajsheZ4RU33pgPOCw0y8FarqVM7WSF9YuD55zeo77ICrdnVfyo
	 ijIjT+05Juj33a9PYimBeusfpCwoZUfdQbVrQH8tkySQA7llx+y/KOqFup3JkXdBx/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794669552;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Qu/0WIZ8Dq53p2n6YqF3E3pv9S8eZe2FdkWqn1VfGZY=;
	b=IeEkwLSoKnRr431dQideWN/p9jMjH2RH2BOgsjavcrgnUhlj3n9GzFZNgnUAVdaiD6PZ
	 mfyfmJLb3c9rOUDZQIwmA5S2XXgjwwfdT+HGQVn7G9MY1dfFDk50TcsffXzMwD9qa7HKJ
	 10ZOfAoKp4yrVlHjfE2HOenCuZsOSYJ5oB/CI4Qoliw3K2svRkJVbpKYk35yLHbW5VD14
	 rlZAJQRTgMF2iNHT1NKaEZg+XUUhtDm9aDpnB7+Gs6YXIUxv6K26nkz7VPP8gb4Cgq050
	 wOkltZ/9LWpp4fZoQejEHKT8WqYzCy9M+f2yslAADkfVzSNOKiAclMgVTK3ot2pcfgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hRh+De9a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA56606A323;
	Sat, 14 Nov 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hRh+De9a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715BF1F000C4;
	Sat, 14 Nov 2026 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794669552;
	bh=Qu/0WIZ8Dq53p2n6YqF3E3pv9S8eZe2FdkWqn1VfGZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hRh+De9arbJulQhHIXnMDtBDRcZwEMHFpp+p1Jdu2UlT/zKEpDB7/2KdM4CMWrTKj
	 GxQ+Z/ETc0pmquo/112pjd4zpBb9QLCcb/dVEAnu5SGM0HiRaDsTMzGZaVo8qfsihD
	 Ivaf7eii7k9lK32bSqs5erUFWRoOtDtskrNyVeCA4ouo+wb8QG7OnkVS4H03gfbVqN
	 sUpLD5LbBA55pxlIOhDmkzBI529SrZwqTFM9DoYDK0+9LzjL2c4XAMts/YcygFzojN
	 1yNfHbwbY47KyJzbrzyPlZc0D2Za02OCs4g7F8eaN0Kmdyo3lfSPT6iBrJmpD0gX98
	 bgBTughBp4JTA==
Date: Sat, 14 Nov 2026 23:18:58 +0800
From: Zorro Lang <zlang@kernel.org>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>, 
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: (2) [PATCH 1/2] xfs/438: retry failed metadata writes again
Message-ID: <avh7wJ0pJH5olehG@zlang-mailbox>
Mail-Followup-To: Daejun Park <daejun7.park@samsung.com>, 
	Brian Foster <bfoster@redhat.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <avXIstx55STwYao7@bfoster>
 <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
 <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
 <CGME20261112141007epcas2p462246c1d6a82b4540937ad955dbfd8ec@epcms2p7>
 <20261113025637epcms2p7293f70d38c194bcc0484811c63137f94@epcms2p7>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113025637epcms2p7293f70d38c194bcc0484811c63137f94@epcms2p7>

On Fri, Nov 13, 2026 at 11:56:37AM +0900, Daejun Park wrote:
> On Thu, Nov 12, 2026 at 09:09:54AM -0500, Brian Foster wrote:
> > On Thu, Nov 12, 2026 at 10:37:17AM +0900, Daejun Park via B4 Relay wrote:
> [...]
> > > +# The dquot buffer write must still be failing and retried here. A shut
> > > +# down filesystem means that the test missed the hang it checks.
> >
> > Nit on the comment.. something like this is a little more clear to me:
> >
> > # Run a stat to confirm we haven't shutdown prematurely. We expect the
> > # fs to be running metadata write retries. A shutdown fs at this point
> > # means that we haven't properly tested for the hang.
> >
> > But this LGTM regardless. Maybe Zorro can fix that up if you agree:
> 
> Thanks, agreed. Your wording is clearer.
> 
> Zorro, could you replace the comment with Brian's when you apply this?
> Patch 2 does not touch these lines.

Sure, I'll help that.

> 
> Best regards,
> Daejun
