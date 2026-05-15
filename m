Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988E3F0754
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778882349; cv=none; b=ShAjcyxWkDQzIc79Qu33tnVy1EZXU+Hjyxv8y93C9680SWKjpQgs7nq8zFOqLGQelEDweYW81tYnOhSkA17m0hzFTaGKi0Tn+8ZZJlhPdb9VkVd2Ecf/vmdrwst/cEWrjmhJ/YMgpjAe1l+ShW6Uw4loMrH0E5FQHXeEE0R0lUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778882349; c=relaxed/simple;
	bh=Tefq8HvM4P5E2wSS3fwKg/uRUohzy18j3qB5eF3vc+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3WANW6VE90gVoz4gf08o6N1aNz3kswE3EV6lhrfOrOowIjwtbJ6N/y+OMDkpcWChajNIsOTIzh929IZOFiqZtB/JtkW7SCbjn2AWulK0JftLb8mfuOwYbzPOho10ShXLd7jz8C4DoVYaQQCoEK7OHBC2HGAk9tW0g6kFWPU8m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZbHcBYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZbHcBYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E879C2BCB8
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882349;
	bh=Tefq8HvM4P5E2wSS3fwKg/uRUohzy18j3qB5eF3vc+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cZbHcBYiSmtl8fDU3P+2ZlesHw+cZCPoo3njznfI9/LvgERGaxHNlxFE0VbBLM3cJ
	 U4/g8SToz/f/MqC6UFRNoj85ZV/bzmWzlXdwUaJAQrUPtDhCFTRm3P0wp+QaPtTc1Y
	 WxO0WpCGcBt+Ak+nLn9Ivw4FPHslqo8QxlDCQPpPRg0sjB335CWAGIMjpJM2U9hx0z
	 apb2PoT/WotxxeaGndIf3EsZtcyrPA6JLbKxAjrGvVaeAtch+2W3RWYKLRc2QRDyGF
	 RI9MBmF6dE4P7hR0BhXTBm6tH9ddnzfI3kEQfbf/x3ZSxMx4z7C8XizW3cawrLbUM9
	 ftFlYkWW/Mxgg==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-65c37eafcbeso837539d50.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 14:59:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8InXuoeOP/UodLkdI3pBTTnsp+jx/nxyWdq1n7qi6ySC8tV6aWhEMeLEh/qtBjA8zDmA2qeIs593Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw88Xr4gO6d7Sp6rWLPWPnJdVb17uSbks1j7PWiWCVqk3y+z/To
	Wn0dKNYUsZBXxokgvko0ZSjVnkYAOkRr93PDQbyWashOJp19S02jbikdMPtSxk3UHVtHoQ/5T63
	qU2PQixYUSXa0R/EqtAvI9xJZdC7pEV5Ht/4KXcSkWQ==
X-Received: by 2002:a05:690e:4188:b0:65c:477a:2ad7 with SMTP id
 956f58d0204a3-65e22733998mr4980962d50.25.1778882347862; Fri, 15 May 2026
 14:59:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-12-hch@lst.de>
In-Reply-To: <20260512053625.2950900-12-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:58:56 -0700
X-Gmail-Original-Message-ID: <CACePvbWMpfBo0zSFmMGLh7uxrpL2ugHCmD9xp=FC4aXiv9GYmQ@mail.gmail.com>
X-Gm-Features: AVHnY4JjyLNu3psg3JDksoA1h3sEopdVsiktUSZMp2g3bBnm0ZZ5mBGkhXfViRA
Message-ID: <CACePvbWMpfBo0zSFmMGLh7uxrpL2ugHCmD9xp=FC4aXiv9GYmQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] swap: move struct swap_extent to swapfile.c
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

On Mon, May 11, 2026 at 10:38=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> struct swap_extent is only used inside of mm/swapfile.c, so move it
> there.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris
