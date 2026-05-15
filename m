Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB4B3EEACD
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778882298; cv=none; b=O+P6CDyKQZHQKhzXAA0HsftsCqr++Q8AkDRSVsDO4VNXsAJvrtJvLcDP3kxs/4cVaqAZ3JHyoy6dYlb0mrlb8Q+S/Zih9v4MYG4NBqY53Il0w+xr6D6lzOTVpvDjkz2n/YTqXHGxSGMc74n+0Rs0l7Of7tG5EpI++Xfzos2yN7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778882298; c=relaxed/simple;
	bh=/mHSzbEHbunn4Gv+x6uYZkpcvkpdkTON/QAE5a6at5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L3Y86Kn/wy+q8nW0hZCz1ilVGhNlX06O98OnjYma2FrhQoQtpQnOPgNCy+XC2ngXsrxhKEvxasq7YORQ7gRbmvEpEuRXZ68vets7egI5H3T8Zkkt2TY3Tl4eYXV6Tq+eKAPfFAEUQIryM1b6x1PMxhpt1x+NHOMhhV1+frVkgUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrySnH00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrySnH00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A75C4AF0C
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882298;
	bh=/mHSzbEHbunn4Gv+x6uYZkpcvkpdkTON/QAE5a6at5M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YrySnH00B0W1qq5Wp87dlgYi2suFfNd57N2Uuth/vkCX1DrZ3IvFyxISLW0xoIF69
	 hRjENHlGB/3ONaZlglJOc4ukuB0ctST7O4dj+rUVrdlnm1YanBPd1V+Bn1UhoHLW4E
	 JXQ/kS1/ER7ObuNKR8I2hcUCtTBptWdMJXaZCExsraRoFD2Gyjk7NySzzJmUpzQ5cR
	 j5a0wZY7iA7GqaZgUjtc+Taku3bBD9oUOyoWapVjk+PBcCyiTk7K5qE2vYSk/R3eiH
	 nSUWFrQFAEnpEsEBNYMpxB2+u1QHKALgTRITtHr4Lpl3a/9KiTwUTCsF3mm9EJCbKa
	 NZO40x8BvCEDg==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-65c364b893aso670519d50.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 14:58:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/PNMT2XhHJMrVSOORwBkYd+cZG5HFVa+y8JXuo27JtfsdMionJw/iBLDkij3yv5grtwZpiL6UKvu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBH+om20Z/xgwFRrmAEkgO0x8OuPrZldP9FmoneyU8vck/kNG2
	04k258EaYj7KDcAJAida11PRrRzyFnzLpK4U+1cL+n+l9c3RH5cM+rUJYYjIHGT+ePZ/eok3nRb
	ne71m+A+pfpr3Oi/buHxC/Edq5QUV/QkBMROc56UW/g==
X-Received: by 2002:a05:690e:1517:b0:65d:f308:b503 with SMTP id
 956f58d0204a3-65e22650c4amr5634144d50.1.1778882297534; Fri, 15 May 2026
 14:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-13-hch@lst.de>
In-Reply-To: <20260512053625.2950900-13-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:58:06 -0700
X-Gmail-Original-Message-ID: <CACePvbXhMm0nzXdTqbF5j57AC_7qOH-hMZ5pB6z0cZFfAixH5Q@mail.gmail.com>
X-Gm-Features: AVHnY4L_tQU_kPqgc-BeGp-d2068VNSoZvM02GkthxouKCr7BEGYMQdDLNaKcrQ
Message-ID: <CACePvbXhMm0nzXdTqbF5j57AC_7qOH-hMZ5pB6z0cZFfAixH5Q@mail.gmail.com>
Subject: Re: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
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
> swap_info_struct is now internal to the MM subsystem, so remove it from
> the public header.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris
