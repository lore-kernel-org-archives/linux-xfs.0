Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB0614292
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 06:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708066510; cv=none; b=jzY4VAUKbbOnK3TQQNGQYw48hdAjoTkTcpDswNihEhuLSnfdkj7Rl6GlMWHbAwZ6StL8u3w4BRBcbMkv56tGG5Z94swdofmfhY6HKpNumbf0bmM6n3CVaaEdgGGPz3saerRMQxASHNi0UNHb3XllWYPeudB3Sq+BBpMl4jOmnZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708066510; c=relaxed/simple;
	bh=awn/XCpzgvSume5ebZL+Vju8HtNszDlU3PAz9Qpfuoo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZESRMjs3FakNYodbHhzfGgaNHELvqNfm8h6cWFQbJwGU9EPDpYEBcu+NeFgUesrzH5oOBPBKs8Zj2Fjf+mtb4MSsyKNL37oG3em2DeQ6Klq6R0M1yvyvU90TvSQQe7hboXkuzxt28CH4M38agChmV4NwzoQptb2N5h1+TAZNkmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pB4KSBhn; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pB4KSBhn"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6002317a427so15240397b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 22:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708066508; x=1708671308; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/Ev7zx1OY2xavG089OEf6t+LzZ1+fWZhEmI/a93zMk=;
        b=pB4KSBhnNX47JjqJFszyMQL9Qzf9rbTn92L1xoBdrYIHeI2Qn5hwCaWzdsvwxmr8e+
         fi3kso1i/Azr3jFlTieWtAZDf+8Ejr6tfDAzB84jysFaDXpLem2oTWpM1GZYz+B1jxnA
         y3MuYChT1a/JtUoCOPhKLHZxVdENdkW9wZjoObxtEcgNuTV5Y24P3CFUJCrSSNJHf/Km
         Emb7SiSNQuvintdkagVys9oCSwK8oB/g5wNfVNbzeTtvaBoJ6Xpo1OjWT0AurRbs6o6n
         t4UqqbebpiZakpmrU9zfa+JoQOx72Q89mtXmkyJIxlZOCphYtSKoA8pF2GWxTLu46NNm
         Czag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708066508; x=1708671308;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/Ev7zx1OY2xavG089OEf6t+LzZ1+fWZhEmI/a93zMk=;
        b=UljwaXEINU8neo/4l8g+1ULHMC0kYmkubqqkDAqPuaG1ci+NbWNoEqnpocGLWsRIMa
         2HL9z/+kmvcTLOcuD5/O4SSF1LIXuy/pV+oNMPZoxDNfAE8tiklgsRGUMycyj3Be+a6M
         GjrNpcDHP1cEwgDOWPso2j4MsTcHpxv06rr5hTxC8SE7RZxe/vwdOX0Pw6EvvGdUuNSe
         A37yyMKIkfhhunu2nKirwJy4UWislclGqryyuwTlwVFR+XoQWEGBTgLMDb2J/Jka4rVC
         CYd/RUvoGb8Iy/daTjbtZks0ngmYTsuImH/BrErHYAbrsXDukTlJ39ON0vSr2q9gfQQR
         9oyw==
X-Forwarded-Encrypted: i=1; AJvYcCXeRKgrp+Bi296GLEiT/YWRGhmwjea9xhbnUalTtaZC5PX9jhnWT8R/KZfJZCrP2lXv4Q1+k9HMJsmwQW/VPqfi60LwSQDfhFOM
X-Gm-Message-State: AOJu0YzYFlC66stbq45LX1GfoOz7DseHsNnHOpLimpEk3XIZfHnbMZNN
	rMdzlqNqq8ZmZHRU22WAf+2Wv8xGZOG75qARIZMAR0VTcKlG1s09s1Tr9DBSIw==
X-Google-Smtp-Source: AGHT+IHiZawZ5tPVjTUC1usJpsLxHJCItFfeYjDx3TyanwgMlnEkKbuj3kFT6PcFPQDRIjp/XIHWOg==
X-Received: by 2002:a25:f903:0:b0:dc6:c617:7ca with SMTP id q3-20020a25f903000000b00dc6c61707camr4004856ybe.29.1708066507689;
        Thu, 15 Feb 2024 22:55:07 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id r185-20020a25c1c2000000b00dcda90f43d7sm207542ybf.59.2024.02.15.22.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 22:55:07 -0800 (PST)
Date: Thu, 15 Feb 2024 22:55:05 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 12/20] xfs: don't modify file and inode flags for shmem
 files
In-Reply-To: <20240129143502.189370-13-hch@lst.de>
Message-ID: <c9bac2b7-3c11-ef25-9db4-401a9b22834b@google.com>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 29 Jan 2024, Christoph Hellwig wrote:

> shmem_file_setup is explicitly intended for a file that can be
> fully read and written by kernel users without restrictions.  Don't
> poke into internals to change random flags in the file or inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/xfile.c | 17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 7785afacf21809..7e915385ef0011 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -68,28 +68,13 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_file_setup(description, isize, 0);
> +	xf->file = shmem_kernel_file_setup(description, isize, 0);

I think you probably want to say VM_NORESERVE there, instead of 0.

I see from the (deleted) comment below that "We want a large sparse file",
and the VM_NORESERVE does become important on large sparse files.  It is
how normal flles and memfds are set up (whereas SysV SHM says 0 to reserve
size at setup). It affects the Committed_AS seen in /proc/meminfo, and how
__vm_enough_memory() behaves (depending on /proc/sys/vm/overcommit_memory).

Hmm, I think mm/shmem.c is not prepared for the case of flags 0 there,
and then the file growing bigger than isize later on - I suspect that
Committed_AS will end up underflowing.  shmem.c ought to be defensive
against that, sure, but I don't think such a case has come up before.

I see you have two calls to xfile_create(), one with what looks like
a known fixed non-0 isize, but one with isize 0 which will grow later.

>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
>  	}
>  
> -	/*
> -	 * We want a large sparse file that we can pread, pwrite, and seek.
> -	 * xfile users are responsible for keeping the xfile hidden away from
> -	 * all other callers, so we skip timestamp updates and security checks.
> -	 * Make the inode only accessible by root, just in case the xfile ever
> -	 * escapes.
> -	 */
> -	xf->file->f_mode |= FMODE_PREAD | FMODE_PWRITE | FMODE_NOCMTIME |
> -			    FMODE_LSEEK;
> -	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;

I've forgotten offhand how O_LARGEFILE propagates down to where a file
gets grown, and I realize that 32-bit is not your primary concern: but
please double-check that it works correctly without O_LARGEFILE now
(maybe the new folio ops avoid everywhere that largefile would be checked).

Hugh

>  	inode = file_inode(xf->file);
> -	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
> -	inode->i_mode &= ~0177;
> -	inode->i_uid = GLOBAL_ROOT_UID;
> -	inode->i_gid = GLOBAL_ROOT_GID;
> -
>  	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
>  
>  	trace_xfile_create(xf);
> -- 
> 2.39.2
