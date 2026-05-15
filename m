Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381913EDE7A
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778881221; cv=none; b=qTcGkef1VE0IqdRbZunitOkOvt1796TG0DMf7X7ZESMZPKeUZo1OlmduaF7kKxu5LARYAOZQH/RTNTypIVuzi58Wfl3XWqTJyUURopbh8UM9w/tBigkQ0Qg/AYhbpqr7nH42mSnpiJni4yQnt9nX997oTiBtVqx61421P7xPJg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778881221; c=relaxed/simple;
	bh=yn5Ug5k2IASPmOnTWh5/NWKfju83Ji8V+BAWrGXvmqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KBokfFVRnEddi1loMQR8QpI2VKcFL9gaLamMgH4Jv2WsKThZ1Hripnc7pUQ1/OtSCcnQ+JfgYhHD1r4W5qk+AnyExiXyBwx8bCdMh5YQBpCw8MSNZQFxhoam5iNI4FVjDUoKmlcf/2AzN9sF+rXJIL6rqFVeYI3ACkU3/i3raes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpCqy77U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpCqy77U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1925C2BD01
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778881221;
	bh=yn5Ug5k2IASPmOnTWh5/NWKfju83Ji8V+BAWrGXvmqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qpCqy77UuxiJP5M69OT6OBhAi0drLyRIk9VrbL5PImuXKJVo+W1DGL1GTxyvwm/Ap
	 qYwzicA0HugWD3WdRdaqiY/qERdDF+qJ1yrOi80dBJMJ2lOnTNbAjGt057QXURnpdu
	 byM7OJvl/hvAMzB6gwZFP0SMXkNkbAhxODh/esykup4ZKSL6tD6QWIL7kRkgiCrvWQ
	 4c8rjPGv/7SheIbtlwMVjNkzW+2nRHjSPzGcpbRyqvRlyvup2g26IG+XkmKklpY6Od
	 D52c5rAlfSSCPy8Y7KdIS36um5pUDXFrzSJ2loLdDZtVaLknB5oRahkX+Msz7ANBRB
	 9GuEtMCHC/EQw==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65dead17c24so608048d50.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 14:40:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ88+kqXYZPjs+Di+DfN30DWcC/pgaavRSMGhTakxymFFgXcdiy/1y7uCI8wo5fr43zsTwJEd1GQztE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqaK9x8Yl4D+hM4Jklkz5/s461Szfc/5FsTHtgCJ3MsUedkwdb
	1SJvmtPcD8ygVIc64mqRKd/QjkvxWtFZStJqLWagS1TSwt/S//BwDnSOeSAKBWnxEwE9llmllqM
	0AZwxsLaiZndmcAQIwd2/Hn5KFTThiCX/nQJR4fdToQ==
X-Received: by 2002:a53:accf:0:20b0:651:d6a2:f766 with SMTP id
 956f58d0204a3-65e227bae88mr5109450d50.35.1778881220197; Fri, 15 May 2026
 14:40:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de>
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:40:09 -0700
X-Gmail-Original-Message-ID: <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
X-Gm-Features: AVHnY4IVYDXe6JpHvzKEq9XldjgLC8IpryDPCEhie3HNTVfz3whVFC9mf8Ia0bI
Message-ID: <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
Subject: Re: improve the swap_activate interface
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

On Mon, May 11, 2026 at 10:36=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> Darrick recently posted iomap support for fuse-iomap, which was trivial
> but a bit ugly, which triggered me into looking how this could be done
> in a cleaner way.  The result of that is this fairly big series that
> reworks how the MM code calls into the file system to activate swap
> files to make it much cleaner and easier to use.

My first impression it looks very promising. I will need more time to
take a closer look.

BTW, I just tried it, this series conflicts with Kairui's swap table
phase IV series. Might need to coordinate the merge order with Kairui.

Chris
