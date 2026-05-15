Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434C3F5BF1
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778884677; cv=none; b=lEjATusC6T2hndvQgWqcATRAkVFbB0Cx0JS1RXS7pdGvUY49Eijor0oRa8b5Ex/Oq1SfpcSt/UUA5ukbne5/bxMwL73orIdU7MbRvJMzRBujeJOprSgG71CWLswT49mXoJGb+K4sCrN67/V57EcM8RiYMcr/VM78bsuJD4b3dAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778884677; c=relaxed/simple;
	bh=J22XAuCby1Nk4FIP13WT2u/GUxKM6wuoH7hrzV1Eqf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/DPru+R/HdRdO9IxWHdEHvDxbmOLyPwIX+/SD2aGywXkKSD98XwitIndV0IVPBaClr5MlYq2mgTcvH7q8/d+LzyU4dHOYcMSmZrmGWHELZsGA1sYe+HJZXkAHVZn+jpj0TBGFVhUraWc4AmtOLv7rTjp4hoJ+GCuNS04EExY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdweYYrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdweYYrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD5C2BCC7
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778884676;
	bh=J22XAuCby1Nk4FIP13WT2u/GUxKM6wuoH7hrzV1Eqf0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XdweYYrz9Vyd+KWSJrBXDcPXD/D4VOV9rmim6XMosFpalG8friFuqoAJq91rsZOtQ
	 piT0D+kxZEUEXO61emt/K7GiwncZHYv8gQnnd8AiLfO1xLat9w5PQUchmSx1y2EBgh
	 X68vqdOPlXDLY+FXoCAmD4sw4xxLNrJTy+t0W2IRZRKvBeQGhY7Fjw9CJVRn7Yl43p
	 f0ntRT5i2d6aApmcuEsI7K4ebD45svJSQ3Keld6VZBViY+SIXEo2TxkAlXZrc2g31K
	 7ra9/JZsoVHmPjAxQtz+LZeBA2TEFUalb9JX/rrImQ2wKampRAM3w5fvL4LDiM8UIt
	 hO7G1YMdYRbBA==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65c477a3278so689537d50.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:37:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+GQf66mhLjoyM1LNubssS/zaoimuRfcNA0LN5T+IbpeoqMOxxebn6mTpG2DN8k0Hgj8NTq58tuVHI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1r1WBcvZg/D2pPvDmvU+7HS6XK63W5pbncRpf8S2hqO9vQP+I
	dRG03JK7EIBt9nMQ6UnorH6jOa5xJBDyceZjFS5sIUKIzchDhC+e6C9zh3oQ8tn/wnaKBCYSJ+9
	sqlum4JOP/X3FQTIocP3oJ2EZKU2mpiNcZouEbsk7ng==
X-Received: by 2002:a05:690e:1482:b0:651:b13e:f9ef with SMTP id
 956f58d0204a3-65e226d2c42mr6465616d50.14.1778884676176; Fri, 15 May 2026
 15:37:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-2-hch@lst.de>
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:37:44 -0700
X-Gmail-Original-Message-ID: <CACePvbWdxJfCgZzbfFoSOFLKnizDJE62oHKj=mA5jkBGo0dHkw@mail.gmail.com>
X-Gm-Features: AVHnY4KhYBpZIvUDwx68vRewVOsNKOXtAJOmYrhmxnQGCpjvviSHXcfEap0R7tY
Message-ID: <CACePvbWdxJfCgZzbfFoSOFLKnizDJE62oHKj=mA5jkBGo0dHkw@mail.gmail.com>
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
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
> Always use si->max which is updated setup_swap_extents instead of copying
> into and out of maxpages.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..f7ebd97e28a3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3350,10 +3350,9 @@ static unsigned long read_swap_header(struct swap_=
info_struct *si,
>  }
>
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
> -                                   union swap_header *swap_header,
> -                                   unsigned long maxpages)
> +                                   union swap_header *swap_header)
>  {
> -       unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
> +       unsigned long nr_clusters =3D DIV_ROUND_UP(si->max, SWAPFILE_CLUS=
TER);
>         struct swap_cluster_info *cluster_info;
>         int err =3D -ENOMEM;
>         unsigned long i;
> @@ -3395,7 +3394,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                 if (err)
>                         goto err;
>         }
> -       for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
> +       for (i =3D si->max; i < round_up(si->max, SWAPFILE_CLUSTER); i++)=
 {
>                 err =3D swap_cluster_setup_bad_slot(si, cluster_info, i, =
true);

Nitpick: I couldn't hlep but notice the si->max does not change
between setup bad slots, so in theory you can cache the si->max value
to a local variable for the loop. In real life, it will make no
difference, so feel free to keep it as is.

Chris
