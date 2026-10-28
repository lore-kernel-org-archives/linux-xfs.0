Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203355;
	b=Sb9WQ44/eKBg3l0+vHCd7gud410GX1/LRwt4B9wKaxewaktxbUn42NSGibxPDTi6Q9PE
	 6V+a9FWJsHRX9RGKaqB9ThDLZyT8khyo5TbqF1rUBMW4PeC0OcYf4qrb9kfWIg0Hku1s/
	 CkoNplEUl2ZWU8PrY/e06ZPLN4WwNwxw7QTLITBKXzH2osmN8uhW0oD9I7nCzTH/RCjXr
	 bR0IY3/3Tz0Brq042cYzmgk1KmF8dNpRERe5NA+pZ6BhJbX8Gc9G13Def1NHs01IRcMyU
	 vDqOuMxyEK2uP2wXDZap0aISAYArLpQg+S+qs7+IUfThZ3YJJ3KcbvLs5Bma4HpkjSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=pqvidO18/MsoqEupSyt5zaIZm2NWShVR3YPJxgjMIMs=;
	b=Iiy3suYzY4jmVvODBRZcYpwtddHkypL9J7xqdWWDPuZyACTkUUrwhXGu+FBljKxbFEuR
	 fI6SrYr23HS7ISj8wlzu2w8a6nzZKUvXwZs0hmw5N2E/ohyJKx2YdQxibmFjcOWqBGOos
	 U3t1z0u2Ri/QWqH792pNZ9cY0mvSP8A/tRiss/xAJYsND6JM9u7Ff+jNYtyDSCWvOORcN
	 lAZvqAXcxojXTXG9NfbIH1fH8FJIH7pAx6ikNNt7aSNgRICAiuCUWE2NgqpaFGYJin73W
	 ZjKCSRQzgQmgilC+pOoSDYTW9g9yg+eNp9cfqEDnzdm2bQq7JT0SSOKSEpPRqXYFvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZG0L0aDj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF0606A31D;
	Wed, 28 Oct 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZG0L0aDj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46E81F01828;
	Wed, 28 Oct 2026 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793203354;
	bh=pqvidO18/MsoqEupSyt5zaIZm2NWShVR3YPJxgjMIMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZG0L0aDjqTsgzLztgQj3GHplRgcp3JC3WsGZx/YxNehTd57FmefkseXr4Ci+4rVVw
	 zsXoUG77/qVXIA2DpIi2sH2fHwl0axkhR82Tjx9aQoC7Sw4R9qUujs/7L2qGiiyxQv
	 PNpbPrkUbijZwlr47dpkhLJ1a+VXN/J5c5ub85J3WNeW3H3YLxnJ6AENufO/RZu6Ya
	 JpHCSjA8ZNcK6EQ4M9Yem1gPVU7Mm8F8EsMtwmSU7iQFut12ngDTz77ZcX2DeEmXuM
	 DTQlwFe9KPqXNTo3ZYRHY5f02yibn5HXVRh1DwdEbuXTEKLho1gpQlejTX87U/GRT9
	 4dpxOZTZfBbdQ==
From: Christian Brauner <brauner@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
Date: Wed, 28 Oct 2026 17:01:49 +0100
Message-ID: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org> <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org> <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=brauner@kernel.org; h=from:subject:message-id; bh=/2bL9FoOj20KqA4rEtCDZi7CA8CHUBzAXKXFts8ojnQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ksmL8GiJ4XnsbsM5a7aM7ZHXDo+ubXVQend6xo3Dq c6XHseWd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk10SGf8Zp6etfiUn5Kaa4 zdp+ONFrN+eR4/7Xl/x14Hr2cnIIdxQjw5rNYWumRtzN/zyzJWbl3ZUT/BYEPb13q6vr0/3MC10 NDQwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> idea of the freeze sysfs file was to make it behave like the FIFREEZE
> / FITHAW ioctls. This isn't what the code is doing at all.

That's a pre-existing and separate from this series. freeze_store() calls
freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and never
goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes the
freeze glock. I don't think that's for this series to fix.

> Not sure what should prevent us from fixing withdrawn filesystem
> thawing and the SB_RDONLY issue in separate commits. Both need fixing
> in the end, but that's okay.

I guess.

> So before this patch, 'mount -o remount,rw' of a withdrawn filesystem
> fails with -EIO, and this patch changes it to -EROFS. What's wrong
> with -EIO? Once do_withdraw() doesn't set SB_RDONLY anymore, the
> filesystem will remain read-write mounted; getting an -EROFS error in
> that state seems odd.

You can keep -EIO but I tried to make it somewhat consistent.

> > +       /* A withdrawn filesystem can't take the freeze glock anymore. */
> > +       if (gfs2_withdrawn(sdp)) {
> > +               mutex_unlock(&sdp->sd_freeze_mutex);
> > +               return -EIO;
> > +       }
>
> This is racy; the filesystem can still be withdrawn after this
> gfs2_withdrawn() check. It should make more sense to bail out of the
> for loop in gfs2_freeze_super() on withdrawn filesystems.

Right, good catch.

> I'm not a fan of those fake mount options. It doesn't matter all that
> much for "withdrawn" because remounting will fail anyway, but it's
> still messy.

Sure.
