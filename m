Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8B23F5BD5
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883302; cv=none; b=oEq2yB3FaBI210LktGouRpnJUDKlF9LqjEMVN8jz8wC7cna0Bi7EMfnbddiB0cT1XKp6MGYkpwoMuhzEuCR+bzfbl2vu2dKjxPe4t6ZfljfbhEfvsttNMMDEw+CNdlt7YB2/z/GjCtnyDv+tTtWNy5ik1aP78AbScFFvxcGxsS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883302; c=relaxed/simple;
	bh=HEI3NInBIsei/EoRNgiy0qpwrOV6JThvbMsnk7Bz8SQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3Cx1mF6feA8vgk+WgNv3XLtgTUGVnRbw/gUM635YSJL7oW8p896o+M47WcBdY2xD6wNMtmu6Fy/fAH8uLq9hsD/6ZeFVUbDrMJnCQN1SBczN6sWc8QlCW+thRlf8yaIhBBzR/byS5tCvkr/NUnNuwRSaFNj6plBJkprwZ4MuJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jxh1uapp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jxh1uapp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4394FC4AF0C
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883302;
	bh=HEI3NInBIsei/EoRNgiy0qpwrOV6JThvbMsnk7Bz8SQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Jxh1uappRE+fFuV27sWkHNzCj5+d2aVT1j65RMydPiA3+qfe9fqYBuFzc0ZIj/Fpu
	 cFQRaQJoY/iHrKXBJdS2wsRk5rq1xzOyNcs7yejiWh8W6RgAaWEhBqEdZJpxTPy77M
	 JRYi4PNnn2wtzhR/wyqz4rMdmJR+bxiI2vRMwsQLdaCDEgehFvJoO/bHVv0iHuTfP4
	 wfuarXy7ruNKoiYul90mjrrYps4vYn1HEB9yDrtHODVNDLOu+Ppdbyoz4u0hRfUsC2
	 37C28MIvN0l8wESpsUfo9irFJWsoyatkAK0iZULeakWTs0Pc88eJ2PNYyU/VJuXeeM
	 L/xniqqnaAmhQ==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-65c7a459105so535828d50.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:15:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ILZf0ujq/48ZkP0lI30qB9VY14tCDSN3J+09PIrt3NCIYoiq+RHTkJHh1VKRK+05iJTN0VSbpIWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjUi7abVELrFcToYR/K9YOyKr1uPl9K0TOQO4/fLTLOnKnTswb
	RVsGs4qjZ0C/YGUmDBwZC2vJO33N4ha4kBdgLHhbXqPzv1XZdNZHswEPMP1CohQc65BzoXhlFo7
	fHVJC8u19krc5Q3AudpIVzsc+U0Ishv3Am0qLVUfz+Q==
X-Received: by 2002:a05:690e:b46:b0:654:3fca:3515 with SMTP id
 956f58d0204a3-65e0b21fe50mr8034402d50.30.1778883300972; Fri, 15 May 2026
 15:15:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-7-hch@lst.de>
In-Reply-To: <20260512053625.2950900-7-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:14:50 -0700
X-Gmail-Original-Message-ID: <CACePvbVAWsNZ22gzuDEfLiCK3zxb18svrJ+ksuzHnR2eQOyZyA@mail.gmail.com>
X-Gm-Features: AVHnY4JHBmh6X5lXS1qOF4QpMHKR8b6gUc4PeaeujUpSr4VXuziU4ZJkvW_XRo8
Message-ID: <CACePvbVAWsNZ22gzuDEfLiCK3zxb18svrJ+ksuzHnR2eQOyZyA@mail.gmail.com>
Subject: Re: [PATCH 06/12] swap,block: move the block device swapon code into block/fops.c
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Make use of the abstractions we have.  This is a preparation for
> moving more special casing down into block/.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris
