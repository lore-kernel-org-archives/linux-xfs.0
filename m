Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719054;
	b=oLxC/Bo5e3/Nf90ThdGk8qi91vrlxESETm1V2lKAPnjOqzcXx3X0xJ8vt2phrggPrv0n
	 EqnVX7SHXgx9XXnT997gsl7GvxvpT9wd0/69CfyyOLMKEw2KweOCFk7soGk8agWST1Q2M
	 FtjOOS66KCkU4aRBU+i0Zxb2vPWc9VcZjV3tg8jKJ66er86QR2Hx2rDlG5AcFCjk/uybi
	 SY6Y25GHkcRbRmDkpZXVCDHhhsFBUcrEJqC1aCml9MOxgV1N/YOxVvN08y0Pvosuyv7aH
	 rTS2hyebH7tIpXa7mk/RZUxWaSExycC8DLWKKIJHN6cAc2Vc/VeufoqrbjoXeC4dN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719054;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5Wsk9LOHJwMPw8/QSUlH/6zlrehvKERsORFUS4aUAbU=;
	b=KVoK1H6eVT7hk5vs9EgJDRnEvoL2d1NkjBJludRDOk9WvlI5TrMf/6BU2Sx6vgS+5PdG
	 YB+N9SEFs2dGwLDepEzNK4RnA1Sam7ZFWwCnc9h3mOdNEKfEpyrC75ly4Wl1MXf2DlXXf
	 gU2y9iBTbEftCV9dZzCK2yWsi/2bq3McnD2VUajZMyQ6li1QaaOihPf7Vp2Uewfn+awRy
	 uFRudHz7mvgOWqGorHeaY0xy+FGikehuMqFjqIcZ1axlMnAiAvsv4rmWvPq0E5rfWzCkh
	 57a0PhEVNZ7N7yp0xv4qSGwxlcs21aBaAdNyFHTy/ZoJRD5LTWICPUlqs/ihrZyCOug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCmxFfUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AF5606A335;
	Tue,  3 Nov 2026 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCmxFfUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862FA1F000C1;
	Tue,  3 Nov 2026 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719053;
	bh=5Wsk9LOHJwMPw8/QSUlH/6zlrehvKERsORFUS4aUAbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OCmxFfUGmySxrzm2zs+/0CSGSM34t6GsFS1SsAeLZtnj7DUfzm2FN8wW4JN91ZMjx
	 SY4SDVfLShuLctj1ZXewexnEhR7EG5F67PTwPaZXdoBDRXDycBGazO1VQGUKYLO6i1
	 kJiAGXDRizQyqFwnVGe8lvjhCK+KwhCn+zqRtjwFlRkLpRykeJY0xmUhU3YaUuv1Qu
	 IQZXu0Jda42RcP1cbm43/qz7oY8OjUoEtF/tHuQghbaozjLSBXxch8/39pizRcWVX1
	 S3oRw1E1Ydpn2HxSlKDn7W0KFqKZfIk++TrNc7WXXwEl/qxQi9VmHQoxAHbdD0j5Vf
	 D4M1ShYdsvgJQ==
Date: Tue, 3 Nov 2026 16:17:29 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aun5Jb_4OiNClb4q@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
 <aumsPwTUaMgsccSb@infradead.org>
 <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aunyEHubncj93edp@infradead.org>
 <aunynmhdqBMCTdBj@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aun0ehhlLgEdJC63@infradead.org>
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
In-Reply-To: <aun0ehhlLgEdJC63@infradead.org>

On 2026-11-03 06:49:30, Christoph Hellwig wrote:
> On Tue, Nov 03, 2026 at 03:45:15PM +0100, Andrey Albershteyn wrote:
> > 
> > I see that sashiko also noticed that realtime could be enabled
> > betwee _begin_enable() and _end_enable() as inode lock is not held
> > over that period. I will also add check there to forbid that, but
> > the xfs_dinode_verify() comment seems incorrect.
> 
> I don't think it's quite incorrect, although maybe a bit overzealous
> given that we should not be reading an inode from disk that's not
> been completed.  But adding a check there is cheap, so why not?
> 
> 

yeah, not incorrect just seem safe to leave it out. Even if both
flags happens to be set, the fsverity inodes will skip
xfs_free_eofblocks().

but sure it's cheap, I will add it

-- 
- Andrey
