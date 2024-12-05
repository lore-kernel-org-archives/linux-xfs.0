Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B25207DF4
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733393386; cv=none; b=kskdBKAcKgBVUZj5DjB2QmhpIenxYT1sz9I8+iHgT/hiHyTqBfyWvtK3bK1TdJe5taBVCKk+Mpeg6eJGaU0FJ0fXnysDAVUnbdwxf3JqK0YsrQe6i2YXo4BliMFBBgPiFCddKDJDQ1dLffTkfqUunzSeoOvcnTMNVqFpNDPYQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733393386; c=relaxed/simple;
	bh=Z3jv//sWM+e3WT+jnrPRbrsc4Gs+tVld2MeSfEgS1aA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApoetQbuFUjYmFdTWXOg9EHTWHFNG5Hwj6aUt73bm0JtZf36Kvfnaug6ONEVsrMRDyA6C9wSarT1b565b3CLuq2qmCAw9By+V8pf7q21FKkftkQuy1clNosDnYkbp+I/Zg/1+PuiLEFYnjDKCDweZWqaMqLWejom1vSVWVpC75c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=N/taUM52; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DeiGWeNX; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="N/taUM52";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DeiGWeNX"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9B0332540228;
	Thu,  5 Dec 2024 05:09:42 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Thu, 05 Dec 2024 05:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1733393382; x=1733479782; bh=v5t/ziIOc4
	l0JW1Yvn01ex1aF8ZHYJTjeie4e0V97Js=; b=N/taUM52m/I+74t1nLxDu83bTc
	gDONC+XgXwqYSamkGwfLyjKsRFnqsfF1t2TGBXXNBRlevYIVVjDFWcjY1iGDKbd5
	WEMAphzvnCT9Fm9oPmAZERZ7RSHZJijpx/Tek9bAdXg95P7PuFicCikf5I3oaFtH
	z/6+t8yIl++DcAzBVkhHCopt6AvMuFZclBJfeglFIIGANHey/BXRkjwm0xRzxRdl
	IVZC+unxR1srNcjrW6TGKZzh81zqXfAVQX66N7Lr3QJIYA+InO5JdJGpF7mFEKkX
	JNujJMS54Yh06NJe4jX/oZ9uY7nwhIcaykYbNbsU+RrY6Ze4zqCTjECDd5Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733393382; x=1733479782; bh=v5t/ziIOc4l0JW1Yvn01ex1aF8ZHYJTjeie
	4e0V97Js=; b=DeiGWeNXY1Jy8eQa7YUX8+rtZpMPLJGRuuk5HgsqBrvKbpK7RZ2
	Hlp6H+LkqC38bp3UvTr/Zf8GMXl8S3Khe/vlAvYNSVqj9r4RLYIh5OzcZlhdwdqX
	XkMt/PvApyuTlpmcn9iPWyjCTKBYtep0YycRO1ZheM2OcuROeMr9ekHs19fhwdIf
	HpU4HTJ7VQvtTNBd5ZtqXu672ryDsbKTLaFlgwoKLrR/HKblTHpmbUFqbqBk4OdU
	O+4/3FT6oVtyPljmo5jk5/YBcODrROPoMn6QuH7+/5nr+nY2cRoGjwJk8SFHXRbK
	3lq0xzsB35JG65XZg1tAvxQfsJWI43EDTvw==
X-ME-Sender: <xms:5ntRZyT_IeexeH_J7clVZ7X4fgOlp4Tg9jzWObdpNfP855Zl0QgIjg>
    <xme:5ntRZ3wW2qmr68B4h8Z0Ro7xjEeyBX3zn6Tubl82FTcWShHLHZafAodpPOozqMiZd
    jpYWFQ-BM20-pT0Iw>
