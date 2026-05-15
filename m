Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4F93F5BC0
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883163; cv=none; b=AFiXBHCJm8nMpOf8xRckzo5FG9gf6pJulR35ANeS7VkGIL2bJaQQnBCvvdKyjT5jEDRK70qvzZpspB+I/JuYuvXN9LqwJZKSvXkVa/JBGcDmgFvlk6Qx5EhYbsPSd/cQGlC7uKTjcejdOG+HZwd0cicnRvrASZta7aujYVFHcZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883163; c=relaxed/simple;
	bh=Xo9RN/YaHlAbWe60yDn3HcJADUDb6frVOkoaJStZf5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p0F6lHTTWHEQwwLLRKv5mnObmtRCx0pOWnE04GeouCMDc7JJ63IQjh4H3WP3rGe1MA3fn4YjYARkJR5s8uh8yRSUNXG+dEo0+srtnTz9ZW9F91rmsInBBoqTZ4VPZGkno3Qy7lU4IgvCAaqnbFVCpkxMJTxYljdcAxB5c+yv724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlfzjCTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlfzjCTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02259C32786
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883163;
	bh=Xo9RN/YaHlAbWe60yDn3HcJADUDb6frVOkoaJStZf5s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BlfzjCTQujDTFYwP1IdfqBvDnP7bqoVW+7gBYTb7tVpouWD86Z7za8gA4/Jy5Q8YR
	 8z9ZiApEdvIDzDtQn3KgOB0psMl+WaP88/KbG39aLd9z86XYeZw9of379FrXV+XpOc
	 wc6ihUSxncFGtKuyRx1qXCA6q2Mm9W/OoNdDfeKBUDBWNDfUHbw1aaGS7BSHwKFDtb
	 Xy4Q7esQ5NvPu/j5IIucFjtiTFV4SPB++uU4xZaoevHP0VK9qEmaQ89hsveXYKEGeZ
	 cKGNOAj+b9httU4HixygKTCBpt+UGRlXkTxxjab7bgTPeZC0406U31RJlKB3UMnUGP
	 93kJ6SQgh+Htw==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-65c5361142fso700163d50.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:12:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/nUYOlH8FzbH07ty9Rj7gOc/z1vOFLiDFDQQ8Lht7iY2El7BPEcbvGkb6oVuftgTKZDPBqa7OvG6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKGp0CRuQoJeJuLeYEYeXjRz6CdIrxhTKzi5be+Bat4TPI5DzO
	/lKaojUJsAh2/ZEuxnArQEcGwTWv7wLbdsSAp00OitPeIMp3qf0UEG1OXCsvgvy41L7qho3o7TE
	FUKVhPJWyWGhnhX2KJthfM3zYZY93aG8dH2p+6L2jtQ==
X-Received: by 2002:a05:690e:14c4:b0:64e:f106:60ea with SMTP id
 956f58d0204a3-65e22807f82mr6158139d50.44.1778883162092; Fri, 15 May 2026
 15:12:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-10-hch@lst.de>
In-Reply-To: <20260512053625.2950900-10-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:12:31 -0700
X-Gmail-Original-Message-ID: <CACePvbVPV55SgPmivqMX+bP8H7FKcSAbWCwAe5icgZjZV9vUNA@mail.gmail.com>
X-Gm-Features: AVHnY4LtC3KSyPNEsLh1ud1t2IOob9XfSBaYZO4ouG71LQM8qOS5lvZuuzrl4N0
Message-ID: <CACePvbVPV55SgPmivqMX+bP8H7FKcSAbWCwAe5icgZjZV9vUNA@mail.gmail.com>
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into ->swap_activate
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
> Only the file operation method knows what block device we'll swap
> to.  So move down setting sis->bdev and the special blockdev flag
> into ->swap_activate.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


The core swap part of the code looks fine to me, I did not look much
deeper into the fs side.

Ack-by: Chris Li <chrisl@kernel.org>

Chris
