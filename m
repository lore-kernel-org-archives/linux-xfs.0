Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002364;
	b=Ad312p+VPxkaD8xUnpf+k7gD7D5O5ARpITmhYecOphaQZ3R1b0q9TqnVF8nfHjRo6swA
	 mU5mU9/Nufz5fALCeakGJHNzpFErG/QO+UYwFBVL5uMgUDwy+odPYJIiS/Y8Nhx48hxE1
	 MbpyoikQ7CN74Fvv/P9WifrsyTa2M2A7vdRqyecQts9VMi3vC3d8qtIxbuV7++DCvnkS3
	 L//UDMYPsIUnApfwLy85mvE3V1P8anwB+pDC9YeGYZXlf02nLlnk2HC13iEcoiatUuqB1
	 1EHikZMbRTPoDdo2BoN7+nk+i5XD9NQ0FCvtxTgQd0iit3utyDBWutS6ErN1lrkBpjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002364;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=twvo2S5XjbqEkOWkAQpnGbrW91qUdbVnGPc73sw06G4=;
	b=qp9WLMiM+KUsJYD+64bAXe3GTd5T8fhRh5cjZlzPfA+r1NkAoaoTchQbSmqVKEpcKi9e
	 FlUH9yzvpD+5uQ5L9H0sVSnBRjP4BqTWSnhR5tzGfmsjsBF9WDRcVnkzCzY2YGWCxzbVj
	 TARDOhGXeCBU9TXyV4Lf4XzNig9DaKaGT/83kIdLU2Cxk63jnp0BtmOAg+HOSlNJZcP7P
	 /6+pZ9ghdrrwdU1BJJJ+s+H2a13e46HA6VF4UL/5Mu21uXNWlbQn+g3YhYMFbhfPGpn+J
	 iRrAslpu2CZmrO7EYC6f8Q9AE8v0Bf09fy4HxbHRwrSTJxd9iwFDW3Ue/e6PnI1Vbdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFNJNicX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E59606A31A;
	Mon, 26 Oct 2026 08:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFNJNicX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8936D1F01825;
	Mon, 26 Oct 2026 08:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002363;
	bh=twvo2S5XjbqEkOWkAQpnGbrW91qUdbVnGPc73sw06G4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NFNJNicX6mXjCGpZhiZiDheE4OhQLW4CMPrvMwmhEQV6Sq1TxOHedI51pkk8pDhNS
	 PD8CDdmWZcRxvMEAmdne/GyfcWHutE84sT6cGLcWhob6VmPa5DFpancxtpgIemAgaS
	 Syt6R0JdrMc6iqm2autEf7mFIGcPTNXDKMxLPI46onGdFDgqyEisFCvH98js/oc5pU
	 jM8ULVd2dxYAzoC1xbI9lwPXYMmb7C/wYJ76l99gv+eqVsclhAXbj6jhGt5Uw/LQHn
	 Ef+4BnJX9phtyvdah+Yl5c8tgHidpPYY8nqarZoU5Tcpt3/1EROrnWsO+G0qqdn24z
	 J/Upbu1Wh0rbg==
Date: Mon, 26 Oct 2026 09:12:38 +0100
From: Christian Brauner <brauner@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, 
	Gabriel Krisman Bertazi <krisman@kernel.org>
Subject: Re: [PATCH 1/2] dcache: don't leave negative dentries in casefolded
 directories
Message-ID: <20261026-virologen-abtropfen-endlich-b6ffb9111409@brauner>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
 <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
 <20261024192017.GG2553@quark>
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
In-Reply-To: <20261024192017.GG2553@quark>

On Sat, Oct 24, 2026 at 12:20:17PM -0700, Eric Biggers wrote:
> On Fri, Oct 23, 2026 at 02:44:22PM +0200, Christian Brauner wrote:
> > +static __always_inline bool d_delete_drop(struct dentry *dentry)
> > +{
> > +	return dentry_negative_policy ||
> > +	       IS_CASEFOLDED(d_inode(dentry->d_parent));
> > +}
> 
> Should this also check IS_ENABLED(CONFIG_UNICODE), so there will be no
> overhead when CONFIG_UNICODE=n?

Sounds good. I'll fold then in when applying.