X-ME-Received: <xmr:5ntRZ_1Sv3urFgP9KA2PB8OrAm4QnUMa0XzB3W1joZrjgQoIYEhpgBttqTYHz7T0EwHvi8r8FyShIcvAOOeJnIgf1bVX_5RElw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjfgesthdtsfdttderjeen
    ucfhrhhomheplfgrnhcurfgrlhhushcuoehjphgrlhhushesfhgrshhtmhgrihhlrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeevhedvhfekhfeuiedttdfggfefteejgffgteeluddv
    gefghfeuheeghfekkeekffenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhprghluhhssehf
    rghsthhmrghilhdrtghomhdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouh
    htpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggrlh
    gsvghrshhhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:5ntRZ-APJcE-iqtMhS9XTPQHWFQF19E726pe0ZmXrK3Ycd3tAyIkEA>
    <xmx:5ntRZ7jGzqfFkd0g8stmkeXWy5ueLmsT-d84nTwT-wYBW04nqbnMug>
    <xmx:5ntRZ6qIGnxirs1EVT8Ink8Db0e17gzRj0wyHSf6oIw95vudjQvyIQ>
    <xmx:5ntRZ-h9aomtyMgZmaazsLRQLebXKweVRD9q4vABbDnuj5g_TG7Mbg>
    <xmx:5ntRZ4uZh7YKsalVal0-K3W3UmPznS8EMqG9kX5JGW2WWczHb5S8eo7v>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Dec 2024 05:09:41 -0500 (EST)
Date: Thu, 5 Dec 2024 11:09:39 +0100
From: Jan Palus <jpalus@fastmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs v6.12.0 released
Message-ID: <4ssfj3ye4724v66ravsmi7aajesbbj2k5pbordrejzmosecekg@kwzif7uhh4ip>
References: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
 <z34jlvpz5wfeejc4ub2ynfcozbhdvzp3ug2eynuepfkqlhlna5@fpuhaexfm24h>
 <20241205054404.GA7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241205054404.GA7837@frogsfrogsfrogs>
User-Agent: NeoMutt/20241114

On 04.12.2024 21:44, Darrick J. Wong wrote:
> On Wed, Dec 04, 2024 at 10:50:49PM +0100, Jan Palus wrote:
> > On 03.12.2024 11:10, Andrey Albershteyn wrote:
> > > Hi folks,
> > > 
> > > The xfsprogs repository at:
> > > 
> > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > 
> > > has just been updated.
> > > 
> > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > on the list and not included in this update, please let me know.
> > > 
> > > The for-next branch has also been updated to match the state of master.
> > > 
> > > The new head of the master branch is commit:
> > > 
> > > 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> > > 
> > > New commits:
> > > 
> > > Andrey Albershteyn (1):
> > >       [90d6da68ee54] xfsprogs: Release v6.12.0
> > ...
> > >       [bc37fe78843f] man: document file range commit ioctls
> > 
> > Note there is a small issue in this release -- ioctl_xfs_commit_range.2
> > man page is never installed due to how INSTALL_MAN works:
> > 
> > - for man pages that source other page, like ioctl_xfs_start_commit.2,
> >   it is copied as is with same filename
> > 
> > - for mans with .SH NAME section, like ioctl_xfs_commit_range.2, it will
> >   use first symbol that follows this section both for source and
> >   destination filename, which in case of ioctl_xfs_commit_range.2 is
> >   ioctl_xfs_start_commit
> > 
> > Effectively ioctl_xfs_start_commit.2 is copied twice and is broken since
> > it points to non-existent man page. Swapping symbols in .SH NAME section
> > is one workaround:
> > 
> > @@ -22,8 +22,8 @@
> >  .\" %%%LICENSE_END
> >  .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
> >  .SH NAME
> > -ioctl_xfs_start_commit \- prepare to exchange the contents of two files
> >  ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
> > +ioctl_xfs_start_commit \- prepare to exchange the contents of two files
> 
> I had not realized that install_man does that. :(
> 
> If you turn this into a formal patch I can RVB it and we can merge it
> upstream.

Sent.

Although I was also contemplating swapping content of
ioctl_xfs_start_commit.2 and ioctl_xfs_commit_range.2 so
ioctl_xfs_start_commit.2 contains actual content and
ioctl_xfs_commit_range.2 includes ioctl_xfs_start_commit.2. It would allow
to maintain logical order of ioctls however I believe emphasis is on
ioctl_xfs_commit_range and perhaps its preferred to keep main content in
ioctl_xfs_commit_range.2

> 
> --D
> 
> >  .SH SYNOPSIS
> >  .br
> >  .B #include <sys/ioctl.h>
> > 
