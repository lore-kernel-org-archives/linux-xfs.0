Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CAF3AC0C6
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377696; cv=none; b=Iyfdn59cc9tsWeUvbke9h8GY0F0GMXuHHyLlTU/aFJKOVdcAKYISZMW3v05bdr4q0NHOU7ML+AN9W8scIYLYhUTjFN8u6Ft7hop9vH93nu6ttNdfE2m8fq7yoBSS1ESwPhuLex+mEptoyo1WzSgbsr3Pl6iakYDyt1iBDuSFsS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377696; c=relaxed/simple;
	bh=3WGPUky1hmwDKOIR30PGoglOqPg/CfPHhhz1D/WGWTI=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=lvi+GDaru97L/sK1EZUvLBC/zYg58sdynlZpn5wBsa0yhfMqxpS5mIHSYmS6dFHKwj7sqXrcTX8ZOdpdRx8ZD/N6QpFtUeB/txIvNmGo9CmHxYwVzmk9Dpz2GRSd6QnmXvIcg1YGMou8DhmZfG6zMtY1Y2tmJe8yglJ8yuYhEYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=dA1yL4xF; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="dA1yL4xF"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52fa6005224so12817211cf.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377689; x=1788982489; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTllqewIXAY5+sR//IBZWAZfUENL/NuhQCFU0zl+dm8=;
        b=dA1yL4xFmI/xLm4gRSWgFben1ST4myVImRVF3JDQcxKkV0fYD1Ntg9aKbmMS+Z+l78
         1/PWPbsjSZySmLHZideqKf+2aZzOLMAX9z2/84wXgSVlWbAm5hXDMv9KcEjc/puDweL3
         S6hUENsBnMQqsWYW9wDYNaFFFD1w8xhepjmDHisqycyUmz76aqSpxZvHM4OwoAAiQvlw
         62c4LWA0DWUYE6qqfOJzANDT6279+eDBPO0QC5/KDtprAIrbEoN2zG0aTCWDkC8nh72q
         TxsRBcE/AJeHtQGYCav2Fm3C30T4flhV5XQnCvzHynsxo+HzPMRVXjx9/tNF0MFsGTZa
         6OEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377689; x=1788982489;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tTllqewIXAY5+sR//IBZWAZfUENL/NuhQCFU0zl+dm8=;
        b=JKTxDqoGrTnSlXAxrYcyVqrbk7wf2dkECQT+FcMMWCLTk3tKHzoBfJuKnoS/1koQWI
         yQf9tXQfoKssAdRntF8rIswRFZB+0j0Fb8hcuCeF+mAtFnHSahN28CY3IEiXztIMVyDT
         Sm2mmGij3mH+TB51gOsw9M9CAZAD0kdkUL8eakogZ5EMimmdIkwaWpzdUm9aRdM6Gvp2
         i5lwao6zIUDCTdisLpXFCZ1zRCp5NNScYQgoFG29/VEG8sZdjroDVortiq1DV07oA1tJ
         I33d9cuphO5+L5K3PwI0iE67ofaWT5fYK/9I/yNHZh/QCq3aLWvy292Frjhrd5qiIpmN
         zVuA==
X-Forwarded-Encrypted: i=1; AKwUvBwJp1dCflXT+UXqIfx2Ikah7agTLcrS7LI+Wxl/jz2u7tPjxNmvwk1yESpS2hV82QmZf9AFxQ5esW8=@vger.kernel.org
X-Gm-Message-State: AFuF++nXmDWcU6J8HqImorr3NuztSpg0+16Wh5dz8+yJxPYZQAoo8ibM
	qwLt5sAPzY0vo52zrl3wS4fwnVKMzGETN+nfLocWISiocGM0dsb2LxWcAgU0mRFX5ocufR26z7v
	7YzRvQw==
