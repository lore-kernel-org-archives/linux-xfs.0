Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72036C5A1;
	Tue, 16 Jun 2026 14:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781619575; cv=none; b=I3kZAdJfwQ6DhaGWGF/HoPfeKbVgBPd9omiLNuPskLL4IRTVVBsXLKg2usE8NRub0cvm8pdaFhFUiukQI3i0GudEqSX417WQJuYebWOOJlAnjNh6ki/sFqFbSRZy9r/M1rZ1r0NdBbalwUfhi6XjizzmUYApKA4IZtY4Hn4W5jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781619575; c=relaxed/simple;
	bh=f0B7hPcLipWmH3E8jjtfL31N+sYuG8r1wAD9c9nYHVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AA48y0rCuT0qOtleuWlS5NvYNh5Y8gTkW6sQugirr6TtOtNfnXd8mLk9TLJtVt9/FhgBG2eXztfrIgrUPhJpMghUUWwr78TqM6ppMLYHj/8ko6WA6jTZ2jIAtogCOZXr8kj1scXpT/h7vdjODT5cUoExXrdvg6QOjudr3Jy4/fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYYJAupL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYYJAupL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C21F000E9;
	Tue, 16 Jun 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781619574;
	bh=TLGGdLtUmkchl0dQCLv1NvzeNJ5dSPlGQkOH9FAEEBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UYYJAupLKnVLY+f+SbK8WhBPC/wZkWBRG04GJeZddICgwlcHkm3ldMO2Udb/Vk6in
	 /7e5rKDqV7pswD6PRKf3cYq1ax9tI3jsHEOWbtnpPURKASvjwc+STALhf/VbGwwNDK
	 Pm1SKI1FMUEiNHWY+Iuw/+RHW1p6L6H8exaSGqD9Q/TwVj2CO4SYID/aPrafZD51mi
	 aK9TfeDDqNXTMHAATINmkq3104pBcB+czy1IFf8PHGQk+baiz7gOUMKUrQO6gG++VU
	 QZSmAFJwMbQV89U3eOdo4VtYdvy+3RP2JgW1bgNzL9IBQkb3WcnSH8M5zgS7tSip0A
	 EUH+0qGeOryzg==
Date: Tue, 16 Jun 2026 16:19:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>, Fedor Pchelkin <pchelkin@ispras.ru>, 
	Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org, xfs-stable@lists.linux.dev, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Catherine Hoang <catherine.hoang@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
References: <20250322143418.216654-1-pchelkin@ispras.ru>
 <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org>
 <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>
 <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> Cc: linux-xfs@vger.kernel.org
> 
> On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > Cc: Carlos Maiolino <cem@kernel.org>
> > 
> > FWIW I don't maintain the stable trees I really don't have time for
> > that. Darrick/Leah have been doing a best effort case for that, but
> > again, this is mostly a best effort so we shouldn't expect them to be
> > looking/picking up every single possible patch suggested for stable.
> > 
> 
> Now that you mention it, the xfs-stable mailing list seems to be pretty
> much dead (i.e. the last time fixes from it were merged into stable was
> almost a year ago). I guess no one is really working on it anymore?

IIRC Darrick started it, I personally never worked on it, but I didn't
follow the evolution there.

> 
> > > 
> > > On Fri, Jun 12, 2026 at 08:20:34PM -0400, Sasha Levin wrote:
> > > > On Wed, Jun 11, 2026 at 02:39:03PM -0400, Hamza Mahfooz wrote:
> > > > > Any idea what happened to this series? It resolves an issue that I've
> > > > > hit in a production environment FWIW.
> > > > >
> > > > > Series is:
> > > > >
> > > > > Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> > > > 
> > > > Thanks for the nudge, and thanks Fedor for putting the backport together.
> > > > 
> > > > We generally don't take XFS backports without a maintainer signing off on them,
> > > > so right now we're waiting for one to do so :)
> > > > 
> > > > --
> > > > Thanks,
> > > > Sasha
