Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192135;
	b=RzcxNBIq+0BRXhjGDl2RxfOyQw0oT2mKcTRk31DInSXmEKNu84i3Kp2GhHyd5l72zXAT
	 cXtcvroZD1SoNL+vsv38JUnibgJd4/zJVcVze4LfiDu5mOTdn2Gko6IuOQEufr8dN1XK4
	 NzZv41DV7/m8WEL0sPnBIish+dQgLcBVvSovR9L9GGN8EaCO+EkOB2BbnS2N0KiWJIcPT
	 o8ux9WX+xOMOlnxPv2tISsC5iGlnaT5JoAnUApIMNtkT2dTJC2kSGvxOjVHasaBgsZOAI
	 3EpWyGYHKsXlfngkXwluDN1+gdGUGHUJrklzWNLA86PgSj6BpUfpL0Vayd/LpO2Is0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192135;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hKTq5offfOb2bDNEYaRHVBez+Fjet5kFrAEYBp90cl8=;
	b=sjHdc+gLs0aES4XCX7NizgwpJA6vnDKq68kYFjWWSpoKM2HFlFqgoW4U3sqIVvR9x62u
	 S7b2WNpMHXVBE8blacqiSfGYOKiAzZIcc55WQFK+epWjV2jo+BLbSt7faFQpw6d6EU8D8
	 d8GQbawsanAvnQRv8Ip4ezQzgQWP6Rg80ceEmZPIapEDnE4CEFo548CJu9Qm/SY89I3vi
	 aI4V4aKj1fq24A3BTrXIz7LszFNxBWXK5MrpBkvsU7BHJp2WhEU9eRaTjAJuoWGpnYicn
	 GZPvCNYMgXu+uX7F4tW/Idb1/EHu8r+Ti6BSoUw/5eWz3yNdI6l7+HzXwTLI8ww0/sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djEjpth8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AA606A320;
	Fri, 20 Nov 2026 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djEjpth8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE771F000CF;
	Fri, 20 Nov 2026 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795192134;
	bh=hKTq5offfOb2bDNEYaRHVBez+Fjet5kFrAEYBp90cl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=djEjpth8BxGSnk2aoPvo4XYFFDO0eGaPld+QWKK55LA1ccQyLBAdB2stBwKJLD8Tt
	 0GTRafVzuFXkm4T0YeloOMLe9PX/FMEi9N/4XSlwf127ASmQmYU20C4U9jbt8i6sFE
	 BgxHxm6U0xv45Ud76OaFnxTvUKkesnBffKEOEhpKxjDxE/vPyWCoD2jAi9npzodOvk
	 WmmHMgazxZ1L7kGpkwBdveM28Ukn8zlNyJJVZV0KNV6MfG+XSHqaFjAU1a6QmdU6Bj
	 D7eDE3IxKG85ygq033he358+BkhRUl01bnZpeWJea/6LDEJtrQl5msL4Gpsk91iyB9
	 X9uoFcSqNNRXw==
Date: Fri, 20 Nov 2026 17:28:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, 
	Andreas Gruenbacher <agruenba@redhat.com>, gfs2@lists.linux.dev, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, Dave Kleikamp <shaggy@kernel.org>, 
	jfs-discussion@lists.sourceforge.net, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 0/13] fs: Various I_DIRTY_* state handling fixes
Message-ID: <20261120-ampel-ungepflegt-begeben-9da8182f2de3@brauner>
References: <20261116171044.6938-1-jack@suse.cz>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116171044.6938-1-jack@suse.cz>

On Wed, Nov 18, 2026 at 03:59:34PM +0100, Jan Kara wrote:

I'll wait for your v3. :)
