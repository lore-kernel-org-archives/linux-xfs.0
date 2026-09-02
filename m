Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378BE4ACC8E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377705; cv=none; b=GVfXZUu47QxRJRUSJVzt+sRjXBedQ3vIvs86W9dcqH3iq1ova4rISd642CPrbU6iiMl/0fmiV3AM8hf04EFUMXxTjW9Kf+isGsRqIj1tWMbakuXky1Th9N7CC6afBaFUlQUEIR7gxYZh/M9hwe+j77oGAfR6G7VESV64UBXoe18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377705; c=relaxed/simple;
	bh=eh+it0zb54ufEP/JnblEMEpySL7Prj/F5s/H28111ro=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=msbtgX15kiHniCe3s7fLkxb+i8VyzWZJvNZjLaqxUg1n6zsSqMx0gtP9sbWNci6IgH0xHkyuvvnu9adpnLkXj/tGitVIENZJgCCWrIaWydA6YXlGALcES4cbi2S+qGqj7vdVU1dkZs4fs1U1IvjSTQBW7J8I+uLQG5yi9GIVOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=BApmi94N; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="BApmi94N"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90d7fa95a58so12990946d6.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377687; x=1788982487; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=BApmi94N0haia63+fWtF0lO8gtf7CPbnhyiBUjO2IH+nYwAJb4uJXYRK7Cr6JJKpFk
         YxGptCgPyiA1YZmnPhS3FOGlqVAlbkwTb/eVF5NtLCuLuSICFUx37nq/Nns4yNA2zgH0
         CFYc13B4d2J1cC4nKVeZUp+yNmFJrn0DoYd6ScYOlVDpCIQWM8wV9IJ51HJQi6KW+GVF
         nI2FzCFnKFMfXHpWkki8P6hmZ4q8a2BhC/Xez0+PIPWLa+R4Uc0B91tXHiwfcP+6AsP1
         FRMH/M4HjtVOxsSROaRN5mJYZjmLY8FnTjlOzEo1VRpzChFgoAHEReRUhVrJL43U/Yma
         Kkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377687; x=1788982487;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=cTs0EWTSfEE1N2/Q6eVBjLp02Olu+aBxFFVsiDsmjGOZov+ewXj+BqLIqsiRXjQI6y
         gUhYEnNutnmQxp9XIpJCfQtMwc3muCDeSy3YoTlgoxMSqAqgnm4TuxirsjQ1RXVvz1+4
         GGUABLBdoZ7xiDapA/NWFsMkEUSBHTKTFH9/R+Dz45Jy+Lj+TIQzwhaJU2EtnlO3iQQY
         Yi1om2WqsvMjpX2g64KWgIPVwfY+uKPYWN8uenT8aW38znP55rl804YGHo4jlBhRJaPQ
         /r2oKIzVYM+SZ6RZAUsTwJhp2H6cFm7RtUB6J2K9eY39XZ9ztOA72wWRtscLCJZjPMcW
         /fiA==
X-Forwarded-Encrypted: i=1; AKwUvByj7tTo7eMgEGmQDjvux3MtLwInUaioJTMmcXFRJ7yoBmP7aK4iYPDGENxVm8F0cQ9RT03bhA4lZho=@vger.kernel.org
X-Gm-Message-State: AFuF++kyV5zCcQbUqcTPNu5eA0g/W39aK80azBbI7BOLYnl1CviDsc67
	ypetKS5gfEhDav7UhFpCKHuVAv/kJmQRTorHmBNx43HmUyCAjADmjHs0qPOwePy2eA==
X-Gm-Gg: AYBFou1NMzjkzei3IxLQCgg2tIJBaFDgbrZ23uAqXDGLjlUK/i/Iy9a4KIUgGbcR3Ac
	b8wXfujCqhW7PpMOKmY0GlR8+7C2zIU1X27qPOE6K2dWewJ2KjmqbKfT1krKDxIBUVY8C5zIP1K
	YQWPMK4mqvdx/xAqDmeo3O/QFAET3FNYOL4ZgcIbDI0adIfuucgSMXlklbzMXOi5SFFbtQsfD65
	35Co7hbswkvmcI1Vjue2ptJP8djS2NCkXdDqWoL21Gh5VhqutFNWw48/Ighm25fAtzAv4moOips
	f0MGTJUIp4DMrr04QasVXXkzAfMcjXFiTdPNVhfh9c1GEMtkkcLRLnA5MR1jvWx49eDPDi8inHy
	OeIeu1RpHWd9ZupMxS3HQZ7ynpY0/Q5Jy51aPXSJya+AtB/CqVvP0Ddzd8Dyizvo2vj8FI5iQCG
	6v4oJzbzvrv8pJaA5nrTgLczauicIyuSE1+M3npkFBhUa4pfte9x2fNgFaPtYUzsH64WgeJQ/DU
	FpFkN9Yb1Co22FWG7vKdIopfTc3wOT9wQ==
X-Received: by 2002:a05:6214:e85:b0:90e:7de2:d81f with SMTP id 6a1803df08f44-90ebabbac8emr90744936d6.20.1788377687526;
        Wed, 02 Sep 2026 12:34:47 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ee08710sm25176366d6.2.2026.09.02.12.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:46 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:46 -0400
Message-ID: <e266759fa7a20e9620b16c1b5a717744@paul-moore.com>
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
Subject: Re: [PATCH 11/27] fs: port acl to const mnt_idmap
References: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>

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
>  fs/ntfs/ea.c                          |  4 ++--
>  fs/ntfs/ea.h                          |  2 +-
>  fs/ntfs/namei.c                       |  2 +-
>  fs/ntfs3/inode.c                      |  2 +-
>  fs/ntfs3/ntfs_fs.h                    |  4 ++--
>  fs/ntfs3/xattr.c                      |  4 ++--
>  fs/posix_acl.c                        |  6 +++---
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/posix_acl.h             |  4 ++--
>  include/linux/security.h              | 16 ++++++++--------
>  security/integrity/evm/evm_main.c     | 10 +++++-----
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  15 files changed, 43 insertions(+), 43 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
