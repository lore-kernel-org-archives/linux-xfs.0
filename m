Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182781;
	b=rebCwKnkTELZXvVheHnh/3oNxU+OGfJUFLSaNmU9IhbPXABmB3drcgvp6yYz1OG0Q0ML
	 I7p2zr6RobC7W7RLERgWMYDEsfYwkUn/V7+F5j+zUQLbRhHo1pUL2HFfwLZd64pd49L5A
	 0bQolR4ttshvyA8WWI/6W8jbbmdqxOv1TQQV1fH2MYfws3ALZeeR1WYyt972ahF/FUs3z
	 mOwPy3gJsZXX7z3ov8ca3567pIskdVNIkdV433Q6AToqH/DmOC5xmDpv/GUeBWmlc1AKb
	 r1Z/1nC8RcyX5MXSalny4+0mhMxsgNsCknjlfOzsOtjyELrEdqJw5vXEVOZhSTS3V4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182781;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MtYcp9E4TOsBFM3Tgx+Vs46+jbMI/1uCJNU29VoYtl4=;
	b=JCesPG8uu3R3+oG0j+jOkWGJPfkDBF9M4PEpQKnduDcBxtBXwo3T5dlxRq8fUZf1PL87
	 fOtLoXhO5o4VLwKTags3bYxupN92X8Kt2a4HylNB/LcE8fdwGzdDw74xexc0DIOKIlEGe
	 UP7pMx67Rx1sEtJW4Gady21S9aCBCyhf4UDrkiZLbaUtYPH6eHJyxYOAaPAMMEKLwTA3M
	 Q8J8Kvd7iolerKw8jpTshwhGG70aB/utNlOdVSPxt1fzDKFMW7+FMmhLtcgwPtZDdbEKV
	 qb8IFcDEAarHC8DPDNVmQpbcAPJWvYhif7ioB2rZRMO1jDqUmM9pFA891AeS7U62Aig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtiNAwc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CCC60A2614;
	Fri, 20 Nov 2026 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtiNAwc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E131F000E1;
	Fri, 20 Nov 2026 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182781;
	bh=MtYcp9E4TOsBFM3Tgx+Vs46+jbMI/1uCJNU29VoYtl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WtiNAwc5j9y35D+mZGCX7gIb3m/b9EjdxE42aBoYj/VOlZGvUQmn4q9D4LEG4Zz9O
	 +MrZn/9A/K1rrf+kz+4osJgut7VL2vULRuU8NCLoiMblKsWwnWf9aglO3in960K8uW
	 +bTOgAWRzap08S83YqbNPjzF2M3yQqsLTj4rl+Tr5POEu+fkraqW2JYl4Goa+fJZ1K
	 xdBmIFBD2FvzkEfVd26UC3ZzrecJ0C7+ucFJCYhsrcW4DbU/y5rAkgjBDGkYxd8EVh
	 gZ5O8CgrlqSRT8aBKByHHS8PlBhOargTTQKdtC7TPEdrOpktF9HN8J6kQAfoyCyV8q
	 LeafJNAVj23pg==
Date: Fri, 20 Nov 2026 14:52:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, tytso@mit.edu, david@fromorbit.com, 
	jack@suse.cz, djwong@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	tz2294@columbia.edu
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <awBQmhLF1xjsZKOg@cronus.toxiclabs.cc>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
 <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>
 <20261120-echsen-wolle-gekonnt-03c21df2493a@brauner>
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
In-Reply-To: <20261120-echsen-wolle-gekonnt-03c21df2493a@brauner>

On Fri, Nov 20, 2026 at 12:23:22PM +0100, Christian Brauner wrote:
> On Mon, Nov 16, 2026 at 12:05:26PM +0100, Carlos Maiolino wrote:
> > FWIW, this is another patch that would normally go through Brauner's
> > branch, so just in case once we get it settled...
> > 
> > Chris, Ted, Jan. Are you guys fine if I merge this patch through xfs's
> > tree?
> 
> Seems fine,
> Acked-by: Christian Brauner <brauner@kernel.org>

Thanks Chris. Jan.

Once the ext4 patches that this on depends on get merged, I'll pull this
in.

Cheers!

> 
> -- 
> 
