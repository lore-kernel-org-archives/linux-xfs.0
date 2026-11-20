Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195858;
	b=PgUx0ABxGwwsC8r0TQ7Cc8ek3y2oz4q2mBdZAFi1xPxCsxP347dPuUuhYdMHFSppcgxg
	 hgNwVUHjH2+1iMmIGBNlI7wThZsOZDgADA12FjDo0Vo5IJY7dUwy8PQeCtxQS4SmKGyYM
	 UMyWvxSIxhOc0VpGTjCP5tixTbTyQrR2wxdjfbGRDHntMsU2be/jXaGyl7IudTp6pZFfd
	 B46f70/Y/I7bTM0zxQAnkZX6V/PW/qWaUKSWvfntyH6JIyvUmuqnUl4pmh3d6gQVpTosd
	 sNhjbsG6xcB565p9SXHprkLkCW3sphF+aj+UD8BjM0LJ12y4Y+z9nLI2UKkzCfooCuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Cpp+sFCicuYgf+c3zxc4haugV0ip6eM5biX4gD19sTs=;
	b=GQMF8v6ZyGwCrEVMtXUj7QvwLa+QpkVX19IK0ojacU79uYqPuhWQo4OKkLJxAaf8KRxK
	 UHYrklk4ZXv7pJdbdqAfAblD8jyBwBwuU1bIic8Avm8ODF+YjuxbhWsX90If8pqsaqXOk
	 butDf+lQRo3QcTEUA35nx4ivwvs4WRqpCC/oohwJ/sbrPgSXyrPbzWb+L3ZoeBts8/COg
	 aidpW1GKhUH+bb5fV2+Vvo5CHNeOp8LqnfswkL/jtvm1RUqXaXPi/TN33bscMqUbxq5Ir
	 lpLOF/bGxv0i8NFFqtrgCp69URfQRAiddMmQRqWqkgnLGLQAMXh7fiq7KcviQoOnwKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.cmu.edu;
	spf=pass smtp.mailfrom=andrew.cmu.edu;
	dkim=pass header.d=cs.cmu.edu header.i=@cs.cmu.edu header.a=rsa-sha256 header.s=google-2021 header.b=hVD2xIA8;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E1860A261A
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 17:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77E1860A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.cmu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrew.cmu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.cmu.edu header.i=@cs.cmu.edu header.a=rsa-sha256 header.s=google-2021 header.b=hVD2xIA8
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55c304f7031so13455771cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 09:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1795195855; x=1795800655; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cpp+sFCicuYgf+c3zxc4haugV0ip6eM5biX4gD19sTs=;
        b=hVD2xIA8/rREyHY9Si7a/qw5Wd8nD0YUGombNk2V2ydWCXhxEPqJ7vR5Tn+rU1D2Vi
         tglykETYBfX6JkCKFNvnZ67IBYNwP7vfbSrTpXpDYto9iW6YunV3R00FWywjtCuBfpbL
         Z2S3t3dAY4GnD52x86KSRhe2JtD6ZkOLhHlwHCbizeuEjrfimHUtCh4CcaRzfTMq76VA
         1/2ViFygRU6O0lb3hVV8cJS9ZFBo2P4DYDtBrHpvhekegZXywFK/PmxgMLoszf7vuvXy
         zxVc4VYZ/DO8CYBKKw0+iIIA+mdlzp2pc8xh+v2rKB8VMaDlp31arkDZJMXoAfidkhax
         8ryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195855; x=1795800655;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cpp+sFCicuYgf+c3zxc4haugV0ip6eM5biX4gD19sTs=;
        b=rx8VReekiV8HbpYgqc0Mh2AqedJ180FYtU3KGAfL2cUsif3HD8pbSWxKsA75CfwhKk
         +NgapzkVHKQwcy0trpmHM65KGqrgzIMJ1aUoEW6D/ZJvNG3Qf0QUBPKR1XAXyMTmOIWC
         QohsNqtbhH6PNJob93NrS8PJkQcDdE6Ncoouwi5IuoLvnQoMzqy25lSReg2cyWueP8WT
         4FMM5+C8tNLwOyS8mKBBUZ3QtelRMkCJhzvFfUXXOXoMTcWERma1or0JJtj/u3lEHUB0
         JRDpxenWY+hYKdL3UdAwWHOXXrdneMoFJDSmX5gIuxHjNmy9zzzYtq0cGdWSQONDbGyo
         +KrQ==
X-Forwarded-Encrypted: i=1; AL+hErEQV9hk40Uaxe9PhSKV/SXD2PREbSbQDJudpbfyR8HeiapMocEvDU61PewNF7yvpi3/aG95MPO4Mfc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9vaGbLZCI0jFw4rqwhzyv/VnW0usoJ06rFe/TS6ZQrObioDmbo
	ebwt4t8cqkoSAOOhglBRb/ivBucPdRti8JQkyl57+wHijLNdF1TP+4RVJlX58VjGQQ==
X-Gm-Gg: AYBFou2uVgESTjJjhFRJ3ET2Kx+xp9IPmXgfgOVkYxcfozzx4Mfqqd/JHsjjXgMGPzB
	BeMMC84eP4mmCEPnvXUGaUHzEGVLW3920YNZcRQ2Mew1VryHEOnDUKtr4CzMU97faHUeHTOj8kn
	/spllXTbk7dDJL445Vqr1OmsG1ZA3TT/O8v02EBkWLb58UJh7k9kJJRDG2EmNBALDcvAc6IgxDB
	koVMPloqUcLeKvtICNhS7WcM55O7SWZmqSNNA6XmnodeUbxYm1GYGhZAuQmg0Fgcwl/Fl4abGy9
	1Pi4Jy+4RoykT1fXYBTEvLfl4sUFX8aqntRcNgQDuzjlkxN8LwmfKXlVM1E3trPmRXeuJa7QjQa
	zCzgTtYl7gdnKDGOVxXSxi9zdq+6y3hwR4H+BPjNlujTiBngSZdBaslXw4lEh1zdij/wfxDtouW
	CwSqjOUfBN9nipAnQNYzg5vz1PZc1wTZymZBSIXzBhdfleVmL/+HB0WN+dyJFOULaAVe3v8EO9/
	1K7lVUl5p7NFaNUfivxT/QJBYJcY3TrWzRfenvQ/PJsoJmhrTINpIJI9JolmNDYc3BUflX+nckp
	v3gDFss9V5uZKn/WQJj5SRxyos8cBb+Q5NkpFf8MEWKL9xDuwUg=
X-Received: by 2002:ac8:5d0e:0:b0:535:1d5b:a7fa with SMTP id d75a77b69052e-55d769fe4ddmr65344931cf.14.1795195855134;
        Fri, 20 Nov 2026 09:30:55 -0800 (PST)
Received: from cs.cmu.edu (tempest.elijah.cs.cmu.edu. [128.2.210.10])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882e32dsm28152341cf.13.2026.11.20.09.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:30:54 -0800 (PST)
Date: Fri, 20 Nov 2026 12:30:41 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] coda: don't d_drop() early.
Message-ID: <20261120173041.bd3xeidt4ndkmimd@cs.cmu.edu>
Mail-Followup-To: NeilBrown <neil@brown.name>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
References: <20261117000115.1433875-1-neilb@ownmail.net>
 <20261117000115.1433875-3-neilb@ownmail.net>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117000115.1433875-3-neilb@ownmail.net>

On Mon, Nov 16, 2026 at 07:09:14PM -0500, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> Proposed locking changes will mean that calling d_drop() could
> effectively unlock the name allowing a parallel lookup to proceed.
> For this reason it should only be called *after* the attempt to create a
> symlink (in this case) has completed (whether successfully or not).
> 
> So move the d_drop() to after the venus_symlink() call.
> 
> Doing this also means that if the upcall that handles venus_symlink()
> happens to look up the name being created, it will get -ENOENT rather
> then a possible deadlock.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

I was sort of already assuming that the userspace cache manager should
never ever traverse into the mounted /coda file system tree because
there is only a finite pool of worker threads. But it is good to know
that this change would fix at least one possible deadlock.

> ---
>  fs/coda/dir.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> index a85be5962e62..b47299527b65 100644
> --- a/fs/coda/dir.c
> +++ b/fs/coda/dir.c
> @@ -249,13 +249,13 @@ static int coda_symlink(const struct mnt_idmap *idmap,
>  	if (symlen > CODA_MAXPATHLEN)
>  		return -ENAMETOOLONG;
>  
> +	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
> +			      symname, symlen);
>  	/*
> -	 * This entry is now negative. Since we do not create
> +	 * This entry is still negative. Since we did not create
>  	 * an inode for the entry we have to drop it.
>  	 */
>  	d_drop(de);
> -	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
> -			      symname, symlen);
>  
>  	/* mtime is no good anymore */
>  	if (!error)
> -- 
> 2.50.0.107.gf914562f5916.dirty
> 
