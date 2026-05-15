Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98E405C4C
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778882466; cv=none; b=ENLpkK8ZAslBniPvfI5I6vx60/zjjqJx0NNpAe/7uphRZKUTl2+ChNJ7ecpnMhjavPH+VNuJ9E1UjKgPd3OIeToTz6DxwKJCHUInbVwKolSRWbMhJmPjla08BRKN3wXvUvUQOOCogxvuYLC5pJ4a96lApgHkc29fuuu/s2b2lyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778882466; c=relaxed/simple;
	bh=8FzUPImWV18kvph4lTxQrEFg0N5DGTFbvVX3bryYp3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k297Egy1UfDVOCEi+LDDtj6b+Q3PGpLyt1Y8J4YxSNiv104pJoQPau/eVcHYdQJjFIIvOTxtOR689kq7Pt8FXbmcSxgpBL/DuDpFrCmETRWgOLmfHRrCF42WdAXOyiFyaLvkueirKtfSnJGJzZvUefpe7cSsmmLnjnrqs6JKExA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnxyRqbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnxyRqbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B0C2BCC7
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882466;
	bh=8FzUPImWV18kvph4lTxQrEFg0N5DGTFbvVX3bryYp3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VnxyRqbTDYx6GgcrEkNlGe2hGiAg4yRf75lATHoVW0PpFzHCCZ+JgXUyuTTzFzYbZ
	 nNFOXRco11MWvh1JDJOczfjW/o82VAln7pHQl4C82nUu1ViOis3SosrtDwHSbeQ5h2
	 7hh5YIRfWUUE01drL01kz1ymKoCuIOuYafR/+moxrWHGCFsIPM/YwkCOoOMPR2BW2F
	 sEFBWfkOLqEDVYWBgUv069lwh+x4UOBR3ulzyYJOKkob68jjmMKdwTenYe8GkABinC
	 7xFMM9GSsMSLs+ZAmcpTxsTv3F41hHwR75Z87TBgh2LyaBVb9TXRTx2e7ts+Cg9SFX
	 aQUiJr4F/vybw==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-651bc83e74aso663503d50.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:01:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/IhS11v5yX+qiUBal4J8oVBOuRovQFM7fwiPTqBUGNmCgrja6i6NybMOcz+LTdHdJcqPLB/TgTlcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAHebCWOIA5iPXeXG3OVbGiSQoeuJlt3Ls+UZL7H9vPlwgxvmT
	iaFofsxbDFsRFFIE7za6qAF1J5cslRaOBo1BbMHiuUw/ynK80h8uuahfaRLPJiGtq5VxG/vRlyR
	OEJg6cv4hx3ncL7UDWmwl+x4b9WRM2kV0v/ph6GvsnQ==
X-Received: by 2002:a53:accd:0:20b0:654:468c:7dd5 with SMTP id
 956f58d0204a3-65e2280d9e5mr5432439d50.33.1778882465457; Fri, 15 May 2026
 15:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-11-hch@lst.de>
In-Reply-To: <20260512053625.2950900-11-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:00:54 -0700
X-Gmail-Original-Message-ID: <CACePvbXY5sdG=JXV2TE65NAWaEQ975wHhcGGzuFg5mRECkwy+Q@mail.gmail.com>
X-Gm-Features: AVHnY4LoQkrm9-GqAeD5m6WwSsE12ARR5KdnPZLUwdKcGhFx_HvxcMbpEFa8lE4
Message-ID: <CACePvbXY5sdG=JXV2TE65NAWaEQ975wHhcGGzuFg5mRECkwy+Q@mail.gmail.com>
Subject: Re: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
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
> Add a helper abstracting away the low-level details of enabling
> fs_ops-based swapping.  This prepares for taking swap_info_struct
> private.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris
