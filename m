Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC573ED5C9
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778884209; cv=none; b=TKvmNaZejzAmzY3erzRvsHGHhebXunq4q3aDnEcSO0aGQLWN99hWRJgjTyTxwgUwnEZJnJTW75xxosU26v4Qa85Hx6EALc9re0/hIJEwwst4M4p265Pe+thVTlmK9ZZSb1whxPm/qAEp9aYVlJJjgD9Xv6DFelOUa507OL0+fSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778884209; c=relaxed/simple;
	bh=ReQtRGN6YCVCM+VLe1SVEp6J++lmzI2ST6cnJuKfsNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mvlHGU9FujJwUr6tsxTd6zftaHSPjsCUimEPDZBL7Im1tMc06LdMd4+6lkbbcSR8gXFqS2jVmRfJbaj5JmTS+W6hEfyFPdaPg61EgJsE4xDbKaOTMJOLkvFFsQLgoCpyZinaIYCJqbdEBPGTwPI3xxIhY03hLC10w3yhBDwZa7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lH/oYski; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lH/oYski"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF249C4AF0B
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778884209;
	bh=ReQtRGN6YCVCM+VLe1SVEp6J++lmzI2ST6cnJuKfsNY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lH/oYskikR0guEnFauK05dvIZ7FFOdsB402hk52KOZzyV4nYLxbRzejKFJOnc1Dth
	 w/5a5hUpZX+oSd+Q7yvURYG2zTINRb2MaS+LZjeCmGUjICZ/jn41oeyAjtN/eefh4m
	 Gt4NMS00if6iGXKVc9tppTzWUMHkK3RPxT58jLkMU8/T1ASXOwE8so7tlvXLAaBl/B
	 9DnHctfZhu72zNDQ8m5IAFpkxcvxLY58P7S8dOJtzvI3UOq81+eSU/SsYxM7lBsRUi
	 Dx5Tw2rmxDu7dfR6lZgdkJxU1Gv4Ud0Qej1pnvyneAGj+HUQxL/QfeWwtpw7osF6O6
	 acPlePHI9qEeg==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65c24be9e4bso660140d50.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:30:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+NObmnNiBMHxgO9svrBfESJjuUE0ayjiBzTayjLuQ9vvM8OewMCl/Zwi1LWPcr1ISSzsckYhhMttE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ag0hfWbzb8cUQHo1oICtjc7OvZkYcQrbcjEkjXYxTME66KUj
	1xMiaNDpF1suXNuttqITUCnaaJg8x3vgtYpou552PtnTuF/XFZaWGyFjKYxsub8vqeZoEd+BroX
	thbaawAi852xBOZQWl1eDB5d21wsuojnH731xaatlnA==
X-Received: by 2002:a05:690e:480f:b0:64e:597a:f5c2 with SMTP id
 956f58d0204a3-65e2289a39cmr4822587d50.65.1778884208163; Fri, 15 May 2026
 15:30:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-3-hch@lst.de>
In-Reply-To: <20260512053625.2950900-3-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:29:57 -0700
X-Gmail-Original-Message-ID: <CACePvbUPQ=tO5feC=2-8XdBV1PgzoX+EwASU__jNiuzcGsPMPA@mail.gmail.com>
X-Gm-Features: AVHnY4KVT3GwVUdlKXUpf18PwWGpkgh1B7IPlKLHiB6TxVcw3NQNEM73-FjKVDw
Message-ID: <CACePvbUPQ=tO5feC=2-8XdBV1PgzoX+EwASU__jNiuzcGsPMPA@mail.gmail.com>
Subject: Re: [PATCH 02/12] swap: move boilerplate code into the core swap code
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
> Make the core swap code calculate sis->pages, nr_extents and the span,
> re-set sis->max based on it and don't require passing the current offset
> into the swap file to swap_add_extent as all that can trivially be
> calculated internally.  Also truncate the spans based on the available
> information.
>
> All this removes a lot of boilerplate code in the callers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Very nice cleanup.

Acked-by: Chris Li <chrisl@kernel.org>

Chris