X-Gm-Gg: AYBFou3fTuXZGxs4HShP1tPrB7SKxoNX2CJO1rUe7ONqU8DiSTDGIufxxVlrD+1Ll1D
	hhesO6Mj0p8fcqOyks6ihAbgdRpqRMJl19Rb+UP7m/7eS0Tqd8b4k+7SXIeRsobNuAqvv9Hfkp9
	ObJalSYCqAKl52wh7fhPMXURtvmlDJQ4o3W7wJGhmvI92YvHqBFz8+mnFva0WDmxNKteYqSO9Qv
	IZrQLKDkxlN1uooA7mQtGYeY6LEOrepd0LgcERD/fxc9tcKeTachMz+xHUtW5jpWyCrYzaVBttT
	uOf303vmKcZ6CtggqofDxnigCXo7D4Zq1JFuh/AKcocCfOtxCRVa1yUUJ9tZqE0z0x/RIHv0GEl
	w1C4jkREh/tGzHfXtaSvAXhJKq3HZLzSXh/cmN6wvXuCMfnRFQch12lZaFKAjoN2GN6zVUX/6tz
	cUCh4E7oYimkadAS5IWS3GFRmSjJXwwkpJPEd8Q+y1mfEm93Clt+OSxUEz8T0MoOHPn3vwUFTH3
	p9ng71SH55MG+aQ1MzVUfqiyqbJor3bGA==
X-Received: by 2002:a05:622a:1f8d:b0:51b:f25c:2896 with SMTP id d75a77b69052e-53036bfdbebmr93564831cf.11.1788377688931;
        Wed, 02 Sep 2026 12:34:48 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53033252530sm25672391cf.28.2026.09.02.12.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:48 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:47 -0400
Message-ID: <4bcb6be827e73a667592e7110ba78682@paul-moore.com>
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
Subject: Re: [PATCH 12/27] fs: port ->permission() to pass const mnt_idmap
References: <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>

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
>  Documentation/filesystems/locking.rst |  2 +-
>  Documentation/filesystems/vfs.rst     |  2 +-
>  fs/afs/internal.h                     |  2 +-
>  fs/afs/security.c                     |  2 +-
>  fs/attr.c                             |  2 +-
>  fs/autofs/root.c                      |  4 ++--
>  fs/bad_inode.c                        |  2 +-
>  fs/btrfs/inode.c                      |  2 +-
>  fs/btrfs/ioctl.c                      |  2 +-
>  fs/ceph/inode.c                       |  2 +-
>  fs/ceph/super.h                       |  2 +-
>  fs/coda/coda_linux.h                  |  2 +-
>  fs/coda/dir.c                         |  2 +-
>  fs/coda/pioctl.c                      |  4 ++--
>  fs/ecryptfs/inode.c                   |  2 +-
>  fs/failfs.c                           |  2 +-
>  fs/fuse/dir.c                         |  2 +-
>  fs/gfs2/inode.c                       |  2 +-
>  fs/gfs2/inode.h                       |  2 +-
>  fs/hostfs/hostfs_kern.c               |  2 +-
>  fs/internal.h                         |  2 +-
>  fs/kernfs/inode.c                     |  2 +-
>  fs/kernfs/kernfs-internal.h           |  2 +-
>  fs/namei.c                            | 22 +++++++++++-----------
>  fs/nfs/dir.c                          |  2 +-
>  fs/nilfs2/inode.c                     |  2 +-
>  fs/nilfs2/nilfs.h                     |  2 +-
>  fs/ocfs2/file.c                       |  2 +-
>  fs/ocfs2/file.h                       |  2 +-
>  fs/orangefs/inode.c                   |  2 +-
>  fs/orangefs/orangefs-kernel.h         |  2 +-
>  fs/overlayfs/inode.c                  |  2 +-
>  fs/overlayfs/overlayfs.h              |  2 +-
>  fs/proc/base.c                        |  4 ++--
>  fs/proc/fd.c                          |  4 ++--
>  fs/proc/fd.h                          |  2 +-
>  fs/proc/proc_sysctl.c                 |  2 +-
>  fs/smb/client/cifsfs.c                |  2 +-
>  fs/smb/server/vfs.c                   |  2 +-
>  fs/smb/server/vfs.h                   |  2 +-
>  fs/tracefs/inode.c                    |  2 +-
>  include/linux/fs.h                    |  8 ++++----
>  include/linux/nfs_fs.h                |  2 +-
>  security/selinux/selinuxfs.c          |  2 +-
>  44 files changed, 61 insertions(+), 61 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (SELinux)

--
paul-moore.com
