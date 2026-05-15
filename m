Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E53F44ED
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883869; cv=none; b=V694Vv6+PzvT6XAWmMLzdvIQakFUIglFl5A0uGCbIEgPM8T4HNjQPKz6FTyc1wmSL1ABXilmEiuTH8jtNsS2woSO9cmZ37a9rlr0rfA3VIBkM4fNx7fQL/qoIpVvM3l4ZOyI2Xmlz+4c9MajJXu3tF0eljMd9MRoEwoU0zqr6JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883869; c=relaxed/simple;
	bh=CQjBHE398jfmQc9Nk7uTNv+8vscqO8uzAxJfVr6TjOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCs/aEzTqKX4X8//82s0X0vMctfP+Zwj4r0Uuwyk1puWothmYxrz1JiHmf34rEddmzoblF0nok8fa0WvkXO8vSTbBWPZexptdINpuvRCMxO7r7J4+3WA0gEetfxrUX10hvki5sQcS3WgWAcT9dwdyq8/vqFtGJpFjFHnTymLBTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I75LpWDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I75LpWDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7146C2BCC9
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883868;
	bh=CQjBHE398jfmQc9Nk7uTNv+8vscqO8uzAxJfVr6TjOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I75LpWDrE4HspM1Nom8QNNiBxvvPPC1Z/wA25yBCJ/4enl3WTmrgj8AZMjhk2O/xG
	 yshsfHF9WvD9zWHVLpX9AeHo3Ri3ddj1aGewMbBUU8ZueR0ecjlr9Q0zOirV60mTuL
	 Blg8dz0+peaFU83cqwIw+GtehBIoilyr1JVfpLfi/1DhIwPgar4tiP57UNiR2Z6RXb
	 jJG0DtJ2+JgFoQLnfeXEZOoydPFpzXHXPWSjEyaxuisnvQztS1Uw/mSHrNECrgkznS
	 jVFyqqaY/Np9buMNHRC3bZWYDATHC2YK2s+ERM+sBFNsc5fqz/AcPMBEuFWjFE7Hyy
	 AhPRursx/3ldg==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-651bf695701so681293d50.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:24:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9oIDgEHC96g16SjmGQWwcvRFYNoTgmz/Ez+SmamKlSJX5VY2XTmSEywbYEobRbVfYldy/8Y1mhxEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY2FJCLUNCiFzeafPatK/gNaY8eRp3txM+DGlQ4wo0ciOdYT+8
	NMhJBUYb61f3vyvBrHUULh+3MGErcYRW1/4RTaqDsGozd39eaeX6PLjQ9fF3ld+kACdUnrNZzPD
	HlCMkI7dMzONs7GqJQxqKeiaBVkWlndQS6OqJHJpALQ==
X-Received: by 2002:a05:690c:c504:b0:7b8:926e:3ef4 with SMTP id
 00721157ae682-7c9599a3c98mr72668207b3.17.1778883868040; Fri, 15 May 2026
 15:24:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-4-hch@lst.de>
In-Reply-To: <20260512053625.2950900-4-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:24:16 -0700
X-Gmail-Original-Message-ID: <CACePvbVmxUVVZLd=hUnzjRLtt3hBWRxemR_YQZCVSYYNadiAUw@mail.gmail.com>
X-Gm-Features: AVHnY4K8odfW_w5Sv5zxMaAGvoOSmdsLHmORiA0lm6BrpYzORI9rYZ53g2APvuQ
Message-ID: <CACePvbVmxUVVZLd=hUnzjRLtt3hBWRxemR_YQZCVSYYNadiAUw@mail.gmail.com>
Subject: Re: [PATCH 03/12] swap,fs: move swapfile operations to struct file_operations
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
> The swap operations have nothing to do with the address_space, which is
> used for pagecache operations.  Move them to struct file_operations
> instead.  This will allow moving the block device special cases into
> block/fops.c subsequently.
>
> Pass struct file first to ->swap_activate as file operations typically
> get the file or iocb as first argument and use swap_activate instead of
> swapfile_activate in all names to be consistent.
>
> Note that while the trivial iomap wrappers are moved to a new file when
> applicable to keep them local to the file operation instances, complex
> implementation are kept in their existing place.  It might be worth to
> move them in follow-on patches if the maintainers desire so.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense to me. I ack for the core swap part of the code.

Acked-by: Chris Li <chrisl@kernel.org>

Chris
