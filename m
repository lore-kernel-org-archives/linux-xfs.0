Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562169;
	b=W7+nkpnfdoX1AVqht2SWdNYKgTFNyPYGFchwa4SGGZfq3uuAC9x6PN5grjVkPuneAmy6
	 49F1XztXr+9uS88BhI9UBX5+aR0W01CduCaa9lpuc8UVdtrjVvgugr0yr07fscgxln12R
	 J98HWFNZ/+jQul9qcMhgQyyEEDvAHdf39F5Orb+V0r5iN5hybSxok3kiV+Io9wwxPEhqW
	 ZiQSc5mqpeXbyE8zabqJOkEB4Fgl/rEAunSOIZ7f/lk6ayLSegHCm4xHJ7cEt7g2lukRS
	 sOaIunKIC7c6qGGVmTYzIWchlVRbkdEdwkjhFfbhurq6r7LFrmqq4otuVurpsPVGy0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562169;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nw/51PF4TJNFh8UkFaKDOcT2MvzI7GDnyjnmESasy7A=;
	b=2nhhA1jnfbO21h03arEICev4googn0Klf4a96IRFiyRYCzrQccZTUX3UEo1Vx9nTmiSG
	 YNDrYz0jr3rRBeD7mINLAIjuODLDDOYOA1D5nQYMorUlq0oEkcLGvMusBugxNB3m/qEnP
	 uT6yt8wOXFx+Y2vZPO+LY9QzoWSs55Sl4eADTSrL9sQIjQtNtj0SncNezvPiAkJ0Z2zX3
	 uAjtnLFHDHmfGtCv9/8GhcK17mFFWAvZybTAfZPjodIaXo/RZ//sVjDyuoOnPDpSmCB20
	 8b1zrMRwixxt1iHNmXLFm43C1SX8dptxnEFhzr/JHfb92lXndpMInyK5KN6Pw39DA7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPHUFdvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7EB606A31E;
	Tue, 24 Nov 2026 23:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPHUFdvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E42E1F000C4;
	Tue, 24 Nov 2026 23:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795562169;
	bh=nw/51PF4TJNFh8UkFaKDOcT2MvzI7GDnyjnmESasy7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPHUFdvHFaRsE9kBhT28WZv933HqbbxEueLgYq6DCfD64pxj0Tm12m2wG2QQPry6u
	 3LmY5mFetsFJ/IFlIXIMEpi6w3/NFm0EDZ2PvSRgFi+f58IGwQpicT30aXRhPvbGJA
	 PMHsvkXxTueHLBJV0ToBHBwkmSoFxvkAiyiq61woFEzqBGQophErlMcHDwjRLTRHUh
	 cS2au2/LHham7//s25WCXzlEdemwVwYGMePzlPxeWaDTRLwtM4N8suiZDUTeJbERSg
	 MS9qM34OEGEEM+TGeuyOamWLJKh7IDQco/VNDvB6pGA8uRIGtwPxnzy/0NdAabSZt4
	 MLRw5d/XPhQ0Q==
Date: Tue, 24 Nov 2026 15:16:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Andreas Gruenbacher <agruenba@redhat.com>, gfs2@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 12/13] fscrypt: Use inode_or_folios_dirty() instead of
 explicit state check
Message-ID: <20261124231606.GC2001@quark>
References: <20261123085601.21199-1-jack@suse.cz>
 <20261123090040.19006-25-jack@suse.cz>
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
In-Reply-To: <20261123090040.19006-25-jack@suse.cz>

On Mon, Nov 23, 2026 at 10:00:47AM +0100, Jan Kara wrote:
> Use inode_or_folios_dirty() helper instead of explicit inode state
> check. No functional change.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/crypto/keysetup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
