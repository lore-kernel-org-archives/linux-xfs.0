Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033002;
	b=gSYMWv+nxoMWy4Ue2KPzCaRmCbAvwm0SNttb8f3qXBQ3XJM6q2mpL+v4GIsUZ5rVJYFI
	 O9ISmAgTXmxyJFIgxj+BksU5HQeJ2ixledNGgTrzgK2ouXhHxDAYuH5Urmf7xF9Iifyyi
	 gLwCTpc62YgqDz76XaSYcujTIc3jJjJzUKW0BKHQyIG4HKug3W/Ah81Tjer+fk8mvQyON
	 J5cxbVCPTrRzf51JswdcDxh1wp2kywr7LXb54JTcxOPmBl1YNTOsJrTma+HsE4Tnq4W6T
	 P7dATITfTmrTnZtKVZJu15BfdlRaJhrLjOa9oLVuyyKnTcdn5PxHTAZNi34ztvBlTaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033002;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Iyy5rHt8wdojXmesxiaPyIfh6qBHJimQ/sEuE5qTOKk=;
	b=gk0WueJ76pI8Pgveor7WkM1K7okskBQwQPB/EjKcFl/EP+7s8ntgE5cn52VJj6U9VPyC
	 MZqtq0fu3y2SXsBcSKf5ifKx7jRsodQak16lES6olXhutclkfwGUiO+AeEAReeLIQUHNS
	 XtFm1AlXjm82nRbd1MWgkRkwriNOXSxKSBjFUxqCKyZAbBip/4U5dNPbO6hlwvObZr/cm
	 zoMESEuCbt0E2N3i/p3HwZ3oN242/nUEi9zuV4G3WQ7a1JV9uSdFw5VDSgb6vBvjW2iV3
	 2nKlSHsRpl1lxTsL6/kAA3x6lMfi/pXdNcJ5/gFzD3gEf9oX0+qb4IaHYpflzapLifQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cl2J1hZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0541F606A331;
	Wed, 18 Nov 2026 20:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cl2J1hZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFB51F000C7;
	Wed, 18 Nov 2026 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033001;
	bh=Iyy5rHt8wdojXmesxiaPyIfh6qBHJimQ/sEuE5qTOKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cl2J1hZvIPaLYz8PK3ibIwHEj8ENjkTs5l9jG7LnQLNJZ/pUP5sVqtWlEwOUW25N7
	 DAohysPcy4Z8lORDVUd3JmtGnZsdL2QqOqpfA+rtWGtE8G/1le3L20spuzR32LFSky
	 5bdHCrErjjQCnZXDNOjWG8iJzDteHX5UogjHTPY3wEOWpoJOYkHKjv6qTtl5xLvR4h
	 I3q81pvFCufnTD81ejRhLxJ22v6+YwMUGx1eRT18p3h6vkJAt5iOuaVjm3K/OCtSd8
	 UMRdcCetpZimS2Ea3ALgnz911cLEsjWFBK67vAH9WABxVky8tRfTy1gWfSevD2o2Uf
	 tJRJN2hZKPPhA==
Date: Thu, 19 Nov 2026 07:16:31 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Lauri Gates <lauri.gates@gmail.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <av4Hn9u80fs8iHZ6@dread>
References: <au3wJNbRPXQZG5Op@infradead.org>
 <20261106204026.14530-1-lauri.gates@gmail.com>
 <avYb7D3bCmnw0Mbw@infradead.org>
 <20261117-kiefer-beinfreiheit-entnommen-685343327ac9@brauner>
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
In-Reply-To: <20261117-kiefer-beinfreiheit-entnommen-685343327ac9@brauner>

On Tue, Nov 17, 2026 at 05:22:25PM +0100, Christian Brauner wrote:
> On Thu, Nov 12, 2026 at 12:05:00PM -0800, Christoph Hellwig wrote:
> > On Fri, Nov 06, 2026 at 10:40:26PM +0200, Lauri Gates wrote:
> > > The other is that for a "may share" bit, clear is the unsafe answer,
> > > so a filesystem that cannot answer should not look like one that
> > > answers "not shared". As I understand it, stx_attributes_mask makes
> > > that distinction, while struct file_attr has no validity mask today
> > > (it is size-versioned, so one could be added), so through
> > > file_getattr() btrfs would currently read as never shared. A spare
> > > bit in stx_attributes adds no field to struct statx, which I hope
> > > meets the concern Christian raised about spending statx space on the
> > > case-folding RFC [2]. If fileattr is preferred, the bit could instead
> > > mean "no shared extents", so that clear is the safe default, as it is
> > > for FS_XFLAG_CASEFOLD.
> > 
> > statx sounds good to me, but I'd really like to hear from Christian.
> 
> I'm not fond of it mostly because it seems FIEMAP is a debug interface
> and adding bits into statx() to make said debug interface quicker or
> easier to use feels very wrong to me. So I'd like to hear a better
> argument why we should do this. Otherwise, I think using file_attr as
> suggested earlier is good enough.

I really don't care if it is exposed by statx or file_attr; checking
the flag through either interface will be orders of magnitude faster
than using FIEMAP to iterate extents on every file to find shared
extents. My concern with statx is coherency - it runs completely
unlocked and so can race with operations that add/remove the reflink
flag...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
