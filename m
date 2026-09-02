Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BE39150B
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377705; cv=none; b=emKXYu6Fw/OAwpFRLFvnYsu2EaR1g4V5vtCSHP/aFvxetd4fvw68WVpq5YZoLYfb6L9DmnUe6O8hF5ln7FLWCQIBK1QUiV7CfEuzOg9wo9LtICY96mrDVXEK+a2zaeGAqtF/CnFicnTKkeQQuKe3ehd2tKXNGQ38N/+7y3wHnGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377705; c=relaxed/simple;
	bh=dINnaKckdfOT2F94x9t7jziPlS9yc2iyV99WUJZti5k=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=gRogYGsnTgO0jmYgwAoLzf8QK7PkOYQjq2XjycYx5wEoJ9IdNM9rY3oZ71uknlcKMMnwT60Pfv+YxmXM08PVoNk9JAxXV/gyUF/KPyNbJzAm4/9yRga4BNBYkNkME3Yt2ZnE4G3Dpw0yzERWUiWnwwdHGRZepItBfrvGscPB2Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Mp6gh/qJ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Mp6gh/qJ"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-90e7bde5596so15083166d6.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377692; x=1788982492; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=183/fvO/by+DRdIa2ztu9BBJ4pI2bMZEyG+Jxipy0sA=;
        b=Mp6gh/qJ9PlBzkbFBngWPcHLug6aL4CVpoMoBhP+8cG8UE9y85GoduQoqIih5YgyNl
         SvWVTiaBA/qyWMiONrZyvM0SY6wAjBbacAFAI4GP+egbp+jJYuipoqAOwzb682f32Yt1
         fBk0GiCRl9Z4HsaMpBNG+78y26N5SSpIM/AOYae8IP4AZNWGUSbhW260XHN+LyULIoky
         tTLV/D4i/SUONQC9eRCfWI3RnwTzmbOnuTetb2uBIXo13sa2mXOch1rXBMVA132fBrCs
         m5HvTYka9FeVwWTn1jP+9TIgCrYp74rb/+grmmfh1kSjT9kNCRgOlwiR9+mH/Zta7Csw
         WhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377692; x=1788982492;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=183/fvO/by+DRdIa2ztu9BBJ4pI2bMZEyG+Jxipy0sA=;
        b=rGCvoz3A1N8ZvGqp7gGUxYCiWu9OYiApXadGrHSW1H0+pSNUgcDItdT+k/UgdO2wl9
         y8lAgaV89U3KxunbMAoQMdp1Y0yb3sH9reJMV441MNbKd0bpWxOa5RI+v2jdFaMGq24A
         y3D3GOQ7cPIlSfY9l7+8LFm3u/n2ICNvi5yWpnuX+q0ftEb6fPCyVjuANaFiGhQjptkT
         NhnCQ9hz5+4lMLsMpHgx654qg8U0StHFZ/pCDH0S37Pmi+f3+WLXPLJ8R05q58MrmF9W
         yNx+nGoXCQf4Bc7w94F4sd/64qYsdce5iyeRPfwnRfPz4xmEVYo2ia7m5ZV42kHsbT0R
         wZ8Q==
X-Forwarded-Encrypted: i=1; AKwUvBxROxguB75uAGf3HyesaIJIaTyimtf8WIakxMKWwZTm2zD/mOD1CG+sko2X3+tHOSq2MhNnwdUVVt0=@vger.kernel.org
X-Gm-Message-State: AFuF++kF95XrtJRe4BpgCu3mP36ZtHERDqN+jL2RhUAb17C4JSxakL5z
	clUcoYmdF1CelIHOVVi8uTLdFY//HmM3gurCD8b6XDfdJ4HAtEY8LSpfReK316ejoA==
X-Gm-Gg: AYBFou31/1Pq2a+f7S+bAWfg4mqxmtt8Dqb/WDcvVRyy99ZFn+vKh5lqP91NbQ2EgyU
	GClUL0QYjfLQ3GKh1J4BmOAHkvdv7sMPY/a8NZLA4ccwnuyu+JYz1L2hlW5NMj+AkrDAjSHUk35
	RklhCPqXM02UB+SPb03ZSeRlOAEvxMkPaord2mczcicGds8VhMNsEzCaLpjzBYgc+sQJDNlVil7
	iV8nDfvC/XGJkWdGu1L0yRFUx0pX1fBKBiYkkFCzo2DezSCtHvxHTrgWVckk6COvDI+S/hfi0p2
	74qCeAt9pa65A0P5ctMW8a8zhUXdTkRyyqzbpUIe+rknLJ7QdMj/9c9utzP1OxBpQRQk/wSqb8m
	CxM3KkWImFlNbzOg+NOoPVeIBed81gJ1BGMe0qDYpgjv+X8E1Nner20R33QIvL8LtWdcxxxmTB7
	18x2U8xNxHPghSf1R3ibtxAF5gqhZaFwY2QKyuD8QiRWizITqHydjd56O8g/hJ07EXE0AufsvXA
	Azqi9cEGQ7MS+NkNJk5dtGBoqcp+8WE8Q==
X-Received: by 2002:a05:6214:2dc9:b0:90e:8022:b66a with SMTP id 6a1803df08f44-90eca50ecaamr99641606d6.22.1788377691985;
        Wed, 02 Sep 2026 12:34:51 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec8099sm25284386d6.30.2026.09.02.12.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:51 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:50 -0400
Message-ID: <32dd145d801e472375c21d582023ed40@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260902_1319/pstg-lib:20260901_1604/pstg-pwork:20260902_1319
From: Paul Moore <paul@paul-moore.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, linux-security-module@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 17/27] fs: port ->tmpfile() to pass const mnt_idmap
References: <20260901-work-idmap-const-v1-17-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-17-54ccd48e100b@kernel.org>

On Sep  1, 2026 Christian Brauner <brauner@kernel.org> wrote:
> 
> Convert to const struct mnt_idmap.
> 
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  Documentation/filesystems/locking.rst | 2 +-
>  Documentation/filesystems/vfs.rst     | 2 +-
>  fs/bad_inode.c                        | 2 +-
>  fs/btrfs/inode.c                      | 2 +-
>  fs/ext2/namei.c                       | 2 +-
>  fs/ext4/namei.c                       | 2 +-
>  fs/f2fs/namei.c                       | 2 +-
>  fs/fuse/dir.c                         | 2 +-
>  fs/hugetlbfs/inode.c                  | 2 +-
>  fs/minix/namei.c                      | 2 +-
>  fs/overlayfs/dir.c                    | 2 +-
>  fs/ramfs/inode.c                      | 2 +-
>  fs/smb/client/cifsfs.h                | 2 +-
>  fs/smb/client/dir.c                   | 2 +-
>  fs/ubifs/dir.c                        | 2 +-
>  fs/udf/namei.c                        | 2 +-
>  fs/xfs/xfs_iops.c                     | 2 +-
>  include/linux/fs.h                    | 2 +-
>  include/linux/lsm_hook_defs.h         | 2 +-
>  include/linux/security.h              | 4 ++--
>  mm/shmem.c                            | 2 +-
>  security/integrity/ima/ima_main.c     | 2 +-
>  security/security.c                   | 2 +-
>  23 files changed, 24 insertions(+), 24 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM)

--
paul-moore.com
